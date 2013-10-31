CREATE OR REPLACE PROCEDURE TM_CZ.I2B2_LOAD_SECURITY_DATA(NUMERIC(18,0))
RETURNS NUMERIC
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
  
  secNodeExists		int4;
  etlDate			timestamp;
  bslash			char(1);

BEGIN

  --Set Audit Parameters
  newJobFlag := 0; -- False (Default)
  jobID := currentJobID;
  select now() into etlDate;
  bslash := '\\';

  databaseName := 'TM_CZ';
  procedureName := 'I2B2_LOAD_SECURITY_DATA';

  --Audit JOB Initialization
  --If Job ID does not exist, then this is a single procedure run and we need to create it
  IF(jobID IS NULL or jobID < 1)
  THEN
    newJobFlag := 1; -- True
    jobId := tm_cz.czx_start_audit (procedureName, databaseName);
  END IF;

  stepCt := 0;

  Execute immediate 'truncate table I2B2METADATA.i2b2_secure';

  stepCt := stepCt + 1;
  call tm_cz.czx_write_audit(jobId,databaseName,procedureName,'Truncate I2B2METADATA i2b2_secure',0,stepCt,'Done');

  insert into I2B2METADATA.i2b2_secure(
    C_HLEVEL,
    C_FULLNAME,
    C_NAME,
    C_SYNONYM_CD,
    C_VISUALATTRIBUTES,
    C_TOTALNUM,
    C_BASECODE,
    C_METADATAXML,
    C_FACTTABLECOLUMN,
    C_TABLENAME,
    C_COLUMNNAME,
    C_COLUMNDATATYPE,
    C_OPERATOR,
    C_DIMCODE,
    C_COMMENT,
    C_TOOLTIP,
    UPDATE_DATE,
    DOWNLOAD_DATE,
    IMPORT_DATE,
    SOURCESYSTEM_CD,
    VALUETYPE_CD,
	secure_obj_token)
  select
    b.C_HLEVEL,
    b.C_FULLNAME,
    b.C_NAME,
    b.C_SYNONYM_CD,
    b.C_VISUALATTRIBUTES,
    b.C_TOTALNUM,
    b.C_BASECODE,
    b.C_METADATAXML,
    b.C_FACTTABLECOLUMN,
    b.C_TABLENAME,
    b.C_COLUMNNAME,
    b.C_COLUMNDATATYPE,
    b.C_OPERATOR,
    b.C_DIMCODE,
    b.C_COMMENT,
    b.C_TOOLTIP,
    b.UPDATE_DATE,
    b.DOWNLOAD_DATE,
    b.IMPORT_DATE,
    b.SOURCESYSTEM_CD,
    b.VALUETYPE_CD,
	coalesce(f.tval_char,'EXP:PUBLIC')
    from I2B2METADATA.I2B2 b
	left outer join (select distinct case when sourcesystem_cd like '%:%' then substr(sourcesystem_cd,1,instr(sourcesystem_cd,':')-1)
							   else sourcesystem_cd end as sourcesystem_cd
				,tval_char from i2b2demodata.observation_fact where concept_cd = 'SECURITY') f
	on b.sourcesystem_cd = f.sourcesystem_cd;
	rowCount := ROW_COUNT;
    stepCt := stepCt + 1;
    call tm_cz.czx_write_audit(jobId,databaseName,procedureName,'Insert security data into I2B2METADATA i2b2_secure',rowCount,stepCt,'Done');
	
	--	check if SECURITY node exists in i2b2

	select count(*) into secNodeExists
	from i2b2metadata.i2b2
	where c_fullname = bslash || 'Public Studies' || bslash || 'SECURITY' || bslash;

	if secNodeExists = 0 then
		insert into i2b2metadata.i2b2
		(c_hlevel
		,c_fullname
		,c_name
		,c_synonym_cd
		,c_visualattributes
		,c_totalnum
		,c_basecode
		,c_metadataxml
		,c_facttablecolumn
		,c_tablename
		,c_columnname
		,c_columndatatype
		,c_operator
		,c_dimcode
		,c_comment
		,c_tooltip
		,update_date
		,download_date
		,import_date
		,sourcesystem_cd
		,valuetype_cd
		,m_applied_path
		)
		select 1 as c_hlevel
			  ,bslash || 'Public Studies' || bslash || 'SECURITY' || bslash as c_fullname
			  ,'SECURITY' as c_name
			  ,'N' as c_synonym_cd
			  ,'CA' as c_visualattributes
			  ,null as c_totalnum
			  ,null as c_basecode
			  ,null as c_metadataxml
			  ,'concept_cd' as c_facttablecolumn
			  ,'concept_dimension' as c_tablename
			  ,'concept_path' as c_columnname
			  ,'T' as c_columndatatype
			  ,'LIKE' as c_operator
			  ,bslash || 'Public Studies' || bslash || 'SECURITY' || bslash as c_dimcode
			  ,null as c_comment
			  ,bslash || 'Public Studies' || bslash || 'SECURITY' || bslash as c_tooltip
			  ,etlDate as update_date
			  ,null as download_date
			  ,etlDate as import_date
			  ,null as sourcesystem_cd
			  ,null as valuetype_cd
			  ,'@' as m_applied_path;
		rowCount := ROW_COUNT;
		stepCt := stepCt + 1;
		call tm_cz.czx_write_audit(jobId,databaseName,procedureName,'Insert \Public Studies\SECURITY\ node to i2b2',rowCount,stepCt,'Done');	
	end if;

	--	check if SECURITY node exists in concept_dimension
	
	select count(*) into secNodeExists
	from i2b2demodata.concept_dimension
	where concept_path = bslash || 'Public Studies' || bslash || 'SECURITY' || bslash;
	
	if secNodeExists = 0 then
		insert into i2b2demodata.concept_dimension
		(concept_cd
		,concept_path
		,name_char
		,update_date
		,download_date
		,import_date
		,sourcesystem_cd
		)
		select 'SECURITY'
			 ,bslash || 'Public Studies' || bslash || 'SECURITY' || bslash
			 ,'SECURITY'
			 ,etlDate
			 ,etlDate
			 ,etlDate
			 ,null;
		rowCount := ROW_COUNT;
		stepCt := stepCt + 1;
		call tm_cz.czx_(jobId,databaseName,procedureName,'Insert \Public Studies\SECURITY\ node to concept_dimension',rowCount,stepCt,'Done');
	end if;

    ---Cleanup OVERALL JOB if this proc is being run standalone
	IF newJobFlag = 1
	THEN
		call tm_cz.czx_end_audit (jobID, 'SUCCESS');
	END IF;

	EXCEPTION
	WHEN OTHERS THEN
		raise notice 'error: %', SQLERRM;
		--Handle errors.
		call tm_cz.czx_error_handler (jobID, procedureName);
		--End Proc
		call tm_cz.czx_end_audit (jobID, 'FAIL');

end;
END_PROC;

