set define off;
CREATE OR REPLACE PROCEDURE "I2B2_LINK_ADDITIONAL_DATA" 
( currentJobID NUMBER := null
, rtn_code OUT number
)
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

	pexists			int;
	subjCt			int;
	
	--Audit variables
	newJobFlag INTEGER(1);
	databaseName VARCHAR(100);
	procedureName VARCHAR(100);
	jobID number(18,0);
	stepCt number(18,0);
	
	no_repository		exception;
	unmapped_subjects	exception;

BEGIN

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
	
	select count(*) into pExists
	from (select t.platform, bcr.location
		  from tm_lz.lt_src_mrna_subj_samp_map t
		  left outer join biomart.bio_content_repository bcr
			   on  upper(t.platform) = upper(bcr.repository_type)
		  where bcr.location is null
		    and not exists
				(select 1 from deapp.de_gpl_info g
				 where t.platform = g.platform));
		  
	if pExists > 0 then
		raise no_repository;
	end if;
	
	--	check to make sure subject map to patient_dimension
	
	select count(*) into subjCt
	from tm_lz.lt_src_mrna_subj_samp_map t
	where not exists
		 (select 1 from deapp.de_gpl_info g
		  where t.platform = g.platform);
	
	select count(*) into pExists
	from lt_src_mrna_subj_samp_map t
		,patient_dimension pd
	where REGEXP_REPLACE(t.trial_name || ':' || t.site_id || ':' || t.subject_id,
                   '(::){1,}', ':') = pd.sourcesystem_cd
	  and not exists
		 (select 1 from deapp.de_gpl_info g
		  where t.platform = g.platform);
	stepCt := stepCt + 1;
	czx_write_audit(jobId,databaseName,procedureName,'Check patient mapping',SQL%ROWCOUNT,stepCt,'Done');
	
	if pExists < subjCt then
		raise unmapped_subjects;
	end if;

	--	insert additional data into bio_content
	
	insert into bio_content
	(file_name			-- filename value in sample_cd without extension
	,repository_id		-- bio_content_repo_id
	,location			-- study_id
	,title				-- null
	,abstract			-- null
	,file_type			-- 'Data'
	,etl_id				-- null
	,etl_id_c			-- study_id
	,study_name			-- study_id
	,cel_location		-- url for site, example http://157.206.120.144:7070/CEL/BSI201_20070102/
	,cel_file_suffix	-- filename extension (everything to right of first .)
	)
	select distinct substr(t.sample_cd,1,instr(t.sample_cd,'.')-1) as file_name
	,bc.bio_content_repo_id
	,t.trial_name as location
	,null as title
	,null as abstract
	,'Data' as file_type
	,null as etl_id
	,t.trial_name as etl_id_c
	,t.trial_name as study_name
	,bc.location || '/' || t.trial_name || '/' as cel_location
	,substr(t.sample_cd,instr(t.sample_cd,'.')) as cel_file_suffix
	from lt_src_mrna_subj_samp_map t
		,bio_content_repository bc
	where upper(bc.repository_type) = upper(t.platform)
	  --and t.platform not in (select distinct x.platform from de_gpl_info x)
	  and not exists
		 (select 1 from bio_content x
		  where substr(t.sample_cd,1,instr(t.sample_cd,'.')-1) = x.file_name
		    and bc.bio_content_repo_id = x.repository_id
			and t.trial_name = x.location
			and bc.location || '/' || t.trial_name = x.cel_location
			and substr(t.sample_cd,instr(t.sample_cd,'.')) = x.cel_file_suffix);
	
	stepCt := stepCt + 1;
	czx_write_audit(jobId,databaseName,procedureName,'Add additional data links to bio_content',SQL%ROWCOUNT,stepCt,'Done');
	commit;
			
	--	insert into bio_experiment if needed

	insert into bio_experiment
	(bio_experiment_type
	,title
	,etl_id
	,accession)
	select distinct 'Experiment'
	,'Metadata not available'
	,'METADATA:' || t.trial_name
	,t.trial_name
	from lt_src_mrna_subj_samp_map t
	where not exists 
		(select 1 from bio_experiment x
		 where t.trial_name = x.accession);

	stepCt := stepCt + 1;
	czx_write_audit(jobId,databaseName,procedureName,'Added trial to bio_experiment if needed',SQL%ROWCOUNT,stepCt,'Done');

	--	insert into bio_content_reference
	
	insert into bio_content_reference
	(bio_content_id
	,bio_data_id	
	,content_reference_type
	,etl_id
	,etl_id_c
	)
	select distinct bc.bio_file_content_id
	,be.bio_experiment_id
	,'Data'
	,null
	,'METADATA:' || sm.trial_name
	from lt_src_mrna_subj_samp_map sm
		,bio_content bc
		,bio_experiment be
	where sm.trial_name = bc.etl_id_c
	and sm.trial_name = be.accession
	and bc.file_type = 'Data'
	and not exists
	  (select 1 from bio_content_reference x
	   where x.bio_content_id = bc.bio_file_content_id
		 and x.bio_data_id = be.bio_experiment_id
		 and x.content_reference_type = 'Data');

	stepCt := stepCt + 1;
	czx_write_audit(jobId,databaseName,procedureName,'Added data to bio_content_reference',SQL%ROWCOUNT,stepCt,'Done');

	--	insert records into de_subject_sample_mapping with dummy concept codes (-1)

	insert into de_subject_sample_mapping
	select distinct pd.patient_num as patient_id
		  ,null as site_id
		  ,t.subject_id
		  ,null as subject_type
		  ,-1 as concept_cd
		  ,-1 as assay_id
		  ,null as patient_uid
		  ,null as sample_type
		  ,null as assay_uid
		  ,t.trial_name as trial_name
		  ,null as timepoint
		  ,-1 as timepoint_cd
		  ,-1 as sample_type_cd
		  ,-1 as tissue_type_cd
		  ,t.platform as platform
		  ,-1 as platform_cd
		  ,null as tissue_type
		  ,null as data_uid
		  ,null as gpl_id
		  ,null as rbm_panel
		  ,null as sample_id
		  ,substr(t.sample_cd,1,instr(t.sample_cd,'.')-1) as sample_cd
		  ,null as category_cd
		  ,'ADDL' as source_cd
		  ,t.trial_name as omic_source_study
		  ,pd.patient_num as omic_patient_num
	from lt_src_mrna_subj_samp_map t
		,patient_dimension pd
	where REGEXP_REPLACE(t.trial_name || ':' || t.site_id || ':' || t.subject_id,
                   '(::){1,}', ':') = pd.sourcesystem_cd
	  and not exists
		  (select 1 from deapp.de_gpl_info g
		   where t.platform = g.platform);
	pExists := SQL%ROWCOUNT;
	stepCt := stepCt + 1;
	czx_write_audit(jobId,databaseName,procedureName,'Insert additional data records into de_subject_sample_mapping',SQL%ROWCOUNT,stepCt,'Done');

	stepCt := stepCt + 1;
	czx_write_audit(jobId,databaseName,procedureName,'End ' || procedureName,0,stepCt,'Done');
	
       ---Cleanup OVERALL JOB if this proc is being run standalone
	IF newJobFlag = 1
	THEN
		czx_end_audit (jobID, 'SUCCESS');
	END IF;

	rtn_code := 0;
	
	EXCEPTION
	when no_repository then
		stepCt := stepCt + 1;
		czx_write_audit(jobId,databaseName,procedureName,'At least one platform in lt_src_mrna_subj_samp_map does not exist in bio_content_repository',0,stepCt,'Done');
		-- End Proc
		czx_end_audit (jobID, 'FAIL');
		rtn_code := 16;
	when unmapped_subjects then
		stepCt := stepCt + 1;
		czx_write_audit(jobId,databaseName,procedureName,'One or more subject in subject_sample map file are not mapped to patients',0,stepCt,'Done');
		-- End Proc
		czx_end_audit (jobID, 'FAIL');
		rtn_code := 16;
	WHEN OTHERS THEN
		--Handle errors.
		czx_error_handler (jobID, procedureName);
		-- End Proc
		czx_end_audit (jobID, 'FAIL');
		rtn_code := 16;

END;