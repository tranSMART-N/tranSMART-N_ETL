set define off;
  CREATE OR REPLACE PROCEDURE "I2B2_CREATE_CONCEPT_COUNTS" 
(
  path VARCHAR2
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
  
  delete 
    from concept_counts
  where 
    concept_path like path || '%';
  stepCt := stepCt + 1;
  czx_write_audit(jobId,databaseName,procedureName,'Delete counts for trial from I2B2DEMODATA concept_counts',SQL%ROWCOUNT,stepCt,'Done');
	
  commit;
	
	--	Join each node (folder or leaf) in the path to it's leaf in the work table to count patient numbers

	insert into concept_counts
	(concept_path
	,parent_concept_path
	,patient_count
	)
	select fa.c_fullname
		  ,ltrim(SUBSTR(fa.c_fullname, 1,instr(fa.c_fullname, '\',-1,2)))
		  ,count(distinct tpm.patient_num)
	from i2b2 fa
	    ,i2b2 la
		,observation_fact tpm
		,patient_dimension p
	where fa.c_fullname like path || '%'
	  and substr(fa.c_visualattributes,2,1) != 'H'
	  and la.c_fullname like fa.c_fullname || '%'
	  and la.c_visualattributes like 'L%'
	  and tpm.patient_num = p.patient_num
	  and p.sourcesystem_cd not like '%:S:%'
	  and la.c_basecode = tpm.concept_cd(+)
	group by fa.c_fullname
			,ltrim(SUBSTR(fa.c_fullname, 1,instr(fa.c_fullname, '\',-1,2)));
			
	stepCt := stepCt + 1;
	czx_write_audit(jobId,databaseName,procedureName,'Insert counts for trial into I2B2DEMODATA concept_counts',SQL%ROWCOUNT,stepCt,'Done');
		
	commit;

	--execute immediate('truncate table tmp_concept_counts');
	
	--SET ANY NODE WITH MISSING OR ZERO COUNTS TO HIDDEN

	update i2b2
	set c_visualattributes = substr(c_visualattributes,1,1) || 'H' || substr(c_visualattributes,3,1)
	where c_fullname like path || '%'
	  and (not exists
			 (select 1 from concept_counts nc
				  where c_fullname = nc.concept_path)
				 or
			 exists
				 (select 1 from concept_counts zc
				  where c_fullname = zc.concept_path
					and zc.patient_count = 0)
			  )
		and c_name != 'SECURITY';
		
	stepCt := stepCt + 1;
	czx_write_audit(jobId,databaseName,procedureName,'Nodes hidden with missing/zero counts for trial into I2B2DEMODATA concept_counts',SQL%ROWCOUNT,stepCt,'Done');
		
	  commit;
    
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
