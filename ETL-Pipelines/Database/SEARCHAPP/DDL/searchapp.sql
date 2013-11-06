
   CREATE SEQUENCE  "SEARCHAPP"."HIBERNATE_SEQUENCE";
--------------------------------------------------------
--  DDL for Sequence PLUGIN_MODULE_SEQ
--------------------------------------------------------

   CREATE SEQUENCE  "SEARCHAPP"."PLUGIN_MODULE_SEQ";
--------------------------------------------------------
--  DDL for Sequence PLUGIN_SEQ
--------------------------------------------------------

   CREATE SEQUENCE  "SEARCHAPP"."PLUGIN_SEQ";
--------------------------------------------------------
--  DDL for Sequence SEQ_SEARCH_DATA_ID
--------------------------------------------------------

   CREATE SEQUENCE  "SEARCHAPP"."SEQ_SEARCH_DATA_ID";
--------------------------------------------------------
--  DDL for Sequence SEQ_SEARCH_TAXONOMY_RELS_ID
--------------------------------------------------------

   CREATE SEQUENCE  "SEARCHAPP"."SEQ_SEARCH_TAXONOMY_RELS_ID";
--------------------------------------------------------
--  DDL for Sequence SEQ_SEARCH_TAXONOMY_TERM_ID
--------------------------------------------------------

   CREATE SEQUENCE  "SEARCHAPP"."SEQ_SEARCH_TAXONOMY_TERM_ID";
  
/*
--------------------------------------------------------
--  DDL for Table MLOG$_SEARCH_GENE_SIGNATUR
--------------------------------------------------------

  CREATE TABLE "SEARCHAPP"."MLOG$_SEARCH_GENE_SIGNATUR" 
   ("DELETED_FLAG" numeric(1,0), 
	"PUBLIC_FLAG" numeric(1,0), 
	"M_ROW$$" varchar(255), 
	"SEQUENCE$$" numeric(18,0), 
	"SNAPTIME$$" timestamp, 
	"DMLTYPE$$" varchar(1), 
	"OLD_NEW$$" varchar(1), 
	"CHANGE_VECTOR$$" RAW(255)
   ) ;
 

   COMMENT ON TABLE "SEARCHAPP"."MLOG$_SEARCH_GENE_SIGNATUR"  IS 'snapshot log for master table SEARCHAPP.SEARCH_GENE_SIGNATURE';
*/

--------------------------------------------------------
--  DDL for Table PLUGIN
--------------------------------------------------------

  CREATE TABLE "SEARCHAPP"."PLUGIN" 
   (	"PLUGIN_SEQ" numeric(18,0), 
	"NAME" varchar(200), 
	"PLUGIN_NAME" varchar(90), 
	"HAS_MODULES" char(1) DEFAULT 'N', 
	"HAS_FORM" char(1) DEFAULT 'N', 
	"DEFAULT_LINK" varchar(70), 
	"FORM_LINK" varchar(70), 
	"FORM_PAGE" varchar(100), 
	"ACTIVE" char(1)
   ) ;
--------------------------------------------------------
--  DDL for Table PLUGIN1
--------------------------------------------------------

  CREATE TABLE "SEARCHAPP"."PLUGIN1" 
   (	"PLUGIN_SEQ" numeric(18,0), 
	"NAME" varchar(200), 
	"PLUGIN_NAME" varchar(90), 
	"HAS_MODULES" char(1) DEFAULT 'N', 
	"HAS_FORM" char(1) DEFAULT 'N', 
	"DEFAULT_LINK" varchar(70), 
	"FORM_LINK" varchar(70), 
	"FORM_PAGE" varchar(100), 
	"ACTIVE" char(1)
   ) ;
--------------------------------------------------------
--  DDL for Table PLUGIN_MODULE
--------------------------------------------------------

  CREATE TABLE "SEARCHAPP"."PLUGIN_MODULE" 
   (	"MODULE_SEQ" numeric(18,0), 
	"PLUGIN_SEQ" numeric(18,0), 
	"NAME" varchar(70), 
	"PARAMS" varchar(4000), 
	"VERSION" varchar(10) DEFAULT 0.1, 
	"ACTIVE" char(1) DEFAULT 'Y', 
	"HAS_FORM" char(1) DEFAULT 'N', 
	"FORM_LINK" varchar(90), 
	"FORM_PAGE" varchar(90), 
	"MODULE_NAME" varchar(50), 
	"CATEGORY" varchar(50)
   ) ;
--------------------------------------------------------
--  DDL for Table PLUGIN_MODULE1
--------------------------------------------------------

  CREATE TABLE "SEARCHAPP"."PLUGIN_MODULE1" 
   (	"MODULE_SEQ" numeric(18,0), 
	"PLUGIN_SEQ" numeric(18,0), 
	"NAME" varchar(70), 
	"PARAMS" varchar(4000), 
	"VERSION" varchar(10) DEFAULT 0.1, 
	"ACTIVE" char(1) DEFAULT 'Y', 
	"HAS_FORM" char(1) DEFAULT 'N', 
	"FORM_LINK" varchar(90), 
	"FORM_PAGE" varchar(90), 
	"MODULE_NAME" varchar(50), 
	"CATEGORY" varchar(50)
   ) ;
