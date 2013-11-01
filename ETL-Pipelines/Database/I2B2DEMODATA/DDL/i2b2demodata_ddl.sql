-- CREATE SCHEMA i2b2demodata;

CREATE TABLE i2b2demodata.archive_observation_fact (
    encounter_num numeric(38,0),
    patient_num numeric(38,0),
    concept_cd varchar(50),
    provider_id varchar(50),
    start_date timestamp,
    modifier_cd varchar(100),
    instance_num numeric(18,0),
    valtype_cd varchar(50),
    tval_char varchar(255),
    nval_num numeric(18,5),
    valueflag_cd varchar(50),
    quantity_num numeric(18,5),
    units_cd varchar(50),
    end_date timestamp,
    location_cd varchar(50),
    observation_blob varchar(4000),
    confidence_num numeric(18,5),
    update_date timestamp,
    download_date timestamp,
    import_date timestamp,
    sourcesystem_cd varchar(50),
    upload_id numeric(38,0),
    archive_upload_id numeric(22,0)
);

CREATE TABLE i2b2demodata.async_job (
    id integer,
    job_name varchar(200),
    job_status varchar(200),
    run_time varchar(200),
    last_run_on timestamp,
    viewer_url varchar(4000),
    alt_viewer_url varchar(600),
    job_results varchar(4000),
    job_type varchar(20)
);

CREATE TABLE i2b2demodata.code_lookup (
    table_cd varchar(100) NOT NULL,
    column_cd varchar(100) NOT NULL,
    code_cd varchar(50) NOT NULL,
    name_char varchar(650),
    lookup_blob varchar(4000),
    upload_date timestamp,
    update_date timestamp,
    download_date timestamp,
    import_date timestamp,
    sourcesystem_cd varchar(50),
    upload_id numeric(38,0)
);

CREATE TABLE i2b2demodata.concept_counts (
    concept_path varchar(500),
    parent_concept_path varchar(500),
    patient_count numeric(18,0)
);

CREATE TABLE i2b2demodata.concept_dimension (
    concept_path varchar(700) NOT NULL,
    concept_cd varchar(50) NOT NULL,
    name_char varchar(2000),
    concept_blob varchar(4000),
    update_date timestamp,
    download_date timestamp,
    import_date timestamp,
    sourcesystem_cd varchar(50),
    upload_id numeric(38,0)
);

CREATE SEQUENCE i2b2demodata.concept_id as bigint START WITH 1 INCREMENT BY 1 NO MINVALUE NO MAXVALUE;

CREATE TABLE i2b2demodata.datamart_report (
    total_patient numeric(38,0),
    total_observationfact numeric(38,0),
    total_event numeric(38,0),
    report_date timestamp
);

CREATE TABLE i2b2demodata.encounter_mapping (
    encounter_ide varchar(200) NOT NULL,
    encounter_ide_source varchar(50) NOT NULL,
    encounter_num numeric(38,0) NOT NULL,
    patient_ide varchar(200),
    patient_ide_source varchar(50),
    encounter_ide_status varchar(50),
    upload_date timestamp,
    update_date timestamp,
    download_date timestamp,
    import_date timestamp,
    sourcesystem_cd varchar(50),
    upload_id numeric(38,0)
);

CREATE TABLE i2b2demodata.modifier_dimension (
    modifier_path varchar(700) NOT NULL,
    modifier_cd varchar(50),
    name_char varchar(2000),
    modifier_blob varchar(4000),
    update_date timestamp,
    download_date timestamp,
    import_date timestamp,
    sourcesystem_cd varchar(50),
    upload_id numeric(38,0),
	modifier_level numeric(18,0),
	modifier_node_type varchar(10)
);
   
CREATE TABLE i2b2demodata.news_updates (
    newsid integer,
    ranbyuser varchar(200),
    rowsaffected integer,
    operation varchar(200),
    datasetname varchar(200),
    updatedate timestamp,
    commentfield varchar(200)
);

CREATE TABLE i2b2demodata.observation_fact (
    encounter_num numeric(38,0),
    patient_num numeric(38,0) NOT NULL,
    concept_cd varchar(50) NOT NULL,
    provider_id varchar(50) NOT NULL,
    start_date timestamp,
    modifier_cd varchar(100) NOT NULL,
    instance_num numeric(18,0) NOT NULL,
    valtype_cd varchar(50),
    tval_char varchar(255),
    nval_num numeric(18,5),
    valueflag_cd varchar(50),
    quantity_num numeric(18,5),
    units_cd varchar(50),
    end_date timestamp,
    location_cd varchar(50),
    observation_blob varchar(4000),
    confidence_num numeric(18,5),
    update_date timestamp,
    download_date timestamp,
    import_date timestamp,
    sourcesystem_cd varchar(50),
    upload_id numeric(38,0)
);

