CREATE OR REPLACE PROCEDURE TM_CZ.I2B2_RENAME_NODE(VARCHAR(ANY), VARCHAR(ANY), VARCHAR(ANY), INTEGER)
RETURNS INTEGER
EXECUTE AS OWNER
LANGUAGE NZPLSQL AS
BEGIN_PROC
DECLARE
	TRIAL_ID ALIAS FOR $1;
	OLD_NODE ALIAS FOR $2;
	NEW_NODE ALIAS FOR $3;
	CURRENTJOBID ALIAS FOR $4;
	
	newJobFlag INTEGER(1);
  	databaseName VARCHAR(100);
  	procedureName VARCHAR(100);
  	jobID number(18,0);
  	stepCt number(18,0);
	
BEGIN
	
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
    	
  stepCt := 0;

  
	stepCt := stepCt + 1;
	call tm_cz.czx_write_audit(jobId,databaseName,procedureName,'Start i2b2_rename_node',0,stepCt,'Done'); 
	
  if old_node != ''  and old_node != '%' and new_node != ''  and new_node != '%'
  then

	--	Update concept_counts paths

	update i2b2demodata.concept_counts cc
      set CONCEPT_PATH = replace(cc.concept_path, '\' || old_node || '\', '\' || new_node || '\'),
	      parent_concept_path = replace(cc.parent_concept_path, '\' || old_node || '\', '\' || new_node || '\')
      where cc.concept_path in
		   (select cd.concept_path from i2b2demodata.concept_dimension cd
		    where cd.sourcesystem_cd = trial_id
              and cd.concept_path like '%' || old_node || '%');
	stepCt := stepCt + 1;
	
	call tm_cz.czx_write_audit(jobId,databaseName,procedureName,'Update concept_counts with new path',1 /*SQL%ROWCOUNT*/,stepCt,'Done'); 

    COMMIT;
	
    --Update path in i2b2_tags
    update i2b2metadata.i2b2_tags t
      set path = replace(t.path, '\' || old_node || '\', '\' || new_node || '\')
      where t.path in
		   (select cd.concept_path from i2b2demodata.concept_dimension cd
		    where cd.sourcesystem_cd = trial_id
              and cd.concept_path like '%\' || old_node || '\%');
	
	stepCt := stepCt + 1;
	call tm_cz.czx_write_audit(jobId,databaseName,procedureName,'Update i2b2_tags with new path',1/*SQL%ROWCOUNT*/,stepCt,'Done'); 

    COMMIT;
	
    --Update specific name
    --update concept_dimension
    --  set name_char = new_node
    --  where name_char = old_node
    --    and sourcesystem_cd = trial_id;

    --Update all paths
    update i2b2demodata.concept_dimension
      set CONCEPT_PATH = replace(concept_path, '\' || old_node || '\', '\' || new_node || '\')
	     ,name_char=decode(name_char,old_node,new_node,name_char)
      where
		sourcesystem_cd = trial_id
        and concept_path like '%\' || old_node || '\%';
	stepCt := stepCt + 1;
	
	call tm_cz.czx_write_audit(jobId,databaseName,procedureName,'Update concept_dimension with new path',1 /*SQL%ROWCOUNT*/,stepCt,'Done'); 

    COMMIT;



    --I2B2
    --Update specific name
    --update i2b2
    --  set c_name = new_node
    --  where c_name = old_node
    --    and c_fullname like '%' || trial_id || '%';

    --Update all paths, added updates to c_dimcode and c_tooltip instead of separate pass
    update i2b2metadata.i2b2
      set c_fullname = replace(c_fullname, '\' || old_node || '\', '\' || new_node || '\')
	  	 ,c_dimcode = replace(c_dimcode, '\' || old_node || '\', '\' || new_node || '\')
		 ,c_tooltip = replace(c_tooltip, '\' || old_node || '\', '\' || new_node || '\')
		 ,c_name = decode(c_name,old_node,new_node,c_name)
      where sourcesystem_cd = trial_id
        and c_fullname like '%\' || old_node || '\%';
	
	stepCt := stepCt + 1;
	cal tm_cz.czx_write_audit(jobId,databaseName,procedureName,'Update i2b2 with new path',SQL%ROWCOUNT,stepCt,'Done'); 

    COMMIT;

	--Update i2b2_secure to match i2b2
    --update i2b2_secure
    --  set c_fullname = replace(c_fullname, old_node, new_node)
	--  	 ,c_dimcode = replace(c_dimcode, old_node, new_node)
	--	 ,c_tooltip = replace(c_tooltip, old_node, new_node)
    --  where
    --    c_fullname like '%' || trial_id || '%';
    --COMMIT;
	
	call tm_cz.i2b2_load_security_data(jobID);


  END IF;
  
    ---Cleanup OVERALL JOB if this proc is being run standalone
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