--------------------------------------------------------
--  DDL for Table REPORT
--------------------------------------------------------

  CREATE TABLE "SEARCHAPP"."REPORT" 
   (	"REPORT_ID" numeric(18,0), 
	"NAME" varchar(200), 
	"DESCRIPTION" varchar(1000), 
	"CREATINGUSER" varchar(200), 
	"PUBLIC_FLAG" char(1), 
	"CREATE_timestamp" timestamp, 
	"STUDY" varchar(200)
   ) ;
--------------------------------------------------------
--  DDL for Table REPORT_ITEM
--------------------------------------------------------

  CREATE TABLE "SEARCHAPP"."REPORT_ITEM" 
   (	"REPORT_ITEM_ID" numeric(18,0), 
	"REPORT_ID" numeric(18,0), 
	"CODE" varchar(200)
   ) ;
   

--------------------------------------------------------
--  DDL for Table SEARCH_APP_ACCESS_LOG
--------------------------------------------------------

  CREATE TABLE "SEARCHAPP"."SEARCH_APP_ACCESS_LOG" 
   (	"ID" numeric(19,0), 
	"ACCESS_TIME" timestamp, 
	"EVENT" varchar(255), 
	"REQUEST_URL" varchar(255), 
	"USER_NAME" varchar(255), 
	"EVENT_MESSAGE" varchar(4000)
   ) ;
--------------------------------------------------------
--  DDL for Table SEARCH_AUTH_GROUP
--------------------------------------------------------

  CREATE TABLE "SEARCHAPP"."SEARCH_AUTH_GROUP" 
   (	"ID" numeric(19,0), 
	"GROUP_CATEGORY" varchar(255)
   ) ;
--------------------------------------------------------
--  DDL for Table SEARCH_AUTH_GROUP_MEMBER
--------------------------------------------------------

  CREATE TABLE "SEARCHAPP"."SEARCH_AUTH_GROUP_MEMBER" 
   (	"AUTH_USER_ID" numeric(19,0), 
	"AUTH_GROUP_ID" numeric(19,0)
   ) ;
--------------------------------------------------------
--  DDL for Table SEARCH_AUTH_PRINCIPAL
--------------------------------------------------------

  CREATE TABLE "SEARCHAPP"."SEARCH_AUTH_PRINCIPAL" 
   (	"ID" numeric(19,0), 
	"PRINCIPAL_TYPE" varchar(255), 
	"timestamp_CREATED" timestamp, 
	"DESCRIPTION" varchar(255), 
	"LAST_UPtimestampD" timestamp, 
	"NAME" varchar(255), 
	"UNIQUE_ID" varchar(255), 
	"ENABLED" numeric(1,0)
   ) ;
--------------------------------------------------------
--  DDL for Table SEARCH_AUTH_SEC_OBJECT_ACCESS
--------------------------------------------------------

  CREATE TABLE "SEARCHAPP"."SEARCH_AUTH_SEC_OBJECT_ACCESS" 
   (	"AUTH_SEC_OBJ_ACCESS_ID" numeric(18,0), 
	"AUTH_PRINCIPAL_ID" numeric(18,0), 
	"SECURE_OBJECT_ID" numeric(18,0), 
	"SECURE_ACCESS_LEVEL_ID" numeric(18,0)
   ) ;
--------------------------------------------------------
--  DDL for Table SEARCH_AUTH_USER
--------------------------------------------------------

  CREATE TABLE "SEARCHAPP"."SEARCH_AUTH_USER" 
   (	"ID" numeric(19,0), 
	"EMAIL" varchar(255), 
	"EMAIL_SHOW" numeric(1,0), 
	"PASSWD" varchar(255), 
	"USER_REAL_NAME" varchar(255), 
	"USERNAME" varchar(255)
   ) ;
--------------------------------------------------------
--  DDL for Table SEARCH_AUTH_USER_SEC_ACCESS
--------------------------------------------------------

  CREATE TABLE "SEARCHAPP"."SEARCH_AUTH_USER_SEC_ACCESS" 
   (	"SEARCH_AUTH_USER_SEC_ACCESS_ID" numeric(18,0), 
	"SEARCH_AUTH_USER_ID" numeric(18,0), 
	"SEARCH_SECURE_OBJECT_ID" numeric(18,0), 
	"SEARCH_SEC_ACCESS_LEVEL_ID" numeric(18,0)
   ) ;
--------------------------------------------------------
--  DDL for Table SEARCH_CUSTOM_FILTER
--------------------------------------------------------

  CREATE TABLE "SEARCHAPP"."SEARCH_CUSTOM_FILTER" 
   (	"SEARCH_CUSTOM_FILTER_ID" numeric(18,0), 
	"SEARCH_USER_ID" numeric(18,0), 
	"NAME" varchar(200), 
	"DESCRIPTION" varchar(2000), 
	"PRIVATE" char(1) DEFAULT 'N'
   ) ;
