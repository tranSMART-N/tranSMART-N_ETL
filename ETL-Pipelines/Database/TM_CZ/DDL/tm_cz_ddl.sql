-- CREATE SCHEMA TM_CZ;

CREATE SEQUENCE tm_cz.emt_temp_seq INCREMENT BY 1 MINVALUE 1 NO MAXVALUE START WITH 1;

CREATE SEQUENCE tm_cz.rtqalimits_testid_seq INCREMENT BY 1 MINVALUE 1 NO MAXVALUE START WITH 1;

CREATE SEQUENCE tm_cz.rtqastatslist_testid_seq INCREMENT BY 1 MINVALUE 1 NO MAXVALUE START WITH 1;

CREATE SEQUENCE tm_cz.seq_child_rollup_id INCREMENT BY 1 MINVALUE 1 NO MAXVALUE START WITH 1;

CREATE SEQUENCE tm_cz.seq_cz INCREMENT BY 1 MINVALUE 1 MAXVALUE 9999999999 START WITH 1;

CREATE SEQUENCE tm_cz.seq_cz_data INCREMENT BY 1 MINVALUE 1 NO MAXVALUE START WITH 1;

CREATE SEQUENCE tm_cz.seq_cz_data_file INCREMENT BY 1 MINVALUE 1 NO MAXVALUE START WITH 1;

CREATE SEQUENCE tm_cz.seq_cz_dw_version_id INCREMENT BY 1 MINVALUE 1 NO MAXVALUE START WITH 1;

CREATE SEQUENCE tm_cz.seq_cz_job_audit INCREMENT BY 1 MINVALUE 1 NO MAXVALUE START WITH 1;

CREATE SEQUENCE tm_cz.seq_cz_job_id INCREMENT BY 1 MINVALUE 1 NO MAXVALUE START WITH 1;

CREATE SEQUENCE tm_cz.seq_cz_job_master INCREMENT BY 1 MINVALUE 1 NO MAXVALUE START WITH 1;

CREATE SEQUENCE tm_cz.seq_cz_job_message INCREMENT BY 1 MINVALUE 1 NO MAXVALUE START WITH 1;

CREATE SEQUENCE tm_cz.seq_cz_person_id INCREMENT BY 1 MINVALUE 1 NO MAXVALUE START WITH 1;

CREATE SEQUENCE tm_cz.seq_cz_test INCREMENT BY 1 MINVALUE 1 NO MAXVALUE START WITH 1;

CREATE SEQUENCE tm_cz.seq_cz_test_category INCREMENT BY 1 MINVALUE 1 NO MAXVALUE START WITH 1;

CREATE SEQUENCE tm_cz.seq_probeset_id INCREMENT BY 1 MINVALUE 1 MAXVALUE 99999999 START WITH 1;


CREATE TABLE tm_cz.de_mrna_annotation_release (
	gpl_id varchar(100),
	probe_id varchar(100),
	gene_symbol varchar(100),
	gene_id varchar(100),
	probeset_id bigint
);

CREATE TABLE tm_cz.cz_job_audit (
	seq_id bigint NOT NULL,
	job_id bigint NOT NULL,
	database_name varchar(50),
	procedure_name varchar(100),
	step_desc varchar(1000),
	step_status varchar(50),
	records_manipulated bigint,
	step_number bigint,
	job_date timestamp,
	time_elapsed_secs double precision DEFAULT 0
);

ALTER TABLE tm_cz.cz_job_audit ADD CONSTRAINT cz_job_audit_pk PRIMARY KEY (seq_id);

CREATE TABLE tm_cz.de_subject_rbm_data_release (
	trial_name varchar(15),
	antigen_name varchar(100),
	n_value bigint,
	patient_id bigint,
	gene_symbol varchar(100),
	gene_id integer,
	assay_id bigint,
	normalized_value double precision,
	concept_cd varchar(100),
	timepoint varchar(100),
	data_uid varchar(100),
	value bigint,
	log_intensity bigint,
	mean_intensity bigint,
	stddev_intensity bigint,
	median_intensity bigint,
	zscore bigint,
	rbm_panel varchar(50),
	release_study varchar(15)
);

