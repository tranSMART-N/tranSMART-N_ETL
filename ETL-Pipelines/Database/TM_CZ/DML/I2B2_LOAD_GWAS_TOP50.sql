CREATE OR REPLACE PROCEDURE TM_CZ.I2B2_LOAD_GWAS_TOP50 
(numeric(18,0)
)
RETURNS int4
LANGUAGE NZPLSQL AS
BEGIN_PROC
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
Declare
	--	Alias for parameters
	
	currentJobID alias for $1;

	--Audit variables
	newJobFlag int4;
	databaseName VARCHAR(100);
	procedureName VARCHAR(100);
	jobID numeric(18,0);
	stepCt numeric(18,0);
	rowCount		numeric(18,0);
	tExists		int4;
	v_sqlerrm		varchar(1000);
	
begin

	stepCt := 0;
	rowCount := 0;
	
	--Set Audit Parameters
	newJobFlag := 0; -- False (Default)
	jobID := currentJobID;

	databaseName := 'TM_CZ';
	procedureName := 'I2B2_LOAD_GWAS_TOP50';
	
	--Audit JOB Initialization
	--If Job ID does not exist, then this is a single procedure run and we need to create it
	IF(jobID IS NULL or jobID < 1)
	THEN
		newJobFlag := 1; -- True
		jobId := tm_cz.czx_start_audit (procedureName, databaseName);
	END IF;
	
	call tm_cz.czx_write_audit(jobId,databaseName,procedureName,'Start ' || procedureName,0,stepCt,'Done');
	
	execute immediate 'truncate table biomart.bio_asy_analysis_gwas_top50';
	stepCt := stepCt + 1;
	call tm_cz.czx_write_audit(jobId,databaseName,procedureName,'Truncate bio_asy_analysis_gwas_top50',0,stepCt,'Done');
	
	insert into biomart.bio_asy_analysis_gwas_top50
	(bio_assay_analysis_id
	,analysis
	,chrom
	,pos
	,rsgene
	,rsid
	,pvalue
	,logpvalue
	,ext_data
	,rnum
	)
	select a.*
	from (select baa.bio_assay_analysis_id
				,baa.analysis_name as analysis
				,info.chrom as chrom
				,info.pos as pos
				,gmap.gene_name as rsgene
				,gwas.rs_id as rsid
				,gwas.p_value as pvalue
				,gwas.log_p_value as logpvalue
				,gwas.gene as gene
				,gwas.ext_data as extdata
				,row_number () over (partition by bio_assay_analysis_id order by p_value asc, rs_id asc) as rnum
		  from biomart.bio_assay_analysis_gwas gwas 
		  inner join biomart.bio_assay_analysis baa 
				on  baa.bio_assay_analysis_id = gwas.bio_assay_analysis_id
		  inner join deapp.de_rc_snp_info info 
				on  gwas.rs_id = info.rs_id 
				and hg_version='19'
		  left outer join deapp.de_snp_gene_map gmap 
				on  gmap.snp_name =info.rs_id) a
	where a.rnum < 500;
	rowCount := ROW_COUNT
	stepCt := stepCt + 1;
	call tm_cz.czx_write_audit(jobId,databaseName,procedureName,'Insert into bio_asy_analysis_gwas_top50',rowCount,stepCt,'Done');
	
      ---Cleanup OVERALL JOB if this proc is being run standalone
	if newjobflag = 1
	then
		call tm_cz.czx_end_audit (jobID, 'SUCCESS');
	end if;
	
	return 0;

	exception
	when others then
		v_sqlerrm := substr(SQLERRM,1,1000);
		raise notice 'error: %', v_sqlerrm;
		--Handle errors.
		call tm_cz.czx_error_handler (jobID, procedureName,v_sqlerrm);
		--End Proc
		call tm_cz.czx_end_audit (jobID, 'FAIL');
		return 16;

END;
END_PROC;

/*
execute immediate('drop table BIOMART.tmp_analysis_gwas_top500');

execute immediate('create table BIOMART.tmp_analysis_gwas_top500 
as
select a.* 
from (
select 
bio_asy_analysis_gwas_id,
bio_assay_analysis_id,
rs_id,
p_value,
log_p_value,
etl_id,
ext_data,
p_value_char,
row_number () over (partition by bio_assay_analysis_id order by p_value asc, rs_id asc) as rnum
from BIOMART.bio_assay_analysis_gwas
--where bio_assay_analysis_id = 419842521
) a
where 
a.rnum <=500');

execute immediate('create index t_a_g_t500_idx on BIOMART.TMP_ANALYSIS_GWAS_TOP500(RS_ID) tablespace "INDX"');
execute immediate('create index t_a_ga_t500_idx on BIOMART.TMP_ANALYSIS_GWAS_TOP500(bio_assay_analysis_id) tablespace "INDX"');

execute immediate('drop table BIOMART.bio_asy_analysis_gwas_top50');

execute immediate('create table BIOMART.BIO_ASY_ANALYSIS_GWAS_TOP50
as 
SELECT baa.bio_assay_analysis_id,
baa.analysis_name AS analysis, info.chrom AS chrom, info.pos AS pos,
gmap.gene_name AS rsgene, DATA.rs_id AS rsid,
DATA.p_value AS pvalue, DATA.log_p_value AS logpvalue,
DATA.ext_data AS extdata , DATA.rnum
FROM biomart.tmp_analysis_gwas_top500 DATA 
JOIN biomart.bio_assay_analysis baa 
ON baa.bio_assay_analysis_id = DATA.bio_assay_analysis_id
JOIN deapp.de_rc_snp_info info ON DATA.rs_id = info.rs_id and (hg_version='''||19||''')
LEFT JOIN deapp.de_snp_gene_map gmap ON  gmap.snp_name =info.rs_id') ;

--select count(*) from BIO_ASY_ANALYSIS_GWAS_TOP50;

execute immediate('create index BIOMART.B_ASY_GWAS_T50_IDX1 on BIOMART.BIO_ASY_ANALYSIS_GWAS_TOP50(bio_assay_analysis_id) parallel tablespace "INDX"');

execute immediate('create index BIOMART.B_ASY_GWAS_T50_IDX2 on BIOMART.BIO_ASY_ANALYSIS_GWAS_TOP50(ANALYSIS) parallel tablespace "INDX"');

END I2B2_LOAD_GWAS_TOP50;
/
*/