--------------------------------------------------------
--  DDL for Table SEARCH_CUSTOM_FILTER_ITEM
--------------------------------------------------------

  CREATE TABLE "SEARCHAPP"."SEARCH_CUSTOM_FILTER_ITEM" 
   (	"SEARCH_CUSTOM_FILTER_ITEM_ID" numeric(18,0), 
	"SEARCH_CUSTOM_FILTER_ID" numeric(18,0), 
	"UNIQUE_ID" varchar(200), 
	"BIO_DATA_TYPE" varchar(100)
   ) ;
--------------------------------------------------------
--  DDL for Table SEARCH_GENE_SIGNATURE
--------------------------------------------------------

  CREATE TABLE "SEARCHAPP"."SEARCH_GENE_SIGNATURE" 
   (	"SEARCH_GENE_SIGNATURE_ID" numeric(18,0), 
	"NAME" varchar(100), 
	"DESCRIPTION" varchar(1000), 
	"UNIQUE_ID" varchar(50), 
	"CREATE_timestamp" timestamp, 
	"CREATED_BY_AUTH_USER_ID" numeric(18,0), 
	"LAST_MODIFIED_timestamp" timestamp, 
	"MODIFIED_BY_AUTH_USER_ID" numeric(18,0), 
	"VERSION_NUMBER" varchar(50), 
	"PUBLIC_FLAG" numeric(1,0) DEFAULT 0, 
	"DELETED_FLAG" numeric(1,0) DEFAULT 0, 
	"PARENT_GENE_SIGNATURE_ID" numeric(18,0), 
	"SOURCE_CONCEPT_ID" numeric(18,0), 
	"SOURCE_OTHER" varchar(255), 
	"OWNER_CONCEPT_ID" numeric(18,0), 
	"STIMULUS_DESCRIPTION" varchar(1000), 
	"STIMULUS_DOSING" varchar(255), 
	"TREATMENT_DESCRIPTION" varchar(1000), 
	"TREATMENT_DOSING" varchar(255), 
	"TREATMENT_BIO_COMPOUND_ID" numeric(18,0), 
	"TREATMENT_PROTOCOL_NUMBER" varchar(50), 
	"PMID_LIST" varchar(255), 
	"SPECIES_CONCEPT_ID" numeric(18,0), 
	"SPECIES_MOUSE_SRC_CONCEPT_ID" numeric(18,0), 
	"SPECIES_MOUSE_DETAIL" varchar(255), 
	"TISSUE_TYPE_CONCEPT_ID" numeric(18,0), 
	"EXPERIMENT_TYPE_CONCEPT_ID" numeric(18,0), 
	"EXPERIMENT_TYPE_IN_VIVO_DESCR" varchar(255), 
	"EXPERIMENT_TYPE_ATCC_REF" varchar(255), 
	"ANALYTIC_CAT_CONCEPT_ID" numeric(18,0), 
	"ANALYTIC_CAT_OTHER" varchar(255), 
	"BIO_ASSAY_PLATFORM_ID" numeric(18,0), 
	"ANALYST_NAME" varchar(100), 
	"NORM_METHOD_CONCEPT_ID" numeric(18,0), 
	"NORM_METHOD_OTHER" varchar(255), 
	"ANALYSIS_METHOD_CONCEPT_ID" numeric(18,0), 
	"ANALYSIS_METHOD_OTHER" varchar(255), 
	"MULTIPLE_TESTING_CORRECTION" numeric(1,0), 
	"P_VALUE_CUTOFF_CONCEPT_ID" numeric(18,0), 
	"UPLOAD_FILE" varchar(255), 
	"SEARCH_GENE_SIG_FILE_SCHEMA_ID" numeric(18,0) DEFAULT 1, 
	"FOLD_CHG_METRIC_CONCEPT_ID" numeric(18,0) DEFAULT NULL, 
	"EXPERIMENT_TYPE_CELL_LINE_ID" numeric(18,0), 
	"QC_PERFORMED" numeric(1,0), 
	"QC_timestamp" timestamp, 
	"QC_INFO" varchar(255), 
	"DATA_SOURCE" varchar(255), 
	"CUSTOM_VALUE1" varchar(255), 
	"CUSTOM_NAME1" varchar(255), 
	"CUSTOM_VALUE2" varchar(255), 
	"CUSTOM_NAME2" varchar(255), 
	"CUSTOM_VALUE3" varchar(255), 
	"CUSTOM_NAME3" varchar(255), 
	"CUSTOM_VALUE4" varchar(255), 
	"CUSTOM_NAME4" varchar(255), 
	"CUSTOM_VALUE5" varchar(255), 
	"CUSTOM_NAME5" varchar(255), 
	"VERSION" varchar(255)
   ) ;
 
