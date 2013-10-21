--------------------------------------------------------
--  File created - Monday-June-03-2013   
--------------------------------------------------------
--------------------------------------------------------
--  DDL for Table MIGRATE_TABLES
--------------------------------------------------------
-- drop table tm_cz.migrate_tables;
CREATE TABLE "TM_CZ"."MIGRATE_TABLES" ("DATA_TYPE" VARCHAR2(50), "TABLE_OWNER" VARCHAR2(50), "TABLE_NAME" VARCHAR2(50), "STUDY_SPECIFIC" CHAR(1), "WHERE_CLAUSE" VARCHAR2(2000), "DATA_TYPE_SEQ" NUMBER(*,0), "STAGE_TABLE_NAME" VARCHAR2(50), "REBUILD_INDEX" CHAR(1)) ;
REM INSERTING into TM_CZ.MIGRATE_TABLES
SET DEFINE OFF;
Insert into TM_CZ.MIGRATE_TABLES (DATA_TYPE,TABLE_OWNER,TABLE_NAME,STUDY_SPECIFIC,WHERE_CLAUSE,DATA_TYPE_SEQ,STAGE_TABLE_NAME,REBUILD_INDEX) values ('CLINICAL','I2B2METADATA','I2B2','Y','where st.sourcesystem_cd = TrialId',null,'I2B2_RELEASE',null);
Insert into TM_CZ.MIGRATE_TABLES (DATA_TYPE,TABLE_OWNER,TABLE_NAME,STUDY_SPECIFIC,WHERE_CLAUSE,DATA_TYPE_SEQ,STAGE_TABLE_NAME,REBUILD_INDEX) values ('CLINICAL','I2B2DEMODATA','CONCEPT_DIMENSION','Y','where st.sourcesystem_cd = TrialId',null,'CONCEPT_DIMENSION_RELEASE',null);
Insert into TM_CZ.MIGRATE_TABLES (DATA_TYPE,TABLE_OWNER,TABLE_NAME,STUDY_SPECIFIC,WHERE_CLAUSE,DATA_TYPE_SEQ,STAGE_TABLE_NAME,REBUILD_INDEX) values ('CLINICAL','I2B2DEMODATA','OBSERVATION_FACT','Y','where st.modifier_cd = TrialId or st.sourcesystem_cd = TrialId',null,'OBSERVATION_FACT_RELEASE','Y');
Insert into TM_CZ.MIGRATE_TABLES (DATA_TYPE,TABLE_OWNER,TABLE_NAME,STUDY_SPECIFIC,WHERE_CLAUSE,DATA_TYPE_SEQ,STAGE_TABLE_NAME,REBUILD_INDEX) values ('CLINICAL','I2B2DEMODATA','PATIENT_DIMENSION','Y','where st.sourcesystem_cd like TrialId || '':%''',null,'PATIENT_DIMENSION_RELEASE',null);
Insert into TM_CZ.MIGRATE_TABLES (DATA_TYPE,TABLE_OWNER,TABLE_NAME,STUDY_SPECIFIC,WHERE_CLAUSE,DATA_TYPE_SEQ,STAGE_TABLE_NAME,REBUILD_INDEX) values ('CLINICAL','I2B2DEMODATA','MODIFIER_DIMENSION','N',null,null,'MODIFIER_DIMENSION_RELEASE',null);
Insert into TM_CZ.MIGRATE_TABLES (DATA_TYPE,TABLE_OWNER,TABLE_NAME,STUDY_SPECIFIC,WHERE_CLAUSE,DATA_TYPE_SEQ,STAGE_TABLE_NAME,REBUILD_INDEX) values ('CLINICAL','I2B2DEMODATA','MODIFIER_METADATA','N',null,null,'MODIFIER_METADATA_RELEASE',null);
Insert into TM_CZ.MIGRATE_TABLES (DATA_TYPE,TABLE_OWNER,TABLE_NAME,STUDY_SPECIFIC,WHERE_CLAUSE,DATA_TYPE_SEQ,STAGE_TABLE_NAME,REBUILD_INDEX) values ('CLINICAL','SEARCHAPP','SEARCH_SECURE_OBJECT','Y','where bio_data_unique_id = ''EXP:'' || TrialId',null,'SEARCH_SECURE_OBJECT_RELEASE',null);
Insert into TM_CZ.MIGRATE_TABLES (DATA_TYPE,TABLE_OWNER,TABLE_NAME,STUDY_SPECIFIC,WHERE_CLAUSE,DATA_TYPE_SEQ,STAGE_TABLE_NAME,REBUILD_INDEX) values ('CLINICAL','I2B2DEMODATA','CONCEPT_COUNTS','Y','where st.concept_path in (select x.c_fullname from i2b2metadata.i2b2 x where x.sourcesystem_cd = TrialId)',null,'CONCEPT_COUNTS_RELEASE',null);
Insert into TM_CZ.MIGRATE_TABLES (DATA_TYPE,TABLE_OWNER,TABLE_NAME,STUDY_SPECIFIC,WHERE_CLAUSE,DATA_TYPE_SEQ,STAGE_TABLE_NAME,REBUILD_INDEX) values ('METADATA','BIOMART','BIO_EXPERIMENT','Y','where st.accession = TrialId',1,'BIO_EXPERIMENT_RELEASE',null);
Insert into TM_CZ.MIGRATE_TABLES (DATA_TYPE,TABLE_OWNER,TABLE_NAME,STUDY_SPECIFIC,WHERE_CLAUSE,DATA_TYPE_SEQ,STAGE_TABLE_NAME,REBUILD_INDEX) values ('METADATA','BIOMART','BIO_DATA_DISEASE','Y','where st.etl_source = ''METADATA:'' || TrialId',4,'BIO_DATA_DISEASE_RELEASE',null);
Insert into TM_CZ.MIGRATE_TABLES (DATA_TYPE,TABLE_OWNER,TABLE_NAME,STUDY_SPECIFIC,WHERE_CLAUSE,DATA_TYPE_SEQ,STAGE_TABLE_NAME,REBUILD_INDEX) values ('METADATA','BIOMART','BIO_AD_HOC_PROPERTY','Y','where st.bio_data_id = (select x.bio_experiment_id from biomart.bio_experiment x where x.accession = TrialId)',2,'BIO_AD_HOC_PROPERTY_RELEASE',null);
Insert into TM_CZ.MIGRATE_TABLES (DATA_TYPE,TABLE_OWNER,TABLE_NAME,STUDY_SPECIFIC,WHERE_CLAUSE,DATA_TYPE_SEQ,STAGE_TABLE_NAME,REBUILD_INDEX) values ('METADATA','BIOMART','BIO_DATA_UID','Y','where st.unique_id = ''EXP:'' || TrialId',3,'BIO_DATA_UID_RELEASE',null);
Insert into TM_CZ.MIGRATE_TABLES (DATA_TYPE,TABLE_OWNER,TABLE_NAME,STUDY_SPECIFIC,WHERE_CLAUSE,DATA_TYPE_SEQ,STAGE_TABLE_NAME,REBUILD_INDEX) values ('METADATA','BIOMART','BIO_DATA_COMPOUND','Y','where st.etl_source = ''METADATA:'' || TrialId',5,'BIO_DATA_COMPOUND_RELEASE',null);
Insert into TM_CZ.MIGRATE_TABLES (DATA_TYPE,TABLE_OWNER,TABLE_NAME,STUDY_SPECIFIC,WHERE_CLAUSE,DATA_TYPE_SEQ,STAGE_TABLE_NAME,REBUILD_INDEX) values ('METADATA','BIOMART','BIO_DATA_TAXONOMY','Y','where st.etl_source = ''METADATA:'' || TrialId',6,'BIO_DATA_TAXONOMY_RELEASE',null);
Insert into TM_CZ.MIGRATE_TABLES (DATA_TYPE,TABLE_OWNER,TABLE_NAME,STUDY_SPECIFIC,WHERE_CLAUSE,DATA_TYPE_SEQ,STAGE_TABLE_NAME,REBUILD_INDEX) values ('METADATA','BIOMART','BIO_CONTENT_REPOSITORY','N',null,7,'BIO_CONTENT_REPOSITORY_RELEASE',null);
Insert into TM_CZ.MIGRATE_TABLES (DATA_TYPE,TABLE_OWNER,TABLE_NAME,STUDY_SPECIFIC,WHERE_CLAUSE,DATA_TYPE_SEQ,STAGE_TABLE_NAME,REBUILD_INDEX) values ('METADATA','BIOMART','BIO_CONTENT_REFERENCE','Y','where st.etl_id_c = ''METADATA:'' || TrialId',8,'BIO_CONTENT_REFERENCE_RELEASE',null);
Insert into TM_CZ.MIGRATE_TABLES (DATA_TYPE,TABLE_OWNER,TABLE_NAME,STUDY_SPECIFIC,WHERE_CLAUSE,DATA_TYPE_SEQ,STAGE_TABLE_NAME,REBUILD_INDEX) values ('METADATA','BIOMART','BIO_CONTENT','Y','where st.etl_id_c = ''METADATA:'' || TrialId',9,'BIO_CONTENT_RELEASE',null);
Insert into TM_CZ.MIGRATE_TABLES (DATA_TYPE,TABLE_OWNER,TABLE_NAME,STUDY_SPECIFIC,WHERE_CLAUSE,DATA_TYPE_SEQ,STAGE_TABLE_NAME,REBUILD_INDEX) values ('CLINICAL','I2B2DEMODATA','VISIT_DIMENSION','Y','where st.sourcesystem_cd = TrialId',null,'VISIT_DIMENSION_RELEASE','Y');
