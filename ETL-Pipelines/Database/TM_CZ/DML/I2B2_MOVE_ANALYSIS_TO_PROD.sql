CREATE OR REPLACE PROCEDURE TM_CZ."I2B2_MOVE_ANALYSIS_TO_PROD" 
(numeric(18,0)
,numeric(18,0)
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
	i_etl_id  alias for $1;
	i_job_id  alias for $2;
	
    -- create indexes using parallele 8  -zhanh101 5/10/2013 use ~20-30% original time  
    --Audit variables
    newJobFlag     int4;
    databaseName     VARCHAR(100);
    procedureName VARCHAR(100);
    jobID         numeric(18,0);
    stepCt         numeric(18,0);
	rowCount		numeric(18,0);
	v_sqlerrm		varchar(1000);
	
 
    v_etl_id					number(18,0);
    v_bio_assay_analysis_id		number(18,0);
    v_data_type					varchar2(50);
    v_sqlText					varchar2(2000);
    v_exists					int4;
    v_GWAS_staged				int4;
    v_EQTL_staged				int4;				
    
	stage_rec					record
/*
    type stage_rec  is record
    (bio_assay_analysis_id        number(18,0)
    ,etl_id                        number(18,0)
    ,study_id                    varchar2(500)
    ,data_type                    varchar2(50)
    ,orig_data_type                varchar2(50)
    ,analysis_name                varchar2(1000)
    );

    type stage_table is table of stage_rec; 
    stage_array stage_table;
    
    type stage_table_names_rec is record
    (table_name                    varchar2(500)
    );
    
    type stage_table_names is table of stage_table_names_rec;
    stage_table_array stage_table_names;
    
    no_staged_data    exception;
 */   
BEGIN    
    
    --Set Audit Parameters
    newJobFlag := 0; -- False (Default)
    jobID := -1;

	databaseName := 'TM_CZ';
	procedureName := 'I2B2_MOVE_ANALYSIS_TO_PROD';
	
	--Audit JOB Initialization
	--If Job ID does not exist, then this is a single procedure run and we need to create it
	IF(jobID IS NULL or jobID < 1)
	THEN
		newJobFlag := 1; -- True
		jobId := tm_cz.czx_start_audit (procedureName, databaseName);
	END IF;
        
    stepCt := 1;    
    call tm_cz.czx_write_audit(jobId,databaseName,procedureName,'Starting i2b2_move_analysis_to_prod',0,stepCt,'Done');
	
	--	delete existing data for staged analyses from bio_asy_analysis_gwas
	
	delete from biomart.bio_assay_analysis_gwas g
	where g.bio_assay_analysis_id in
		  (select x.bio_assay_analysis_id
		   from tm_lz.lz_src_analysis_metadata t
			   ,biomart.bio_assay_analysis x
		  where t.status = 'STAGED'
			and t.data_type in ('GWAS','Metabolic GWAS')
			and t.study_id = x.etl_id
			and t.etl_id = x.etl_id_source
			and case when i_etl_id = -1 then 1
					 when t.etl_id = i_etl_id then 1
                     else 0 end = 1);
	rowCount := ROW_COUNT;
	stepCt := stepCt + 1;
	call tm_cz.czx_write_audit(jobId,databaseName,procedureName,'Delete exising data for staged analyses from BIOMART.BIO_ASSAY_ANALYSIS_GWAS',rowCount,stepCt,'Done');
			
	--	delete existing data for staged analyses from bio_asy_analysis_eqtl
	
	delete from biomart.bio_assay_analysis_eqtl g
	where g.bio_assay_analysis_id in
	     (select x.bio_assay_analysis_id
		  from tm_lz.lz_src_analysis_metadata t
			  ,biomart.bio_assay_analysis x
		  where t.status = 'STAGED'
			and t.data_type = 'EQTL'
			and t.study_id = x.etl_id
			and t.etl_id = x.etl_id_source
			and case when i_etl_id = -1 then 1
                     when t.etl_id = i_etl_id then 1
                     else 0 end = 1);
	rowCount := ROW_COUNT;
	stepCt := stepCt + 1;
	call tm_cz.czx_write_audit(jobId,databaseName,procedureName,'Delete exising data for staged analyses from BIOMART.BIO_ASSAY_ANALYSIS_EQTL',rowCount,stepCt,'Done');
			
    --    load staged analysis to array
	
	v_GWAS_staged := 0;
    v_EQTL_staged := 0;
    
	for stage_rec in
		select baa.bio_assay_analysis_id
			  ,lz.etl_id
			  ,lz.study_id
			  ,case when lz.data_type = 'Metabolic GWAS' then 'GWAS' else lz.data_type end as data_type
			  ,lz.data_type as orig_data_type
			  ,lz.analysis_name
		from tm_lz.lz_src_analysis_metadata lz
			,biomart.bio_assay_analysis baa
		where lz.status = 'STAGED'
		  and lz.study_id = baa.etl_id
		  and lz.etl_id = baa.etl_id_source
		  and case when i_etl_id = -1 then 1
				   when lz.etl_id = i_etl_id then 1
				   else 0 end = 1
	loop   
	
	    call tm_cz.czx_write_audit(jobId,databaseName,procedureName,'Loading ' || stege_rec.study_id || ' ' || stege_rec.orig_data_type || ' ' ||
                       stege_rec.analysis_name,0,stepCt,'Done');
					   
		v_bio_assay_analysis_id := stage_rec.bio_assay_analysis_id;
		v_data_type := stage_reg.data_type;
		v_etl_id := stage_rec.etl_id;
					   
        if stege_rec.data_type = 'GWAS' then
            v_GWAS_staged := 1;
			
			--	move GWAS data from biomart_stage to biomart
			
			insert into biomart.bio_assay_analysis_gwas
            (bio_asy_analysis_gwas_id
            ,bio_assay_analysis_id
            ,rs_id
            ,p_value
            ,p_value_char
            ,etl_id
            ,ext_data
            ,log_p_value)
            select bio_asy_analysis_gwas_id
                  ,bio_assay_analysis_id
                  ,rs_id
                  ,cast(p_value_char as double precision)
                  ,p_value_char
                  ,etl_id
                  ,ext_data
                  ,log(cast(p_value_char as double precision))*-1
            from biomart_stage.bio_assay_analysis_gwas
            where bio_assay_analysis_id = v_bio_assay_analysis_id;
			rowCount := ROW_COUNT;
            stepCt := stepCt + 1;
            call tm_cz.czx_write_audit(jobId,databaseName,procedureName,'Insert data for analysis from BIOMART_STAGE.BIO_ASSAY_ANALYSIS_' || v_data_type,rowCount,stepCt,'Done');
			
			--	update data_count in bio_assay_analysis
			
		    update biomart.bio_assay_analysis baa
			set data_count=upd.data_count
			from (select count(*) as data_count
				  from biomart.bio_assay_analysis_gwas be
				  where be.bio_assay_analysis_id=v_bio_assay_analysis_id) upd
            where bio_assay_analysis.bio_assay_analysis_id=v_bio_assay_analysis_id;
			rowCount := ROW_COUNT;
            stepCt := stepCt +1;
            call tm_cz.czx_write_audit(jobId,databaseName,procedureName,'Update data_count in bio_assay_analysis',rowCount,stepCt,'Done');
			
			v_sqlText := 'delete from biomart_stage.bio_assay_analysis_' || v_data_type || 
						 ' where bio_assay_analysis_id = ' || to_char(v_bio_assay_analysis_id);
			execute immediate v_sqlText;
			rowCount := ROW_COUNT;
			stepCt := stepCt + 1;
			call tm_cz.czx_write_audit(jobId,databaseName,procedureName,'Delete data for analysis from BIOMART_STAGE.BIO_ASSAY_ANALYSIS_' || v_data_type,rowCount,stepCt,'Done');       
           
        end if;
        
        if stege_rec.data_type = 'EQTL' then
            v_EQTL_staged := 1;
			
			--	move EQTL data from biomart_stage to biomart

			insert into biomart.bio_assay_analysis_eqtl
            (bio_asy_analysis_eqtl_id
            ,bio_assay_analysis_id
            ,rs_id
            ,gene
            ,p_value
            ,p_value_char
            ,cis_trans
            ,distance_from_gene
            ,etl_id
            ,ext_data
            ,log_p_value)
            select bio_asy_analysis_eqtl_id
                  ,bio_assay_analysis_id
                  ,rs_id
                  ,gene
                  ,cast(p_value_char as double precision)
                  ,p_value_char
                  ,cis_trans
                  ,distance_from_gene
                  ,etl_id
                  ,ext_data
                  ,log(cast(p_value_char as double precision))*-1
            from biomart_stage.bio_assay_analysis_eqtl
            where bio_assay_analysis_id = v_bio_assay_analysis_id;
			rowCount := ROW_COUNT
            stepCt := stepCt + 1;
            call tm_cz.czx_write_audit(jobId,databaseName,procedureName,'Insert data for analysis from BIOMART_STAGE.BIO_ASSAY_ANALYSIS_' || v_data_type,rowCount,stepCt,'Done');
        
			--	update data_count in bio_assay_analysis
			
		    update biomart.bio_assay_analysis baa
			set data_count=upd.data_count
			from (select count(*) as data_count
				  from biomart.bio_assay_analysis_eqtl be
				  where be.bio_assay_analysis_id=v_bio_assay_analysis_id) upd
            where bio_assay_analysis.bio_assay_analysis_id=v_bio_assay_analysis_id;
			rowCount := ROW_COUNT;
            stepCt := stepCt +1;
            call tm_cz.czx_write_audit(jobId,databaseName,procedureName,'Update data_count in bio_assay_analysis',rowCount,stepCt,'Done');
           			
			v_sqlText := 'delete from biomart_stage.bio_assay_analysis_' || v_data_type || 
						 ' where bio_assay_analysis_id = ' || to_char(v_bio_assay_analysis_id);
			execute immediate v_sqlText;
			rowCount := ROW_COUNT;
			stepCt := stepCt + 1;
			call tm_cz.czx_write_audit(jobId,databaseName,procedureName,'Delete data for analysis from BIOMART_STAGE.BIO_ASSAY_ANALYSIS_' || v_data_type,rowCount,stepCt,'Done');       
       
		end if;    
		
		--	update status in lz_src_analysis_metadata
		
        update tm_lz.lz_src_analysis_metadata
        set status='PRODUCTION'
        where etl_id = v_etl_id;
		rowCount := ROW_COUNT;
        stepCt := stepCt + 1;
        call tm_cz.czx_write_audit(jobId,databaseName,procedureName,'Set status to PRODUCTION in tm_lz.lz_src_analysis_metadata',rowCount,stepCt,'Done');               
        
	end loop;
      
	--	check if no data loaded from biomart_stage, if none, terminate normally
	
	if v_GWAS_staged = 0 and v_EQTL_staged = 0 then
	    stepCt := stepCt + 1;
        call tm_cz.czx_write_audit(jobId,databaseName,procedureName,'No staged data - run terminating normally',0,stepCt,'Done');
		return 0;
	end if;
    
    --	recreate top 50(0) if gwas or eqtl reloaded
	
	if v_GWAS_staged > 0 then
		call tm_cz.i2b2_load_gwas_top50(jobId);
		stepCt := stepCt + 1;
		call tm_cz.czx_write_audit(jobId,databaseName,procedureName,'Created top 50 GWAS',0,stepCt,'Done');
	end if;
        
    if v_EQTL_staged = 1 then 
		call tm_cz.i2b2_load_eqtl_top50(jobId);
		stepCt := stepCt + 1;
		call tm_cz.czx_write_audit(jobId,databaseName,procedureName,'Created top 50 EQTL',0,stepCt,'Done');
	end if;
    
    call tm_cz.czx_write_audit(jobId,databaseName,procedureName,'End i2b2_move_analysis_to_prod',0,stepCt,'Done');
    stepCt := stepCt + 1;
    
    call tm_cz.czx_end_audit(jobId, 'Success');
	return 0;
    
    exception when others then
		v_sqlerrm := substr(SQLERRM,1,1000);
		raise notice 'error: %', v_sqlerrm;
		--Handle errors.
        call tm_cz.czx_error_handler (jobID, , v_sqlerrm);
		--End Proc
        call tm_cz.czx_end_audit (jobID, 'FAIL');
		return 16;
    
END;
END_PROC;
