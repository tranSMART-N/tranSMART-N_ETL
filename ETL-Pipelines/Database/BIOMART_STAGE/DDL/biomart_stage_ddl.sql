  CREATE TABLE "BIOMART_STAGE"."BIO_ASSAY_ANALYSIS_EQTL" 
   ("BIO_ASY_ANALYSIS_EQTL_ID" numeric(22,0), 
	"BIO_ASSAY_ANALYSIS_ID" numeric(22,0), 
	"RS_ID" Nvarchar(50), 
	"GENE" varchar(50), 
	"P_VALUE_CHAR" varchar(100), 
	"CIS_TRANS" varchar(10), 
	"DISTANCE_FROM_GENE" varchar(10), 
	"ETL_ID" numeric(18,0), 
	"EXT_DATA" varchar(4000)
   );
   
     CREATE TABLE "BIOMART_STAGE"."BIO_ASSAY_ANALYSIS_GWAS" 
   ("BIO_ASY_ANALYSIS_GWAS_ID" numeric(18,0), 
	"BIO_ASSAY_ANALYSIS_ID" numeric(18,0), 
	"RS_ID" Nvarchar(50), 
	"P_VALUE_CHAR" varchar(100), 
	"ETL_ID" numeric(18,0), 
	"EXT_DATA" varchar(4000)
   ) ;
 