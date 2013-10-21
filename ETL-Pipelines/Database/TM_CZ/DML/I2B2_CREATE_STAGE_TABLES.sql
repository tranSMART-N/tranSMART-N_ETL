set define off;
CREATE OR REPLACE PROCEDURE "I2B2_CREATE_STAGE_TABLES" 
AUTHID CURRENT_USER
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

	--	Define the abstract result set record
	
	TYPE r_type IS RECORD (
		 table_owner		varchar2(50)
		,table_name			varchar2(50)
		,study_specific		char(1)
		,stage_table_name	varchar2(50)
	);
	
	--	Define the abstract result set table
	TYPE tr_type IS TABLE OF r_type;

	--	Define the result set
	
	rtn_array tr_type;

	--	Variables

	tText 			varchar2(2000);
	pExists			int;
	release_table	varchar2(50);
	
    --Audit variables
	newJobFlag INTEGER(1);
	databaseName VARCHAR(100);
	procedureName VARCHAR(100);
	jobID number(18,0);
	stepCt number(18,0);
	
	BEGIN	
	
	--Set Audit Parameters
	newJobFlag := 0; -- False (Default)
	jobID := -1;

	SELECT sys_context('USERENV', 'CURRENT_SCHEMA') INTO databaseName FROM dual;
	procedureName := $$PLSQL_UNIT;

	--Audit JOB Initialization
	--If Job ID does not exist, then this is a single procedure run and we need to create it
	IF(jobID IS NULL or jobID < 1)
	THEN
		newJobFlag := 1; -- True
		czx_start_audit (procedureName, databaseName, jobID);
	END IF;
    	
	stepCt := 0;	
	czx_write_audit(jobId,databaseName,procedureName,'Starting ' || procedureName,0,stepCt,'Done');
	
	select upper(table_owner) as table_owner
		  ,upper(table_name) as table_name
		  ,upper(study_specific) as study_specific
		  ,upper(stage_table_name) as stage_table_name
	bulk collect into rtn_array
	from tm_cz.migrate_tables;
      
	for i in rtn_array.first .. rtn_array.last
	loop
	
		release_table := rtn_array(i).stage_table_name;

		select count(*) into pExists
		from all_tables
		where owner = 'TM_STAGE'
		  and table_name = release_table;	
	  
		if pExists > 0 then
			execute immediate('drop table tm_stage.' || release_table);
		end if;

		tText := 'create table tm_stage.' || release_table || ' as select * from ' || 
				  rtn_array(i).table_owner || '.' || rtn_array(i).table_name ||
				 ' where 1=2';
		execute immediate(tText);
		
		if rtn_array(i).study_specific = 'Y' then
			tText := 'alter table tm_stage.' || release_table || ' add RELEASE_STUDY VARCHAR2(200)';
			execute immediate(tText);
		end if;

		stepCt := stepCt + 1;
		czx_write_audit(jobId,databaseName,procedureName,'Created '|| release_table,0,stepCt,'Done');
			
	end loop;
	
	-- util_grant_all('TM_CZ','TABLES');
	
	czx_write_audit(jobId,databaseName,procedureName,'End i2b2_create_release_tablese',0,stepCt,'Done');
	stepCt := stepCt + 1;
	
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


