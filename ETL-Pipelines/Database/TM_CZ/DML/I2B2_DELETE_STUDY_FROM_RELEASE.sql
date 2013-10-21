
  CREATE OR REPLACE PROCEDURE "I2B2_DELETE_STUDY_FROM_RELEASE" 
(
  trial_id IN VARCHAR2
-- ,ont_Path IN VARCHAR2	--	Use this parameter if TrialID is not contained in the i2b2/concept_dimension paths.  This will specify the string to use in filters
 ,currentJobID NUMBER := null
 )
AS

	TrialId varchar2(200);
	ontPath varchar2(200);

	sql_txt varchar2(2000);
	tExists number;

	--Audit variables
	newJobFlag INTEGER(1);
	databaseName VARCHAR(100);
	procedureName VARCHAR(100);
	jobID number(18,0);
	stepCt number(18,0);

	--	JEA@20100624	Removed gene_symbol, renamed probeset to probeset_id in de_subject_mrna_data_release
	--					added de_mrna_annotation_release
	--	JEA@@0100915	Added haploview_data_release
BEGIN

	TrialID := upper(trial_id);
	
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
		cz_start_audit (procedureName, databaseName, jobID);
	END IF;
  
	stepCt := stepCt + 1;
	cz_write_audit(jobId,databaseName,procedureName,'Starting i2b2_promote_to_stg',0,stepCt,'Done');

	if TrialId = null then
		stepCt := stepCt + 1;
		cz_write_audit(jobId,databaseName,procedureName,'TrialID missing',0,stepCt,'Done');
		Return;
	end if;

	if ontPath = null or ontPath = '' or ontPath = '%'then
		stepCt := stepCt + 1;
		cz_write_audit(jobId,databaseName,procedureName,'ontPath invalid',0,stepCt,'Done');
		Return;
	End if;

	--	Delete existing data for trial
	
	delete i2b2_release
	where release_study = TrialID;
	stepCt := stepCt + 1;
	cz_write_audit(jobId,databaseName,procedureName,'Deleted trial from CONTROL i2b2_release',SQL%ROWCOUNT,stepCt,'Done');
	commit;

	delete observation_fact_release
	where release_study = TrialID;
	stepCt := stepCt + 1;
	cz_write_audit(jobId,databaseName,procedureName,'Deleted trial from CONTROL observation_fact_release',SQL%ROWCOUNT,stepCt,'Done');
	commit;

	delete patient_dimension_release
	where release_study = TrialID;
	stepCt := stepCt + 1;
	cz_write_audit(jobId,databaseName,procedureName,'Deleted trial from CONTROL patient_dimension_release',SQL%ROWCOUNT,stepCt,'Done');
	commit;

	delete concept_dimension_release
	where release_study = TrialID;
	stepCt := stepCt + 1;
	cz_write_audit(jobId,databaseName,procedureName,'Deleted trial from CONTROL concept_dimension_release',SQL%ROWCOUNT,stepCt,'Done');
	commit;

	delete de_subj_sample_map_release
	where release_study = TrialID;
	stepCt := stepCt + 1;
	cz_write_audit(jobId,databaseName,procedureName,'Deleted trial from CONTROL de_subj_sample_map_release',SQL%ROWCOUNT,stepCt,'Done');
	commit;

	delete de_subject_mrna_data_release
	where release_study = TrialID;
	stepCt := stepCt + 1;
	cz_write_audit(jobId,databaseName,procedureName,'Deleted trial from CONTROL de_subject_mrna_data_release',SQL%ROWCOUNT,stepCt,'Done');
	commit;

	delete de_subject_rbm_data_release
	where release_study = TrialID;
	stepCt := stepCt + 1;
	cz_write_audit(jobId,databaseName,procedureName,'Deleted trial from CONTROL de_subject_rbm_data_release',SQL%ROWCOUNT,stepCt,'Done');
	commit;

	delete de_subj_protein_data_release
	where release_study = TrialID;
	stepCt := stepCt + 1;
	cz_write_audit(jobId,databaseName,procedureName,'Deleted trial from CONTROL de_subj_protein_data_release',SQL%ROWCOUNT,stepCt,'Done');
	commit;

	delete haploview_data_release
	where release_study = TrialID;
	stepCt := stepCt + 1;
	cz_write_audit(jobId,databaseName,procedureName,'Deleted trial from CONTROL haploview_data_release',SQL%ROWCOUNT,stepCt,'Done');
	commit;

	delete i2b2_tags_release
	where release_study = TrialID;
	stepCt := stepCt + 1;
	cz_write_audit(jobId,databaseName,procedureName,'Deleted trial from CONTROL i2b2_tags_release',SQL%ROWCOUNT,stepCt,'Done');
	commit;

	delete bio_experiment_release
	where release_study = TrialID;
	stepCt := stepCt + 1;
	cz_write_audit(jobId,databaseName,procedureName,'Deleted trial from CONTROL bio_experiment_release',SQL%ROWCOUNT,stepCt,'Done');
	commit;

	delete bio_clinical_trial_release
	where release_study = TrialID;
	stepCt := stepCt + 1;
	cz_write_audit(jobId,databaseName,procedureName,'Deleted trial from CONTROL bio_clinical_trial_release',SQL%ROWCOUNT,stepCt,'Done');
	commit;	

	delete bio_data_uid_release
	where release_study = TrialID;
	stepCt := stepCt + 1;
	cz_write_audit(jobId,databaseName,procedureName,'Deleted trial from CONTROL bio_data_uid_release',SQL%ROWCOUNT,stepCt,'Done');
	commit;	

	delete bio_data_compound_release
	where release_study = TrialID;
	stepCt := stepCt + 1;
	cz_write_audit(jobId,databaseName,procedureName,'Deleted trial from CONTROL bio_data_compound_release',SQL%ROWCOUNT,stepCt,'Done');
	commit;	

	delete search_secure_object_release
	where release_study = TrialID;
	stepCt := stepCt + 1;
	cz_write_audit(jobId,databaseName,procedureName,'Deleted trial from CONTROL search_secure_object_release',SQL%ROWCOUNT,stepCt,'Done');
	commit;	
	
	stepCt := stepCt + 1;
	cz_write_audit(jobId,databaseName,procedureName,'End i2b2_promote_to_stg',0,stepCt,'Done');
	
       ---Cleanup OVERALL JOB if this proc is being run standalone
  IF newJobFlag = 1
  THEN
    cz_end_audit (jobID, 'SUCCESS');
  END IF;

  EXCEPTION
  WHEN OTHERS THEN
    --Handle errors.
    cz_error_handler (jobID, procedureName);
    --End Proc
    cz_end_audit (jobID, 'FAIL');

