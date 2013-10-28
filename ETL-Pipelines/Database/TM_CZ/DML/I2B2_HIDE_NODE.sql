CREATE OR REPLACE PROCEDURE TM_CZ.I2B2_HIDE_NODE(VARCHAR(ANY))
RETURNS INTEGER
EXECUTE AS OWNER
LANGUAGE NZPLSQL AS
BEGIN_PROC
DECLARE
	PATH ALIAS FOR $1;
BEGIN

if path != ''  and path != '%'
  then 
  
	update I2B2METADATA.i2b2 b
	set c_visualattributes=substr(b.c_visualattributes,1,1) || 'H' || substr(b.c_visualattributes,3,1)
	where c_fullname like path || '%';
	
	delete from I2B2DEMODATA.concept_counts
	where concept_path like path || '%';
	
/*
      --I2B2
     UPDATE i2b2
      SET c_visualattributes = 'FH'
    WHERE c_visualattributes like 'F%'
      AND C_FULLNAME LIKE PATH || '%';

     UPDATE i2b2
      SET c_visualattributes = 'LH'
    WHERE c_visualattributes like 'L%'
      AND C_FULLNAME LIKE PATH || '%';
    COMMIT;
*/
  END IF;
  

END;
END_PROC;
