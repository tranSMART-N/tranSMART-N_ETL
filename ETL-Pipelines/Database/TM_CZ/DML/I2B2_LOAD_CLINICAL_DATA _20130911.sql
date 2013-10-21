set define off;
create or replace
PROCEDURE "I2B2_LOAD_CLINICAL_DATA" 
(
  trial_id 			IN	VARCHAR2
 ,top_node			in  varchar2
 ,secure_study		in varchar2 := 'N'
 ,highlight_study	in	varchar2 := 'N'
 ,currentJobID		IN	NUMBER := null
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
   
  topNode		VARCHAR2(2000);
  topLevel		number(10,0);
  root_node		varchar2(2000);
  root_level	int;
  study_name	varchar2(2000);
  TrialID		varchar2(100);
  secureStudy	varchar2(200);
  etlDate		date;
  tPath			varchar2(2000);
  pCount		int;
  pExists		int;
  rtnCode		int;
  tText			varchar2(2000);
  v_bio_experiment_id	number(18,0);
  levelName		varchar2(200);
  dCount		int;
  tmp_vocab		varchar2(500);
  tmp_components	varchar2(1000);
  tmp_leaf		varchar2(1000);
  tmp_label_vocab	varchar2(500);
  tmp_label_node	varchar2(2000);
  tmp_label		varchar2(500);
  tmp_vocab_codes	varchar2(1000);
  vCount		int;

  Type vocab_rec is record
  (vocab_leaf	varchar2(1000)
  ,vocab_codes	varchar2(500)
  ,label_components	varchar2(1000)
  ,data_label	varchar2(500)
  );
  
  Type vocab_table is table of vocab_rec;
  vocab_array vocab_table;

  
    --Audit variables
  newJobFlag INTEGER(1);
  databaseName VARCHAR(100);
  procedureName VARCHAR(100);
  jobID number(18,0);
  stepCt number(18,0);
  
  duplicate_values	exception;
  invalid_topNode	exception;
  multiple_visit_names	exception;
  invalid_visit_date	exception;
  invalid_end_date	exception;
  invalid_enroll_date	exception;
  duplicate_visit_dates	exception;
  no_study_data			exception;
  parent_node_exists	exception;
  
  CURSOR addNodes is
  select DISTINCT 
         leaf_node,
    		 node_name
  from  wt_trial_nodes a
  ;
   
	--	cursor to define the path for delete_one_node  this will delete any nodes that are hidden after i2b2_create_concept_counts

	CURSOR delNodes is
	select distinct c_fullname 
	from  i2b2
	where c_fullname like topNode || '%'
      and substr(c_visualattributes,2,1) = 'H';

	  
BEGIN
  
	TrialID := upper(trial_id);
	secureStudy := upper(secure_study);
	
	--Set Audit Parameters
	newJobFlag := 0; -- False (Default)
	jobID := currentJobID;

	SELECT sys_context('USERENV', 'CURRENT_SCHEMA') INTO databaseName FROM dual;
	procedureName := $$PLSQL_UNIT;
	
	select sysdate into etlDate from dual;

	--Audit JOB Initialization
	--If Job ID does not exist, then this is a single procedure run and we need to create it
	IF(jobID IS NULL or jobID < 1)
	THEN
		newJobFlag := 1; -- True
		czx_start_audit (procedureName, databaseName, jobID);
	END IF;
    	
	stepCt := 0;

	stepCt := stepCt + 1;
	tText := 'Start i2b2_load_clinical_data for ' || TrialId;
	czx_write_audit(jobId,databaseName,procedureName,tText,0,stepCt,'Done');
	
	if (secureStudy not in ('Y','N') ) then
		secureStudy := 'Y';
	end if;
	
	topNode := REGEXP_REPLACE('\' || top_node || '\','(\\){2,}', '\');
	
	--	figure out how many nodes (folders) are at study name and above
	--	\Public Studies\Clinical Studies\Pancreatic_Cancer_Smith_GSE22780\: topLevel = 4, so there are 3 nodes
	--	\Public Studies\GSE12345\: topLevel = 3, so there are 2 nodes
	
	select length(topNode)-length(replace(topNode,'\','')) into topLevel from dual;
	
	if topLevel < 3 then
		raise invalid_topNode;
	end if;	
	
	--	check if study data exists in lt_src_clinical_data
	
	select count(*) into pExists
	from tm_lz.lt_src_clinical_data
	where study_id = TrialId;
	
	if pExists = 0 then
		raise no_study_data;
	end if;

	--	delete any existing data from lz_src_clinical_data and load new data
	
	delete from tm_lz.lz_src_clinical_data
	where study_id = TrialId;
	
	stepCt := stepCt + 1;
	czx_write_audit(jobId,databaseName,procedureName,'Delete existing data from lz_src_clinical_data',SQL%ROWCOUNT,stepCt,'Done');
	commit;
	
	insert into tm_lz.lz_src_clinical_data
	(study_id
	,site_id
	,subject_id
	,visit_name
	,data_label
	,data_value
	,category_cd
	,etl_job_id
	,etl_date
	,data_label_ctrl_vocab_code
	,data_value_ctrl_vocab_code
	,data_label_components
	,units_cd
	,visit_date
	,link_type
	,link_value
	,end_date
	,visit_reference
	,date_ind
	,obs_string
	,valuetype_cd
	)
	select study_id
		  ,site_id
		  ,subject_id
		  ,visit_name
		  ,data_label
		  ,data_value
		  ,category_cd
		  ,jobId
		  ,etlDate
		  ,data_label_ctrl_vocab_code
		  ,data_value_ctrl_vocab_code
		  ,data_label_components
		  ,units_cd
		  ,visit_date
		  ,link_type
		  ,link_value
		  ,end_date
		  ,visit_reference
		  ,date_ind
		  ,obs_string
		  ,valuetype_cd
	from lt_src_clinical_data;
	stepCt := stepCt + 1;
	czx_write_audit(jobId,databaseName,procedureName,'Insert data into lz_src_clinical_data',SQL%ROWCOUNT,stepCt,'Done');
	commit;
	
	--	delete any existing data from lz_src_subj_enroll_date and add new
	
	delete from tm_lz.lz_src_subj_enroll_date
	where study_id = TrialId;
	
	stepCt := stepCt + 1;
	czx_write_audit(jobId,databaseName,procedureName,'Delete existing data from lz_src_subj_enroll_date',SQL%ROWCOUNT,stepCt,'Done');
	commit;
	
	insert into tm_lz.lz_src_subj_enroll_date
	(study_id
	,site_id
	,subject_id
	,enroll_date
	)
	select study_id
		  ,site_id
		  ,subject_id
		  ,enroll_date
	from tm_lz.lt_src_subj_enroll_date;
	stepCt := stepCt + 1;
	czx_write_audit(jobId,databaseName,procedureName,'Insert data into lz_src_subj_enroll_date',SQL%ROWCOUNT,stepCt,'Done');
	commit;
	
	--	truncate wrk_clinical_data and load data 
	
	execute immediate('truncate table tm_wz.wrk_clinical_data');
	
	--	insert data from lt_src_clinical_data to wrk_clinical_data
	
	insert into tm_wz.wrk_clinical_data
	(study_id
	,site_id
	,subject_id
	,visit_name
	,data_label
	,data_value
	,category_cd
	,data_label_ctrl_vocab_code
	,data_value_ctrl_vocab_code
	,data_label_components
	,units_cd
	,visit_date
	,end_date
	,data_type
	,category_path
	,usubjid
	,link_type
	,link_value
	,visit_reference
	,obs_string
	,valuetype_cd
	)
	select study_id
		  ,site_id
		  ,subject_id
		  ,visit_name
		  ,replace(data_label, '|', ',')
		  ,replace(trim('|' from data_value), '|', '-')
		  ,category_cd
		  ,data_label_ctrl_vocab_code
		  ,data_value_ctrl_vocab_code
		  ,data_label_components
		  ,units_cd
		  ,visit_date
		  ,end_date
		  ,date_ind
		  ,replace(replace(category_cd,'_',' '),'+','\')
		  ,REGEXP_REPLACE(TrialID || ':' || site_id || ':' || subject_id,'(::){1,}', ':')
		  ,link_type
		  ,link_value
		  ,trim(leading '\' from trim(trailing '\' from coalesce(visit_reference,visit_name)))
		  ,obs_string
		  ,valuetype_cd
	from lt_src_clinical_data
	where data_value is not null;
	
	stepCt := stepCt + 1;
	czx_write_audit(jobId,databaseName,procedureName,'Load lt_src_clinical_data to work table',SQL%ROWCOUNT,stepCt,'Done');
	
	commit;  	

	-- Get study name from topNode
  
	select parse_nth_value(topNode, topLevel, '\') into study_name from dual;	
	
	--	Replace all underscores with spaces in topNode except those in study name

	topNode := replace(replace(topNode,'\'||study_name||'\',null),'_',' ') || '\' || study_name || '\';
	
	-- Get root_node from topNode
  
	select parse_nth_value(topNode, 2, '\') into root_node from dual;
	
	select count(*) into pExists
	from table_access
	where c_name = root_node;
	
	select count(*) into pCount
	from i2b2
	where c_name = root_node;
	
	if pExists = 0 or pCount = 0 then
		i2b2_add_root_node(root_node, jobId);
	end if;
	
	select c_hlevel into root_level
	from table_access
	where c_name = root_node;
	
	--	Add any upper level nodes as needed
	
	tPath := REGEXP_REPLACE(replace(top_node,study_name,null),'(\\){2,}', '\');
	select length(tPath) - length(replace(tPath,'\',null)) into pCount from dual;

	if pCount > 2 then
		stepCt := stepCt + 1;
		czx_write_audit(jobId,databaseName,procedureName,'Adding upper-level nodes',0,stepCt,'Done');
		i2b2_fill_in_tree(null, tPath, jobId);
	end if;

	select count(*) into pExists
	from i2b2
	where c_fullname = topNode;
	
	--	add top node for study
	
	if pExists = 0 then
		i2b2_add_node(TrialId, topNode, study_name, jobId);
	end if;

	--Remove invalid Parens in the data
	--They have appeared as empty pairs or only single ones.
  
	update tm_wz.wrk_clinical_data
	set data_value = replace(data_value,'(', '')
	where data_value like '%()%'
	   or data_value like '%( )%'
	   or (data_value like '%(%' and data_value NOT like '%)%');
	stepCt := stepCt + 1;
	czx_write_audit(jobId,databaseName,procedureName,'Remove empty parentheses 1',SQL%ROWCOUNT,stepCt,'Done');
	
	update tm_wz.wrk_clinical_data
	set data_value = replace(data_value,')', '')
	where data_value like '%()%'
	   or data_value like '%( )%'
	   or (data_value like '%)%' and data_value NOT like '%(%');
	stepCt := stepCt + 1;
	czx_write_audit(jobId,databaseName,procedureName,'Remove empty parentheses 2',SQL%ROWCOUNT,stepCt,'Done');
	
	commit;
	
	--	set data_label to null when it duplicates the last part of the category_path
	--	Remove data_label from last part of category_path when they are the same
	
	update tm_wz.wrk_clinical_data tpm
	--set data_label = null
	set category_path=substr(tpm.category_path,1,instr(tpm.category_path,'\',-2)-1)
	   ,category_cd=substr(tpm.category_cd,1,instr(tpm.category_cd,'+',-2)-1)
	where (tpm.category_cd, tpm.data_label) in
		  (select distinct t.category_cd
				 ,t.data_label
		   from tm_wz.wrk_clinical_data t
		   where upper(substr(t.category_path,instr(t.category_path,'\',-1)+1,length(t.category_path)-instr(t.category_path,'\',-1))) 
			     = upper(t.data_label)
		     and t.data_label is not null)
	  and tpm.data_label is not null;

	stepCt := stepCt + 1;
	czx_write_audit(jobId,databaseName,procedureName,'Set data_label to null when found in category_path',SQL%ROWCOUNT,stepCt,'Done');
		
	commit;
	
	--	change any % to Pct and & and + to ' and ' and _ to space in data_label only
	
	update tm_wz.wrk_clinical_data
	set data_label=replace(replace(replace(replace(data_label,'%',' Pct'),'&',' and '),'+',' and '),'_',' ')
	   ,data_value=replace(replace(replace(data_value,'%',' Pct'),'&',' and '),'+',' and ')
	   ,category_cd=replace(replace(category_cd,'%',' Pct'),'&',' and ')
	   ,category_path=replace(replace(category_path,'%',' Pct'),'&',' and ');

  --Trim trailing and leadling spaces as well as remove any double spaces, remove space from before comma, remove trailing comma

	update tm_wz.wrk_clinical_data
	set data_label  = trim(trailing ',' from trim(replace(replace(data_label,'  ', ' '),' ,',','))),
		data_value  = trim(trailing ',' from trim(replace(replace(data_value,'  ', ' '),' ,',','))),
--		sample_type = trim(trailing ',' from trim(replace(replace(sample_type,'  ', ' '),' ,',','))),
		visit_name  = trim(trailing ',' from trim(replace(replace(visit_name,'  ', ' '),' ,',',')));
	stepCt := stepCt + 1;
	czx_write_audit(jobId,databaseName,procedureName,'Remove leading, trailing, double spaces',SQL%ROWCOUNT,stepCt,'Done');
	
	commit;

	--	check if visit_date is date
	
	select count(*) into pExists
	from tm_wz.wrk_clinical_data
	where visit_date is not null
	  and is_date(visit_date,'YYYY-MM-DD HH24:mi') = 1;
	stepCt := stepCt + 1;
	czx_write_audit(jobId,databaseName,procedureName,'Check for invalid visit_date',SQL%ROWCOUNT,stepCt,'Done');
		  
	if pExists > 0 then
		raise invalid_visit_date;
	end if;

	--	check if end_date is date
	
	select count(*) into pExists
	from tm_wz.wrk_clinical_data
	where end_date is not null
	  and is_date(visit_date,'YYYY-MM-DD HH24:mi') = 1;
	stepCt := stepCt + 1;
	czx_write_audit(jobId,databaseName,procedureName,'Check for invalid end_date',SQL%ROWCOUNT,stepCt,'Done');
		  
	if pExists > 0 then
		raise invalid_end_date;
	end if;

	--	determine numeric data types, force D (dates) to be non-numeric so mixed data types gets set correctly
	--	this deals with valid date of 20130101.1230 (D) and valid number of 2013 (T) not getting tagged as numeric

	execute immediate('truncate table tm_wz.wt_num_data_types');
  
	insert into wt_num_data_types
	(category_cd
	,data_label
	,visit_name
	)
    select category_cd,
           data_label,
           visit_name
    from tm_wz.wrk_clinical_data
    where data_value is not null
    group by category_cd
	        ,data_label
            ,visit_name
      having sum(case when data_type = 'D' then 1 else is_number(data_value) end) = 0;
	stepCt := stepCt + 1;
	czx_write_audit(jobId,databaseName,procedureName,'Insert numeric data into WZ wt_num_data_types',SQL%ROWCOUNT,stepCt,'Done');
	commit;
	
	--	set mixed dates to data_type = T
	
	merge into tm_wz.wrk_clinical_data a
    using (select coalesce(t.category_cd,'@') as category_cd, coalesce(t.data_label,'@') as data_label, coalesce(t.visit_name,'@') as visit_name
          from tm_wz.wrk_clinical_data t
          group by coalesce(t.category_cd,'@'), coalesce(t.data_label,'@'), coalesce(t.visit_name,'@')
          having count(*) > sum(case when t.data_type = 'D' then 1 else 0 end)
		     and sum(case when t.data_type = 'D' then 1 else 0 end) > 0) upd
    on (coalesce(a.category_cd,'@') = upd.category_cd and 
        coalesce(a.data_label,'@') = upd.data_label and 
        coalesce(a.visit_name,'@') = upd.visit_name)
    when matched then
    update set a.data_type='T';
	stepCt := stepCt + 1;
	czx_write_audit(jobId,databaseName,procedureName,'Reset mixed date/text data_types to T',SQL%ROWCOUNT,stepCt,'Done');
	commit;
		
	--	only update T data_types, leave D as is
	
	update tm_wz.wrk_clinical_data t
	set data_type='N'
	where exists
	     (select 1 from wt_num_data_types x
	      where nvl(t.category_cd,'@') = nvl(x.category_cd,'@')
			and nvl(t.data_label,'**NULL**') = nvl(x.data_label,'**NULL**')
			and nvl(t.visit_name,'**NULL**') = nvl(x.visit_name,'**NULL**')
		  )
	  and t.data_type = 'T';
	stepCt := stepCt + 1;
	czx_write_audit(jobId,databaseName,procedureName,'Updated data_type flag for numeric data_types',SQL%ROWCOUNT,stepCt,'Done');
	commit;
	
	--	set visit_date to date if D data_type and visit_date is null
	
	update tm_wz.wrk_clinical_data t
	set visit_date=to_char(to_date(substr(data_value,1,8) || substr(data_value,10,4),'YYYYMMDD.HH24mi'),'YYYY-MM-DD HH24:mi')
	where t.data_type = 'D'
	  and t.visit_date is null
	  and is_date(substr(data_value,1,8) || substr(data_value,10,4),'YYYYMMDDHH24mi') = 0;
	stepCt := stepCt + 1;
	czx_write_audit(jobId,databaseName,procedureName,'Updated visit_date for date data_types',SQL%ROWCOUNT,stepCt,'Done');
	commit;	  

	-- Build all needed leaf nodes in one pass for both numeric and text nodes
 
	execute immediate('truncate table tm_wz.wt_trial_nodes');
	
	insert into wt_trial_nodes
	(leaf_node
	,category_cd
	,visit_name
	,data_label
	--,node_name
	,data_value
	,data_type
	,data_value_ctrl_vocab_code
	,data_label_ctrl_vocab_code
	,data_label_components
	,link_type
	,obs_string
	,valuetype_cd
	)
    select 	REGEXP_REPLACE(Case 
				--	Text data_type (default node)
				When a.data_type = 'T'
				then case when a.category_path like '%DATALABEL%' or a.category_path like '%VISITNAME%' or a.category_path like '%OBSERVATION%'
						  then topNode || replace(replace(replace(a.category_path,'DATALABEL',a.data_label),'VISITNAME',a.visit_name),'OBSERVATION',null) || '\' || a.data_value || '\'
						  else topNode || a.category_path || '\'  || a.data_label || '\' || a.data_value || '\' || a.visit_name || '\'
					 end
				--	else is numeric or date data_type and default_node
				else case when a.category_path like '%DATALABEL%' or a.category_path like '%VISITNAME%' or a.category_path like '%OBSERVATION%'
						  then topNode || replace(replace(replace(a.category_path,'DATALABEL',a.data_label),'VISITNAME',a.visit_name),'OBSERVATION',a.obs_string) || '\'
						  else topNode || a.category_path || '\'  || a.data_label || '\' || a.visit_name || '\'               
						end
				end ,'(\\){2,}', '\') as leaf_node
			,a.category_cd
			,a.visit_name
			,a.data_label
			,case when a.data_type = 'T' then a.data_value else null end as data_value
			,a.data_type
			,a.data_value_ctrl_vocab_code
			,a.data_label_ctrl_vocab_code
			,a.data_label_components
			,a.link_type
			,a.obs_string
			,max(a.valuetype_cd)
	from  tm_wz.wrk_clinical_data a
	group by REGEXP_REPLACE(Case 
				--	Text data_type (default node)
				When a.data_type = 'T'
				then case when a.category_path like '%DATALABEL%' or a.category_path like '%VISITNAME%' or a.category_path like '%OBSERVATION%'
						  then topNode || replace(replace(replace(a.category_path,'DATALABEL',a.data_label),'VISITNAME',a.visit_name),'OBSERVATION',null) || '\' || a.data_value || '\'
						  else topNode || a.category_path || '\'  || a.data_label || '\' || a.data_value || '\' || a.visit_name || '\'
					 end
				--	else is numeric or date data_type and default_node
				else case when a.category_path like '%DATALABEL%' or a.category_path like '%VISITNAME%' or a.category_path like '%OBSERVATION%'
						  then topNode || replace(replace(replace(a.category_path,'DATALABEL',a.data_label),'VISITNAME',a.visit_name),'OBSERVATION',a.obs_string) || '\'
						  else topNode || a.category_path || '\'  || a.data_label || '\' || a.visit_name || '\'               
						end
				end ,'(\\){2,}', '\') 
			,a.category_cd
			,a.visit_name
			,a.data_label
			,case when a.data_type = 'T' then a.data_value else null end 
			,a.data_type
			,a.data_value_ctrl_vocab_code
			,a.data_label_ctrl_vocab_code
			,a.data_label_components
			,a.link_type
			,a.obs_string;
	stepCt := stepCt + 1;
	czx_write_audit(jobId,databaseName,procedureName,'Create leaf nodes for trial',SQL%ROWCOUNT,stepCt,'Done');
	commit;
	
	--	set node_name
	
	update wt_trial_nodes
	set node_name=parse_nth_value(leaf_node,length(leaf_node)-length(replace(leaf_node,'\',null)),'\');
	stepCt := stepCt + 1;
	czx_write_audit(jobId,databaseName,procedureName,'Updated node name for leaf nodes',SQL%ROWCOUNT,stepCt,'Done');
	commit;	
	
	--	check if any node is a parent of another, all nodes must be children
	
	select count(*) into pExists
	from tm_wz.wt_trial_nodes p
		,tm_wz.wt_trial_nodes c
	where c.leaf_node like p.leaf_node || '%'
	  and c.leaf_node != p.leaf_node;
	stepCt := stepCt + 1;
	czx_write_audit(jobId,databaseName,procedureName,'Check if node is parent of another node',SQL%ROWCOUNT,stepCt,'Done');

	if pExists > 0 then
		raise parent_node_exists;
	end if;
		
	-- execute immediate('analyze table tm_wz.wt_trial_nodes compute statistics');
	
	--	value vocab
	
	execute immediate('truncate table tm_wz.wt_vocab_nodes');
	
	select distinct leaf_node
		  ,data_value_ctrl_vocab_code
		  ,null as label_components
		  ,null as data_label
	bulk collect into vocab_array
	from wt_trial_nodes
	where replace(replace(data_value_ctrl_vocab_code,';',null),'null',null)	is not null;
	
	if SQL%ROWCOUNT > 0 then
		vCount := 0;
		
		for i in vocab_array.first .. vocab_array.last
		loop
			
			select length(vocab_array(i).vocab_codes) -
				   length(replace(vocab_array(i).vocab_codes,';',null))+1
			into dcount from dual;
			
			while dcount > 0
			loop
				select parse_nth_value(vocab_array(i).vocab_codes,dcount,';') into tmp_vocab from dual;
				
				tmp_vocab := trim(tmp_vocab);
				insert into tm_wz.wt_vocab_nodes
				(leaf_node, modifier_cd, label_node)
				select vocab_array(i).vocab_leaf, tmp_vocab, vocab_array(i).vocab_leaf
				from dual
				where not exists
					 (select 1 from tm_wz.wt_vocab_nodes x
					  where x.leaf_node = vocab_array(i).vocab_leaf
					    and x.modifier_cd = tmp_vocab
						and x.label_node = vocab_array(i).vocab_leaf);
				
				dcount := dcount - 1;
				vCount := vCount + 1;
			end loop;
		end loop;
		commit;
		stepCt := stepCt + 1;
		czx_write_audit(jobId,databaseName,procedureName,'Create modifiers for data_values',vCount,stepCt,'Done');
	end if;	
	
	--	update instance number for value modifiers
	
	merge into tm_wz.wt_vocab_nodes a
    using (select t.leaf_node
                 ,t.modifier_cd
                 ,row_number() over (partition by leaf_node order by modifier_cd) as instance_num
           from tm_wz.wt_vocab_nodes t
           where t.leaf_node = t.label_node) upd
    on (a.leaf_node = upd.leaf_node and a.modifier_cd = upd.modifier_cd)
    when matched then
    update set a.value_instance=upd.instance_num;
	commit;
	stepCt := stepCt + 1;
	czx_write_audit(jobId,databaseName,procedureName,'Update value_instance in wt_vocab_nodes',SQL%ROWCOUNT,stepCt,'Done');
	
/*
	--	modifiers for data_labels
	
	select distinct leaf_node
		  ,data_label_ctrl_vocab_code
		  ,data_label_components
		  ,trim('\' from data_label)
	bulk collect into vocab_array
	from wt_trial_nodes
	where replace(replace(data_label_ctrl_vocab_code,'|',null),'null',null) is not null;
	
	if SQL%ROWCOUNT > 0 then
	
		--execute immediate('truncate table tm_wz.wt_vocab_nodes');
		vCount := 0;
		
		for i in vocab_array.first .. vocab_array.last
		loop
			tmp_leaf := vocab_array(i).vocab_leaf;
			
			if vocab_array(i).label_components is null then
				tmp_label := vocab_array(i).data_label;
				select length(vocab_array(i).vocab_codes) - length(replace(vocab_array(i).vocab_codes,';',null))+1 into dcount from dual;
				while dcount > 0
				loop
					select parse_nth_value(vocab_array(i).vocab_codes,dcount,';') into tmp_vocab from dual;
					tmp_vocab := trim(tmp_vocab);
					tmp_label_node := substr(tmp_leaf,1,instr(tmp_leaf,'\'||tmp_label||'\')+length('\'||tmp_label||'\')-1);
					insert into tm_wz.wt_vocab_nodes
					(leaf_node, label_node, modifier_cd)
					select tmp_leaf
						  ,tmp_label_node
						  ,tmp_vocab
					from dual
					where not exists
						 (select 1 from tm_wz.wt_vocab_nodes x
						  where x.leaf_node = tmp_leaf
						    and x.label_node = tmp_label_node
							and x.modifier_cd = tmp_vocab);
					dcount := dcount - 1;
					vCount := vCount + 1;
				end loop;		
			else
				tmp_vocab_codes := trim('|' from vocab_array(i).vocab_codes);
				tmp_components := trim('|' from vocab_array(i).label_components);
				select length(tmp_vocab_codes)-length(replace(tmp_vocab_codes,'|',null))+1 into dcount from dual;

				while dcount > 0
				loop
					select parse_nth_value(tmp_vocab_codes,dcount,'|') into tmp_vocab from dual;
					select parse_nth_value(tmp_components,dcount,'|') into tmp_label from dual;
					if tmp_components <> '\' then 
						select length(tmp_vocab)-length(replace(tmp_vocab,';',null))+1 into pCount from dual;
						while pCount > 0
						loop
							select parse_nth_value(tmp_vocab,pcount,';') into tmp_label_vocab from dual;
							tmp_label_vocab := trim(tmp_label_vocab);
							tmp_label_node := substr(tmp_leaf,1,instr(tmp_leaf,'\'||tmp_label||'\')+length('\'||tmp_label||'\')-1);
							if coalesce(tmp_label_vocab,'null') <> 'null' then
								insert into tm_wz.wt_vocab_nodes
								(leaf_node, label_node, modifier_cd)
								select tmp_leaf
									  ,tmp_label_node
									  ,tmp_label_vocab
								from dual
								where not exists
									 (select 1 from tm_wz.wt_vocab_nodes x
									  where x.leaf_node = tmp_leaf
										and x.label_node = tmp_label_node
										and x.modifier_cd = tmp_vocab);
								vCount := vCount + 1;
							end if;
							pCount := pCount - 1;			
						end loop;
					end if;
					dCount := dCount - 1;
				end loop;
			end if;
		end loop;
		stepCt := stepCt + 1;
		czx_write_audit(jobId,databaseName,procedureName,'Create modifiers for data_labels',vCount,stepCt,'Done');	
		commit;
	end if;		

	--	update instance number for label modifiers
	
	merge into tm_wz.wt_vocab_nodes a
    using (select x.label_node, x.modifier_cd
          ,row_number() over (partition by x.label_node order by x.modifier_cd) as instance_num
          from (select distinct label_node, modifier_cd
              from tm_wz.wt_vocab_nodes
              where leaf_node != label_node) x) upd
    on (a.label_node = upd.label_node
       and a.modifier_cd = upd.modifier_cd)
    when matched then
    update set a.label_instance=upd.instance_num;
	commit;
	stepCt := stepCt + 1;
	czx_write_audit(jobId,databaseName,procedureName,'Update label_instance in wt_vocab_nodes',SQL%ROWCOUNT,stepCt,'Done');
*/
				
	--	insert subjects into patient_dimension if needed
	
	execute immediate('truncate table tmp_subject_info');

	insert into tmp_subject_info
	(usubjid,
     age_in_years_num,
     sex_cd,
     race_cd
    )
	select a.usubjid,
	      nvl(max(case when upper(a.data_label) = 'AGE'
					   then case when is_number(a.data_value) = 1 then 0 else to_number(a.data_value) end
		               when upper(a.data_label) like '%(AGE)' 
					   then case when is_number(a.data_value) = 1 then 0 else to_number(a.data_value) end
					   else null end),0) as age,
		  --nvl(max(decode(upper(a.data_label),'AGE',data_value,null)),0) as age,
		  nvl(max(case when upper(a.data_label) = 'SEX' then a.data_value
		           when upper(a.data_label) like '%(SEX)' then a.data_value
				   when upper(a.data_label) = 'GENDER' then a.data_value
				   else null end),'Unknown') as sex,
		  --max(decode(upper(a.data_label),'SEX',data_value,'GENDER',data_value,null)) as sex,
		  max(case when upper(a.data_label) = 'RACE' then a.data_value
		           when upper(a.data_label) like '%(RACE)' then a.data_value
				   else null end) as race
		  --max(decode(upper(a.data_label),'RACE',data_value,null)) as race
	from tm_wz.wrk_clinical_data a
	--where upper(a.data_label) in ('AGE','RACE','SEX','GENDER')
	group by a.usubjid;
		  
	stepCt := stepCt + 1;
	czx_write_audit(jobId,databaseName,procedureName,'Insert subject information into temp table',SQL%ROWCOUNT,stepCt,'Done');
	
	commit;
	
	--	Delete dropped subjects from patient_dimension if they do not exist in de_subject_sample_mapping
	
	delete patient_dimension
	where sourcesystem_cd in
		 (select distinct pd.sourcesystem_cd from patient_dimension pd
		  where pd.sourcesystem_cd like TrialId || ':%'
		  minus 
		  select distinct cd.usubjid from tm_wz.wrk_clinical_data cd)
	  and patient_num not in
		  (select distinct sm.patient_id from de_subject_sample_mapping sm);
		  
	stepCt := stepCt + 1;
	czx_write_audit(jobId,databaseName,procedureName,'Delete dropped subjects from patient_dimension',SQL%ROWCOUNT,stepCt,'Done');
	
	commit;	
	
	--	update patients with changed information

    merge into patient_dimension a
    using (select t.usubjid as sourcesystem_cd
                 ,t.sex_cd
                 ,t.race_cd
                 ,t.age_in_years_num
           from tmp_subject_info t
			   ,patient_dimension pd
           where pd.sourcesystem_cd = t.usubjid
			and t.sex_cd != pd.sex_cd
			and t.age_in_years_num != pd.age_in_years_num
			and t.race_cd != pd.race_cd) upd
    on (a.sourcesystem_cd = upd.sourcesystem_cd)
    when matched then
    update set a.sex_cd=upd.sex_cd, a.race_cd=upd.race_cd,a.age_in_years_num=upd.age_in_years_num,update_date=etlDate;		  
	stepCt := stepCt + 1;
	czx_write_audit(jobId,databaseName,procedureName,'Update subjects with changed demographics in patient_dimension',SQL%ROWCOUNT,stepCt,'Done');
	
	commit;	

	--	insert new subjects into patient_dimension
	
	insert into patient_dimension
    (patient_num,
     sex_cd,
     age_in_years_num,
     race_cd,
     update_date,
     download_date,
     import_date,
     sourcesystem_cd
    )
    select seq_patient_num.nextval,
		   t.sex_cd,
		   t.age_in_years_num,
		   t.race_cd,
		   etlDate,
		   etlDate,
		   etlDate,
		   t.usubjid
    from tmp_subject_info t
	where t.usubjid in 
		 (select distinct cd.usubjid from tmp_subject_info cd
		  minus
		  select distinct pd.sourcesystem_cd from patient_dimension pd
		  where pd.sourcesystem_cd like TrialId || ':%');
		  
	stepCt := stepCt + 1;
	czx_write_audit(jobId,databaseName,procedureName,'Insert new subjects into patient_dimension',SQL%ROWCOUNT,stepCt,'Done');
	
	commit;
		
	--	new bulk delete of unused nodes
	
	execute immediate('truncate table tm_wz.wt_del_nodes');
	stepCt := stepCt + 1;	
	czx_write_audit(jobId,databaseName,procedureName,'Truncate table tm_wz.wt_del_nodes',0,stepCt,'Done');
	
	insert into tm_wz.wt_del_nodes
	select l.c_fullname
		  ,l.c_basecode
	from i2b2 l
	where l.c_visualattributes like 'L%'
	  and l.c_fullname like topNode || '%'
	  and l.c_fullname not in
		 (select t.leaf_node 
		  from wt_trial_nodes t
		  union
		  select m.c_fullname
		  from de_subject_sample_mapping sm
			  ,i2b2 m
		  where sm.trial_name = TrialId
		    and sm.concept_code = m.c_basecode
			and m.c_visualattributes like 'L%');
	stepCt := stepCt + 1;	
	czx_write_audit(jobId,databaseName,procedureName,'Insert nodes into tm_wz.wt_del_nodes',SQL%ROWCOUNT,stepCt,'Done');
	commit;
	
	select count(*) into pExists
	from tm_wz.wt_del_nodes;
	
	if pExists > 0 then 
	
		--	delete i2b2 unused nodes
		
		delete from i2b2metadata.i2b2 f
		where f.c_fullname in (select distinct x.c_fullname from tm_wz.wt_del_nodes x);
		stepCt := stepCt + 1;	
		czx_write_audit(jobId,databaseName,procedureName,'Bulk delete nodes from i2b2',SQL%ROWCOUNT,stepCt,'Done');
		commit;
		
		--	delete concept_dimension unused nodes
		
		delete from i2b2demodata.concept_dimension f
		where f.concept_cd in (select distinct x.c_basecode as concept_cd from tm_wz.wt_del_nodes x);
		stepCt := stepCt + 1;	
		czx_write_audit(jobId,databaseName,procedureName,'Bulk delete nodes from concept_dimension',SQL%ROWCOUNT,stepCt,'Done');
		commit;
		
		--	delete observation_fact unused nodes
		
		delete from i2b2demodata.observation_fact f
		where f.concept_cd in (select distinct x.c_basecode as concept_cd from tm_wz.wt_del_nodes x);
		stepCt := stepCt + 1;	
		czx_write_audit(jobId,databaseName,procedureName,'Bulk delete nodes from observation_fact',SQL%ROWCOUNT,stepCt,'Done');
		commit;
		
		--	delete de_concept_visit unused nodes
		
		delete from deapp.de_concept_visit f
		where f.concept_cd in (select distinct x.c_basecode as concept_cd from tm_wz.wt_del_nodes x);
		stepCt := stepCt + 1;	
		czx_write_audit(jobId,databaseName,procedureName,'Bulk delete nodes from de_concept_visit',SQL%ROWCOUNT,stepCt,'Done');
		commit;
		
	end if;

	--	bulk insert leaf nodes

	merge into concept_dimension a
    using (select t.leaf_node as concept_path
                 ,t.node_name
           from wt_trial_nodes t
			   ,concept_dimension c
           where t.leaf_node = c.concept_path
              and t.node_name != c.name_char) upd
    on (a.concept_path = upd.concept_path)
    when matched then
    update set a.name_char=upd.node_name;	  
	stepCt := stepCt + 1;
	czx_write_audit(jobId,databaseName,procedureName,'Update name_char in concept_dimension for changed names',SQL%ROWCOUNT,stepCt,'Done');
	commit;
	
	insert into concept_dimension
    (concept_cd
	,concept_path
	,name_char
	,update_date
	,download_date
	,import_date
	,sourcesystem_cd
	)
    select concept_id.nextval
	     ,x.leaf_node
		 ,x.node_name
		 ,etlDate
		 ,etlDate
		 ,etlDate
		 ,TrialId
	from (select distinct c.leaf_node
				,to_char(c.node_name) as node_name
		  from wt_trial_nodes c
		  where not exists
			(select 1 from concept_dimension x
			where c.leaf_node = x.concept_path)
		 ) x;
	
	stepCt := stepCt + 1;
	czx_write_audit(jobId,databaseName,procedureName,'Inserted new leaf nodes into I2B2DEMODATA concept_dimension',SQL%ROWCOUNT,stepCt,'Done');
    commit;

	--	convert D data_type to T for i2b2
	
	merge into i2b2 a
    using (select distinct t.leaf_node as c_fullname
                 ,t.data_type  --t.data_type
                 ,t.node_name
				 ,t.valuetype_cd
           from wt_trial_nodes t
              ,i2b2 c
           where t.leaf_node = c.c_fullname
              and (t.node_name != c.c_name or
			       c.c_columndatatype != t.data_type or
				  (c.c_metadataxml is not null and t.data_type = 'T'))) upd
    on (a.c_fullname = upd.c_fullname)
    when matched then
    update set a.c_name=upd.node_name
		  ,a.c_visualattributes=case when upd.data_type = 'D' then 'LAD' else 'LA' end
          ,a.c_metadataxml=case when upd.data_type = 'T'
								then null
								when upd.data_type = 'D' 
								then '<?xml version="1.0"?><ValueMetadata><Version>3.02</Version><CreationDateTime>08/14/2008 01:22:59</CreationDateTime><TestID></TestID><TestName></TestName><DataType>PosFloat</DataType><CodeType></CodeType><Loinc></Loinc><Flagstouse></Flagstouse><Oktousevalues>Y</Oktousevalues><MaxStringLength></MaxStringLength><LowofLowValue>0</LowofLowValue><HighofLowValue>0</HighofLowValue><LowofHighValue>100</LowofHighValue>100<HighofHighValue>100</HighofHighValue><LowofToxicValue></LowofToxicValue><HighofToxicValue></HighofToxicValue><EnumValues></EnumValues><CommentsDeterminingExclusion><Com></Com></CommentsDeterminingExclusion><UnitValues><NormalUnits>ratio</NormalUnits><EqualUnits></EqualUnits><ExcludingUnits></ExcludingUnits><ConvertingUnits><Units></Units><MultiplyingFactor></MultiplyingFactor></ConvertingUnits></UnitValues><Analysis><Enums /><Counts /><New /></Analysis></ValueMetadata>'
								else '<?xml version="1.0"?><ValueMetadata><Version>3.02</Version><CreationDateTime>08/14/2008 01:22:59</CreationDateTime><TestID></TestID><TestName></TestName><DataType>PosFloat</DataType><CodeType></CodeType><Loinc></Loinc><Flagstouse>LNH</Flagstouse><Oktousevalues>Y</Oktousevalues><MaxStringLength></MaxStringLength><LowofLowValue>0</LowofLowValue><HighofLowValue>0</HighofLowValue><LowofHighValue>100</LowofHighValue>100<HighofHighValue>100</HighofHighValue><LowofToxicValue></LowofToxicValue><HighofToxicValue></HighofToxicValue><EnumValues></EnumValues><CommentsDeterminingExclusion><Com></Com></CommentsDeterminingExclusion><UnitValues><NormalUnits>ratio</NormalUnits><EqualUnits></EqualUnits><ExcludingUnits></ExcludingUnits><ConvertingUnits><Units></Units><MultiplyingFactor></MultiplyingFactor></ConvertingUnits></UnitValues><Analysis><Enums /><Counts /><New /></Analysis></ValueMetadata>'
						   end;	
	stepCt := stepCt + 1;
	czx_write_audit(jobId,databaseName,procedureName,'Updated name and data type in i2b2 if changed',SQL%ROWCOUNT,stepCt,'Done');
    commit;
			   
	insert into i2b2
    (c_hlevel
	,c_fullname
	,c_name
	,c_visualattributes
	,c_synonym_cd
	,c_facttablecolumn
	,c_tablename
	,c_columnname
	,c_dimcode
	,c_tooltip
	,update_date
	,download_date
	,import_date
	,sourcesystem_cd
	,c_basecode
	,c_operator
	,c_columndatatype
	,c_comment
	,i2b2_id
	,c_metadataxml
	)
    select x.c_hlevel
		  ,x.concept_path
		  ,x.name_char
		  ,case when x.data_type = 'D' then 'LAD' else 'LA' end
		  ,'N'
		  ,'CONCEPT_CD'
		  ,'CONCEPT_DIMENSION'
		  ,'CONCEPT_PATH'
		  ,x.concept_path
		  ,x.concept_path
		  ,etlDate
		  ,etlDate
		  ,etlDate
		  ,TrialId
		  ,x.concept_cd
		  ,'LIKE'
		  ,'T'
		  ,'trial:' || TrialId
		  ,i2b2metadata.i2b2_id_seq.nextval
		  ,x.c_metadataxml
	from (select distinct (length(c.concept_path) - nvl(length(replace(c.concept_path, '\')),0)) / length('\') - 2 + root_level as c_hlevel
		  ,c.concept_path
		  ,c.concept_cd
		  ,c.name_char
		  ,case when t.data_type = 'T' then null
		        when t.data_type = 'D' then '<?xml version="1.0"?><ValueMetadata><Version>3.02</Version><CreationDateTime>08/14/2008 01:22:59</CreationDateTime><TestID></TestID><TestName></TestName><DataType>PosFloat</DataType><CodeType></CodeType><Loinc></Loinc><Flagstouse></Flagstouse><Oktousevalues>Y</Oktousevalues><MaxStringLength></MaxStringLength><LowofLowValue>0</LowofLowValue><HighofLowValue>0</HighofLowValue><LowofHighValue>100</LowofHighValue>100<HighofHighValue>100</HighofHighValue><LowofToxicValue></LowofToxicValue><HighofToxicValue></HighofToxicValue><EnumValues></EnumValues><CommentsDeterminingExclusion><Com></Com></CommentsDeterminingExclusion><UnitValues><NormalUnits>ratio</NormalUnits><EqualUnits></EqualUnits><ExcludingUnits></ExcludingUnits><ConvertingUnits><Units></Units><MultiplyingFactor></MultiplyingFactor></ConvertingUnits></UnitValues><Analysis><Enums /><Counts /><New /></Analysis></ValueMetadata>'
		   else '<?xml version="1.0"?><ValueMetadata><Version>3.02</Version><CreationDateTime>08/14/2008 01:22:59</CreationDateTime><TestID></TestID><TestName></TestName><DataType>PosFloat</DataType><CodeType></CodeType><Loinc></Loinc><Flagstouse>LNH</Flagstouse><Oktousevalues>Y</Oktousevalues><MaxStringLength></MaxStringLength><LowofLowValue>0</LowofLowValue><HighofLowValue>0</HighofLowValue><LowofHighValue>100</LowofHighValue>100<HighofHighValue>100</HighofHighValue><LowofToxicValue></LowofToxicValue><HighofToxicValue></HighofToxicValue><EnumValues></EnumValues><CommentsDeterminingExclusion><Com></Com></CommentsDeterminingExclusion><UnitValues><NormalUnits>ratio</NormalUnits><EqualUnits></EqualUnits><ExcludingUnits></ExcludingUnits><ConvertingUnits><Units></Units><MultiplyingFactor></MultiplyingFactor></ConvertingUnits></UnitValues><Analysis><Enums /><Counts /><New /></Analysis></ValueMetadata>'
		   end as c_metadataxml
		  ,t.data_type
		 from concept_dimension c
			 ,wt_trial_nodes t
		 where c.concept_path = t.leaf_node
		  and not exists
			 (select 1 from i2b2 x
			  where c.concept_path = x.c_fullname)
		) x;
		  
	stepCt := stepCt + 1;
	czx_write_audit(jobId,databaseName,procedureName,'Inserted leaf nodes into I2B2METADATA i2b2',SQL%ROWCOUNT,stepCt,'Done');
    COMMIT;

	--	delete from observation_fact all concept_cds for trial that are clinical data, exclude concept_cds from biomarker data
	
	i2b2_table_index_maint('DROP','OBSERVATION_FACT',jobId);
	-- i2b2_table_index_maint('DROP','VISIT_DIMENSION',jobId);
	
	delete from observation_fact f
	where (f.modifier_cd = TrialId or f.sourcesystem_cd = TrialId)
	  and f.concept_cd not in
		 (select distinct concept_code as concept_cd from de_subject_sample_mapping
		  where trial_name = TrialId
		    and concept_code is not null
		  union
		  select distinct concept_cd as concept_cd from de_subject_snp_dataset
		  where trial_name = TrialId
		    and concept_cd is not null);
		  
	stepCt := stepCt + 1;
	czx_write_audit(jobId,databaseName,procedureName,'Delete clinical data for study from observation_fact',SQL%ROWCOUNT,stepCt,'Done');
    COMMIT;		  

	/*
	--	delete any data from visit_dimension	
			
	delete from visit_dimension
	where sourcesystem_cd = TrialId;
	stepCt := stepCt + 1;
	czx_write_audit(jobId,databaseName,procedureName,'Delete study from  I2B2DEMODATA visit_dimension',SQL%ROWCOUNT,stepCt,'Done');	
	commit;	
*/
	
	--	create encounter_num for each link type/value 

	delete from deapp.de_encounter_type
	where study_id = TrialId;
	stepCt := stepCt + 1;
	czx_write_audit(jobId,databaseName,procedureName,'Delete study from deapp.de_encounter_type',SQL%ROWCOUNT,stepCt,'Done');	
	commit;
	
	
	insert into deapp.de_encounter_type
	select TrialId
		  ,x.link_type
		  ,x.link_value
		  ,i2b2demodata.seq_encounter_num.nextval
	from (select distinct link_type, link_value from tm_wz.wrk_clinical_data) x;
	stepCt := stepCt + 1;
	czx_write_audit(jobId,databaseName,procedureName,'Add study to deapp.de_encounter_type',SQL%ROWCOUNT,stepCt,'Done');	
	commit;
	execute immediate('alter session enable parallel dml');
	execute immediate('alter trigger i2b2demodata.trg_encounter_num disable');

	insert into /*+ append parallel(6) */ observation_fact
	(encounter_num
	,patient_num
    ,concept_cd
    ,modifier_cd
    ,valtype_cd
    ,tval_char
    ,nval_num
    ,sourcesystem_cd
    ,import_date
    ,valueflag_cd
    ,provider_id
    ,location_cd
	,units_cd
	,instance_num
	,start_date
	,end_date
	)
	select distinct enc.encounter_num
		  ,c.patient_num
		  ,i.c_basecode
		  ,coalesce(vv.modifier_cd,'@') as modifier_cd
		  ,a.data_type
		  ,case when a.data_type = 'T' then a.data_value
				else 'E'  --Stands for Equals for numeric types
				end as tval_char
		  ,case when a.data_type != 'T' then a.data_value
				else null --Null for text types
				end as nval_num
		  ,a.study_id
		  ,etlDate
		  ,case when t.valuetype_cd is null then '@' else coalesce(a.valuetype_cd,'N') end as valuetype_cd
		  ,'@'
		  ,'@'
		  ,units_cd
		--  ,1
		 ,coalesce(vv.value_instance,1)
		 --,row_number() over (partition by enc.encounter_num, i.c_basecode order by coalesce(vv.modifier_cd,'@')) as instance_num
		 ,case when a.visit_date is null then null else to_date(a.visit_date,'YYYY-MM-DD HH24:mi') end
		 ,case when a.end_date is null then null else to_date(a.end_date,'YYYY-MM-DD HH24:mi') end
	from tm_wz.wrk_clinical_data a
		 inner join deapp.de_encounter_type enc
			   on  a.link_type = enc.link_type
			   and a.link_value = enc.link_value
			   and enc.study_id = TrialId
		 inner join i2b2demodata.patient_dimension c
             on  a.usubjid = c.sourcesystem_cd
		 inner join tm_wz.wt_trial_nodes t
             on  coalesce(a.category_cd,'@') = coalesce(t.category_cd,'@')
			 and coalesce(a.obs_string,'@') = coalesce(t.obs_string,'@')
             and coalesce(a.data_label,'@') = coalesce(t.data_label,'@')
             and coalesce(a.visit_name,'@') = coalesce(t.visit_name,'@')
             and decode(a.data_type,'T',a.data_value,'@') = coalesce(t.data_value,'@')
		 inner join i2b2metadata.i2b2 i
             on t.leaf_node = i.c_fullname
		 left outer join tm_wz.wt_vocab_nodes vv
			 on t.leaf_node = vv.label_node
	where not exists		-- don't insert if lower level node exists
		 (select 1 from wt_trial_nodes x
		  where x.leaf_node like t.leaf_node || '%_');  
	stepCt := stepCt + 1;
	czx_write_audit(jobId,databaseName,procedureName,'Insert trial into I2B2DEMODATA observation_fact',SQL%ROWCOUNT,stepCt,'Done');	
	commit;
			
	-- fill in folder nodes 
  
	i2b2_fill_in_tree(TrialId, topNode, jobID);
	
/*
	--	insert label modifiers, study-level modifer and modifier for each patient at study-level
	
	select count(*) into pExists
	from tm_wz.wt_vocab_nodes;
	
	if pExists > 0 then
	
	   --Insert modifiers into observation_fact for label nodes
		
		insert into  observation_fact  - add parallel if needed
		(encounter_num,
		 patient_num,
		 concept_cd,
		 modifier_cd,
		 valtype_cd,
		 tval_char,
		 nval_num,
		 sourcesystem_cd,
		 import_date,
		 valueflag_cd,
		 provider_id,
		 location_cd,
		 instance_num
		)
		select distinct obs.encounter_num
			  ,obs.patient_num
			  ,p.c_basecode
			  ,vv.modifier_cd
			  ,'T'
			  ,'E'
			  ,null
			  ,TrialId
			  ,etlDate
			  ,'@'
			  ,'@'
			  ,'@'
			  ,coalesce(vv.label_instance,1) as instance_num
		from tm_wz.wt_vocab_nodes vv
		inner join i2b2metadata.i2b2 c
			  on vv.leaf_node = c.c_fullname
		inner join i2b2metadata.i2b2 p
			  on vv.label_node = p.c_fullname
		inner join i2b2demodata.observation_fact obs
			  on c.c_basecode = obs.concept_cd
		where vv.leaf_node != vv.label_node
		  and not exists
			 (select 1 from i2b2demodata.observation_fact  x
			  where obs.encounter_num = x.encounter_num
			    and obs.concept_cd = x.concept_cd
				and obs.patient_num = x.patient_num
				and vv.modifier_cd = x.modifier_cd); 
 		stepCt := stepCt + 1;
		czx_write_audit(jobId,databaseName,procedureName,'Insert label modifiers into I2B2DEMODATA observation_fact',SQL%ROWCOUNT,stepCt,'Done');	
		commit;
		
	end if;
*/
		
	--	insert study-level modifer and modifier for each patient at study-level
	
	select count(*) into pExists
	from tm_wz.wt_vocab_nodes;
		
	if pExists > 0 then
		
		select count(*) into pExists
		from i2b2demodata.modifier_dimension
		where modifier_path = '\Study\';
			
		--	insert top_level \Study\ modifier if not found
			
		if pExists = 0 then 
			insert into i2b2demodata.modifier_dimension
			(modifier_path
			,modifier_cd
			,name_char
			,modifier_level
			,modifier_node_type
			)
			select '\Study\'
			,'CSTUDY:' || TrialId
			,'Study'
			,0
			,'F'	
			from dual;
			stepCt := stepCt + 1;
			czx_write_audit(jobId,databaseName,procedureName,'Insert \Study\ modifier into modifier_dimension',SQL%ROWCOUNT,stepCt,'Done');	
			commit;			
		end if;

		--	insert study into modifier_dimension
			
		select count(*) into pExists
		from i2b2demodata.modifier_dimension
		where modifier_cd = 'STUDY:' || TrialId;
		
		if pExists = 0 then
			insert into i2b2demodata.modifier_dimension
			(modifier_path
			,modifier_cd
			,name_char
			,modifier_level
			,modifier_node_type
			,sourcesystem_cd
			)
			select '\Study\' || i.c_name || '\'
			,'STUDY:' || TrialId
			,i.c_name
			,1
			,'L'
			,TrialId
			from i2b2 i
			where i.sourcesystem_cd = TrialId
			  and i.c_hlevel = (select min(x.c_hlevel) from i2b2 x
								where x.sourcesystem_cd = TrialId);
			stepCt := stepCt + 1;
			czx_write_audit(jobId,databaseName,procedureName,'Insert modifier for study into modifier_dimension',SQL%ROWCOUNT,stepCt,'Done');	
			commit;	
		end if;
			
		-- insert study into modifier_metadata
			
		select count(*) into pExists
		from i2b2demodata.modifier_metadata
		where modifier_cd = 'STUDY:' || TrialId;
			
		if pExists = 0 then			
			insert into i2b2demodata.modifier_metadata
			(modifier_cd
			,valtype_cd
			,std_units
			,visit_ind)
			select 'STUDY:' || TrialId
			,'T'
			,null
			,'N'
			from dual
			where not exists
				 (select 1 from i2b2demodata.modifier_metadata x
				  where x.modifier_cd = 'STUDY:' || TrialId);
			stepCt := stepCt + 1;
			czx_write_audit(jobId,databaseName,procedureName,'Insert modifier for study into modifier_metadata',SQL%ROWCOUNT,stepCt,'Done');	
			commit;	
		end if;
		
		--	insert observation_fact for each patient at study-level
		
		insert into observation_fact
		(encounter_num,
		 patient_num,
		 concept_cd,
		 modifier_cd,
		 valtype_cd,
		 tval_char,
		 nval_num,
		 sourcesystem_cd,
		 import_date,
		 valueflag_cd,
		 provider_id,
		 location_cd,
		 instance_num
		)
		select c.patient_num*-1,
			   c.patient_num,
			   (select i.c_basecode from i2b2 i
				where i.sourcesystem_cd = TrialId
				  and i.c_hlevel = (select min(x.c_hlevel) from i2b2 x
									where x.sourcesystem_cd = TrialId)) as concept_cd,
			   'STUDY:' || TrialId,
			   'T',
			   'E',
			   null,
			   TrialId, 
			   etlDate, 
			   '@',
			   '@',
			   '@',
				1
		from patient_dimension c
		where c.sourcesystem_cd like TrialId || ':%';
		stepCt := stepCt + 1;
		czx_write_audit(jobId,databaseName,procedureName,'Insert study-level modifiers into observation_fact',SQL%ROWCOUNT,stepCt,'Done');	
		commit;		
	else
		--	no modifiers for study, remove study-level modifier from modifier_dimension and modifier_metadata
		
		delete from i2b2demodata.modifier_dimension
		where modifier_cd = 'STUDY:' || TrialId;
		stepCt := stepCt + 1;
		czx_write_audit(jobId,databaseName,procedureName,'Delete study-level modifiers from modifier_dimension',SQL%ROWCOUNT,stepCt,'Done');	
		commit;	
		
		delete from i2b2demodata.modifier_metadata
		where modifier_cd = 'STUDY:' || TrialId;
		stepCt := stepCt + 1;
		czx_write_audit(jobId,databaseName,procedureName,'Delete study-level modifiers from modifier_metadata',SQL%ROWCOUNT,stepCt,'Done');	
		commit;
		
	end if;
	execute immediate('alter trigger i2b2demodata.trg_encounter_num enable');
	
	i2b2_table_index_maint('ADD','OBSERVATION_FACT',jobId);
	
/*
	--	insert records into visit_dimension where visit_name is not null
	
	select count(*) into pExists
	from tm_wz.wrk_clinical_data
	where visit_reference is not null;
	
	if pExists > 0 then
		
		--	insert first visit
		
		insert into visit_dimension  -- need to add parallel if this goes back in
		(encounter_num
		,patient_num
		,inout_cd
		,import_date
		,sourcesystem_cd
		,start_date
		,end_date
		)
		select distinct enc.encounter_num
			  ,f.patient_num
			  ,case when instr(t.visit_reference,'\') > 0 
					then substr(t.visit_reference,1,instr(t.visit_reference,'\')-1)
					else t.visit_reference
			   end as inout_cd
			  ,etlDate
			  ,TrialId
			  ,case when t.visit_date is null then null else to_date(t.visit_date,'YYYY-MM-DD HH24:mi') end
			  ,case when t.end_date is null then null else to_date(t.end_date,'YYYY-MM-DD HH24:mi') end
		from tm_wz.wrk_clinical_data t
			,deapp.de_encounter_type enc
			,i2b2demodata.observation_fact f
		 where t.visit_reference is not null
		   and t.link_type = enc.link_type
           and t.link_value = enc.link_value
           and t.study_id = enc.study_id
           and enc.encounter_num = f.encounter_num;
		stepCt := stepCt + 1;
		czx_write_audit(jobId,databaseName,procedureName,'Insert visit into I2B2DEMODATA visit_dimension',SQL%ROWCOUNT,stepCt,'Done');	
		commit;
		
		--	insert rest of visit
		
		insert into visit_dimension  -- need to add parallel if this goes back in
		(encounter_num 
		,patient_num
		,inout_cd
		,import_date
		,sourcesystem_cd
		,start_date
		,end_date
		)
		select distinct enc.encounter_num
			  ,f.patient_num
			  ,substr(t.visit_reference,instr(t.visit_reference,'\')+1) as inout_cd
			  ,etlDate
			  ,TrialId
			  ,case when t.visit_date is null then null else to_date(t.visit_date,'YYYY-MM-DD HH24:mi') end
			  ,case when t.end_date is null then null else to_date(t.end_date,'YYYY-MM-DD HH24:mi') end
		from tm_wz.wrk_clinical_data t
			,deapp.de_encounter_type enc
			,i2b2demodata.observation_fact f
		 where t.visit_reference is not null
		   and t.link_type = enc.link_type
           and t.link_value = enc.link_value
           and t.study_id = enc.study_id
           and enc.encounter_num = f.encounter_num
		   and instr(t.visit_reference,'\') > 0;
		stepCt := stepCt + 1;
		czx_write_audit(jobId,databaseName,procedureName,'Insert visit into I2B2DEMODATA visit_dimension',SQL%ROWCOUNT,stepCt,'Done');	
		commit;
	end if;
	
	i2b2_table_index_maint('ADD','VISIT_DIMENSION',jobId);
*/

	--	insert records to de_concept_visit if not exists
	
	insert into deapp.de_concept_visit
	(concept_cd
	,visit_name
	,sourcesystem_cd
	)
	select cd.concept_cd as concept_cd
		  ,t.visit_name
		  ,TrialId as sourcesystem_cd
	from tm_wz.wt_trial_nodes t
		,i2b2demodata.concept_dimension cd
	where t.leaf_node = cd.concept_path
	  and t.valuetype_cd != 'D'
	  and t.visit_name is not null
	  and not exists
		  (select 1 from deapp.de_concept_visit x
		   where cd.concept_cd = x.concept_cd
		     and t.visit_name = x.visit_name
			 and x.sourcesystem_cd = TrialId);
	stepCt := stepCt + 1;
	czx_write_audit(jobId,databaseName,procedureName,'Insert data into de_concept_visit',SQL%ROWCOUNT,stepCt,'Done');	
	commit;
	
	--	populate deapp.de_encounter_level with highest level of same encounter type
	
	delete from deapp.de_encounter_level
	where study_id = TrialId;
	stepCt := stepCt + 1;
	czx_write_audit(jobId,databaseName,procedureName,'Delete study from deapp.de_encounter_level',SQL%ROWCOUNT,stepCt,'Done');	
	commit;
	
	insert into deapp.de_encounter_level 
	(study_id
	,concept_cd
	,link_type
	)
	select TrialId
		  ,x.c_basecode
		  ,case when x.subject_type = 1 and x.enc_type = 0 then 'S'
            when x.subject_type = 0 and x.enc_type = 1 then 'E'
            else 'M' end as enc_type
	from (select p.c_basecode
				,max(case when t.link_type = 'SUBJECT' then 1 else 0 end) as subject_type
				,max(case when t.link_type = 'SUBJECT' then 0 else 1 end) as enc_type
		 from tm_wz.wt_trial_nodes t
			 ,i2b2metadata.i2b2 p
			 ,i2b2metadata.i2b2 c
		 where t.leaf_node = c.c_fullname
		   and c.c_fullname like p.c_fullname || '%'
		   and p.sourcesystem_cd = TrialId
		 group by p.c_basecode) x;
	stepCt := stepCt + 1;
	czx_write_audit(jobId,databaseName,procedureName,'Insert study into deapp.de_encounter_level',SQL%ROWCOUNT,stepCt,'Done');	
	commit;
	
	select count(*) into pExists
	from tm_lz.lt_src_subj_enroll_date
	where study_id = TrialId;
	
	if pExists > 0 then 
	
		--	calculate days_since_enroll
		
		delete from deapp.de_obs_enroll_days
		where study_id = TrialId;
		stepCt := stepCt + 1;
		czx_write_audit(jobId,databaseName,procedureName,'Delete existing data from deapp.de_obs_enroll_days',SQL%ROWCOUNT,stepCt,'Done');
		commit;	
		
		insert into deapp.de_obs_enroll_days
		(encounter_num
		,days_since_enroll
		,study_id
		,visit_date)
		select distinct enc.encounter_num
			  ,round(enc.start_date-to_date(enr.enroll_date,'YYYY-MM-DD HH24:mi:ss'),5) "MIDy"
			  ,TrialId
			  ,enc.start_date
		from i2b2demodata.observation_fact enc
		inner join patient_dimension pd
			  on  enc.patient_num = pd.patient_num
		left outer join tm_lz.lt_src_subj_enroll_date enr
			  on REGEXP_REPLACE(TrialID || ':' || enr.site_id || ':' || enr.subject_id,'(::){1,}', ':') = pd.sourcesystem_cd
		where enc.sourcesystem_cd = TrialId
		  and enc.start_date is not null
		  and enc.encounter_num is not null
		  and enc.concept_cd != 'SECURITY';
		  
		stepCt := stepCt + 1;
		czx_write_audit(jobId,databaseName,procedureName,'Insert data in deapp.de_obs_enroll_days',SQL%ROWCOUNT,stepCt,'Done');
		commit;	
	end if;
	
	--	update c_visualattributes for all nodes in study, done to pick up node that changed from leaf/numeric to folder/text
	
	update i2b2 a
	set c_visualattributes=(
		with upd as (select p.c_fullname, count(*) as nbr_children 
				 from i2b2 p
					 ,i2b2 c
				 where p.c_fullname like topNode || '%'
				   and c.c_fullname like p.c_fullname || '%'
				 group by p.c_fullname)
		select case when u.nbr_children = 1 
					then 'L' || substr(a.c_visualattributes,2,2)
	                else 'F' || substr(a.c_visualattributes,2,1) ||
						 case when u.c_fullname = topNode and highlight_study = 'Y'
							  then 'J' else substr(a.c_visualattributes,3,1) end
			   end
		from upd u
		where a.c_fullname = u.c_fullname)
	where a.c_fullname in
		(select x.c_fullname from i2b2 x
		 where x.c_fullname like topNode || '%');

	stepCt := stepCt + 1;
	czx_write_audit(jobId,databaseName,procedureName,'Update c_visualattributes for study',SQL%ROWCOUNT,stepCt,'Done');

	commit;
	
	--	set sourcesystem_cd, c_comment to null if any added upper-level nodes
		
	update i2b2 b
	set sourcesystem_cd=null,c_comment=null
	where b.sourcesystem_cd = TrialId
	  and length(b.c_fullname) < length(topNode);
	  
	stepCt := stepCt + 1;
	czx_write_audit(jobId,databaseName,procedureName,'Set sourcesystem_cd to null for added upper-level nodes',SQL%ROWCOUNT,stepCt,'Done');
	commit;
	
	i2b2_create_concept_counts(topNode, jobID);
	
		--	new bulk delete of unused nodes
	
	execute immediate('truncate table tm_wz.wt_del_nodes');
	stepCt := stepCt + 1;	
	czx_write_audit(jobId,databaseName,procedureName,'Truncate table tm_wz.wt_del_nodes for hidden nodes',0,stepCt,'Done');
	
	insert into tm_wz.wt_del_nodes
	select l.c_fullname
		  ,l.c_basecode
	from i2b2 l
	where l.c_visualattributes like '%H%'
	  and l.c_fullname like topNode || '%';
	stepCt := stepCt + 1;	
	czx_write_audit(jobId,databaseName,procedureName,'Insert hidden nodes into tm_wz.wt_del_nodes',SQL%ROWCOUNT,stepCt,'Done');
	commit;
	
	select count(*) into pExists
	from tm_wz.wt_del_nodes;
	
	if pExists > 0 then 
	
		--	delete i2b2 unused nodes
		
		delete from i2b2 f
		where f.c_fullname in (select distinct x.c_fullname from tm_wz.wt_del_nodes x);
		stepCt := stepCt + 1;	
		czx_write_audit(jobId,databaseName,procedureName,'Bulk delete hidden nodes from i2b2',SQL%ROWCOUNT,stepCt,'Done');
		commit;
		
		--	delete concept_dimension unused nodes
		
		delete from concept_dimension f
		where f.concept_cd in (select distinct x.c_basecode as concept_cd from tm_wz.wt_del_nodes x);
		stepCt := stepCt + 1;	
		czx_write_audit(jobId,databaseName,procedureName,'Bulk delete hidden nodes from concept_dimension',SQL%ROWCOUNT,stepCt,'Done');
		commit;
		
		--	delete observation_fact unused nodes - not needed because the node was hidden due to no observations
		
		--delete from observation_fact f
		--where f.concept_cd in (select distinct x.c_basecode as concept_cd from tm_wz.wt_del_nodes x);
		--stepCt := stepCt + 1;	
		--czx_write_audit(jobId,databaseName,procedureName,'Bulk delete hidden nodes from observation_fact',SQL%ROWCOUNT,stepCt,'Done');
		--commit;
		
	end if;

/*	
	--	delete each node that is hidden after create concept counts
	
	 FOR r_delNodes in delNodes Loop

    --	deletes hidden nodes for a trial one at a time

		i2b2_delete_1_node(r_delNodes.c_fullname,jobId);
		stepCt := stepCt + 1;
		tText := 'Deleted node: ' || r_delNodes.c_fullname;
		
		czx_write_audit(jobId,databaseName,procedureName,tText,SQL%ROWCOUNT,stepCt,'Done');

	END LOOP;  	
*/

	i2b2_create_security_for_trial(TrialId, secureStudy, jobID);
	i2b2_load_security_data(jobID);
	
	stepCt := stepCt + 1;
	czx_write_audit(jobId,databaseName,procedureName,'End i2b2_load_clinical_data',0,stepCt,'Done');
	
    ---Cleanup OVERALL JOB if this proc is being run standalone
	if newJobFlag = 1
	then
		czx_end_audit (jobID, 'SUCCESS');
	end if;

	rtnCode := 0;
  
	exception
	when duplicate_values then
		stepCt := stepCt + 1;
		czx_write_audit(jobId,databaseName,procedureName,'Duplicate values found in key columns',0,stepCt,'Done');	
		czx_error_handler (jobID, procedureName);
		czx_end_audit (jobID, 'FAIL');
		rtnCode := 16;		
	when invalid_topNode then
		stepCt := stepCt + 1;
		czx_write_audit(jobId,databaseName,procedureName,'Path specified in top_node must contain at least 2 nodes',0,stepCt,'Done');	
		czx_error_handler (jobID, procedureName);
		czx_end_audit (jobID, 'FAIL');
		rtnCode := 16;	
	when multiple_visit_names then
		stepCt := stepCt + 1;
		czx_write_audit(jobId,databaseName,procedureName,'Multiple visit_names exist for category/label/value',0,stepCt,'Done');	
		czx_error_handler (jobID, procedureName);
		czx_end_audit (jobID, 'FAIL');
		rtnCode := 16;
	when invalid_visit_date then
		stepCt := stepCt + 1;
		czx_write_audit(jobId,databaseName,procedureName,'Invalid visit_date in tm_lz.lt_src_clinical_data',pExists,stepCt,'Done');	
		czx_error_handler (jobID, procedureName);
		czx_end_audit (jobID, 'FAIL');
		rtnCode := 16;
	when invalid_end_date then
		stepCt := stepCt + 1;
		czx_write_audit(jobId,databaseName,procedureName,'Invalid end_date in tm_lz.lt_src_clinical_data',pExists,stepCt,'Done');	
		czx_error_handler (jobID, procedureName);
		czx_end_audit (jobID, 'FAIL');
		rtnCode := 16;
	when invalid_enroll_date then
		stepCt := stepCt + 1;
		czx_write_audit(jobId,databaseName,procedureName,'Invalid enroll_date in tm_lz.lt_src_subj_enroll_date',0,stepCt,'Done');	
		czx_error_handler (jobID, procedureName);
		czx_end_audit (jobID, 'FAIL');
		rtnCode := 16;
	when duplicate_visit_dates then
		stepCt := stepCt + 1;
		czx_write_audit(jobId,databaseName,procedureName,'Multiple records with same visit_date',0,stepCt,'Done');	
		czx_error_handler (jobID, procedureName);
		czx_end_audit (jobID, 'FAIL');
		rtnCode := 16;
	when no_study_data then
		stepCt := stepCt + 1;
		czx_write_audit(jobId,databaseName,procedureName,'No records exist in lt_src_clinical_data for study',0,stepCt,'Done');	
		czx_error_handler (jobID, procedureName);
		czx_end_audit (jobID, 'FAIL');
		rtnCode := 16;
	when parent_node_exists then
		stepCt := stepCt + 1;
		czx_write_audit(jobId,databaseName,procedureName,'Leaf node in tm_wz.wt_trial_nodes is a parent of another node',0,stepCt,'Done');	
		czx_error_handler (jobID, procedureName);
		czx_end_audit (jobID, 'FAIL');
		rtnCode := 16;
	when others then
    --Handle errors.
		czx_error_handler (jobID, procedureName);
    --End Proc
		czx_end_audit (jobID, 'FAIL');
		rtnCode := 16;
	
end;