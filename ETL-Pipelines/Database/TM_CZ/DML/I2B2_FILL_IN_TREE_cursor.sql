set define off;
create or replace
PROCEDURE         "I2B2_FILL_IN_TREE" 
(
  trial_id VARCHAR2
 ,input_path VARCHAR2
 ,currentJobID NUMBER := null
) AUTHID CURRENT_USER
AS
/*************************************************************************
* Copyright 2008-2012 Janssen Research & Development, LLC.
*
* Licensed under the Apache License, Version 2.0 (the "License");
* you may not use this file except in compliance with the License.
* You may obtain a copy of the License at
*
* http://www.apache.org/licenses/LICENSE-2.0
*
* Unless required by applicable law or agreed to in writing, software
* distributed under the License is distributed on an "AS IS" BASIS,
* WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
* See the License for the specific language governing permissions and
* limitations under the License.
******************************************************************/
  TrialID varchar2(100);
  
    --Audit variables
	newJobFlag INTEGER(1);
	databaseName VARCHAR(100);
	procedureName VARCHAR(100);
	jobID number(18,0);
	stepCt number(18,0);
  
	auditText 	varchar2(4000);
	etlDate		date;
	root_level	int;
	curr_node	varchar2(700);
	node_name	varchar2(700);
	v_count		NUMBER;
  
	--Get the nodes
	CURSOR cNodes is
		--Trimming off the last node as it would never need to be added.
		select distinct substr(c_fullname, 1,instr(c_fullname,'\',-2,1)) as c_fullname
		from i2b2 
		where c_fullname like input_path || '%'
		union
		--	add input_path if filling in upper-level nodes only
		select input_path as c_fullname from dual;
		--  and c_visualattributes like 'L%';
		--  and c_hlevel > = 2;
  
BEGIN
	TrialID := upper(trial_id);
  
    stepCt := 0;
	select sysdate into etlDate from dual;
	
	--Set Audit Parameters
	newJobFlag := 0; -- False (Default)
	jobID := currentJobID;

	SELECT sys_context('USERENV', 'CURRENT_SCHEMA') INTO databaseName FROM dual;
	procedureName := $$PLSQL_UNIT;

	--Audit JOB Initialization
	--If Job ID does not exist, then this is a single procedure run and we need to create it
	IF(jobID IS NULL or jobID < 1)
	THEN
		newJobFlag := 1; -- True
		czx_start_audit (procedureName, databaseName, jobID);
	END IF;
  
  	select parse_nth_value(input_path, 2, '\') into curr_node from dual;
	
	select c_hlevel into root_level
	from table_access
	where c_name = curr_node;
	
	--start node with the first slash
	
	execute immediate('truncate table tm_wz.wt_folder_nodes');
 
	--Iterate through each node
	FOR r_cNodes in cNodes Loop
		--Determine how many nodes there are and iterate through
    
		for loop_counter in 1 .. (length(r_cNodes.c_fullname) - nvl(length(replace(r_cNodes.c_fullname, '\')),0)) / length('\')
		LOOP
			--Determine Node:
			curr_node := substr(r_cNodes.c_fullname,1,instr(r_cNodes.c_fullname,'\',-1,loop_counter));	
			if curr_node is not null and curr_node != '\' then
				insert into tm_wz.wt_folder_nodes
				(folder_path)
				values(curr_node);
			end if;
		end loop;
	end loop;
		
	commit;
			
	--	bulk insert concept_dimension records
		
	insert into concept_dimension
	(concept_cd
	,concept_path
	,name_char
	,update_date
	,download_date
	,import_date
	,sourcesystem_cd)
	Select concept_id.nextval
		  ,y.folder_path
		  ,parse_nth_value(y.folder_path,length(y.folder_path)-length(replace(y.folder_path,'\',null)),'\')
		  ,etlDate
		  ,etlDate
		  ,etlDate
		  ,TrialID
	from (select distinct folder_path from tm_wz.wt_folder_nodes x
		  where not exists
			   (select 1 from concept_dimension cd where x.folder_path = cd.concept_path)) y ;
	stepCt := stepCt + 1;
	czx_write_audit(jobId,databaseName,procedureName,'Inserted concept for path into I2B2DEMODATA concept_dimension',SQL%ROWCOUNT,stepCt,'Done');
	COMMIT;
    
	--	bulk insert the i2b2 records
	
	insert into i2b2
	(c_hlevel
	,c_fullname
	,c_name
	,c_visualattributes
	,c_synonym_cd
	,c_facttablecolumn
	,c_tablename
	,c_columnname
	,c_dimcode
	,c_tooltip
	,update_date
	,download_date
	,import_date
	,sourcesystem_cd
	,c_basecode
	,c_operator
	,c_columndatatype
	,c_comment
	,i2b2_id
	,m_applied_path)
    select (length(concept_path) - nvl(length(replace(concept_path, '\')),0)) / length('\') - 2 + root_level
		  ,concept_path
		  ,name_char
		  ,'FA'
		  ,'N'
		  ,'CONCEPT_CD'
		  ,'CONCEPT_DIMENSION'
		  ,'CONCEPT_PATH'
		  ,concept_path
		  ,concept_path
		  ,etlDate
		  ,etlDate
		  ,etlDate
		  ,sourcesystem_cd
		  ,concept_cd
		  ,'LIKE'
		  ,'T'
		  ,decode(TrialID,null,null,'trial:' || TrialID)
		  ,i2b2_id_seq.nextval
		  ,'@'
    from concept_dimension cd
    where cd.concept_path in (select distinct folder_path from tm_wz.wt_folder_nodes)
	  and not exists
		  (select 1 from i2b2 x
		   where cd.concept_path = x.c_fullname);
	stepCt := stepCt + 1;
	czx_write_audit(jobId,databaseName,procedureName,'Inserted path into I2B2METADATA i2b2',SQL%ROWCOUNT,stepCt,'Done');
    COMMIT;

      ---Cleanup OVERALL JOB if this proc is being run standalone
  IF newJobFlag = 1
  THEN
    czx_end_audit (jobID, 'SUCCESS');
  END IF;

  EXCEPTION
  WHEN OTHERS THEN
    --Handle errors.
    czx_error_handler (jobID, procedureName);
    --End Proc
    czx_end_audit (jobID, 'FAIL');
	
END;