/*
   COMMENT ON COLUMN "SEARCHAPP"."SEARCH_GENE_SIGNATURE"."NAME" IS 'name of the gene signature for identification purposes';
 
   COMMENT ON COLUMN "SEARCHAPP"."SEARCH_GENE_SIGNATURE"."DESCRIPTION" IS 'expanded description ';
 
   COMMENT ON COLUMN "SEARCHAPP"."SEARCH_GENE_SIGNATURE"."UNIQUE_ID" IS 'a unique code assigned to the object by a naming convention';
 
   COMMENT ON COLUMN "SEARCHAPP"."SEARCH_GENE_SIGNATURE"."CREATE_timestamp" IS 'timestamp object was created';
 
   COMMENT ON COLUMN "SEARCHAPP"."SEARCH_GENE_SIGNATURE"."CREATED_BY_AUTH_USER_ID" IS 'auth user that created the object';
 
   COMMENT ON COLUMN "SEARCHAPP"."SEARCH_GENE_SIGNATURE"."LAST_MODIFIED_timestamp" IS 'timestamp of the last modification';
 
   COMMENT ON COLUMN "SEARCHAPP"."SEARCH_GENE_SIGNATURE"."MODIFIED_BY_AUTH_USER_ID" IS 'auth user that last modified the object';
 
   COMMENT ON COLUMN "SEARCHAPP"."SEARCH_GENE_SIGNATURE"."VERSION_NUMBER" IS 'for version tracking for modifications';
 
   COMMENT ON COLUMN "SEARCHAPP"."SEARCH_GENE_SIGNATURE"."PUBLIC_FLAG" IS 'binary flag indicates if object is accessible to other users besides the creator';
 
   COMMENT ON COLUMN "SEARCHAPP"."SEARCH_GENE_SIGNATURE"."DELETED_FLAG" IS 'binary flag indicates if object is deleted so that it will not appear on the UI';
 
   COMMENT ON COLUMN "SEARCHAPP"."SEARCH_GENE_SIGNATURE"."PARENT_GENE_SIGNATURE_ID" IS 'tracks the parent gene signature this object was derived from';
 
   COMMENT ON COLUMN "SEARCHAPP"."SEARCH_GENE_SIGNATURE"."SOURCE_CONCEPT_ID" IS 'source meta data defined in bio_concept_code';
 
   COMMENT ON COLUMN "SEARCHAPP"."SEARCH_GENE_SIGNATURE"."SOURCE_OTHER" IS 'source of the object when selection is not defined in bio_concept_code (other selection)';
 
   COMMENT ON COLUMN "SEARCHAPP"."SEARCH_GENE_SIGNATURE"."OWNER_CONCEPT_ID" IS 'owner of the data defined in bio_concept_code';
 
   COMMENT ON COLUMN "SEARCHAPP"."SEARCH_GENE_SIGNATURE"."STIMULUS_DESCRIPTION" IS 'a description for the stimulus ';
 
   COMMENT ON COLUMN "SEARCHAPP"."SEARCH_GENE_SIGNATURE"."STIMULUS_DOSING" IS 'the dosing used for the stimulus';
 
   COMMENT ON COLUMN "SEARCHAPP"."SEARCH_GENE_SIGNATURE"."TREATMENT_DESCRIPTION" IS 'description of the treamtent involved';
 
   COMMENT ON COLUMN "SEARCHAPP"."SEARCH_GENE_SIGNATURE"."TREATMENT_DOSING" IS 'descipriont of any treatment dosing used';
 
   COMMENT ON COLUMN "SEARCHAPP"."SEARCH_GENE_SIGNATURE"."TREATMENT_BIO_COMPOUND_ID" IS 'reference to the bio_compound_id if relevant';
 
   COMMENT ON COLUMN "SEARCHAPP"."SEARCH_GENE_SIGNATURE"."TREATMENT_PROTOCOL_NUMBER" IS 'the protocol number associated with the treatment';
 
   COMMENT ON COLUMN "SEARCHAPP"."SEARCH_GENE_SIGNATURE"."PMID_LIST" IS 'list of associated pmids (comma separated)';
 
   COMMENT ON COLUMN "SEARCHAPP"."SEARCH_GENE_SIGNATURE"."SPECIES_CONCEPT_ID" IS 'species meta data defined in bio_concept_code';
 
   COMMENT ON COLUMN "SEARCHAPP"."SEARCH_GENE_SIGNATURE"."SPECIES_MOUSE_SRC_CONCEPT_ID" IS 'for species of mouse type, specifies the source of the mouse in bio_concept_code';
 
   COMMENT ON COLUMN "SEARCHAPP"."SEARCH_GENE_SIGNATURE"."SPECIES_MOUSE_DETAIL" IS 'extra detail for knockout/transgenic, or other mouse strain ';
 
   COMMENT ON COLUMN "SEARCHAPP"."SEARCH_GENE_SIGNATURE"."TISSUE_TYPE_CONCEPT_ID" IS 'tissue type meta data defined in bio_concept_code';
 
   COMMENT ON COLUMN "SEARCHAPP"."SEARCH_GENE_SIGNATURE"."EXPERIMENT_TYPE_CONCEPT_ID" IS 'experiment type meta data defined in bio_concept_code';
 
   COMMENT ON COLUMN "SEARCHAPP"."SEARCH_GENE_SIGNATURE"."EXPERIMENT_TYPE_IN_VIVO_DESCR" IS 'describes the model for in vivo experiment types';
 
   COMMENT ON COLUMN "SEARCHAPP"."SEARCH_GENE_SIGNATURE"."EXPERIMENT_TYPE_ATCC_REF" IS 'experiment type atcc designation';
 
   COMMENT ON COLUMN "SEARCHAPP"."SEARCH_GENE_SIGNATURE"."ANALYTIC_CAT_CONCEPT_ID" IS 'analytic category meta deta from bio_concept_code';
 
   COMMENT ON COLUMN "SEARCHAPP"."SEARCH_GENE_SIGNATURE"."ANALYTIC_CAT_OTHER" IS 'analytic category atcc designation';
 
   COMMENT ON COLUMN "SEARCHAPP"."SEARCH_GENE_SIGNATURE"."BIO_ASSAY_PLATFORM_ID" IS 'technology platform meta deta from bio_concept_code';
 
   COMMENT ON COLUMN "SEARCHAPP"."SEARCH_GENE_SIGNATURE"."ANALYST_NAME" IS 'name of the analyst performing analysis (analysis meta data)';
 
   COMMENT ON COLUMN "SEARCHAPP"."SEARCH_GENE_SIGNATURE"."NORM_METHOD_CONCEPT_ID" IS 'normalization method from bio_concept_code (analysis meta data)';
 
   COMMENT ON COLUMN "SEARCHAPP"."SEARCH_GENE_SIGNATURE"."NORM_METHOD_OTHER" IS 'normalization method for other selection (analysis meta data)';
 
   COMMENT ON COLUMN "SEARCHAPP"."SEARCH_GENE_SIGNATURE"."ANALYSIS_METHOD_CONCEPT_ID" IS 'analysis method from bio_concept_code (analysis meta data)';
 
   COMMENT ON COLUMN "SEARCHAPP"."SEARCH_GENE_SIGNATURE"."ANALYSIS_METHOD_OTHER" IS 'analysis method for other selection (analysis meta data)';
 
   COMMENT ON COLUMN "SEARCHAPP"."SEARCH_GENE_SIGNATURE"."MULTIPLE_TESTING_CORRECTION" IS 'binary flag indicates if multiple testing correction was employed (analysis meta data) ';
 
   COMMENT ON COLUMN "SEARCHAPP"."SEARCH_GENE_SIGNATURE"."P_VALUE_CUTOFF_CONCEPT_ID" IS 'p-value cutoff from bio_concept_code (analysis meta data)';
 
   COMMENT ON COLUMN "SEARCHAPP"."SEARCH_GENE_SIGNATURE"."UPLOAD_FILE" IS 'upload file name from user containing gene items';
 
   COMMENT ON COLUMN "SEARCHAPP"."SEARCH_GENE_SIGNATURE"."SEARCH_GENE_SIG_FILE_SCHEMA_ID" IS 'file schema for the upload gene signature file';
 
   COMMENT ON COLUMN "SEARCHAPP"."SEARCH_GENE_SIGNATURE"."FOLD_CHG_METRIC_CONCEPT_ID" IS 'fold change metric type in bio_concept_code';
 
   COMMENT ON COLUMN "SEARCHAPP"."SEARCH_GENE_SIGNATURE"."EXPERIMENT_TYPE_CELL_LINE_ID" IS 'for established cell line experiment, specifies the specific cell line from bio_cell_line';
*/
--------------------------------------------------------
--  DDL for Table SEARCH_GENE_SIGNATURE_ITEM
--------------------------------------------------------

  CREATE TABLE "SEARCHAPP"."SEARCH_GENE_SIGNATURE_ITEM" 
   (	"SEARCH_GENE_SIGNATURE_ID" numeric(18,0), 
	"BIO_MARKER_ID" numeric(18,0), 
	"FOLD_CHG_METRIC" numeric(18,0), 
	"BIO_DATA_UNIQUE_ID" varchar(200), 
	"ID" numeric(18,0), 
	"BIO_ASSAY_FEATURE_GROUP_ID" numeric(18,0)
   ) ;
 
