set define off;
  CREATE OR REPLACE PROCEDURE "TM_CZ"."I2B2_DELETE_ALL_NODES" 
(
  input_path VARCHAR2
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
	
	invalid_path	exception;

Begin

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
	stepct := stepct + 1;
	czx_write_audit(jobid,databasename,procedurename,'Starting procedure '||procedureName,0,stepct,'done');

	if coalesce(input_path,'') = ''  or input_path = '%'
		then 
			czx_write_audit(jobId,databaseName,procedureName,'Path missing or invalid',0,stepCt,'Done'); 
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
		czx_write_audit(jobid,databasename,procedurename,'Study: ' || studyId || ' Node: ' || input_path,0,stepct,'done');
				
		parentNode := substr(input_path,1,instr(input_path,'\',-2));
		stepct := stepct + 1;
		czx_write_audit(jobid,databasename,procedurename,'topNode: '|| topNode || ' parentNode: ' || parentNode,0,stepct,'done');
	
		--	visit_dimension
		
		i2b2_table_index_maint('DROP','VISIT_DIMENSION',jobId);
		
		delete from i2b2demodata.visit_dimension v
		where v.encounter_num in
			  (select f.encounter_num
			   from i2b2demodata.observation_fact f
			   where f.concept_cd in (select x.c_basecode from i2b2metadata.i2b2 x where x.c_fullname like input_path || '%'));
		stepct := stepct + 1;
		czx_write_audit(jobid,databasename,procedurename,'delete data for trial from i2b2demodata visit_dimension',sql%rowcount,stepct,'done');
		commit;
		i2b2_table_index_maint('ADD','VISIT_DIMENSION',jobId);

		--observation_fact
		
		i2b2_table_index_maint('DROP','OBSERVATION_FACT',jobId);
		
		delete from i2b2demodata.observation_fact f
		where f.concept_cd in (select x.c_basecode from i2b2metadata.i2b2 x where x.c_fullname like input_path || '%');
		stepct := stepct + 1;
		czx_write_audit(jobid,databasename,procedurename,'delete data for trial from i2b2demodata observation_fact',sql%rowcount,stepct,'done');
		commit;
		i2b2_table_index_maint('ADD','OBSERVATION_FACT',jobId);
		
		--concept dimension
		
		i2b2_table_index_maint('DROP','CONCEPT_DIMENSION',jobId);
		
		delete from concept_dimension c
		where c.concept_path like input_path || '%';
		stepct := stepct + 1;
		czx_write_audit(jobid,databasename,procedurename,'delete data for trial from i2b2demodata concept_dimension',sql%rowcount,stepct,'done');
		commit;
		i2b2_table_index_maint('ADD','CONCEPT_DIMENSION',jobId);
		
		--i2b2
		delete from i2b2 i
		where i.c_fullname like input_path || '%';
		stepct := stepct + 1;
		czx_write_audit(jobid,databasename,procedurename,'delete data for trial from i2b2metadata i2b2',sql%rowcount,stepct,'done');
		commit;
	  
		--i2b2_secure
		delete from i2b2_secure s
		where s.c_fullname like input_path || '%';
		stepct := stepct + 1;
		czx_write_audit(jobid,databasename,procedurename,'delete data for trial from i2b2metadata i2b2_secure',sql%rowcount,stepct,'done');
		commit;

		--concept_counts
	
		if parentNode >= topNode then
			i2b2_create_concept_counts(parentNode,jobId);
		else
			delete from concept_counts
			where concept_path like input_path || '%';
			stepct := stepct + 1;
			czx_write_audit(jobid,databasename,procedurename,'delete data for trial from i2b2demodata concept_counts',sql%rowcount,stepct,'done');
			commit;
		end if;
    end if;
	
    ---Cleanup OVERALL JOB if this proc is being run standalone
  IF newJobFlag = 1
  THEN
    czx_end_audit (jobID, 'SUCCESS');
  END IF;

  EXCEPTION
	when invalid_path then
		czx_write_audit(jobId,databaseName,procedureName,'Path supplied was not found: ' || input_path, 0,stepCt,'Done');
		czx_end_audit(jobId,'SUCCESS');
  WHEN OTHERS THEN
    --Handle errors.
    czx_error_handler (jobID, procedureName);
    --End Proc
    czx_end_audit (jobID, 'FAIL');  
END;