CREATE TABLE i2b2demodata.patient_dimension (
    patient_num numeric(38,0) NOT NULL,
    vital_status_cd varchar(50),
    birth_date timestamp,
    death_date timestamp,
    sex_cd varchar(50),
    age_in_years_num numeric(38,0),
    language_cd varchar(50),
    race_cd varchar(50),
    marital_status_cd varchar(50),
    religion_cd varchar(50),
    zip_cd varchar(10),
    statecityzip_path varchar(700),
    income_cd varchar(50),
    patient_blob varchar(4000),
    update_date timestamp,
    download_date timestamp,
    import_date timestamp,
    sourcesystem_cd varchar(50),
    upload_id numeric(38,0)
);

CREATE TABLE i2b2demodata.patient_mapping ( 
    patient_ide varchar(200) NOT NULL,
    patient_ide_source varchar(50) NOT NULL,
    patient_num numeric(38,0) NOT NULL,
    patient_ide_status varchar(50),
    upload_date timestamp,
    update_date timestamp,
    download_date timestamp,
    import_date timestamp,
    sourcesystem_cd varchar(50),
    upload_id numeric(38,0)
);

CREATE TABLE i2b2demodata.patient_trial (
    patient_num numeric,
    trial varchar(30),
    secure_obj_token varchar(50)
);

CREATE TABLE i2b2demodata.provider_dimension ( 
    provider_id varchar(50) NOT NULL,
    provider_path varchar(700) NOT NULL,
    name_char varchar(850),
    provider_blob varchar(4000),
    update_date timestamp,
    download_date timestamp,
    import_date timestamp,
    sourcesystem_cd varchar(50),
    upload_id numeric(38,0)
);

CREATE TABLE i2b2demodata.qt_analysis_plugin (
    plugin_id numeric(10,0) NOT NULL,
    plugin_name varchar(2000),
    description varchar(2000),
    version_cd varchar(50),
    parameter_info varchar(4000),
    parameter_info_xsd varchar(2000),
    command_line varchar(2000),
    working_folder varchar(2000),
    commandoption_cd varchar(2000),
    plugin_icon varchar(2000),
    status_cd varchar(50),
    user_id varchar(50),
    group_id varchar(50),
    create_date timestamp,
    update_date timestamp
);

CREATE TABLE i2b2demodata.qt_analysis_plugin_result_type (
    plugin_id numeric(10,0) NOT NULL,
    result_type_id numeric(10,0) NOT NULL
);

CREATE TABLE i2b2demodata.qt_breakdown_path (
    name varchar(100),
    value varchar(2000),
    create_date timestamp,
    update_date timestamp,
    user_id varchar(50)
);

CREATE SEQUENCE i2b2demodata.qt_sq_qper_pecid
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE ;

CREATE TABLE i2b2demodata.qt_patient_enc_collection (
    patient_enc_coll_id numeric(10,0) NOT NULL,
    result_instance_id numeric(5,0),
    set_index numeric(10,0),
    patient_num numeric(10,0),
    encounter_num numeric(10,0)
);

CREATE SEQUENCE  i2b2demodata.qt_sq_qpr_pcid
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE;

CREATE TABLE i2b2demodata.qt_patient_set_collection (
    patient_set_coll_id numeric(10,0) NOT NULL,
    result_instance_id numeric(5,0),
    set_index numeric(10,0),
    patient_num numeric(10,0)
);

CREATE SEQUENCE  i2b2demodata.qt_sq_pqm_qmid
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE;

CREATE TABLE i2b2demodata.qt_pdo_query_master (
    query_master_id numeric(5,0) NOT NULL,
    user_id varchar(50) NOT NULL,
    group_id varchar(50) NOT NULL,
    create_date timestamp NOT NULL,
    request_xml varchar(4000),
    i2b2_request_xml varchar(4000)
);

CREATE TABLE i2b2demodata.qt_privilege (
    protection_label_cd varchar(1500),
    dataprot_cd varchar(1000),
    hivemgmt_cd varchar(1000),
    plugin_id numeric(10,0)
);

