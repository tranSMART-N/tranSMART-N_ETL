CREATE OR REPLACE PROCEDURE TM_CZ.I2B2_ADD_NODE(CHARACTER VARYING(50), CHARACTER VARYING(2000), CHARACTER VARYING(500), BIGINT)
RETURNS CHARACTER VARYING(ANY)
LANGUAGE NZPLSQL AS
BEGIN_PROC
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
Declare
	--	Alias for parameters
	TrialID 		alias for $1;
	input_path 		alias for $2;
	path_name		alias for $3;
	currentJobID 	alias for $4;
 
  root_node		varchar(2000);
  root_level	int4;
  etlDate		timestamp;
  
  --Audit variables
  newJobFlag int4;
  databaseName VARCHAR(100);
  procedureName VARCHAR(100);
  jobID numeric(18,0);
  stepCt numeric(18,0);
  
BEGIN
    
	stepCt := 0;
	select now() into etlDate;
	
	--Set Audit Parameters
	newJobFlag := 0; -- False (Default)
	jobID := currentJobID;

	databaseName := 'TM_CZ';
	procedureName := 'I2B2_ADD_NODE';
  
	select tm_cz.parse_nth_value(input_path, 2, '\') into root_node from dual;
	
	select c_hlevel into root_level
	from i2b2metadata.table_access
	where c_name = root_node;

	--Audit JOB Initialization
	--If Job ID does not exist, then this is a single procedure run and we need to create it
	IF(jobID IS NULL or jobID < 1)
	THEN
		newJobFlag := 1; -- True
		--select czx_start_audit (procedureName, databaseName) into jobId;
	END IF;
  
	if input_path = ''  or input_path = '%' or path_name = ''
	then 
		stepCt := stepCt + 1;
		--call czx_write_audit(jobId,databaseName,procedureName,'Missing path or name - path:' || input_path || ' name: ' || path_name,SQL%ROWCOUNT,stepCt,'Done');
	else
		--CONCEPT DIMENSION
		insert into i2b2demodata.concept_dimension
		(concept_cd
		,concept_path
		,name_char
		,update_date
		,download_date
		,mport_date
		,ourcesystem_cd
		)
		select next value for i2b2demodata.concept_id::varchar
			  ,input_path,
			  ,to_char(path_name)
			  ,etlDate,
			  ,etlDate,
			  ,etlDate,
			  ,TrialID
		where not exists (select 1 from i2b2demodata.concept_dimension x where input_path = x.concept_path);
		stepCt := stepCt + 1;
		--call czx_write_audit(jobId,databaseName,procedureName,'Inserted concept for path into I2B2DEMODATA concept_dimension',SQL%ROWCOUNT,stepCt,'Done');
    
		--I2B2
		insert into i2b2metadata.i2b2
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
		,m_applied_path
		)
		select (length(concept_path) - coalesce(length(replace(concept_path, '\')),0)) / length('\') - 2 + root_level
			  ,concept_path
			  ,name_char
			  ,'FA'
			  ,'N'
			  ,'CONCEPT_CD'
			  ,'CONCEPT_DIMENSION'
			  ,'CONCEPT_PATH'
			  ,concept_path
			  ,concept_path
			  ,etldate
			  ,etldate
			  ,etldate
			  ,sourcesystem_cd
			  ,concept_cd
			  ,'LIKE'
			  ,'T'
			  ,case when TrialID is null then null else 'trial:' || TrialID end
			  ,'@'
		from i2b2demodata.concept_dimension
		where concept_path = input_path
		  and not exists
			 (select 1 from i2b2metadata.i2b2 x where input_path = x.c_fullname);
		stepCt := stepCt + 1;
		--call czx_write_audit(jobId,databaseName,procedureName,'Inserted path into I2B2METADATA i2b2',SQL%ROWCOUNT,stepCt,'Done');
	end if;
	
      ---Cleanup OVERALL JOB if this proc is being run standalone
	if newjobflag = 1
	then
		--call czx_end_audit (jobID, 'SUCCESS');
	end if;

	exception
	when others then
		raise notice 'error: %', SQLERRM;
		--Handle errors.
		--call czx_error_handler (jobID, procedureName);
		--End Proc
		--call czx_end_audit (jobID, 'FAIL');

END;
END_PROC;

