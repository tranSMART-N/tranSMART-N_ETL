set define off;
  CREATE OR REPLACE PROCEDURE "I2B2_COPY_TO_STAGE" 
(
  trial_id IN VARCHAR2
  ,data_type in varchar2
  ,currentJobID NUMBER := null
  ,rtn_code		OUT	NUMBER
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

	TrialId 	varchar2(200);
	msgText		varchar2(2000);
	dataType	varchar2(50);

	tText			varchar2(2000);
	tExists 		number;
	source_table	varchar2(50);
	release_table	varchar2(50);
	vSNP 			number;
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
	);
	
	--	Define the abstract result set table
	TYPE tr_type IS TABLE OF r_type;

	--	Define the result set
	
	rtn_array tr_type;
	
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

	if TrialId = null then
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
	bulk collect into rtn_array
	from tm_cz.migrate_tables
	where instr(dataType,data_type) > 0;
	
	if SQL%ROWCOUNT = 0 then
		stepCt := stepCt + 1;
		czx_write_audit(jobId,databaseName,procedureName,'data_type invalid: '|| data_type,0,stepCt,'Done');
		rtn_code := 16;
		Return;
	end if;
      
	for i in rtn_array.first .. rtn_array.last
	loop
	
		source_table := rtn_array(i).table_owner || '.' || rtn_array(i).table_name;
		release_table := 'tm_stage.' || rtn_array(i).stage_table_name;
		stepCt := stepCt + 1;
		czx_write_audit(jobId,databaseName,procedureName,'Processing ' || source_table,0,stepCt,'Done');
		
		if rtn_array(i).study_specific = 'Y' then
			tText := 'delete ' || release_table || ' where release_study = ' || '''' || TrialId || '''';
			execute immediate(tText);
			stepCt := stepCt + 1;
			czx_write_audit(jobId,databaseName,procedureName,'Deleted study from ' || release_table,SQL%ROWCOUNT,stepCt,'Done');
			
			tText := 'insert into ' || release_table || ' select st.*,' || '''' || TrialId || '''' || ' from ' || source_table || ' st ' || 
					 replace(rtn_array(i).where_clause,'TrialId','''' || TrialId || '''');
			execute immediate(tText);
			rowCt := SQL%ROWCOUNT;
			commit;
			stepCt := stepCt + 1;
			czx_write_audit(jobId,databaseName,procedureName,'Inserted study into ' || release_table,rowCt,stepCt,'Done');
		else
			tText := 'truncate table ' || release_table;
			stepCt := stepCt + 1;		
			execute immediate(tText);
			czx_write_audit(jobId,databaseName,procedureName,'Truncated '|| release_table,0,stepCt,'Done');
			tText := 'insert into ' || release_table || ' select st.* from ' || source_table || ' st ';
			execute immediate(tText);
			rowCt := SQL%ROWCOUNT;
			commit;
			stepCt := stepCt + 1;
			czx_write_audit(jobId,databaseName,procedureName,'Inserted all data into ' || release_table,rowCt,stepCt,'Done');
		end if;
			
	end loop;

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
