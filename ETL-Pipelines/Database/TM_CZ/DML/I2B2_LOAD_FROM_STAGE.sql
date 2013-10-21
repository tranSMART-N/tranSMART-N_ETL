set define off;
  CREATE OR REPLACE PROCEDURE "I2B2_LOAD_FROM_STAGE" 
(
  trial_id IN VARCHAR2
 , data_type	In varchar2
 ,currentJobID NUMBER := null
 ,rtn_code	out number
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

	TrialId 		varchar2(200);
	msgText			varchar2(2000);
	dataType		varchar2(50);

	tText			varchar2(2000);
	tExists 		number;
	source_table	varchar2(50);
	release_table	varchar2(50);
	tableOwner		varchar2(50);
	tableName		varchar2(50);
	vSNP 			number;
	topNode			varchar2(1000);
	rootNode		varchar2(1000);
	tPath			varchar2(1000);
	pExists			int;
	pCount			int;
	rowCt			number;

	--Audit variables
	newJobFlag INTEGER(1);
	databaseName VARCHAR(100);
	procedureName VARCHAR(100);
	jobID number(18,0);
	stepCt number(18,0);
  
	TYPE r_type IS RECORD (
		 table_owner		varchar2(50)
		,table_name			varchar2(50)
		,study_specific		char(1)
		,where_clause		varchar2(2000)
		,stage_table_name	varchar2(50)
		,rebuild_index		char(1)
	);
	TYPE tr_type IS TABLE OF r_type;
	rtn_array tr_type;
	
	type tab_constraints is record (
		 pk_table_name		varchar2(50)
		,pk_constraint_name	varchar2(50)
		,fk_owner			varchar2(50)
		,fk_table_name		varchar2(50)
		,fk_constraint_name	varchar2(50)
	);
	type tab_constraints_table is table of tab_constraints;
	tab_constraints_array tab_constraints_table;
	
	type tab_cols is record
	(column_name	varchar2(30));	
	type tab_col_table is table of tab_cols;
	tab_col_array tab_col_table;
	
BEGIN

	TrialID := upper(trial_id);
	dataType := upper(data_type);
	
	stepCt := 0;
	
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
  
	stepCt := stepCt + 1;
	czx_write_audit(jobId,databaseName,procedureName,'Starting ' || procedureName,0,stepCt,'Done');
	
	stepCt := stepCt + 1;
	msgText := 'Extracting trial: ' || TrialId;
	czx_write_audit(jobId,databaseName,procedureName, msgText,0,stepCt,'Done');

	if TrialId is null then
		stepCt := stepCt + 1;
		czx_write_audit(jobId,databaseName,procedureName,'TrialID missing',0,stepCt,'Done');
		rtn_code := 16;
		Return;
	end if;
	
	select upper(table_owner) as table_owner
		  ,upper(table_name) as table_name
		  ,upper(study_specific) as study_specific
		  ,where_clause
		  ,upper(stage_table_name) as stage_table_name
		  ,upper(coalesce(rebuild_index,'N')) as rebuild_index
	bulk collect into rtn_array
	from tm_cz.migrate_tables
	where instr(dataType,data_type) > 0
	order by insert_seq;
	
	if rtn_array.count = 0 then
		stepCt := stepCt + 1;
		czx_write_audit(jobId,databaseName,procedureName,'No records for data_type: '||data_type||' in tm_cz.migrate_tables',0,stepCt,'Done');
		rtn_code := 16;
		Return;
	end if;		
	
	--	drop all constraints for the dataType
		
	select pk.table_name, pk.constraint_name, fk.owner, fk.table_name, fk.constraint_name
	bulk collect into tab_constraints_array
	from all_constraints pk
		,all_constraints fk
	where pk.table_name in (select upper(x.table_name) from tm_cz.migrate_tables x where instr(dataType,x.data_type) > 0)
	  and pk.constraint_name = fk.r_constraint_name
	  and fk.constraint_type = 'R';
	  
	if tab_constraints_array.count > 0 then
		for k in tab_constraints_array.first .. tab_constraints_array.last
		loop
			tText := 'alter table ' || tab_constraints_array(k).fk_owner || '.' ||
					 tab_constraints_array(k).fk_table_name || ' disable constraint ' || tab_constraints_array(k).fk_constraint_name;
			execute immediate(tText);
			stepCt := stepCt + 1;
			--czx_write_audit(jobId,databaseName,procedureName,'Removed constraint from ' || source_table,0,stepCt,'Done');
			czx_write_audit(jobId,databaseName,procedureName,tText,1,stepCt,'Done');
		end loop;
	end if;
	
	--	load from stage
 
	for i in rtn_array.first .. rtn_array.last
	loop
	
		--	setup variables
		
		source_table := rtn_array(i).table_owner || '.' || rtn_array(i).table_name;
		release_table := 'tm_stage.' || rtn_array(i).stage_table_name;
		tableName := rtn_array(i).table_name;
		tableOwner := rtn_array(i).table_owner;
		stepCt := stepCt + 1;
		czx_write_audit(jobId,databaseName,procedureName,'Processing ' || source_table,0,stepCt,'Done');
		
		--	drop indexes if rebuild_index = Y
		
		if rtn_array(i).rebuild_index = 'Y' then
			i2b2_table_index_maint('DROP',rtn_array(i).table_name,jobId);
		end if;
		  
		--	delete or truncate source table
		
		if rtn_array(i).study_specific = 'Y' then
			tText := 'delete ' || source_table || ' st ' || replace(rtn_array(i).where_clause,'TrialId','''' || TrialId || '''');
			execute immediate(tText);
			rowCt := SQL%ROWCOUNT;
			commit;
			stepCt := stepCt + 1;
			czx_write_audit(jobId,databaseName,procedureName,'Deleted study from ' || source_table,SQL%ROWCOUNT,stepCt,'Done');
		else
			tText := 'truncate table ' || source_table;
			execute immediate(tText);
			stepCt := stepCt + 1;		
			czx_write_audit(jobId,databaseName,procedureName,'Truncated '|| source_table,0,stepCt,'Done');
		end if;
		
		--	get list of columns in order
		
		select column_name
		bulk collect into tab_col_array
		from all_tab_columns
		where owner = tableOwner
		  and table_name = tableName
		order by column_id;
		
		--	insert by column for study_specific or bulk insert if not
		
		if rtn_array(i).study_specific = 'Y' then			
			tText := 'insert into ' || source_table || ' select ';
			
			for k in tab_col_array.first .. tab_col_array.last
			loop
				tText := tText || ' st.' || tab_col_array(k).column_name || ',';
			end loop;
			
			tText := trim(trailing ',' from tText) || ' from ' || release_table || ' st ' || ' where st.release_study = ' || '''' || TrialId || '''';
			--dbms_output.put_line(tText);
			execute immediate(tText);
			rowCt := SQL%ROWCOUNT;
			commit;
			stepCt := stepCt + 1;
			czx_write_audit(jobId,databaseName,procedureName,'Inserted study into ' || source_table,rowCt,stepCt,'Done');
		else
			tText := 'insert into ' || source_table || ' select st.* from ' || release_table || ' st ';
			execute immediate(tText);
			rowCt := SQL%ROWCOUNT;
			commit;
			stepCt := stepCt + 1;
			czx_write_audit(jobId,databaseName,procedureName,'Inserted all data into ' || source_table,rowCt,stepCt,'Done');
		end if;		
		
		--	add indexes if necessary
		
		if rtn_array(i).rebuild_index = 'Y' then
			i2b2_table_index_maint('ADD',rtn_array(i).table_name,jobId);
		end if;			
	end loop;
	
	--	enable all constraints for dataType
		
	if tab_constraints_array.count > 0 then
		for k in tab_constraints_array.first .. tab_constraints_array.last
		loop
			tText := 'alter table ' || tab_constraints_array(k).fk_owner || '.' ||
					 tab_constraints_array(k).fk_table_name || ' enable constraint ' || tab_constraints_array(k).fk_constraint_name;
			execute immediate(tText);
			stepCt := stepCt + 1;
			--czx_write_audit(jobId,databaseName,procedureName,'Enabled constraint '||tab_constraints_array(k).fk_constraint_name||' on ' || source_table,1,stepCt,'Done');
			czx_write_audit(jobId,databaseName,procedureName,tText,1,stepCt,'Done');
		end loop;
	end if;
	
	--	if CLINICAL data, add root node if needed and fill in tree for any top nodes
	
	if instr(dataType,'CLINICAL') > 0 then
	
		--	get topNode for study
	
		select min(c_fullname) into topNode
		from i2b2metadata.i2b2
		where sourcesystem_cd = TrialId;
		
		-- Get rootNode from topNode
  
		select parse_nth_value(topNode, 2, '\') into rootNode from dual;
	
		select count(*) into pExists
		from i2b2metadata.table_access
		where c_name = rootNode;
	
		select count(*) into pCount
		from i2b2metadata.i2b2
		where c_name = rootNode;
	
		if pExists = 0 or pCount = 0 then
			i2b2_add_root_node(rootNode, jobId);
		end if;
		
		--	Add any upper level nodes as needed, trim off study name because it's already in i2b2
	
		tPath := substr(topNode, 1,instr(topNode,'\',-2,1));
		select length(tPath) - length(replace(tPath,'\',null)) into pCount from dual;

		if pCount > 2 then
			stepCt := stepCt + 1;
			czx_write_audit(jobId,databaseName,procedureName,'Adding upper-level nodes',0,stepCt,'Done');
			i2b2_fill_in_tree(null, tPath, jobId);
		end if;

		i2b2_load_security_data(jobId);
	end if;

	stepCt := stepCt + 1;
	czx_write_audit(jobId,databaseName,procedureName,'End '||procedureName,0,stepCt,'Done');

       ---Cleanup OVERALL JOB if this proc is being run standalone
  IF newJobFlag = 1
  THEN
    czx_end_audit (jobID, 'SUCCESS');
  END IF;
  
  rtn_code := 0;

  EXCEPTION
  WHEN OTHERS THEN
    --Handle errors.
    czx_error_handler (jobID, procedureName);
    --End Proc
    czx_end_audit (jobID, 'FAIL');
	rtn_code := 16;
END;