/*
   COMMENT ON COLUMN "SEARCHAPP"."SEARCH_GENE_SIGNATURE_ITEM"."SEARCH_GENE_SIGNATURE_ID" IS 'associated gene signature';
 
   COMMENT ON COLUMN "SEARCHAPP"."SEARCH_GENE_SIGNATURE_ITEM"."BIO_MARKER_ID" IS 'link to bio_marker table ';
 
   COMMENT ON COLUMN "SEARCHAPP"."SEARCH_GENE_SIGNATURE_ITEM"."FOLD_CHG_METRIC" IS 'the corresponding fold change value metric (actual number or -1,0,1 for composite gene signatures). If null, it''s assumed to be a gene list in which case all genes are assumed to be up regulated';
 
   COMMENT ON COLUMN "SEARCHAPP"."SEARCH_GENE_SIGNATURE_ITEM"."BIO_DATA_UNIQUE_ID" IS 'link to unique_id from bio_data_uid table (context sensitive)';
 
   COMMENT ON COLUMN "SEARCHAPP"."SEARCH_GENE_SIGNATURE_ITEM"."ID" IS 'hibernate primary key';
   */
   
--------------------------------------------------------
--  DDL for Table SEARCH_GENE_SIG_FILE_SCHEMA
--------------------------------------------------------

  CREATE TABLE "SEARCHAPP"."SEARCH_GENE_SIG_FILE_SCHEMA" 
   (	"SEARCH_GENE_SIG_FILE_SCHEMA_ID" numeric(18,0), 
	"NAME" varchar(100), 
	"DESCRIPTION" varchar(255), 
	"NUMBER_COLUMNS" numeric(18,0) DEFAULT 2, 
	"SUPPORTED" numeric(1,0) DEFAULT 0
   ) ;
 