CREATE SEQUENCE  i2b2demodata.qt_sq_qi_qiid as bigint START WITH 1 INCREMENT BY 1 NO MINVALUE NO MAXVALUE;

CREATE TABLE i2b2demodata.qt_query_instance (
    query_instance_id numeric(5,0) NOT NULL,
    query_master_id numeric(5,0),
    user_id varchar(50) NOT NULL,
    group_id varchar(50) NOT NULL,
    batch_mode varchar(50),
    start_date timestamp NOT NULL,
    end_date timestamp,
    delete_flag varchar(3),
    status_type_id numeric(5,0),
    message varchar(4000)
);

CREATE SEQUENCE  i2b2demodata.qt_sq_qm_qmid as bigint START WITH 1 INCREMENT BY 1 NO MINVALUE NO MAXVALUE;

CREATE TABLE i2b2demodata.qt_query_master (
    query_master_id numeric(5,0) NOT NULL,
    name varchar(250) NOT NULL,
    user_id varchar(50) NOT NULL,
    group_id varchar(50) NOT NULL,
    master_type_cd varchar(2000),
    plugin_id numeric(10,0),
    create_date timestamp NOT NULL,
    delete_date timestamp,
    delete_flag varchar(3),
    generated_sql varchar(4000),
    request_xml varchar(4000),
    i2b2_request_xml varchar(4000)
);

CREATE SEQUENCE i2b2demodata.qt_sq_qri_qriid as bigint START WITH 1 INCREMENT BY 1 NO MINVALUE NO MAXVALUE;

CREATE TABLE i2b2demodata.qt_query_result_instance (
    result_instance_id numeric(5,0) NOT NULL,
    query_instance_id numeric(5,0),
    result_type_id numeric(3,0) NOT NULL,
    set_size numeric(10,0),
    start_date timestamp NOT NULL,
    end_date timestamp,
    delete_flag varchar(3),
    status_type_id numeric(3,0) NOT NULL,
    message varchar(4000),
    description varchar(200),
    real_set_size numeric(10,0),
    obfusc_method varchar(500)
);

CREATE SEQUENCE  i2b2demodata.qt_sq_qr_qrid as bigint START WITH 1 INCREMENT BY 1 NO MINVALUE NO MAXVALUE;

CREATE TABLE i2b2demodata.qt_query_result_type (
    result_type_id numeric(3,0) NOT NULL,
    name varchar(100),
    description varchar(200),
    display_type_id varchar(500),
    visual_attribute_type_id varchar(3)
);

CREATE SEQUENCE i2b2demodata.qt_sq_qs_qsid as bigint START WITH 1 INCREMENT BY 1 NO MINVALUE NO MAXVALUE;

CREATE TABLE i2b2demodata.qt_query_status_type (
    status_type_id numeric(3,0) NOT NULL,
    name varchar(100),
    description varchar(200)
);

CREATE SEQUENCE i2b2demodata.qt_sq_qxr_xrid as bigint START WITH 1 INCREMENT BY 1 NO MINVALUE NO MAXVALUE;

CREATE TABLE i2b2demodata.qt_xml_result (
    xml_result_id numeric(5,0) NOT NULL,
    result_instance_id numeric(5,0),
    xml_value varchar(4000)
);

CREATE TABLE i2b2demodata.sample_categories (  
    trial_name varchar(100),
    tissue_type varchar(2000),
    data_types varchar(2000),
    disease varchar(2000),
    tissue_state varchar(2000),
    sample_id varchar(250),
    biobank varchar(3),
    source_organism varchar(255),
    treatment varchar(255),
    sample_treatment varchar(2000),
    subject_treatment varchar(2000),
    timepoint varchar(250)
);

CREATE SEQUENCE i2b2demodata.seq_patient_num as bigint START WITH 1 INCREMENT BY 1 NO MINVALUE NO MAXVALUE;

CREATE SEQUENCE i2b2demodata.sq_up_patdim_patientnum  as bigint START WITH 1 INCREMENT BY 1 NO MINVALUE NO MAXVALUE;

CREATE TABLE i2b2demodata.set_type ( 
    id integer NOT NULL,
    name varchar(500),
    create_date timestamp
);

