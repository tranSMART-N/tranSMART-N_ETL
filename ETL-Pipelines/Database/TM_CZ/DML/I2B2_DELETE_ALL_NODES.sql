CREATE OR REPLACE PROCEDURE TM_CZ.I2B2_DELETE_ALL_NODES(VARCHAR(ANY), INTEGER)
RETURNS INTEGER
EXECUTE AS OWNER
LANGUAGE NZPLSQL AS
BEGIN_PROC
DECLARE
	INPUT_PATH ALIAS FOR $1;
	CURRENTJOBID ALIAS FOR $2;
	
	--Audit variables
	newJobFlag INTEGER(1);
	databaseName VARCHAR(100);
	procedureName VARCHAR(100);
	jobID number(18,0);
	stepCt number(18,0);
	
	studyId		varchar2(100);
	topNode		varchar2(1000);
	parentNode	varchar2(1000);
	pExists		int;
	
BEGIN

  --Set Audit Parameters
  newJobFlag := 0; -- False (Default)
  jobID := currentJobID;

--	SELECT sys_context('USERENV', 'CURRENT_SCHEMA') INTO databaseName FROM dual;
--	procedureName := $$PLSQL_UNIT;
	select CURRENT_CATALOG into databaseName;
	select I2B2_SECURE_STUDY into procedureName;  

  --Audit JOB Initialization
  --If Job ID does not exist, then this is a single procedure run and we need to create it
  IF(jobID IS NULL or jobID < 1)
  THEN
    newJobFlag := 1; -- True
    CALL TM_CZ.czx_start_audit (procedureName, databaseName, jobID);
  END IF;
    	
	stepCt := 0;
	stepct := stepct + 1;
	CALL TM_CZ.czx_write_audit(jobid,databasename,procedurename,'Starting procedure '||procedureName,0,stepct,'done');

	if coalesce(input_path,'') = ''  or input_path = '%'
		then 
			CALL TM_CZ.czx_write_audit(jobId,databaseName,procedureName,'Path missing or invalid',0,stepCt,'Done'); 
	else 
		select count(*) into pExists
		from i2b2metadata.i2b2
		where c_fullname = input_path;
		
		if pExists = 0 then
			raise invalid_path;
		end if;
		
		select sourcesystem_cd into studyId
		from i2b2metadata.i2b2
		where c_fullname = input_path;
		
		select min(c_fullname) into topNode
		from i2b2metadata.i2b2
		where sourcesystem_cd = studyId;
		
		stepct := stepct + 1;
		CALL TM_CZ.czx_write_audit(jobid,databasename,procedurename,'Study: ' || studyId || ' Node: ' || input_path,0,stepct,'done');
				
		parentNode := substr(input_path,1,instr(input_path,'\',-2));
		stepct := stepct + 1;
		
		CALL TM_CZ.czx_write_audit(jobid,databasename,procedurename,'topNode: '|| topNode || ' parentNode: ' || parentNode,0,stepct,'done');
	
		--	visit_dimension
		
		--* CALL TM_CZ.i2b2_table_index_maint('DROP','VISIT_DIMENSION',jobId);
		
		delete from i2b2demodata.visit_dimension v
		where v.encounter_num in
			  (select f.encounter_num
			   from i2b2demodata.observation_fact f
			   where f.concept_cd in (select x.c_basecode from i2b2metadata.i2b2 x where x.c_fullname like input_path || '%'));
		stepct := stepct + 1;
		
		CALL TM_CZ.czx_write_audit(jobid,databasename,procedurename,'delete data for trial from i2b2demodata visit_dimension',1/*sql%rowcount*/,stepct,'done');
		
		commit;
		
		--* CALL TM_CZ.i2b2_table_index_maint('ADD','VISIT_DIMENSION',jobId);

		--observation_fact
		
		--*CALL TM_CZ.i2b2_table_index_maint('DROP','OBSERVATION_FACT',jobId);
		
		delete from i2b2demodata.observation_fact f
		where f.concept_cd in (select x.c_basecode from i2b2metadata.i2b2 x where x.c_fullname like input_path || '%');
		stepct := stepct + 1;
		CALL TM_CZ.czx_write_audit(jobid,databasename,procedurename,'delete data for trial from i2b2demodata observation_fact',1/*sql%rowcount*/,stepct,'done');
		commit;
		
		--* CALL TM_CZ.i2b2_table_index_maint('ADD','OBSERVATION_FACT',jobId);
		
		--concept dimension
		
		--*i2b2_table_index_maint('DROP','CONCEPT_DIMENSION',jobId);
		
		delete from i2b2demodata.concept_dimension c
		where c.concept_path like input_path || '%';
		stepct := stepct + 1;
		CALL TM_CZ.czx_write_audit(jobid,databasename,procedurename,'delete data for trial from i2b2demodata concept_dimension',1/*sql%rowcount*/,stepct,'done');
		commit;
		
		--*i2b2_table_index_maint('ADD','CONCEPT_DIMENSION',jobId);
		
		--i2b2
		delete from i2b2metadata.i2b2 i
		where i.c_fullname like input_path || '%';
		stepct := stepct + 1;
		CALL TM_CZ.czx_write_audit(jobid,databasename,procedurename,'delete data for trial from i2b2metadata i2b2',1/*sql%rowcount*/,stepct,'done');
		commit;
	  
		--i2b2_secure
		delete from i2b2metadata.i2b2_secure s
		where s.c_fullname like input_path || '%';
		stepct := stepct + 1;
		CALL TM_CZ.czx_write_audit(jobid,databasename,procedurename,'delete data for trial from i2b2metadata i2b2_secure',1/*sql%rowcount*/,stepct,'done');
		commit;

		--concept_counts
	
		if parentNode >= topNode then
			call tm_cz.i2b2_create_concept_counts(parentNode,jobId);
		else
			delete from i2b2demodata.concept_counts
			where concept_path like input_path || '%';
			stepct := stepct + 1;
			CALL TM_CZ.czx_write_audit(jobid,databasename,procedurename,'delete data for trial from i2b2demodata concept_counts',1/*sql%rowcount*/,stepct,'done');
			commit;
		end if;
    end if;
	
    ---Cleanup OVERALL JOB if this proc is being run standalone
  IF newJobFlag = 1
  THEN
    CALL TM_CZ.czx_end_audit (jobID, 'SUCCESS');
  END IF;

  EXCEPTION
	when invalid_path then
		CALL TM_CZ.czx_write_audit(jobId,databaseName,procedureName,'Path supplied was not found: ' || input_path, 0,stepCt,'Done');
		CALL TM_CZ.czx_end_audit(jobId,'SUCCESS');
  WHEN OTHERS THEN
    --Handle errors.
    --czx_error_handler (jobID, procedureName);
    --End Proc
    CALL TM_CZ.czx_end_audit (jobID, 'FAIL');
END;

END_PROC;