/*
   COMMENT ON COLUMN "SEARCHAPP"."SEARCH_GENE_SIG_FILE_SCHEMA"."SEARCH_GENE_SIG_FILE_SCHEMA_ID" IS 'primary key';
 
   COMMENT ON COLUMN "SEARCHAPP"."SEARCH_GENE_SIG_FILE_SCHEMA"."NAME" IS 'name of the file schema';
 
   COMMENT ON COLUMN "SEARCHAPP"."SEARCH_GENE_SIG_FILE_SCHEMA"."NUMBER_COLUMNS" IS 'number of columns in tab delimited file';
 
   COMMENT ON COLUMN "SEARCHAPP"."SEARCH_GENE_SIG_FILE_SCHEMA"."SUPPORTED" IS 'a binary flag indicates if schema is supported by the application';
 
   COMMENT ON TABLE "SEARCHAPP"."SEARCH_GENE_SIG_FILE_SCHEMA"  IS 'Represents file schemas used to represent a gene signature upload. Normally this table would be populated only by seed data';
*/
--------------------------------------------------------
--  DDL for Table SEARCH_KEYWORD
--------------------------------------------------------

  CREATE TABLE "SEARCHAPP"."SEARCH_KEYWORD" 
   (	"KEYWORD" varchar(200), 
	"BIO_DATA_ID" numeric(18,0), 
	"UNIQUE_ID" varchar(500), 
	"SEARCH_KEYWORD_ID" numeric(18,0), 
	"DATA_CATEGORY" varchar(200), 
	"SOURCE_CODE" varchar(100), 
	"DISPLAY_DATA_CATEGORY" varchar(200), 
	"OWNER_AUTH_USER_ID" numeric(18,0)
   ) ;
 

--   COMMENT ON COLUMN "SEARCHAPP"."SEARCH_KEYWORD"."OWNER_AUTH_USER_ID" IS 'the owner of the object, this can be used to control access permissions in search';
--------------------------------------------------------
--  DDL for Table SEARCH_KEYWORD_TERM
--------------------------------------------------------

  CREATE TABLE "SEARCHAPP"."SEARCH_KEYWORD_TERM" 
   (	"KEYWORD_TERM" varchar(200), 
	"SEARCH_KEYWORD_ID" numeric(18,0), 
	"RANK" numeric(18,0), 
	"SEARCH_KEYWORD_TERM_ID" numeric(18,0), 
	"TERM_LENGTH" numeric(18,0), 
	"OWNER_AUTH_USER_ID" numeric(18,0), 
	"DATA_CATEGORY" varchar(200)
   ) ;
 

--   COMMENT ON COLUMN "SEARCHAPP"."SEARCH_KEYWORD_TERM"."OWNER_AUTH_USER_ID" IS 'owner of the object, this can be used to control access in search';
--------------------------------------------------------
--  DDL for Table SEARCH_REQUEST_MAP
--------------------------------------------------------

  CREATE TABLE "SEARCHAPP"."SEARCH_REQUEST_MAP" 
   (	"ID" numeric(19,0), 
	"VERSION" numeric(19,0), 
	"CONFIG_ATTRIBUTE" varchar(255), 
	"URL" varchar(255)
   ) ;
--------------------------------------------------------
--  DDL for Table SEARCH_ROLE
--------------------------------------------------------

  CREATE TABLE "SEARCHAPP"."SEARCH_ROLE" 
   (	"ID" numeric(19,0), 
	"VERSION" numeric(19,0), 
	"AUTHORITY" varchar(255), 
	"DESCRIPTION" varchar(255)
   ) ;
--------------------------------------------------------
--  DDL for Table SEARCH_ROLE_AUTH_USER
--------------------------------------------------------

  CREATE TABLE "SEARCHAPP"."SEARCH_ROLE_AUTH_USER" 
   (	"PEOPLE_ID" numeric(19,0), 
	"AUTHORITIES_ID" numeric(19,0)
   ) ;
--------------------------------------------------------
--  DDL for Table SEARCH_SECURE_OBJECT
--------------------------------------------------------

  CREATE TABLE "SEARCHAPP"."SEARCH_SECURE_OBJECT" 
   (	"SEARCH_SECURE_OBJECT_ID" numeric(18,0), 
	"BIO_DATA_ID" numeric(18,0), 
	"DISPLAY_NAME" varchar(100), 
	"DATA_TYPE" varchar(200), 
	"BIO_DATA_UNIQUE_ID" varchar(200)
   ) ;