CREATE TABLE i2b2demodata.set_upload_status (  
    upload_id numeric NOT NULL,
    set_type_id integer NOT NULL,
    source_cd varchar(50) NOT NULL,
    no_of_record numeric,
    loaded_record numeric,
    deleted_record numeric,
    load_date timestamp NOT NULL,
    end_date timestamp,
    load_status varchar(100),
    message varchar(4000),
    input_file_name varchar(500),
    log_file_name varchar(500),
    transform_name varchar(500)
);

CREATE TABLE i2b2demodata.source_master (  
    source_cd varchar(50) NOT NULL,
    description varchar(300),
    create_date timestamp
);

CREATE SEQUENCE i2b2demodata.seq_encounter_num as bigint START WITH 1 INCREMENT BY 1 NO MINVALUE NO MAXVALUE;

CREATE SEQUENCE  i2b2demodata.sq_up_encdim_encounternum as bigint START WITH 1 INCREMENT BY 1 NO MINVALUE NO MAXVALUE;

CREATE SEQUENCE i2b2demodata.sq_uploadstatus_uploadid  as bigint START WITH 1 INCREMENT BY 1 NO MINVALUE NO MAXVALUE;

CREATE TABLE i2b2demodata.upload_status ( 
    upload_id numeric(38,0) NOT NULL,
    upload_label varchar(500) NOT NULL,
    user_id varchar(100) NOT NULL,
    source_cd varchar(50) NOT NULL,
    no_of_record numeric,
    loaded_record numeric,
    deleted_record numeric,
    load_date timestamp NOT NULL,
    end_date timestamp,
    load_status varchar(100),
    message varchar(4000),
    input_file_name varchar(500),
    log_file_name varchar(500),
    transform_name varchar(500)
);

CREATE TABLE i2b2demodata.visit_dimension (
    encounter_num numeric(38,0) NOT NULL,
    patient_num numeric(38,0) NOT NULL,
    active_status_cd varchar(50),
    start_date timestamp,
    end_date timestamp,
    inout_cd varchar(50),
    location_cd varchar(50),
    location_path varchar(900),
    length_of_stay numeric(38,0),
    visit_blob varchar(4000),
    update_date timestamp,
    download_date timestamp,
    import_date timestamp,
    sourcesystem_cd varchar(50),
    upload_id numeric(38,0)
);

CREATE TABLE i2b2demodata.MODIFIER_METADATA 
   (           MODIFIER_CD VARCHAR(50), 
                VALTYPE_CD VARCHAR(10), 
                STD_UNITS VARCHAR(50), 
                VISIT_IND CHAR(1)
   );

--
-- Netezza allows Primary/Foreign Keys but it doesn't enforce them
--

ALTER TABLE i2b2demodata.qt_analysis_plugin
    ADD CONSTRAINT analysis_plugin_pk PRIMARY KEY (plugin_id);

ALTER TABLE i2b2demodata.qt_analysis_plugin_result_type
    ADD CONSTRAINT analysis_plugin_result_pk PRIMARY KEY (plugin_id, result_type_id);

ALTER TABLE i2b2demodata.code_lookup
    ADD CONSTRAINT code_lookup_pk PRIMARY KEY (table_cd, column_cd, code_cd);

ALTER TABLE i2b2demodata.concept_dimension
    ADD CONSTRAINT concept_dimension_pk PRIMARY KEY (concept_path);

ALTER TABLE i2b2demodata.encounter_mapping
    ADD CONSTRAINT encounter_mapping_pk PRIMARY KEY (encounter_ide, encounter_ide_source);

ALTER TABLE i2b2demodata.modifier_dimension
    ADD CONSTRAINT modifier_dimension_pk PRIMARY KEY (modifier_path);

ALTER TABLE i2b2demodata.observation_fact
    ADD CONSTRAINT observation_fact_pkey PRIMARY KEY (patient_num, concept_cd, provider_id, modifier_cd);

ALTER TABLE i2b2demodata.patient_dimension
    ADD CONSTRAINT patient_dimension_pk PRIMARY KEY (patient_num);

ALTER TABLE i2b2demodata.patient_mapping
    ADD CONSTRAINT patient_mapping_pk PRIMARY KEY (patient_ide, patient_ide_source);

ALTER TABLE i2b2demodata.source_master
    ADD CONSTRAINT pk_sourcemaster_sourcecd PRIMARY KEY (source_cd);

ALTER TABLE i2b2demodata.set_type
    ADD CONSTRAINT pk_st_id PRIMARY KEY (id);

