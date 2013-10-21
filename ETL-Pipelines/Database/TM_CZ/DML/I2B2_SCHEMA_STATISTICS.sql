set define off;
create or replace
PROCEDURE "I2B2_SCHEMA_STATISTICS" 
(
  currentJobID		IN	NUMBER := null
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

  
    --Audit variables
	newJobFlag INTEGER(1);
	databaseName VARCHAR(100);
	procedureName VARCHAR(100);
	jobID number(18,0);
	stepCt number(18,0);
  
BEGIN
	
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
    	
	stepCt := 0;

	stepCt := stepCt + 1;
	czx_write_audit(jobId,databaseName,procedureName,'Starting ' || procedureName,0,stepCt,'Done');  
	
	--	tm_lz
	
	sys.dbms_stats.unlock_schema_stats('TM_LZ');
	stepCt := stepCt + 1;
	czx_write_audit(jobId,databaseName,procedureName,'Unlock schema statistics on tm_lz',0,stepCt,'Done');
	sys.dbms_stats.gather_schema_stats('TM_LZ');
	stepCt := stepCt + 1;
	czx_write_audit(jobId,databaseName,procedureName,'Gather schema statistics on tm_lz',0,stepCt,'Done');
	
	--	tm_wz
	
	sys.dbms_stats.unlock_schema_stats('TM_WZ');
	stepCt := stepCt + 1;
	czx_write_audit(jobId,databaseName,procedureName,'Unlock schema statistics on tm_wz',0,stepCt,'Done');
	sys.dbms_stats.gather_schema_stats('TM_WZ');
	stepCt := stepCt + 1;
	czx_write_audit(jobId,databaseName,procedureName,'Gather schema statistics on tm_wz',0,stepCt,'Done');	
	
	--	i2b2demodata
	
	sys.dbms_stats.unlock_schema_stats('I2B2DEMODATA');
	stepCt := stepCt + 1;
	czx_write_audit(jobId,databaseName,procedureName,'Unlock schema statistics on i2b2demodata',0,stepCt,'Done');
	sys.dbms_stats.gather_schema_stats('I2B2DEMODATA');
	stepCt := stepCt + 1;
	czx_write_audit(jobId,databaseName,procedureName,'Gather schema statistics on i2b2demodata',0,stepCt,'Done');
	
	--	i2b2metadata
	
	sys.dbms_stats.unlock_schema_stats('I2B2METADATA');
	stepCt := stepCt + 1;
	czx_write_audit(jobId,databaseName,procedureName,'Unlock schema statistics on i2b2metadata',0,stepCt,'Done');
	sys.dbms_stats.gather_schema_stats('I2B2METADATA');
	stepCt := stepCt + 1;
	czx_write_audit(jobId,databaseName,procedureName,'Gather schema statistics on i2b2metadata',0,stepCt,'Done');	
	
	--	deapp
	
	sys.dbms_stats.unlock_schema_stats('DEAPP');
	stepCt := stepCt + 1;
	czx_write_audit(jobId,databaseName,procedureName,'Unlock schema statistics on deapp',0,stepCt,'Done');
	sys.dbms_stats.gather_schema_stats('DEAPP');
	stepCt := stepCt + 1;
	czx_write_audit(jobId,databaseName,procedureName,'Gather schema statistics on deapp',0,stepCt,'Done');
	
	stepCt := stepCt + 1;
	czx_write_audit(jobId,databaseName,procedureName,'End ' || procedureName,0,stepCt,'Done');
	
    ---Cleanup OVERALL JOB if this proc is being run standalone
	if newJobFlag = 1
	then
		czx_end_audit (jobID, 'SUCCESS');
	end if;
 
	exception
	when others then
    --Handle errors.
		czx_error_handler (jobID, procedureName);
    --End Proc
		czx_end_audit (jobID, 'FAIL');	
end;