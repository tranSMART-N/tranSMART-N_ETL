create or replace FUNCTION tm_cz.IS_DATE(
 varchar(ANY),VARCHAR(ANY))-- d_fmt varchar2 := 'YYYYMMDD')
)
RETURNS numeric
EXECUTE AS OWNER
LANGUAGE NZPLSQL AS

BEGIN_PROC
DECLARE
	PATH ALIAS FOR $1;
	P_STRING VARCHAR(100);
	D_FMT VARCHAR(100);
	
BEGIN

        x_date date;

  --      x_date := to_date(p_string,d_fmt);
		
        return 0;
--   exception
--       when others then
--           return 1;

   

END

END_PROC;
   