CREATE TABLE tm_cz.sample_categories_release (
	trial_cd varchar(200),
	site_cd varchar(200),
	subject_cd varchar(200),
	sample_cd varchar(200),
	category_cd varchar(200),
	category_value varchar(200),
	release_study varchar(50)
);

CREATE TABLE tm_cz.de_snp_gene_map_release (
	snp_id bigint,
	snp_name varchar(255),
	entrez_gene_id bigint
);

CREATE TABLE tm_cz.category_path_excluded_words (
	excluded_text varchar(100)
);

CREATE TABLE tm_cz.cz_test (
	test_id bigint NOT NULL,
	test_name varchar(200),
	test_desc varchar(1000),
	test_schema varchar(255),
	test_table varchar(255),
	test_column varchar(255),
	test_type varchar(255),
	test_sql varchar(2000),
	test_param1 varchar(2000),
	test_param2 varchar(2000),
	test_param3 varchar(2000),
	test_min_value double precision,
	test_max_value double precision,
	test_category_id bigint,
	test_severity_cd varchar(20),
	table_type varchar(100)
);

ALTER TABLE tm_cz.cz_test ADD CONSTRAINT cz_test_pk PRIMARY KEY (test_id);

CREATE TABLE tm_cz.de_snp_data_ds_loc_release (
	snp_data_dataset_loc_id bigint,
	trial_name varchar(255),
	snp_dataset_id bigint,
	location bigint,
	release_study varchar(200)
);

CREATE TABLE tm_cz.tmp_trial_nodes (
	leaf_node varchar(4000),
	category_cd varchar(200),
	visit_name varchar(100),
	sample_type varchar(100),
	period varchar(100),
	data_label varchar(500),
	node_name varchar(500),
	data_value varchar(500)
);

CREATE TABLE tm_cz.tmp_trial_data (
	usubjid varchar(50),
	study_id varchar(25),
	data_type char(1),
	visit_name varchar(100),
	data_label varchar(500),
	data_value varchar(500),
	unit_cd varchar(50),
	category_path varchar(250),
	sub_category_path_1 varchar(250),
	sub_category_path_2 varchar(250),
	patient_num bigint,
	sourcesystem_cd varchar(50),
	base_path varchar(1250)
);

CREATE TABLE tm_cz.cz_test_category (
	test_category_id bigint NOT NULL,
	test_category varchar(255),
	test_sub_category1 varchar(255),
	test_sub_category2 varchar(255)
);

ALTER TABLE tm_cz.cz_test_category ADD CONSTRAINT cz_test_category_pk PRIMARY KEY (test_category_id);

CREATE TABLE tm_cz.observation_fact_release (
	encounter_num bigint,
	patient_num bigint,
	concept_cd varchar(50) NOT NULL,
	provider_id varchar(50) NOT NULL,
	start_date timestamp,
	modifier_cd varchar(100),
	valtype_cd varchar(50),
	tval_char varchar(255),
	nval_num double precision,
	valueflag_cd varchar(50),
	quantity_num double precision,
	units_cd varchar(50),
	end_date timestamp,
	location_cd varchar(50) NOT NULL,
	confidence_num bigint,
	update_date timestamp,
	download_date timestamp,
	import_date timestamp,
	sourcesystem_cd varchar(50),
	upload_id bigint,
	observation_blob varchar(60000),
	release_study varchar(100)
);

CREATE TABLE tm_cz.cz_xtrial_exclusion (
	trial_id varchar(200)
);

CREATE TABLE tm_cz.tmp_num_data_types (
	category_cd varchar(200),
	data_label varchar(500),
	period varchar(100),
	sample_type varchar(100),
	visit_name varchar(100)
);

CREATE TABLE tm_cz.haploview_data_release (
	i2b2_id bigint,
	jnj_id varchar(30),
	father_id integer,
	mother_id integer,
	sex smallint,
	affection_status smallint,
	chromosome varchar(10),
	gene varchar(50),
	release smallint,
	release_date timestamp,
	trial_name varchar(50),
	snp_data varchar(60000),
	release_study varchar(30)
);

