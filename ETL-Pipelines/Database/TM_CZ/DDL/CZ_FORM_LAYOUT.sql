--------------------------------------------------------
--  DDL for Table CZ_FORM_LAYOUT
--------------------------------------------------------

  CREATE TABLE "TM_CZ"."CZ_FORM_LAYOUT" 
   (	"FORM_LAYOUT_ID" NUMBER(22,0), 
	"FORM_KEY" VARCHAR2(50 BYTE), 
	"FORM_COLUMN" VARCHAR2(50 BYTE), 
	"DISPLAY_NAME" VARCHAR2(50 BYTE), 
	"DATA_TYPE" VARCHAR2(50 BYTE), 
	"SEQUENCE" NUMBER(22,0)
   ) SEGMENT CREATION IMMEDIATE 
  PCTFREE 10 PCTUSED 40 INITRANS 1 MAXTRANS 255 NOCOMPRESS NOLOGGING
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1 BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)
  TABLESPACE "TRANSMART" ;
--------------------------------------------------------
--  DDL for Index CZ_FORM_LAYOUT_PK
--------------------------------------------------------

  CREATE UNIQUE INDEX "TM_CZ"."CZ_FORM_LAYOUT_PK" ON "TM_CZ"."CZ_FORM_LAYOUT" ("FORM_LAYOUT_ID") 
  PCTFREE 10 INITRANS 2 MAXTRANS 255 NOLOGGING COMPUTE STATISTICS 
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1 BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)
  TABLESPACE "INDX" ;
--------------------------------------------------------
--  Constraints for Table CZ_FORM_LAYOUT
--------------------------------------------------------

  ALTER TABLE "TM_CZ"."CZ_FORM_LAYOUT" ADD CONSTRAINT "CZ_FORM_LAYOUT_PK" PRIMARY KEY ("FORM_LAYOUT_ID")
  USING INDEX PCTFREE 10 INITRANS 2 MAXTRANS 255 NOLOGGING COMPUTE STATISTICS 
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1 BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)
  TABLESPACE "INDX"  ENABLE;
 
  ALTER TABLE "TM_CZ"."CZ_FORM_LAYOUT" MODIFY ("FORM_LAYOUT_ID" NOT NULL ENABLE);
 
  ALTER TABLE "TM_CZ"."CZ_FORM_LAYOUT" MODIFY ("FORM_KEY" NOT NULL ENABLE);
 
  ALTER TABLE "TM_CZ"."CZ_FORM_LAYOUT" MODIFY ("FORM_COLUMN" NOT NULL ENABLE);
  
  --------------------------------------------------------
--  DDL for Sequence SEQ_FORM_LAYOUT_ID
--------------------------------------------------------

   CREATE SEQUENCE  "TM_CZ"."SEQ_FORM_LAYOUT_ID"  MINVALUE 1 MAXVALUE 999999999999999999999999999 INCREMENT BY 1 START WITH 1 CACHE 20 NOORDER  NOCYCLE ;

--------------------------------------------------------
--  DDL for Trigger TRG_CZ_FORM_LAYOUT_ID
--------------------------------------------------------

  CREATE OR REPLACE TRIGGER "TM_CZ"."TRG_CZ_FORM_LAYOUT_ID" before
  INSERT ON "TM_CZ"."CZ_FORM_LAYOUT" FOR EACH row BEGIN IF inserting THEN IF :NEW."FORM_LAYOUT_ID" IS NULL THEN
  SELECT SEQ_FORM_LAYOUT_ID.nextval INTO :NEW."FORM_LAYOUT_ID" FROM dual;
END IF;
END IF;
END;
/
ALTER TRIGGER "TM_CZ"."TRG_CZ_FORM_LAYOUT_ID" ENABLE;
