--------------------------------------------------------
--  File created - Wednesday-May-29-2013   
--------------------------------------------------------
--------------------------------------------------------
--  DDL for Table LZ_SRC_STUDY_METADATA_AD_HOC
--------------------------------------------------------

  CREATE TABLE "TM_LZ"."LZ_SRC_STUDY_METADATA_AD_HOC" 
   ("STUDY_ID" VARCHAR2(100 BYTE), 
	"AD_HOC_PROPERTY_KEY" VARCHAR2(500 BYTE), 
	"AD_HOC_PROPERTY_VALUE" VARCHAR2(4000 BYTE), 
	"AD_HOC_PROPERTY_LINK" VARCHAR2(500 BYTE), 
	"UPLOAD_DATE" DATE
   ) 
  NOCOMPRESS NOLOGGING
  TABLESPACE "TRANSMART" ;