ALTER TABLE i2b2demodata.set_upload_status
    ADD CONSTRAINT pk_up_upstatus_idsettypeid PRIMARY KEY (upload_id, set_type_id);

ALTER TABLE i2b2demodata.upload_status
    ADD CONSTRAINT pk_up_upstatus_uploadid PRIMARY KEY (upload_id);

ALTER TABLE i2b2demodata.provider_dimension
    ADD CONSTRAINT provider_dimension_pk PRIMARY KEY (provider_path, provider_id);

ALTER TABLE i2b2demodata.qt_patient_enc_collection
    ADD CONSTRAINT qt_patient_enc_collection_pkey PRIMARY KEY (patient_enc_coll_id);

ALTER TABLE i2b2demodata.qt_patient_set_collection
    ADD CONSTRAINT qt_patient_set_collection_pkey PRIMARY KEY (patient_set_coll_id);

ALTER TABLE i2b2demodata.qt_pdo_query_master
    ADD CONSTRAINT qt_pdo_query_master_pkey PRIMARY KEY (query_master_id);

ALTER TABLE i2b2demodata.qt_query_instance
    ADD CONSTRAINT qt_query_instance_pkey PRIMARY KEY (query_instance_id);

ALTER TABLE i2b2demodata.qt_query_master
    ADD CONSTRAINT qt_query_master_pkey PRIMARY KEY (query_master_id);

ALTER TABLE i2b2demodata.qt_query_result_instance
    ADD CONSTRAINT qt_query_result_instance_pkey PRIMARY KEY (result_instance_id);

ALTER TABLE i2b2demodata.qt_query_result_type
    ADD CONSTRAINT qt_query_result_type_pkey PRIMARY KEY (result_type_id);

ALTER TABLE i2b2demodata.qt_query_status_type
    ADD CONSTRAINT qt_query_status_type_pkey PRIMARY KEY (status_type_id);

ALTER TABLE i2b2demodata.qt_xml_result
    ADD CONSTRAINT qt_xml_result_pkey PRIMARY KEY (xml_result_id);

ALTER TABLE i2b2demodata.visit_dimension
    ADD CONSTRAINT visit_dimension_pk PRIMARY KEY (encounter_num, patient_num);

ALTER TABLE i2b2demodata.set_upload_status
    ADD CONSTRAINT fk_up_set_type_id FOREIGN KEY (set_type_id) REFERENCES i2b2demodata.set_type(id);

ALTER TABLE i2b2demodata.qt_patient_enc_collection
    ADD CONSTRAINT qt_fk_pesc_ri FOREIGN KEY (result_instance_id) REFERENCES i2b2demodata.qt_query_result_instance(result_instance_id);

ALTER TABLE i2b2demodata.qt_patient_set_collection
    ADD CONSTRAINT qt_fk_psc_ri FOREIGN KEY (result_instance_id) REFERENCES i2b2demodata.qt_query_result_instance(result_instance_id);

ALTER TABLE i2b2demodata.qt_query_instance
    ADD CONSTRAINT qt_fk_qi_mid FOREIGN KEY (query_master_id) REFERENCES i2b2demodata.qt_query_master(query_master_id);

ALTER TABLE i2b2demodata.qt_query_instance
    ADD CONSTRAINT qt_fk_qi_stid FOREIGN KEY (status_type_id) REFERENCES i2b2demodata.qt_query_status_type(status_type_id);

ALTER TABLE i2b2demodata.qt_query_result_instance
    ADD CONSTRAINT qt_fk_qri_rid FOREIGN KEY (query_instance_id) REFERENCES i2b2demodata.qt_query_instance(query_instance_id);

ALTER TABLE i2b2demodata.qt_query_result_instance
    ADD CONSTRAINT qt_fk_qri_rtid FOREIGN KEY (result_type_id) REFERENCES i2b2demodata.qt_query_result_type(result_type_id);

ALTER TABLE i2b2demodata.qt_query_result_instance
    ADD CONSTRAINT qt_fk_qri_stid FOREIGN KEY (status_type_id) REFERENCES i2b2demodata.qt_query_status_type(status_type_id);

ALTER TABLE i2b2demodata.qt_xml_result
    ADD CONSTRAINT qt_fk_xmlr_riid FOREIGN KEY (result_instance_id) REFERENCES i2b2demodata.qt_query_result_instance(result_instance_id);

