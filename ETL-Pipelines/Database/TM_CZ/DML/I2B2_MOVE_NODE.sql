CREATE OR REPLACE PROCEDURE tm_cz.I2B2_MOVE_NODE(VARCHAR(ANY), VARCHAR(ANY), VARCHAR(ANY), INTEGER)
RETURNS INTEGER
EXECUTE AS OWNER
LANGUAGE NZPLSQL AS
BEGIN_PROC
DECLARE
	old_path ALIAS FOR $1;
	new_path ALIAS FOR $2;
	topNode ALIAS FOR $3;
	currentJobID ALIAS FOR $4;
	
	root_node varchar2(2000);
	root_level int;
	
	--Audit variables
	newJobFlag INTEGER(1);
	databaseName VARCHAR(100);
	procedureName VARCHAR(100);
	jobID number(18,0);
	stepCt number(18,0);
  	
BEGIN

	stepCt := 0;
	
	--Set Audit Parameters
	newJobFlag := 0; -- False (Default)
	jobID := currentJobID;

--	SELECT sys_context('USERENV', 'CURRENT_SCHEMA') INTO databaseName FROM dual;
--	procedureName := $$PLSQL_UNIT;
	select CURRENT_CATALOG into databaseName;
	select I2B2_SECURE_STUDY into procedureName;  
  
	--Audit JOB Initialization
	--If Job ID does not exist, then this is a single procedure run and we need to create it
	IF(jobID IS NULL or jobID < 1)
	THEN
		newJobFlag := 1; -- True
	call tm_cz.czx_start_audit (procedureName, databaseName, jobID);
	END IF;

	stepCt := stepCt + 1;
	call tm_cz.czx_write_audit(jobId,databaseName,procedureName,'Start i2b2_move_node',0,stepCt,'Done');  
	
	select tm_cz.parse_nth_value(topNode, 2, '\') into root_node;-- from dual;
	
	select c_hlevel into root_level
	from i2b2metadata.table_access
	where c_name = root_node;
	
	if old_path != ''  or old_path != '%' or new_path != ''  or new_path != '%'
	then 
      --CONCEPT DIMENSION
		update i2b2demodata.concept_dimension
		set CONCEPT_PATH = replace(concept_path, old_path, new_path)
		where concept_path like old_path || '%';
		stepCt := stepCt + 1;
		call tm_cz.czx_write_audit(jobId,databaseName,procedureName,'Update concept_dimension with new path',SQL%ROWCOUNT,stepCt,'Done'); 
		COMMIT;
    
		--I2B2
		update i2b2metadata.i2b2
		set c_fullname = replace(c_fullname, old_path, new_path)
		where c_fullname like old_path || '%';
		stepCt := stepCt + 1;
		call tm_cz.czx_write_audit(jobId,databaseName,procedureName,'Update i2b2 with new path',SQL%ROWCOUNT,stepCt,'Done'); 
		COMMIT;
  
		--update level data
		UPDATE i2b2metadata.I2B2
		set c_hlevel = (length(c_fullname) - nvl(length(replace(c_fullname, '\')),0)) / length('\') - 2 + root_level
		where c_fullname like new_path || '%';
		stepCt := stepCt + 1;
		call tm_cz.czx_write_audit(jobId,databaseName,procedureName,'Update i2b2 with new level',SQL%ROWCOUNT,stepCt,'Done'); 
		COMMIT;
		
		--Update tooltip and dimcode
		update i2b2metadata.i2b2
		set c_dimcode = c_fullname,
		c_tooltip = c_fullname
		where c_fullname like new_path || '%';
		stepCt := stepCt + 1;
		call tm_cz.czx_write_audit(jobId,databaseName,procedureName,'Update i2b2 with new dimcode and tooltip',SQL%ROWCOUNT,stepCt,'Done'); 
		COMMIT;

		--if topNode != '' then
		--	i2b2_create_concept_counts(topNode,jobId);
		--end if;
	end if;
	
	IF newJobFlag = 1
	THEN
		call tm_cz.czx_end_audit (jobID, 'SUCCESS');
	END IF;

	EXCEPTION
	WHEN OTHERS THEN
		--Handle errors.
		call tm_cz.czx_error_handler (jobID, procedureName);
		--End Proc
		call tm_cz.czx_end_audit (jobID, 'FAIL');
		
END;

END_PROC;
