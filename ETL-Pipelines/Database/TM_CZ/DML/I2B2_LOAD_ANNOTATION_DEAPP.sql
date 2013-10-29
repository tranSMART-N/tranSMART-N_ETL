CREATE OR REPLACE PROCEDURE TM_CZ.I2B2_LOAD_ANNOTATION_DEAPP(numeric(18,0))
RETURNS CHARACTER VARYING(ANY)
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
	gplId	varchar(100);

BEGIN

	stepCt := 0;

	--Set Audit Parameters
	newJobFlag := 0; -- False (Default)
	jobID := currentJobID;

	databaseName := 'TM_CZ';
	procedureName := 'I2B2_LOAD_ANNOTATION_DEAPP';

	--Audit JOB Initialization
	--If Job ID does not exist, then this is a single procedure run and we need to create it
	IF(jobID IS NULL or jobID < 1)
	THEN
		newJobFlag := 1; -- True
		-- select tm_cz.czx_start_audit (procedureName, databaseName) into jobID;
	END IF;

	stepCt := stepCt + 1;
	-- call czx_write_audit(jobId,databaseName,procedureName,'Starting i2b2_load_annotation_deapp',0,stepCt,'Done');

	--	get GPL id from external table
	
	select distinct gpl_id into gplId from tm_lz.lt_src_deapp_annot;
	
	--	delete any existing data from annotation_deapp
	
	delete from tm_cz.annotation_deapp
	where gpl_id = gplId;
	stepCt := stepCt + 1;
	-- call czx_write_audit(jobId,databaseName,procedureName,'Delete existing data from annotation_deapp',ROW_COUNT,stepCt,'Done');
	
	--	delete any existing data from deapp.de_mrna_annotation
	
	delete from deapp.de_mrna_annotation
	where gpl_id = gplId;
	stepCt := stepCt + 1;
	-- call czx_write_audit(jobId,databaseName,procedureName,'Delete existing data from de_mrna_annotation',ROW_COUNT,stepCt,'Done');

	--	update organism for existing probesets in probeset_deapp
	raise notice 'before probeset';
	update tm_cz.probeset_deapp p
	set organism=t.organism 
	from (select distinct gpl_id, probe_id, organism from tm_lz.LT_SRC_DEAPP_ANNOT) t
	where t.gpl_id = p.platform
	  and p.probeset = t.probe_id;
	stepCt := stepCt + 1;
	-- call czx_write_audit(jobId,databaseName,procedureName,'Update organism in probeset_deapp',ROW_COUNT,stepCt,'Done');

	--	insert any new probesets into probeset_deapp
	raise notice 'before probeset insert';
	insert into tm_cz.probeset_deapp
	(probeset_id
	,probeset
	,organism
	,platform)
	select next value for tm_cz.SEQ_PROBESET_ID
		  ,y.probe_id
		  ,y.organism
		  ,y.gpl_id
	from (select distinct probe_id
				,coalesce(organism,'Homo sapiens') as organism
				,gpl_id
		 from tm_lz.lt_src_deapp_annot t
		 where not exists
			  (select 1 from tm_cz.probeset_deapp x
			   where t.gpl_id = x.platform
		    and t.probe_id = x.probeset
			and coalesce(t.organism,'Homo sapiens') = coalesce(x.organism,'Homo sapiens'))
		  ) y;
	stepCt := stepCt + 1;
	-- call czx_write_audit(jobId,databaseName,procedureName,'Insert new probesets into probeset_deapp',ROW_COUNT,stepCt,'Done');

	--	insert data into annotation_deapp
	raise notice 'before annotation-deapp';
	insert into tm_cz.annotation_deapp
	(gpl_id
	,probe_id
	,gene_symbol
	,gene_id
	,probeset_id
	,organism)
	select distinct d.gpl_id
	,d.probe_id
	,d.gene_symbol
	,d.gene_id
	,p.probeset_id
	,coalesce(d.organism,'Homo sapiens')
	from tm_lz.lt_src_deapp_annot d
	,tm_cz.probeset_deapp p
	where d.probe_id = p.probeset
	  and d.gpl_id = p.platform
	  and coalesce(d.organism,'Homo sapiens') = coalesce(p.organism,'Homo sapiens');
	stepCt := stepCt + 1;
	-- call czx_write_audit(jobId,databaseName,procedureName,'Load annotation data into REFERENCE annotation_deapp',ROW_COUNT,stepCt,'Done');
	
	--	insert data into deapp.de_mrna_annotation
	raise notice 'before de_mrna_annotation';
	insert into deapp.de_mrna_annotation
	(gpl_id
	,probe_id
	,gene_symbol
	,gene_id
	,probeset_id
	,organism)
	select distinct d.gpl_id
	,d.probe_id
	,d.gene_symbol
	,case when d.gene_id is null then null else to_number(d.gene_id,'9') end
	,p.probeset_id
	,coalesce(d.organism,'Homo sapiens')
	from tm_lz.lt_src_deapp_annot d
	,tm_cz.probeset_deapp p
	where d.probe_id = p.probeset
	  and d.gpl_id = p.platform
	  and coalesce(d.organism,'Homo sapiens') = coalesce(p.organism,'Homo sapiens');	
	stepCt := stepCt + 1;
	-- call czx_write_audit(jobId,databaseName,procedureName,'Load annotation data into DEAPP de_mrna_annotation',ROW_COUNT,stepCt,'Done');