/* Netezza does not support Indexes

CREATE INDEX cd_uploadid_idx ON concept_dimension USING btree (upload_id);

CREATE INDEX cl_idx_name_char ON code_lookup USING btree (name_char);

CREATE INDEX cl_idx_uploadid ON code_lookup USING btree (upload_id);

CREATE INDEX em_encnum_idx ON encounter_mapping USING btree (encounter_num);

CREATE INDEX em_idx_encpath ON encounter_mapping USING btree (encounter_ide, encounter_ide_source, patient_ide, patient_ide_source, encounter_num);

CREATE INDEX em_uploadid_idx ON encounter_mapping USING btree (upload_id);

CREATE INDEX fact_cnpt_pat_enct_idx ON observation_fact USING btree (concept_cd, instance_num, patient_num, encounter_num);

CREATE INDEX fact_nolob ON observation_fact USING btree (patient_num, start_date, concept_cd, encounter_num, instance_num, nval_num, tval_char, valtype_cd, modifier_cd, valueflag_cd, provider_id, quantity_num, units_cd, end_date, location_cd, confidence_num, update_date, download_date, import_date, sourcesystem_cd, upload_id);

CREATE INDEX fact_patcon_date_prvd_idx ON observation_fact USING btree (patient_num, concept_cd, start_date, end_date, encounter_num, instance_num, provider_id, nval_num, valtype_cd);

CREATE INDEX idx_concept_dim_1 ON concept_dimension USING btree (concept_cd);

CREATE INDEX idx_concept_dim_2 ON concept_dimension USING btree (concept_path);

CREATE INDEX idx_ob_fact_1 ON observation_fact USING btree (concept_cd);

CREATE INDEX idx_ob_fact_2 ON observation_fact USING btree (concept_cd, patient_num, encounter_num);

CREATE INDEX md_idx_uploadid ON modifier_dimension USING btree (upload_id);

CREATE INDEX patd_uploadid_idx ON patient_dimension USING btree (upload_id);

CREATE INDEX pd_idx_allpatientdim ON patient_dimension USING btree (patient_num, vital_status_cd, birth_date, death_date, sex_cd, age_in_years_num, language_cd, race_cd, marital_status_cd, religion_cd, zip_cd, income_cd);

CREATE INDEX pd_idx_dates ON patient_dimension USING btree (patient_num, vital_status_cd, birth_date, death_date);

CREATE INDEX pd_idx_name_char ON provider_dimension USING btree (provider_id, name_char);

CREATE INDEX pd_idx_statecityzip ON patient_dimension USING btree (statecityzip_path, patient_num);

CREATE INDEX pk_archive_obsfact ON archive_observation_fact USING btree (encounter_num, patient_num, concept_cd, provider_id, start_date, modifier_cd, archive_upload_id);

CREATE INDEX pm_encpnum_idx ON patient_mapping USING btree (patient_ide, patient_ide_source, patient_num);

CREATE INDEX pm_patnum_idx ON patient_mapping USING btree (patient_num);

CREATE INDEX pm_uploadid_idx ON patient_mapping USING btree (upload_id);

CREATE INDEX prod_uploadid_idx ON provider_dimension USING btree (upload_id);

CREATE INDEX qt_apnamevergrp_idx ON qt_analysis_plugin USING btree (plugin_name, version_cd, group_id);

CREATE INDEX qt_idx_pqm_ugid ON qt_pdo_query_master USING btree (user_id, group_id);

CREATE INDEX qt_idx_qi_mstartid ON qt_query_instance USING btree (query_master_id, start_date);

CREATE INDEX qt_idx_qi_ugid ON qt_query_instance USING btree (user_id, group_id);

CREATE INDEX qt_idx_qm_ugid ON qt_query_master USING btree (user_id, group_id, master_type_cd);

CREATE INDEX qt_idx_qpsc_riid ON qt_patient_set_collection USING btree (result_instance_id);

CREATE INDEX vd_uploadid_idx ON visit_dimension USING btree (upload_id);

CREATE UNIQUE INDEX visit_dim_pk ON visit_dimension USING btree (patient_num, encounter_num);

CREATE INDEX visitdim_en_pn_lp_io_sd_idx ON visit_dimension USING btree (encounter_num, patient_num, location_path, inout_cd, start_date);

CREATE INDEX visitdim_std_edd_idx ON visit_dimension USING btree (start_date, end_date);
*/