CREATE TABLE tm_cz.de_subj_sample_map_release (
	patient_id bigint,
	site_id varchar(100),
	subject_id varchar(100),
	subject_type varchar(100),
	concept_code varchar(1000),
	assay_id bigint,
	patient_uid varchar(50),
	sample_type varchar(100),
	assay_uid varchar(100),
	trial_name varchar(30),
	timepoint varchar(100),
	timepoint_cd varchar(50),
	sample_type_cd varchar(50),
	tissue_type_cd varchar(50),
	platform varchar(50),
	platform_cd varchar(50),
	tissue_type varchar(100),
	data_uid varchar(100),
	gpl_id varchar(20),
	rbm_panel varchar(50),
	sample_id bigint,
	sample_cd varchar(200),
	category_cd varchar(1000),
	release_study varchar(30)
);

CREATE TABLE tm_cz.cz_xtrial_ctrl_vocab (
	ctrl_vocab_code varchar(200) NOT NULL,
	ctrl_vocab_name varchar(200) NOT NULL,
	ctrl_vocab_category varchar(200),
	ctrl_vocab_id bigint NOT NULL
);

CREATE TABLE tm_cz.cz_data_profile_column_exclusi (
	table_name varchar(500) NOT NULL,
	column_name varchar(500) NOT NULL,
	exclusion_reason varchar(2000),
	etl_date timestamp DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE tm_cz.cz_job_message (
	job_id bigint NOT NULL,
	message_id bigint,
	message_line bigint,
	message_procedure varchar(100),
	info_message varchar(2000),
	seq_id bigint NOT NULL
);

CREATE TABLE tm_cz.de_subj_protein_data_release (
	trial_name varchar(15),
	component varchar(15),
	intensity bigint,
	patient_id bigint,
	subject_id varchar(10),
	gene_symbol varchar(100),
	gene_id integer,
	assay_id bigint,
	timepoint varchar(20),
	n_value bigint,
	mean_intensity bigint,
	stddev_intensity bigint,
	median_intensity bigint,
	zscore bigint,
	release_study varchar(15)
);

CREATE TABLE tm_cz.de_subject_mrna_data_release (
	trial_name varchar(50),
	probeset_id bigint,
	assay_id bigint,
	patient_id bigint,
	timepoint varchar(100),
	pvalue double precision,
	refseq varchar(50),
	subject_id varchar(50),
	raw_intensity bigint,
	mean_intensity double precision,
	stddev_intensity double precision,
	median_intensity double precision,
	log_intensity double precision,
	zscore double precision,
	sample_id bigint,
	release_study varchar(50)
);


CREATE TABLE tm_cz.node_curation (
	node_type varchar(25),
	node_name varchar(250),
	display_name varchar(250),
	display_in_ui char(1),
	data_type char(1),
	global_flag char(1),
	study_id varchar(30),
	curator_name varchar(250),
	curation_date timestamp,
	active_flag char(1)
);

CREATE TABLE tm_cz.de_snp_info_release (
	snp_info_id bigint,
	name varchar(255),
	chrom varchar(16),
	chrom_pos bigint
);

CREATE TABLE tm_cz.i2b2_release (
	c_hlevel bigint,
	c_fullname varchar(900) NOT NULL,
	c_name varchar(2000),
	c_synonym_cd char(1),
	c_visualattributes char(3),
	c_totalnum bigint,
	c_basecode varchar(450),
	c_metadataxml varchar(28000),
	c_facttablecolumn varchar(50),
	c_tablename varchar(50),
	c_columnname varchar(50),
	c_columndatatype varchar(50),
	c_operator varchar(10),
	c_dimcode varchar(900),
	c_comment varchar(28000),
	c_tooltip varchar(900),
	update_date timestamp,
	download_date timestamp,
	import_date timestamp,
	sourcesystem_cd varchar(50),
	valuetype_cd varchar(50),
	i2b2_id bigint,
	release_study varchar(50)
);

CREATE TABLE tm_cz.de_snp_data_by_probe_release (
	snp_data_by_probe_id bigint,
	probe_id bigint,
	probe_name varchar(255),
	snp_id bigint,
	snp_name varchar(255),
	trial_name varchar(255),
	data_by_probe varchar(60000),
	release_study varchar(200)
);

CREATE TABLE tm_cz.tmp_subject_info (
	usubjid varchar(100),
	age_in_years_num smallint,
	sex_cd varchar(50),
	race_cd varchar(50)
);

CREATE TABLE tm_cz.cz_data_profile_stats (
	table_name varchar(500) NOT NULL,
	column_name varchar(500) NOT NULL,
	data_type varchar(500),
	column_length integer,
	column_precision integer,
	column_scale integer NOT NULL,
	total_count bigint,
	percentage_null real,
	null_count bigint,
	non_null_count bigint,
	distinct_count bigint,
	max_length integer,
	min_length integer,
	first_value varchar(4000),
	last_value varchar(4000),
	max_length_value varchar(4000),
	min_length_value varchar(4000),
	etl_date timestamp DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE tm_cz.de_snp_probe_sort_def_release (
	snp_probe_sorted_def_id bigint,
	platform_name varchar(255),
	num_probe bigint,
	chrom varchar(16),
	probe_def varchar(30000),
	snp_id_def varchar(30000)
);

CREATE TABLE tm_cz.i2b2_tags_release (
	tag_id bigint NOT NULL,
	path varchar(200),
	tag varchar(200),
	tag_type varchar(200),
	release_study varchar(200)
);

CREATE TABLE tm_cz.concept_dimension_release (
	concept_cd varchar(50) NOT NULL,
	concept_path varchar(700) NOT NULL,
	name_char varchar(2000),
	concept_blob varchar(60000),
	update_date timestamp,
	download_date timestamp,
	import_date timestamp,
	sourcesystem_cd varchar(50),
	upload_id bigint,
	table_name varchar(255),
	release_study varchar(50)
);

CREATE TABLE tm_cz.cz_data_profile_column_sample (
	table_name varchar(500),
	column_name varchar(500),
	value varchar(4000),
	count bigint,
	etl_date timestamp DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE tm_cz.bio_clinical_trial_release (
	trial_number varchar(510),
	study_owner varchar(510),
	study_phase varchar(100),
	blinding_procedure varchar(1000),
	studytype varchar(510),
	duration_of_study_weeks integer,
	number_of_patients integer,
	number_of_sites integer,
	route_of_administration varchar(510),
	dosing_regimen varchar(3500),
	group_assignment varchar(510),
	type_of_control varchar(510),
	completion_date timestamp,
	primary_end_points varchar(2000),
	secondary_end_points varchar(3500),
	inclusion_criteria varchar(20000),
	exclusion_criteria varchar(20000),
	subjects varchar(2000),
	gender_restriction_mfb varchar(510),
	min_age integer,
	max_age integer,
	secondary_ids varchar(510),
	bio_experiment_id bigint,
	development_partner varchar(100),
	geo_platform varchar(30),
	main_findings varchar(2000),
	platform_name varchar(200),
	search_area varchar(100),
	release_study varchar(510)
);

CREATE TABLE tm_cz.probeset_deapp (
	probeset_id bigint NOT NULL,
	probeset varchar(100) NOT NULL,
	platform varchar(100) NOT NULL,
	organism varchar(200)
);

CREATE TABLE tm_cz.bio_data_compound_release (
	bio_data_id bigint NOT NULL,
	bio_compound_id bigint NOT NULL,
	etl_source varchar(100),
	release_study varchar(100)
);

CREATE TABLE tm_cz.cz_job_error (
	job_id bigint NOT NULL,
	error_number varchar(30),
	error_message varchar(1000),
	error_stack varchar(2000),
	seq_id bigint NOT NULL,
	error_backtrace varchar(2000)
);

CREATE TABLE tm_cz.cz_test_result (
	test_id bigint NOT NULL,
	test_result_id bigint NOT NULL,
	test_result_text varchar(2000),
	test_result_nbr bigint,
	test_run_id bigint,
	external_location varchar(2000),
	run_date timestamp,
	study_id varchar(2000)
);

CREATE TABLE tm_cz.bio_data_uid_release (
	bio_data_id bigint NOT NULL,
	unique_id varchar(200) NOT NULL,
	bio_data_type varchar(100) NOT NULL,
	release_study varchar(200) NOT NULL
);

CREATE TABLE tm_cz.de_snp_data_by_patient_release (
	snp_data_by_patient_id bigint,
	snp_dataset_id bigint,
	trial_name varchar(255),
	patient_num bigint,
	chrom varchar(16),
	data_by_patient_chr varchar(30000),
	ped_by_patient_chr varchar(30000),
	release_study varchar(255)
);

CREATE TABLE tm_cz.de_snp_probe_release (
	snp_probe_id bigint,
	probe_name varchar(255),
	snp_id bigint,
	snp_name varchar(255),
	vendor_name varchar(255)
);

CREATE TABLE tm_cz.de_gpl_info_release (
	platform varchar(10),
	title varchar(500),
	organism varchar(100),
	annotation_date timestamp
);

CREATE TABLE tm_cz.patient_dimension_release (
	patient_num bigint,
	vital_status_cd varchar(50),
	birth_date timestamp,
	death_date timestamp,
	sex_cd varchar(50),
	age_in_years_num bigint,
	language_cd varchar(50),
	race_cd varchar(50),
	marital_status_cd varchar(50),
	religion_cd varchar(50),
	zip_cd varchar(50),
	statecityzip_path varchar(700),
	update_date timestamp,
	download_date timestamp,
	import_date timestamp,
	sourcesystem_cd varchar(50),
	upload_id bigint,
	patient_blob varchar(60000),
	release_study varchar(50)
);

CREATE TABLE tm_cz.cz_job_master ( 
	job_id bigint NOT NULL,
	start_date timestamp,
	end_date timestamp,
	active varchar(1),
	time_elapsed_secs double precision DEFAULT 0,
	build_id bigint,
	session_id bigint,
	database_name varchar(50),
	job_status varchar(50),
	job_name varchar(500)
);

ALTER TABLE tm_cz.cz_job_master ADD CONSTRAINT cz_job_master_pk PRIMARY KEY (job_id);

CREATE TABLE tm_cz.bio_experiment_release (
	bio_experiment_id bigint,
	bio_experiment_type varchar(200),
	title varchar(1000),
	description varchar(2000),
	design varchar(2000),
	start_date timestamp,
	completion_date timestamp,
	primary_investigator varchar(400),
	contact_field varchar(400),
	etl_id varchar(100),
	status varchar(100),
	overall_design varchar(2000),
	accession varchar(100),
	entrydt timestamp,
	updated timestamp,
	institution varchar(100),
	country varchar(50),
	biomarker_type varchar(255),
	target varchar(255),
	access_type varchar(100),
	release_study varchar(100)
);

CREATE TABLE tm_cz.annotation_deapp (
	gpl_id varchar(100),
	probe_id varchar(100),
	gene_symbol varchar(100),
	gene_id varchar(100),
	probeset_id bigint,
	organism varchar(200)
);

CREATE TABLE tm_cz.search_secure_object_release (
	search_secure_object_id bigint,
	bio_data_id bigint,
	display_name varchar(100),
	data_type varchar(200),
	bio_data_unique_id varchar(200),
	release_study varchar(100)
);

CREATE TABLE tm_cz.cz_person (
	person_id bigint NOT NULL,
	f_name varchar(200),
	l_name varchar(200),
	m_name varchar(200),
	user_name varchar(20),
	role_code varchar(20),
	email_address varchar(100),
	mail_address varchar(200),
	cell_phone varchar(20),
	work_phone varchar(20)
);

ALTER TABLE tm_cz.cz_person ADD CONSTRAINT cz_person_pk PRIMARY KEY (person_id);
ALTER TABLE tm_cz.cz_test ADD CONSTRAINT cz_test_cz_test_category_fk1 FOREIGN KEY (test_category_id) REFERENCES tm_cz.cz_test_category (test_category_id);