/*	--	update gene_id if null
	
	update deapp.de_mrna_annotation t
	set gene_id=(select to_number(min(b.primary_external_id)) as gene_id
				 from biomart.bio_marker b
				 where t.gene_symbol = b.bio_marker_name
				   and upper(b.organism) = upper(t.organism)
				   and upper(b.bio_marker_type) = 'GENE')
	where t.gpl_id = gplId
	  and t.gene_id is null
	  and t.gene_symbol is not null
	  and exists
		 (select 1 from biomart.bio_marker x
		  where t.gene_symbol = x.bio_marker_name
			and upper(x.organism) = upper(t.organism)
			and upper(x.bio_marker_type) = 'GENE');		
	stepCt := stepCt + 1;
	czx_write_audit(jobId,databaseName,procedureName,'Updated missing gene_id in de_mrna_annotation',ROW_COUNT,stepCt,'Done');
	commit;
	
	--	update gene_symbol based on gene_id.  This is done to correct any mislabeling of the gene symbol from the annotation file
	
	update de_mrna_annotation t
	set gene_symbol=(select min(b.bio_marker_name) as gene_symbol
				 from biomart.bio_marker b
				 where to_char(t.gene_id) = b.primary_external_id
				   and upper(b.organism) = upper(t.organism)
				   and upper(b.bio_marker_type) = 'GENE')
	where t.gpl_id = gplId
	  --and t.gene_symbol is null
	  and t.gene_id is not null
	  and exists
		 (select 1 from biomart.bio_marker x
		  where to_char(t.gene_id) = x.primary_external_id
			and upper(x.organism) = upper(t.organism)
			and upper(x.bio_marker_type) = 'GENE');		
	stepCt := stepCt + 1;
	czx_write_audit(jobId,databaseName,procedureName,'Updated gene_symbol in de_mrna_annotation',ROW_COUNT,stepCt,'Done');
	commit;
	
	--	insert probesets into biomart.bio_assay_feature_group
	
	insert into biomart.bio_assay_feature_group
	(feature_group_name
	,feature_group_type)
	select distinct t.probe_id, 'PROBESET'
	from tm_lz.lt_src_deapp_annot t
	where not exists
		 (select 1 from biomart.bio_assay_feature_group x
		  where t.probe_id = x.feature_group_name);	
	stepCt := stepCt + 1;
	-- call czx_write_audit(jobId,databaseName,procedureName,'Insert probesets into biomart.bio_assay_feature_group',ROW_COUNT,stepCt,'Done');
	
	--	insert probesets into biomart.bio_assay_data_annotation
	
	insert into biomart.bio_assay_data_annotation
	(bio_assay_feature_group_id
	,bio_marker_id)
	select distinct fg.bio_assay_feature_group_id
		  ,coalesce(bgs.bio_marker_id,bgi.bio_marker_id)
	from tm_lz.lt_src_deapp_annot t
		,biomart.bio_assay_feature_group fg
		,biomart.bio_marker bgs
		,biomart.bio_marker bgi
	where (t.gene_symbol is not null or t.gene_id is not null)
	  and t.probe_id = fg.feature_group_name
	  and t.gene_symbol = bgs.bio_marker_name(+)
	  and upper(coalesce(t.organism,'Homo sapiens')) = upper(bgs.organism)
	  and to_char(t.gene_id) = bgi.primary_external_id(+)
	  and upper(coalesce(t.organism,'Homo sapiens')) = upper(bgi.organism)
	  and coalesce(bgs.bio_marker_id,bgi.bio_marker_id,-1) > 0
	  and not exists
		 (select 1 from biomart.bio_assay_data_annotation x
		  where fg.bio_assay_feature_group_id = x.bio_assay_feature_group_id
		    and coalesce(bgs.bio_marker_id,bgi.bio_marker_id,-1) = x.bio_marker_id);		
	stepCt := stepCt + 1;
	czx_write_audit(jobId,databaseName,procedureName,'Link feature_group to bio_marker in biomart.bio_assay_data_annotation',ROW_COUNT,stepCt,'Done');
	commit;
*/	
	stepCt := stepCt + 1;
	-- call czx_write_audit(jobId,databaseName,procedureName,'End i2b2_load_annotation_deapp',0,stepCt,'Done');
	
       ---Cleanup OVERALL JOB if this proc is being run standalone
  IF newJobFlag = 1
  THEN
    -- call czx_end_audit (jobID, 'SUCCESS');
  END IF;

  EXCEPTION
  WHEN OTHERS THEN
	raise notice 'error: %', SQLERRM;
    --Handle errors.
    -- call czx_error_handler (jobID, procedureName);
    --End Proc
    -- call czx_end_audit (jobID, 'FAIL');

END;
END_PROC;