--------------------------------------------------------
--  DDL for Table SEARCH_SECURE_OBJECT_PATH
--------------------------------------------------------

  CREATE TABLE "SEARCHAPP"."SEARCH_SECURE_OBJECT_PATH" 
   (	"SEARCH_SECURE_OBJECT_ID" numeric(18,0), 
	"I2B2_CONCEPT_PATH" varchar(2000), 
	"SEARCH_SECURE_OBJ_PATH_ID" numeric(18,0)
   ) ;
--------------------------------------------------------
--  DDL for Table SEARCH_SEC_ACCESS_LEVEL
--------------------------------------------------------

  CREATE TABLE "SEARCHAPP"."SEARCH_SEC_ACCESS_LEVEL" 
   (	"SEARCH_SEC_ACCESS_LEVEL_ID" numeric(18,0), 
	"ACCESS_LEVEL_NAME" varchar(200), 
	"ACCESS_LEVEL_VALUE" numeric(18,0)
   ) ;
--------------------------------------------------------
--  DDL for Table SEARCH_TAXONOMY
--------------------------------------------------------

  CREATE TABLE "SEARCHAPP"."SEARCH_TAXONOMY" 
   (	"TERM_ID" numeric(22,0), 
	"TERM_NAME" varchar(900), 
	"SOURCE_CD" varchar(900), 
	"IMPORT_timestamp" timestamp DEFAULT now(), 
	"SEARCH_KEYWORD_ID" numeric(38,0)
   ) ;
--------------------------------------------------------
--  DDL for Table SEARCH_TAXONOMY_RELS
--------------------------------------------------------

  CREATE TABLE "SEARCHAPP"."SEARCH_TAXONOMY_RELS" 
   (	"SEARCH_TAXONOMY_RELS_ID" numeric(22,0), 
	"CHILD_ID" numeric(22,0), 
	"PARENT_ID" numeric(22,0)
   ) ;
--------------------------------------------------------
--  DDL for Table SEARCH_USER_FEEDBACK
--------------------------------------------------------

  CREATE TABLE "SEARCHAPP"."SEARCH_USER_FEEDBACK" 
   (	"SEARCH_USER_FEEDBACK_ID" numeric(18,0), 
	"SEARCH_USER_ID" numeric(18,0), 
	"CREATE_timestamp" timestamp, 
	"FEEDBACK_TEXT" varchar(2000), 
	"APP_VERSION" varchar(100)
   ) ;
--------------------------------------------------------
--  DDL for Table SEARCH_USER_SETTINGS
--------------------------------------------------------

  CREATE TABLE "SEARCHAPP"."SEARCH_USER_SETTINGS" 
   (	"ID" numeric(18,0), 
	"USER_ID" numeric(18,0), 
	"SETTING_NAME" varchar(255), 
	"SETTING_VALUE" varchar(1024)
   ) ;
--------------------------------------------------------
--  DDL for Table SUBSET
--------------------------------------------------------

  CREATE TABLE "SEARCHAPP"."SUBSET" 
   (	"SUBSET_ID" numeric(18,0), 
	"DESCRIPTION" varchar(1000), 
	"CREATE_timestamp" timestamp, 
	"CREATING_USER" varchar(200), 
	"PUBLIC_FLAG" numeric(1,0) DEFAULT 0, 
	"DELETED_FLAG" numeric(1,0) DEFAULT 0, 
	"QUERY_MASTER_ID_1" numeric(18,0), 
	"QUERY_MASTER_ID_2" numeric(18,0), 
	"STUDY" varchar(200)
   ) ;
--------------------------------------------------------
--  DDL for View SEARCH_AUTH_USER_SEC_ACCESS_V
--------------------------------------------------------

  CREATE OR REPLACE VIEW "SEARCHAPP"."SEARCH_AUTH_USER_SEC_ACCESS_V" ("SEARCH_AUTH_USER_SEC_ACCESS_ID", "SEARCH_AUTH_USER_ID", "SEARCH_SECURE_OBJECT_ID", "SEARCH_SEC_ACCESS_LEVEL_ID") AS 
  SELECT 
 sasoa.AUTH_SEC_OBJ_ACCESS_ID AS SEARCH_AUTH_USER_SEC_ACCESS_ID,
 sasoa.AUTH_PRINCIPAL_ID AS SEARCH_AUTH_USER_ID,
 sasoa.SECURE_OBJECT_ID AS SEARCH_SECURE_OBJECT_ID,
 sasoa.SECURE_ACCESS_LEVEL_ID AS SEARCH_SEC_ACCESS_LEVEL_ID
FROM searchapp.SEARCH_AUTH_USER sau, 
searchapp.SEARCH_AUTH_SEC_OBJECT_ACCESS sasoa
WHERE 
sau.ID = sasoa.AUTH_PRINCIPAL_ID
UNION
 SELECT 
 sasoa.AUTH_SEC_OBJ_ACCESS_ID AS SEARCH_AUTH_USER_SEC_ACCESS_ID,
 sagm.AUTH_USER_ID AS SEARCH_AUTH_USER_ID,
 sasoa.SECURE_OBJECT_ID AS SEARCH_SECURE_OBJECT_ID,
 sasoa.SECURE_ACCESS_LEVEL_ID AS SEARCH_SEC_ACCESS_LEVEL_ID
