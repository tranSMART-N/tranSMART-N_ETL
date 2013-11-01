--------------------------------------------------------
--  File created - Thursday-October-17-2013   
--------------------------------------------------------
--------------------------------------------------------
--  DDL for Table MIGRATE_TABLES
--------------------------------------------------------
drop table tm_cz.migrate_tables;
  CREATE TABLE "TM_CZ"."MIGRATE_TABLES" ("DATA_TYPE" VARCHAR(50), "TABLE_OWNER" VARCHAR(50), "TABLE_NAME" VARCHAR(50), "STUDY_SPECIFIC" CHAR(1), "WHERE_CLAUSE" VARCHAR(2000), "INSERT_SEQ" INT4, "STAGE_TABLE_NAME" varchar(100), "REBUILD_INDEX" CHAR(1), "DELETE_SEQ" INT4) ;

Insert into TM_CZ.MIGRATE_TABLES (DATA_TYPE,TABLE_OWNER,TABLE_NAME,STUDY_SPECIFIC,WHERE_CLAUSE,INSERT_SEQ,STAGE_TABLE_NAME,REBUILD_INDEX,DELETE_SEQ) values ('CLINICAL','DEAPP','DE_ENCOUNTER_TYPE','Y','where st.study_id = TrialId',null,'DE_ENCOUNTER_TYPE_RELEASE','Y',null);
Insert into TM_CZ.MIGRATE_TABLES (DATA_TYPE,TABLE_OWNER,TABLE_NAME,STUDY_SPECIFIC,WHERE_CLAUSE,INSERT_SEQ,STAGE_TABLE_NAME,REBUILD_INDEX,DELETE_SEQ) values ('CLINICAL','DEAPP','DE_ENCOUNTER_LEVEL','Y','where st.study_id = TrialId',null,'DE_ENCOUNTER_LEVEL_RELEASE','Y',null);
Insert into TM_CZ.MIGRATE_TABLES (DATA_TYPE,TABLE_OWNER,TABLE_NAME,STUDY_SPECIFIC,WHERE_CLAUSE,INSERT_SEQ,STAGE_TABLE_NAME,REBUILD_INDEX,DELETE_SEQ) values ('CLINICAL','DEAPP','DE_OBS_ENROLL_DAYS','Y','where st.study_id = TrialId',null,'DE_OBS_ENROLL_DAYS_RELEASE','Y',null);
Insert into TM_CZ.MIGRATE_TABLES (DATA_TYPE,TABLE_OWNER,TABLE_NAME,STUDY_SPECIFIC,WHERE_CLAUSE,INSERT_SEQ,STAGE_TABLE_NAME,REBUILD_INDEX,DELETE_SEQ) values ('CLINICAL','DEAPP','DE_CONCEPT_VISIT','Y','where st.sourcesystem_cd = TrialId',null,'DE_CONCEPT_VISIT_RELEASE','N',null);
Insert into TM_CZ.MIGRATE_TABLES (DATA_TYPE,TABLE_OWNER,TABLE_NAME,STUDY_SPECIFIC,WHERE_CLAUSE,INSERT_SEQ,STAGE_TABLE_NAME,REBUILD_INDEX,DELETE_SEQ) values ('CLINICAL','I2B2METADATA','I2B2','Y','where st.sourcesystem_cd = TrialId',null,'I2B2_RELEASE',null,null);
Insert into TM_CZ.MIGRATE_TABLES (DATA_TYPE,TABLE_OWNER,TABLE_NAME,STUDY_SPECIFIC,WHERE_CLAUSE,INSERT_SEQ,STAGE_TABLE_NAME,REBUILD_INDEX,DELETE_SEQ) values ('CLINICAL','I2B2DEMODATA','CONCEPT_DIMENSION','Y','where st.sourcesystem_cd = TrialId',null,'CONCEPT_DIMENSION_RELEASE',null,null);
Insert into TM_CZ.MIGRATE_TABLES (DATA_TYPE,TABLE_OWNER,TABLE_NAME,STUDY_SPECIFIC,WHERE_CLAUSE,INSERT_SEQ,STAGE_TABLE_NAME,REBUILD_INDEX,DELETE_SEQ) values ('CLINICAL','I2B2DEMODATA','OBSERVATION_FACT','Y','where st.modifier_cd = TrialId or st.sourcesystem_cd = TrialId',null,'OBSERVATION_FACT_RELEASE','Y',null);
Insert into TM_CZ.MIGRATE_TABLES (DATA_TYPE,TABLE_OWNER,TABLE_NAME,STUDY_SPECIFIC,WHERE_CLAUSE,INSERT_SEQ,STAGE_TABLE_NAME,REBUILD_INDEX,DELETE_SEQ) values ('CLINICAL','I2B2DEMODATA','PATIENT_DIMENSION','Y','where st.sourcesystem_cd like TrialId || '':%''',null,'PATIENT_DIMENSION_RELEASE',null,null);
Insert into TM_CZ.MIGRATE_TABLES (DATA_TYPE,TABLE_OWNER,TABLE_NAME,STUDY_SPECIFIC,WHERE_CLAUSE,INSERT_SEQ,STAGE_TABLE_NAME,REBUILD_INDEX,DELETE_SEQ) values ('CLINICAL','I2B2DEMODATA','MODIFIER_DIMENSION','N',null,null,'MODIFIER_DIMENSION_RELEASE',null,null);
Insert into TM_CZ.MIGRATE_TABLES (DATA_TYPE,TABLE_OWNER,TABLE_NAME,STUDY_SPECIFIC,WHERE_CLAUSE,INSERT_SEQ,STAGE_TABLE_NAME,REBUILD_INDEX,DELETE_SEQ) values ('CLINICAL','I2B2DEMODATA','MODIFIER_METADATA','N',null,null,'MODIFIER_METADATA_RELEASE',null,null);
Insert into TM_CZ.MIGRATE_TABLES (DATA_TYPE,TABLE_OWNER,TABLE_NAME,STUDY_SPECIFIC,WHERE_CLAUSE,INSERT_SEQ,STAGE_TABLE_NAME,REBUILD_INDEX,DELETE_SEQ) values ('CLINICAL','SEARCHAPP','SEARCH_SECURE_OBJECT','Y','where bio_data_unique_id = ''EXP:'' || TrialId',null,'SEARCH_SECURE_OBJECT_RELEASE',null,null);
Insert into TM_CZ.MIGRATE_TABLES (DATA_TYPE,TABLE_OWNER,TABLE_NAME,STUDY_SPECIFIC,WHERE_CLAUSE,INSERT_SEQ,STAGE_TABLE_NAME,REBUILD_INDEX,DELETE_SEQ) values ('CLINICAL','I2B2DEMODATA','CONCEPT_COUNTS','Y','where st.concept_path in (select x.c_fullname from i2b2metadata.i2b2 x where x.sourcesystem_cd = TrialId)',null,'CONCEPT_COUNTS_RELEASE',null,null);
Insert into TM_CZ.MIGRATE_TABLES (DATA_TYPE,TABLE_OWNER,TABLE_NAME,STUDY_SPECIFIC,WHERE_CLAUSE,INSERT_SEQ,STAGE_TABLE_NAME,REBUILD_INDEX,DELETE_SEQ) values ('METADATA','BIOMART','BIO_EXPERIMENT','Y','where st.accession = TrialId',10,'BIO_EXPERIMENT_RELEASE',null,90);
Insert into TM_CZ.MIGRATE_TABLES (DATA_TYPE,TABLE_OWNER,TABLE_NAME,STUDY_SPECIFIC,WHERE_CLAUSE,INSERT_SEQ,STAGE_TABLE_NAME,REBUILD_INDEX,DELETE_SEQ) values ('METADATA','BIOMART','BIO_DATA_DISEASE','Y','where st.etl_source = ''METADATA:'' || TrialId',40,'BIO_DATA_DISEASE_RELEASE',null,60);
Insert into TM_CZ.MIGRATE_TABLES (DATA_TYPE,TABLE_OWNER,TABLE_NAME,STUDY_SPECIFIC,WHERE_CLAUSE,INSERT_SEQ,STAGE_TABLE_NAME,REBUILD_INDEX,DELETE_SEQ) values ('METADATA','BIOMART','BIO_AD_HOC_PROPERTY','Y','where st.bio_data_id = (select x.bio_experiment_id from biomart.bio_experiment x where x.accession = TrialId)',20,'BIO_AD_HOC_PROPERTY_RELEASE',null,80);
Insert into TM_CZ.MIGRATE_TABLES (DATA_TYPE,TABLE_OWNER,TABLE_NAME,STUDY_SPECIFIC,WHERE_CLAUSE,INSERT_SEQ,STAGE_TABLE_NAME,REBUILD_INDEX,DELETE_SEQ) values ('METADATA','BIOMART','BIO_DATA_UID','Y','where st.unique_id = ''EXP:'' || TrialId',30,'BIO_DATA_UID_RELEASE',null,70);
Insert into TM_CZ.MIGRATE_TABLES (DATA_TYPE,TABLE_OWNER,TABLE_NAME,STUDY_SPECIFIC,WHERE_CLAUSE,INSERT_SEQ,STAGE_TABLE_NAME,REBUILD_INDEX,DELETE_SEQ) values ('METADATA','BIOMART','BIO_DATA_COMPOUND','Y','where st.etl_source = ''METADATA:'' || TrialId',50,'BIO_DATA_COMPOUND_RELEASE',null,50);
Insert into TM_CZ.MIGRATE_TABLES (DATA_TYPE,TABLE_OWNER,TABLE_NAME,STUDY_SPECIFIC,WHERE_CLAUSE,INSERT_SEQ,STAGE_TABLE_NAME,REBUILD_INDEX,DELETE_SEQ) values ('METADATA','BIOMART','BIO_DATA_TAXONOMY','Y','where st.etl_source = ''METADATA:'' || TrialId',60,'BIO_DATA_TAXONOMY_RELEASE',null,40);
Insert into TM_CZ.MIGRATE_TABLES (DATA_TYPE,TABLE_OWNER,TABLE_NAME,STUDY_SPECIFIC,WHERE_CLAUSE,INSERT_SEQ,STAGE_TABLE_NAME,REBUILD_INDEX,DELETE_SEQ) values ('METADATA','BIOMART','BIO_CONTENT_REPOSITORY','N',null,70,'BIO_CONTENT_REPOSITORY_RELEASE',null,30);
Insert into TM_CZ.MIGRATE_TABLES (DATA_TYPE,TABLE_OWNER,TABLE_NAME,STUDY_SPECIFIC,WHERE_CLAUSE,INSERT_SEQ,STAGE_TABLE_NAME,REBUILD_INDEX,DELETE_SEQ) values ('METADATA','BIOMART','BIO_CONTENT_REFERENCE','Y','where st.etl_id_c = ''METADATA:'' || TrialId',90,'BIO_CONTENT_REFERENCE_RELEASE',null,10);
Insert into TM_CZ.MIGRATE_TABLES (DATA_TYPE,TABLE_OWNER,TABLE_NAME,STUDY_SPECIFIC,WHERE_CLAUSE,INSERT_SEQ,STAGE_TABLE_NAME,REBUILD_INDEX,DELETE_SEQ) values ('METADATA','BIOMART','BIO_CONTENT','Y','where st.etl_id_c = ''METADATA:'' || TrialId',80,'BIO_CONTENT_RELEASE',null,20);
Insert into TM_CZ.MIGRATE_TABLES (DATA_TYPE,TABLE_OWNER,TABLE_NAME,STUDY_SPECIFIC,WHERE_CLAUSE,INSERT_SEQ,STAGE_TABLE_NAME,REBUILD_INDEX,DELETE_SEQ) values ('CLINICAL','I2B2DEMODATA','VISIT_DIMENSION','Y','where st.sourcesystem_cd = TrialId',null,'VISIT_DIMENSION_RELEASE','Y',null);
Insert into TM_CZ.MIGRATE_TABLES (DATA_TYPE,TABLE_OWNER,TABLE_NAME,STUDY_SPECIFIC,WHERE_CLAUSE,INSERT_SEQ,STAGE_TABLE_NAME,REBUILD_INDEX,DELETE_SEQ) values ('CLINICAL','I2B2DEMODATA','PATIENT_TRIAL','Y','where st.trial = TrialId',null,'PATIENT_TRIAL_RELEASE',null,null);
Insert into TM_CZ.MIGRATE_TABLES (DATA_TYPE,TABLE_OWNER,TABLE_NAME,STUDY_SPECIFIC,WHERE_CLAUSE,INSERT_SEQ,STAGE_TABLE_NAME,REBUILD_INDEX,DELETE_SEQ) values ('CLINICAL','BIOMART','BIO_CLINICAL_TRIAL','Y','where st.trial_number = TrialId',82,'BIO_CLINICAL_TRIAL_RELEASE',null,18);
Insert into TM_CZ.MIGRATE_TABLES (DATA_TYPE,TABLE_OWNER,TABLE_NAME,STUDY_SPECIFIC,WHERE_CLAUSE,INSERT_SEQ,STAGE_TABLE_NAME,REBUILD_INDEX,DELETE_SEQ) values ('GEX','DEAPP','DE_SUBJECT_SAMPLE_MAPPING','Y','where st.trial_name = TrialId and st.platform='||'''' || 'MRNA_AFFYMETRIX' || '''',82,'DE_SUBJ_SAMPLE_MAP_RELEASE',null,18);
Insert into TM_CZ.MIGRATE_TABLES (DATA_TYPE,TABLE_OWNER,TABLE_NAME,STUDY_SPECIFIC,WHERE_CLAUSE,INSERT_SEQ,STAGE_TABLE_NAME,REBUILD_INDEX,DELETE_SEQ) values ('GEX','DEAPP','DE_SUBJECT_MICROARRAY_DATA','Y','where st.trial_name = TrialId',82,'DE_SUBJ_MICROARRAY_RELEASE',null,18);
Insert into TM_CZ.MIGRATE_TABLES (DATA_TYPE,TABLE_OWNER,TABLE_NAME,STUDY_SPECIFIC,WHERE_CLAUSE,INSERT_SEQ,STAGE_TABLE_NAME,REBUILD_INDEX,DELETE_SEQ) values ('GEX','DEAPP','DE_MRNA_ANNOTATION','N',null,null,'DE_MRNA_ANNOTATION_RELEASE',null,null);