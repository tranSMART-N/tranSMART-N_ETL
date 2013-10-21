set define off;
  CREATE OR REPLACE PROCEDURE "I2B2_TABLE_INDEX_MAINT" 
(
  run_type 			VARCHAR2 := 'DROP'
  ,input_table		VARCHAR2
 ,currentJobID 		NUMBER := null
) AUTHID CURRENT_USER
AS
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

	runType			varchar2(100);
	idxExists		number;
	pExists			number;
	tableName		varchar2(50);
	sqlText			varchar2(500);
	lastIndex		varchar2(100);
	lastTablespace	varchar2(100);
	lastOwner		varchar2(100);
	lastConstraint	varchar2(100);
	constraintSql	varchar2(1000);
	lastIndexType	varchar2(100);
	lastParam		varchar2(100);
	rowCt			number;
  
	type index_names_rec is record
	(index_name				varchar2(100)
	,index_owner			varchar2(100)
	,table_owner			varchar2(100)
	,constraint_name		varchar2(100)
	);
	
	type index_names is table of index_names_rec;
	index_name_array index_names;
	
	type index_cols_rec is record
	(col_index_name			varchar2(100)
	,col_index_owner		varchar2(100)
	,col_table_name			varchar2(100)
	,col_table_owner		varchar2(100)
	,col_column_name		varchar2(100)
	,col_uniqueness			varchar2(100)
	,col_position			number
	,col_descend			varchar2(4)
	,col_tablespace_name	varchar2(100)
	,col_constraint_name	varchar2(100)
	,col_itype_owner		varchar2(100)
	,col_itype_name			varchar2(100)
	,col_param				varchar2(100)
	);
	type index_cols is table of index_cols_rec;
	index_cols_array index_cols;
	
	type index_sql_rec is record
	(sql_index_name			varchar2(100)
	,sql_index_sql			varchar2(1000)
	,sql_constraint_sql		varchar2(1000)
	);
	type index_sql_text is table of index_sql_rec;
	index_sql_array index_sql_text;
   
	--Audit variables
	newJobFlag INTEGER(1);
	databaseName VARCHAR(100);
	procedureName VARCHAR(100);
	jobID number(18,0);
	stepCt number(18,0);
	
	invalid_table		exception;
	no_indexes			exception;
	no_saved_indexes	exception;
	invalid_run_type	exception;
  
