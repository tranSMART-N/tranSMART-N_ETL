set define off;
CREATE OR REPLACE PROCEDURE "I2B2_BACKOUT_TRIAL" 
(
  trial_id VARCHAR2
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

	TrialID	varchar2(100);
	sqlText	varchar2(1000);
	source_table	varchar2(50);
	release_table	varchar2(50);
	tableOwner		varchar2(50);
	tableName		varchar2(50);
	pExists			int;
	pCount			int;
	rowCt			number;
	topNode			varchar2(2000);
	v_sso_id		number;
  
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
  

BEGIN

	TrialId := upper(trial_id);
  
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
  
	if TrialId is null
	then 
		czx_write_audit(jobId,databaseName,procedureName,'TrialId missing/invalid',0,stepCt,'Done');
		Return;
	end if;

	stepCt := stepCt + 1;
	czx_write_audit(jobId,databaseName,procedureName,'Start procedure ' || procedureName,0,stepCt,'Done');

	--	get top node for study
	
	select min(c_fullname) into topNode
		from i2b2metadata.i2b2
		where sourcesystem_cd = TrialId;
		
	--	load study-specific table names from tm_cz.migrate_tables
	
	select upper(table_owner) as table_owner
		  ,upper(table_name) as table_name
		  ,upper(study_specific) as study_specific
		  ,where_clause
		  ,upper(stage_table_name) as stage_table_name
		  ,upper(coalesce(rebuild_index,'N')) as rebuild_index
	bulk collect into rtn_array
	from tm_cz.migrate_tables
	where upper(study_specific) = 'Y';
	
	if rtn_array.count = 0 then
		stepCt := stepCt + 1;
		czx_write_audit(jobId,databaseName,procedureName,'No records for table in tm_cz.migrate_tables ',0,stepCt,'Done');
		Return;
	end if;

	--	drop all constraints 
		
	select pk.table_name, pk.constraint_name, fk.owner, fk.table_name, fk.constraint_name
	bulk collect into tab_constraints_array
	from all_constraints pk
		,all_constraints fk
	where pk.table_name in (select upper(x.table_name) from tm_cz.migrate_tables x where upper(x.study_specific) = 'Y')
	  and pk.constraint_name = fk.r_constraint_name
	  and fk.constraint_type = 'R';
	  
	if tab_constraints_array.count > 0 then
		for k in tab_constraints_array.first .. tab_constraints_array.last
		loop
			sqlText := 'alter table ' || tab_constraints_array(k).fk_owner || '.' ||
					 tab_constraints_array(k).fk_table_name || ' disable constraint ' || tab_constraints_array(k).fk_constraint_name;
			execute immediate(sqlText);
			stepCt := stepCt + 1;
			--czx_write_audit(jobId,databaseName,procedureName,'Removed constraint from ' || source_table,0,stepCt,'Done');
			czx_write_audit(jobId,databaseName,procedureName,sqlText,1,stepCt,'Done');
		end loop;
	end if;
	
	--	delete study from object or user security tables
	
	select count(*) into pExists
	from searchapp.search_secure_object
	where bio_data_unique_id = 'EXP:' || TrialId;
	
	if pExists > 0 then
		select search_secure_object_id into v_sso_id
		from searchapp.search_secure_object
		where bio_data_unique_id = 'EXP:' || TrialId;
		
		--	delete security for object
		
		delete from searchapp.search_auth_sec_object_access
		where secure_object_id = v_sso_id;
		stepCt := stepCt + 1;
		czx_write_audit(jobId,databaseName,procedureName,'Removed study secure object id from search_auth_sec_object_access',1,stepCt,'Done');
		commit;
		
		--	delete security links between users and study
		
		delete from searchapp.search_auth_user_sec_access
		where search_secure_object_id = v_sso_id;
		stepCt := stepCt + 1;
		czx_write_audit(jobId,databaseName,procedureName,'Removed study secure object id from search_auth_user_sec_access',1,stepCt,'Done');
		commit;
	end if;
		
		
	
	--	delete study from tables
	
	for i in rtn_array.first .. rtn_array.last
	loop
	
		--	setup variables
		
		source_table := rtn_array(i).table_owner || '.' || rtn_array(i).table_name;
		tableName := rtn_array(i).table_name;
		tableOwner := rtn_array(i).table_owner;
		stepCt := stepCt + 1;
		czx_write_audit(jobId,databaseName,procedureName,'Processing ' || source_table,0,stepCt,'Done');
		
		--	drop indexes if rebuild_index = Y
		
		if rtn_array(i).rebuild_index = 'Y' then
			i2b2_table_index_maint('DROP',rtn_array(i).table_name,jobId);
		end if;
		  
		--	delete study from tables
		
		sqlText := 'delete ' || source_table || ' st ' || replace(rtn_array(i).where_clause,'TrialId','''' || TrialId || '''');
		execute immediate(sqlText);
		rowCt := SQL%ROWCOUNT;
		commit;
		stepCt := stepCt + 1;
		czx_write_audit(jobId,databaseName,procedureName,'Deleted study from ' || source_table,rowCt,stepCt,'Done');

		--	add indexes if necessary
		
		if rtn_array(i).rebuild_index = 'Y' then
			i2b2_table_index_maint('ADD',rtn_array(i).table_name,jobId);
		end if;			
	end loop;
	
	--	enable all constraints for dataType
		
	if tab_constraints_array.count > 0 then
		for k in tab_constraints_array.first .. tab_constraints_array.last
		loop
			sqlText := 'alter table ' || tab_constraints_array(k).fk_owner || '.' ||
					 tab_constraints_array(k).fk_table_name || ' enable constraint ' || tab_constraints_array(k).fk_constraint_name;
			execute immediate(sqlText);
			stepCt := stepCt + 1;
			--czx_write_audit(jobId,databaseName,procedureName,'Enabled constraint '||tab_constraints_array(k).fk_constraint_name||' on ' || source_table,1,stepCt,'Done');
			czx_write_audit(jobId,databaseName,procedureName,sqlText,1,stepCt,'Done');
		end loop;
	end if;		
	
	--	delete any data for study in modifier_dimension, modifier_metadata
	
	delete from i2b2demodata.modifier_dimension
	where sourcesystem_cd = trialId;
	stepCt := stepCt + 1;
	czx_write_audit(jobId,databaseName,procedureName,'Delete data for trial from modifier_dimension',SQL%ROWCOUNT,stepCt,'Done');
	commit;	
	
	delete from i2b2demodata.modifier_metadata
	where modifier_cd = 'STUDY:' || trialId;
	stepCt := stepCt + 1;
	czx_write_audit(jobId,databaseName,procedureName,'Delete data for trial from modifier_metadata',SQL%ROWCOUNT,stepCt,'Done');
	commit;	
	
	--	delete tm_lz clinical data
	
	delete from tm_lz.lz_src_clinical_data
	where study_id = trialId;
	stepCt := stepCt + 1;
	czx_write_audit(jobId,databaseName,procedureName,'Delete data for trial from lz_src_clinical_data',SQL%ROWCOUNT,stepCt,'Done');
	commit;
	
	--	delete tm_lz study metadata
	
	delete from tm_lz.lz_src_study_metadata
	where study_id = trialId;
	stepCt := stepCt + 1;
	czx_write_audit(jobId,databaseName,procedureName,'Delete data for trial from lz_src_study_metadata',SQL%ROWCOUNT,stepCt,'Done');
	commit;

	--	reload i2b2_secure
	
	i2b2_load_security_data(jobId);
	
	stepCt := stepCt + 1;
	czx_write_audit(jobId,databaseName,procedureName,'End procedure ' || procedureName,SQL%ROWCOUNT,stepCt,'Done');
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

 
