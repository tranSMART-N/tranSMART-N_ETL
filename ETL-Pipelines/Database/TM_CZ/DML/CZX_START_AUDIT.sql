CREATE OR REPLACE PROCEDURE TM_CZ.CZX_START_AUDIT(CHARACTER VARYING(ANY), CHARACTER VARYING(ANY))
RETURNS BIGINT
LANGUAGE NZPLSQL
AS
BEGIN_PROC
DECLARE
	JOBNAME ALIAS FOR $1;
	DATABASENAME ALIAS FOR $2;
	V_JOBID bigint;
	
BEGIN

SELECT NEXT VALUE FOR TM_CZ.SEQ_CZ_JOB_ID INTO V_JOBID;

		insert into tm_cz.cz_job_master
			(
			job_id,
			start_date, 
			active, 
			database_name,
			job_name,
			job_status) 
		VALUES(
			V_JOBID,
			now(),
			'Y', 
			DATABASENAME,
			JOBNAME,
			'Running');
	
RETURN V_JOBID;
  exception 
	when OTHERS then
	RAISE NOTICE 'Exception Raised: %', SQLERRM;

END;

END_PROC;