BEGIN

	runType := upper(run_type);
	tableName := upper(input_table);
	
	--Set Audit Parameters
	newJobFlag := 0; -- False (Default)
	jobID := currentJobID;

	SELECT sys_context('USERENV', 'CURRENT_SCHEMA') INTO databaseName FROM dual;
	procedureName := $$PLSQL_UNIT;

	--Audit JOB Initialization
	--If Job ID does not exist, then this is a single procedure run and we need to create it
	IF(jobID IS NULL or jobID < 1)
	THEN
		newJobFlag := 1; -- True
		czx_start_audit (procedureName, databaseName, jobID);
	END IF;
    	
	stepCt := 0;
	
	stepCt := stepCt + 1;
	czx_write_audit(jobId,databaseName,procedureName,'Start '|| tableName || ' index '|| run_type ,0,stepCt,'Done');
	
	if runType not in ('DROP','ADD') then
		stepCt := stepCt + 1;
		czx_write_audit(jobId,databaseName,procedureName,'Invalid run_type: ' || run_type,0,stepCt,'Done');
		raise invalid_run_type;
	end if;
	
	select count(*) into pExists
	from all_tables
	where table_name = tableName;
	
	if pExists = 0 then
		raise invalid_table;
	end if;
	
	if runType = 'DROP' then
		select c.index_name
			  ,c.index_owner
			  ,c.table_name
			  ,c.table_owner
			  ,c.column_name
			  ,case when i.uniqueness = 'UNIQUE' then 'UNIQUE' else null end
			  ,c.column_position
			  ,c.descend
			  ,i.tablespace_name
			  ,x.constraint_name
			  ,i.ityp_owner
			  ,i.ityp_name
			  ,i.parameters
		bulk collect into index_cols_array
		from all_indexes i
			,all_ind_columns c
			,all_constraints x
		where i.index_name = c.index_name
		  and i.table_name = tableName
		  and i.index_name = x.index_name(+)
		order by c.index_name, c.column_position;
		rowCt := SQL%ROWCOUNT;
		stepCt := stepCt + 1;
		czx_write_audit(jobId,databaseName,procedureName,'Found indexes for '|| tableName,rowCt,stepCt,'Done');
			
		if index_cols_array.count = 0 then
			raise no_indexes;
		end if;
	
		delete from tm_cz.cz_table_index
		where table_name = tableName;
		stepCt := stepCt + 1;
		czx_write_audit(jobId,databaseName,procedureName,'Deleted table from cz_table_index',SQL%ROWCOUNT,stepCt,'Done');
		
		lastIndex 		:= null;
		lastTablespace	:= null;
		lastConstraint	:= null;
		sqlText			:= null;
		constraintSql	:= null;
		lastParam		:= null;
		lastIndexType	:= null;
		for i in index_cols_array.first .. index_cols_array.last
		loop
			if lastIndex = index_cols_array(i).col_index_name then
				sqlText := sqlText || ', ' || index_cols_array(i).col_column_name || ' ' || index_cols_array(i).col_descend;
				if lastConstraint is not null then
					constraintSql := constraintSql || ', ' || index_cols_array(i).col_column_name;
				end if;
			else
				if sqlText is not null then
					if lastIndexType is not null then
						sqlText := sqlText || ' ) INDEXTYPE IS "' || lastIndexType || '" Parameters (' || '''' || lastParam || '''' || ')';
					else	
						sqlText := sqlText || ' ) nologging compute statistics tablespace "' || lastTablespace || '"';
					end if;
					if constraintSql is not null then
						constraintSql := constraintSql || ' ) using index nologging compute statistics tablespace "' || lastTablespace || '"';
					end if;
					insert into tm_cz.cz_table_index
					(owner, table_name, index_name, index_sql, constraint_sql)
					values(lastOwner, tableName, lastIndex, sqlText, constraintSql);
					stepCt := stepCt + 1;
					czx_write_audit(jobId,databaseName,procedureName,'Backup index: ' || lastIndex,1,stepCt,'Done');
					sqlText := null;
					constraintSql := null;
					lastIndexType := null;
					lastParam := null;
				end if;
		
				lastIndex := index_cols_array(i).col_index_name;
				lastTablespace := index_cols_array(i).col_tablespace_name;
				lastOwner := index_cols_array(i).col_index_owner;
				lastConstraint := index_cols_array(i).col_constraint_name;
				if index_cols_array(i).col_itype_owner is null then
					lastIndexType := null;
				else
					lastIndexType := index_cols_array(i).col_itype_owner || '.' || index_cols_array(i).col_itype_name;
				end if;
				lastParam := index_cols_array(i).col_param;
				sqlText := 'create ' || index_cols_array(i).col_uniqueness || ' index ' || index_cols_array(i).col_index_owner || '.' ||
						   index_cols_array(i).col_index_name || ' on ' || index_cols_array(i).col_table_owner || '.' ||
						   index_cols_array(i).col_table_name || ' (' || index_cols_array(i).col_column_name || ' ' || 
						   case when lastIndexType is null then index_cols_array(i).col_descend else null end;
				if lastConstraint is not null then
					constraintSql := 'alter table ' || index_cols_array(i).col_table_owner || '.' || tableName || ' add constraint ' ||
									lastConstraint || ' primary key (' || index_cols_array(i).col_column_name;
				end if;
			end if;
		end loop;
		if sqlText is not null then
			if lastIndexType is not null then
				sqlText := sqlText || ' ) INDEXTYPE IS ' || lastIndexType || ' Parameters (' || '''' || lastParam || '''' || ')';
			else	
				sqlText := sqlText || ' ) nologging compute statistics tablespace "' || lastTablespace || '"';
			end if;
			if constraintSql is not null then
				constraintSql := constraintSql || ' ) using index nologging compute statistics tablespace "' || lastTablespace || '"';
			end if;
			insert into tm_cz.cz_table_index
			(owner, table_name, index_name, index_sql, constraint_sql)
			values(lastOwner, tableName, lastIndex, sqlText, constraintSql);
			stepCt := stepCt + 1;
			czx_write_audit(jobId,databaseName,procedureName,'Backup index: '|| lastIndex,1,stepCt,'Done');
		end if;
		commit;
	
		select i.index_name
			  ,i.owner
			  ,i.table_owner
			  ,c.constraint_name
		bulk collect into index_name_array
		from all_indexes i
			,all_constraints c
		where i.table_name = tableName
		  and i.index_name = c.index_name(+);

		if index_name_array.count = 0 then
			stepCt := stepCt + 1;
			czx_write_audit(jobId,databaseName,procedureName,'No indexes found for '||tableName,0,stepCt,'Done');
		else
			for i in index_name_array.first .. index_name_array.last
			loop
				if index_name_array(i).constraint_name is not null then
					sqlText := 'alter table ' || index_name_array(i).table_owner || '.' || tableName || ' drop constraint ' ||
							   index_name_array(i).constraint_name;
					stepCt := stepCt + 1;
					czx_write_audit(jobId,databaseName,procedureName,sqlText,0,stepCt,'Done');
					execute immediate(sqlText);
					--stepCt := stepCt + 1;
					--czx_write_audit(jobId,databaseName,procedureName,'Drop complete',0,stepCt,'Done');
				end if;
				sqlText := 'drop index ' || index_name_array(i).index_owner || '.' || index_name_array(i).index_name;
				stepCt := stepCt + 1;
				czx_write_audit(jobId,databaseName,procedureName,sqlText,0,stepCt,'Done');
				execute immediate(sqlText);
				--stepCt := stepCt + 1;
				--czx_write_audit(jobId,databaseName,procedureName,'Drop complete',0,stepCt,'Done');
			end loop;
		end if;
	else
			--	add indexes
		select count(*) into pExists
		from tm_cz.cz_table_index
		where table_name = tableName;
			
		if pExists = 0 then
			raise no_saved_indexes;
		end if;
			
		select index_name
			  ,index_sql
			  ,constraint_sql
		bulk collect into index_sql_array
		from tm_cz.cz_table_index
		where table_name = tableName
		order by case when constraint_sql is null then 1 else 0 end;
		
		for i in index_sql_array.first .. index_sql_array.last
		loop
			select count(*) into pExists
			from all_indexes
			where index_name = index_sql_array(i).sql_index_name;
			
			if pExists > 0 then
				stepCt := stepCt + 1;
				czx_write_audit(jobId,databaseName,procedureName,'Index exists, skipping: ' || index_sql_array(i).sql_index_name,0,stepCt,'Done');
			else
				stepCt := stepCt + 1;
				czx_write_audit(jobId,databaseName,procedureName,'Creating index ' || index_sql_array(i).sql_index_name,0,stepCt,'Done');
				sqlText := index_sql_array(i).sql_index_sql;
				execute immediate(sqlText);
				--stepCt := stepCt + 1;
				--czx_write_audit(jobId,databaseName,procedureName,'Create done',0,stepCt,'Done');
				if index_sql_array(i).sql_constraint_sql is not null then
					sqlText := index_sql_array(i).sql_constraint_sql;
					execute immediate(sqlText);
					stepCt := stepCt + 1;
					czx_write_audit(jobId,databaseName,procedureName,'Constraint done',0,stepCt,'Done');
				end if;
			end if;
		end loop;		
	end if;
	
	stepCt := stepCt + 1;
	czx_write_audit(jobId,databaseName,procedureName,'End procedure '||procedureName,SQL%ROWCOUNT,stepCt,'Done');
	commit;	

	
    ---Cleanup OVERALL JOB if this proc is being run standalone
	IF newJobFlag = 1
	THEN
		czx_end_audit (jobID, 'SUCCESS');
	END IF;

	EXCEPTION
	when invalid_table then
		stepCt := stepCt + 1;
		czx_write_audit(jobId,databaseName,procedureName,'Invalid table name '|| tableName,1,stepCt,'Done');
	when no_saved_indexes then
		stepCt := stepCt + 1;
		czx_write_audit(jobId,databaseName,procedureName,'No indexes in tm_cz.cz_table_index for '|| tableName,1,stepCt,'Done');
	when no_indexes then
		stepCt := stepCt + 1;
		czx_write_audit(jobId,databaseName,procedureName,'No indexes on table '|| tableName,1,stepCt,'Done');
	when invalid_run_type then
		stepCt := stepCt + 1;
		czx_write_audit(jobId,databaseName,procedureName,'Invalid run type '|| runType,1,stepCt,'Done');
	WHEN OTHERS THEN
		--Handle errors.
		czx_error_handler (jobID, procedureName);
		
		--End Proc
		czx_end_audit (jobID, 'FAIL');
end;
 
 