END;

/*	Create release tables

	create table i2b2_release as
	select x.*, x.sourcesystem_cd as release_study
	from i2b2 x
	where 1=2'

	create table observation_fact_release as
	select x.*, x.modifier_cd as release_study
	from observation_fact x
	where 1=2	

	create table patient_dimension_release as
	select x.*, x.sourcesystem_cd as release_study 
	from patient_dimension x
	where 1=2

	create table concept_dimension_release as
	select x.*, x.sourcesystem_cd as release_study 
	from concept_dimension x
	where 1=2
	
	create table de_subj_sample_map_release as
	select x.*, x.trial_name as release_study
	from deapp.de_subject_sample_mapping x
	where 1=2
	
	create table de_subject_mrna_data_release as
	select x.*, x.trial_name as release_study 
	from deapp.de_subject_microarray_data x
	where 1=2
	
	create table de_subject_rbm_data_release as
	select x.*, x.trial_name as release_study 
	from deapp.de_subject_rbm_data x
	where 1=2
	
	create table de_subj_protein_data_release as
	select x.*, x.trial_name as release_study
	from deapp.de_subject_protein_data x
	where 1=2
	
	create table i2b2_tags_release as
	select x.*, x.path as release_study 
	from i2b2_tags x
	where 1=2
	
	create table bio_experiment_release as
	select x.*, x.accession as release_study 
	from biomart.bio_experiment x
	where 1=2
	
	create table bio_clinical_trial_release as
	select x.*, x.trial_number as release_study 
	from biomart.bio_clinical_trial x
	where 1=2
	
	create table bio_data_uid_release as
	select x.*, x.unique_id as release_study 
	from biomart.bio_data_uid x
	where 1=2
	
	create table bio_data_compound_release as
	select c.*, b.accession as release_study 
	from biomart.bio_data_compound c
		,biomart.bio_experiment b
	where 1=2
	
	create table search_secure_object_release as
	select c.*, b.accession as release_study
	from searchapp.search_secure_object c
	    ,biomart.bio_experiment b
	where 1=2
	
*/
 /
 
