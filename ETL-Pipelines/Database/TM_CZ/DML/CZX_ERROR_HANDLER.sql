CREATE OR REPLACE PROCEDURE TM_CZ.CZX_ERROR_HANDLER(bigint, CHARACTER VARYING(ANY))
RETURNS INTEGER
LANGUAGE NZPLSQL AS
BEGIN_PROC

DECLARE
	jobID ALIAS FOR $1;
	procedureName ALIAS FOR $2;
  
  	databaseName VARCHAR(100);
	errorNumber NUMERIC(18,0);
	errorMessage VARCHAR(1000);
  	errorStack VARCHAR(4000);
  	errorBackTrace VARCHAR(4000);
	stepNo NUMERIC(18,0);	

	
BEGIN
  --Get DB Name
	select database_name INTO databaseName
	from tm_cz.cz_job_master 
	where job_id=jobID;
		
  --Get Latest Step
	select max(step_number) into stepNo 
	from tm_cz.cz_job_audit 
	where job_id = jobID;
  
  --Get all error info
  errorNumber := -1; --SQLCODE;
  errorMessage := SQLERRM;
  --errorStack := dbms_utility.format_error_stack;
  --errorBackTrace := dbms_utility.format_error_backtrace;

  --Update the audit step for the error
  CALL tm_cz.czx_write_audit(jobID, databaseName,procedureName, 'Job Failed: See error log for details',ROW_COUNT, stepNo, 'FAIL');

  --write out the error info
  CALL tm_cz.czx_write_error(jobID, errorNumber, errorMessage, errorStack, errorBackTrace);

return 0;

 exception 
	when OTHERS then
	RAISE NOTICE 'Exception Raised: %', SQLERRM;
END;

END_PROC;