FROM searchapp.SEARCH_AUTH_GROUP sag, 
searchapp.SEARCH_AUTH_GROUP_MEMBER sagm,
searchapp.SEARCH_AUTH_SEC_OBJECT_ACCESS sasoa
WHERE 
sag.ID = sagm.AUTH_GROUP_ID
AND
sag.ID = sasoa.AUTH_PRINCIPAL_ID
UNION
SELECT 
 sasoa.AUTH_SEC_OBJ_ACCESS_ID AS SEARCH_AUTH_USER_SEC_ACCESS_ID,
 NULL AS SEARCH_AUTH_USER_ID,
 sasoa.SECURE_OBJECT_ID AS SEARCH_SECURE_OBJECT_ID,
 sasoa.SECURE_ACCESS_LEVEL_ID AS SEARCH_SEC_ACCESS_LEVEL_ID
FROM searchapp.SEARCH_AUTH_GROUP sag, 
searchapp.SEARCH_AUTH_SEC_OBJECT_ACCESS sasoa
WHERE 
sag.group_category = 'EVERYONE_GROUP'
AND
sag.ID = sasoa.AUTH_PRINCIPAL_ID
 
 
 
 
 
 
 ;
--------------------------------------------------------
--  DDL for View SEARCH_BIO_MKR_CORREL_VIEW
--------------------------------------------------------

  CREATE OR REPLACE VIEW "SEARCHAPP"."SEARCH_BIO_MKR_CORREL_VIEW" ("DOMAIN_OBJECT_ID", "ASSO_BIO_MARKER_ID", "CORREL_TYPE", "VALUE_METRIC", "MV_ID") AS 
  SELECT domain_object_id,
    asso_bio_marker_id,
    correl_type,
    value_metric,
    mv_id
  FROM
    (SELECT i.SEARCH_GENE_SIGNATURE_ID AS domain_object_id,
      i.BIO_MARKER_ID                  AS asso_bio_marker_id,
      'GENE_SIGNATURE_ITEM'            AS correl_type,
      CASE
        WHEN i.FOLD_CHG_METRIC IS NULL
        THEN 1
        ELSE i.FOLD_CHG_METRIC
      END AS value_metric,
      1   AS mv_id
    FROM searchapp.SEARCH_GENE_SIGNATURE_ITEM i,
      searchapp.SEARCH_GENE_SIGNATURE gs
    WHERE i.SEARCH_GENE_SIGNATURE_ID = gs.SEARCH_GENE_SIGNATURE_ID
    AND gs.DELETED_FLAG              = 0
    AND i.bio_marker_id             IS NOT NULL
    UNION ALL
    SELECT i.SEARCH_GENE_SIGNATURE_ID AS domain_object_id,
      bada.BIO_MARKER_ID              AS asso_bio_marker_id,
      'GENE_SIGNATURE_ITEM'           AS correl_type,
      CASE
        WHEN i.FOLD_CHG_METRIC IS NULL
        THEN 1
        ELSE i.FOLD_CHG_METRIC
      END AS value_metric,
      2   AS mv_id
    FROM searchapp.SEARCH_GENE_SIGNATURE_ITEM i,
      searchapp.SEARCH_GENE_SIGNATURE gs,
      biomart.bio_assay_data_annotation bada
    WHERE i.SEARCH_GENE_SIGNATURE_ID    = gs.SEARCH_GENE_SIGNATURE_ID
    AND gs.DELETED_FLAG                 = 0
    AND bada.bio_assay_feature_group_id = i.bio_assay_feature_group_id
    AND i.bio_assay_feature_group_id   IS NOT NULL
    ) x;

--------------------------------------------------------
--  DDL for Materialized View SEARCH_BIO_MKR_CORREL_FAST_MV
--------------------------------------------------------


  CREATE MATERIALIZED VIEW "SEARCHAPP"."SEARCH_BIO_MKR_CORREL_FAST_MV" 
  AS SELECT   i.SEARCH_GENE_SIGNATURE_ID AS domain_object_id,
         i.BIO_MARKER_ID AS asso_bio_marker_id,
         'GENE_SIGNATURE_ITEM' AS correl_type,
         CASE
            WHEN i.FOLD_CHG_METRIC IS NULL THEN 1
            ELSE i.FOLD_CHG_METRIC
         END
            AS value_metric,
         3 AS mv_id
  FROM   searchapp.SEARCH_GENE_SIGNATURE_ITEM i, searchapp.SEARCH_GENE_SIGNATURE gs
 WHERE   i.SEARCH_GENE_SIGNATURE_ID = gs.SEARCH_GENE_SIGNATURE_ID
         AND gs.DELETED_FLAG = 0;
 

 --  COMMENT ON MATERIALIZED VIEW "SEARCHAPP"."SEARCH_BIO_MKR_CORREL_FAST_MV"  IS 'snapshot table for snapshot SEARCHAPP.SEARCH_BIO_MKR_CORREL_FAST_MV';
