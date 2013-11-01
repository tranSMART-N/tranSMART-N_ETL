

CREATE SEQUENCE searchapp.hibernate_sequence;


CREATE TABLE searchapp.plugin (
    plugin_seq bigint NOT NULL,
    name character varying(200) NOT NULL,
    plugin_name character varying(90) NOT NULL,
    has_modules character(1) DEFAULT 'N'::bpchar,
    has_form character(1) DEFAULT 'N'::bpchar,
    default_link character varying(70) NOT NULL,
    form_link character varying(70),
    form_page character varying(100),
    active character(1)
);


CREATE TABLE searchapp.plugin_module (
    module_seq bigint NOT NULL,
    plugin_seq bigint NOT NULL,
    name character varying(70) NOT NULL,
    params varchar(4000),
    version character varying(10) DEFAULT 0.1,
    active character(1) DEFAULT 'Y'::bpchar,
    has_form character(1) DEFAULT 'N'::bpchar,
    form_link character varying(90),
    form_page character varying(90),
    module_name character varying(50) NOT NULL,
    category character varying(50)
);

CREATE SEQUENCE searchapp.plugin_module_seq;

CREATE SEQUENCE searchapp.plugin_seq;

CREATE TABLE searchapp.search_app_access_log (
    id bigint,
    access_time timestamp,
    event character varying(255),
    request_url character varying(255),
    user_name character varying(255),
    event_message varchar(2000)
);


CREATE TABLE searchapp.search_auth_group (
    id bigint NOT NULL,
    group_category character varying(255)
);


CREATE TABLE searchapp.search_auth_group_member (
    auth_user_id bigint,
    auth_group_id bigint
);


CREATE TABLE searchapp.search_auth_principal (
    id bigint NOT NULL,
    principal_type character varying(255),
    date_created timestamp, -- without time zone NOT NULL,
    description character varying(255),
    last_updated timestamp, -- without time zone NOT NULL,
    name character varying(255),
    unique_id character varying(255),
    enabled boolean
);

CREATE TABLE searchapp.search_auth_sec_object_access (
    auth_sec_obj_access_id bigint NOT NULL,
    auth_principal_id bigint,
    secure_object_id bigint,
    secure_access_level_id bigint
);



CREATE TABLE searchapp.search_auth_user (
    id bigint NOT NULL,
    email character varying(255),
    email_show boolean,
    passwd character varying(255),
    user_real_name character varying(255),
    username character varying(255)
);


CREATE TABLE searchapp.search_auth_user_sec_access (
    search_auth_user_sec_access_id bigint NOT NULL,
    search_auth_user_id bigint,
    search_secure_object_id bigint,
    search_sec_access_level_id bigint
);


CREATE VIEW searchapp.search_auth_user_sec_access_v AS
    (SELECT sasoa.auth_sec_obj_access_id AS search_auth_user_sec_access_id, sasoa.auth_principal_id AS search_auth_user_id, sasoa.secure_object_id AS search_secure_object_id, sasoa.secure_access_level_id AS search_sec_access_level_id FROM search_auth_user sau, search_auth_sec_object_access sasoa WHERE (sau.id = sasoa.auth_principal_id) UNION SELECT sasoa.auth_sec_obj_access_id AS search_auth_user_sec_access_id, sagm.auth_user_id AS search_auth_user_id, sasoa.secure_object_id AS search_secure_object_id, sasoa.secure_access_level_id AS search_sec_access_level_id FROM search_auth_group sag, search_auth_group_member sagm, search_auth_sec_object_access sasoa WHERE ((sag.id = sagm.auth_group_id) AND (sag.id = sasoa.auth_principal_id))) UNION SELECT sasoa.auth_sec_obj_access_id AS search_auth_user_sec_access_id, NULL::bigint AS search_auth_user_id, sasoa.secure_object_id AS search_secure_object_id, sasoa.secure_access_level_id AS search_sec_access_level_id FROM search_auth_group sag, search_auth_sec_object_access sasoa WHERE (((sag.group_category)::text = 'EVERYONE_GROUP'::text) AND (sag.id = sasoa.auth_principal_id));


CREATE TABLE searchapp.search_bio_mkr_correl_fast_mv (
    domain_object_id bigint,
    asso_bio_marker_id bigint,
    correl_type character varying(19),
    value_metric bigint,
    mv_id bigint
);



CREATE TABLE searchapp.search_gene_signature (
    search_gene_signature_id bigint NOT NULL,
    name character varying(100) NOT NULL,
    description character varying(1000),
    unique_id character varying(50),
    create_date timestamp, -- without time zone NOT NULL,
    created_by_auth_user_id bigint NOT NULL,
    last_modified_date timestamp, -- without time zone,
    modified_by_auth_user_id bigint,
    version_number character varying(50),
    public_flag boolean DEFAULT false,
    deleted_flag boolean DEFAULT false,
    parent_gene_signature_id bigint,
    source_concept_id bigint,
    source_other character varying(255),
    owner_concept_id bigint,
    stimulus_description character varying(1000),
    stimulus_dosing character varying(255),
    treatment_description character varying(1000),
    treatment_dosing character varying(255),
    treatment_bio_compound_id bigint,
    treatment_protocol_number character varying(50),
    pmid_list character varying(255),
    species_concept_id bigint NOT NULL,
    species_mouse_src_concept_id bigint,
    species_mouse_detail character varying(255),
    tissue_type_concept_id bigint,
    experiment_type_concept_id bigint,
    experiment_type_in_vivo_descr character varying(255),
    experiment_type_atcc_ref character varying(255),
    analytic_cat_concept_id bigint,
    analytic_cat_other character varying(255),
    bio_assay_platform_id bigint NOT NULL,
    analyst_name character varying(100),
    norm_method_concept_id bigint,
    norm_method_other character varying(255),
    analysis_method_concept_id bigint,
    analysis_method_other character varying(255),
    multiple_testing_correction boolean,
    p_value_cutoff_concept_id bigint NOT NULL,
    upload_file character varying(255) NOT NULL,
    search_gene_sig_file_schema_id bigint DEFAULT 1,
    fold_chg_metric_concept_id bigint,
    experiment_type_cell_line_id bigint
);


CREATE TABLE searchapp.search_gene_signature_item (
    search_gene_signature_id bigint NOT NULL,
    bio_marker_id bigint,
    fold_chg_metric bigint,
    bio_data_unique_id character varying(200),
    id bigint NOT NULL,
    bio_assay_feature_group_id bigint
);


CREATE VIEW searchapp.search_bio_mkr_correl_fast_view AS
    SELECT i.search_gene_signature_id AS domain_object_id, i.bio_marker_id AS asso_bio_marker_id, 'GENE_SIGNATURE_ITEM' AS correl_type, CASE WHEN (i.fold_chg_metric IS NULL) THEN (1)::bigint ELSE i.fold_chg_metric END AS value_metric, 3 AS mv_id FROM search_gene_signature_item i, search_gene_signature gs WHERE ((i.search_gene_signature_id = gs.search_gene_signature_id) AND (gs.deleted_flag = false));


CREATE TABLE searchapp.search_custom_filter (
    search_custom_filter_id bigint NOT NULL,
    search_user_id bigint NOT NULL,
    name character varying(200) NOT NULL,
    description character varying(2000),
    private character(1) DEFAULT 'N'::bpchar
);


CREATE TABLE searchapp.search_custom_filter_item (
    search_custom_filter_item_id bigint NOT NULL,
    search_custom_filter_id bigint NOT NULL,
    unique_id character varying(200) NOT NULL,
    bio_data_type character varying(100) NOT NULL
);



CREATE TABLE searchapp.search_gene_sig_file_schema (
    search_gene_sig_file_schema_id bigint NOT NULL,
    name character varying(100) NOT NULL,
    description character varying(255),
    number_columns bigint DEFAULT 2,
    supported boolean DEFAULT false
);


CREATE TABLE searchapp.search_keyword (
    keyword character varying(200),
    bio_data_id bigint,
    unique_id character varying(500) NOT NULL,
    search_keyword_id bigint NOT NULL,
    data_category character varying(200) NOT NULL,
    source_code character varying(100),
    display_data_category character varying(200),
    owner_auth_user_id bigint
);



CREATE TABLE searchapp.search_keyword_term (
    keyword_term character varying(200),
    search_keyword_id bigint,
    rank bigint,
    search_keyword_term_id bigint NOT NULL,
    term_length bigint,
    owner_auth_user_id bigint
);

CREATE TABLE searchapp.search_request_map (
    id bigint,
    version bigint,
    config_attribute character varying(255),
    url character varying(255)
);



CREATE TABLE searchapp.search_role (
    id bigint NOT NULL,
    version bigint,
    authority character varying(255),
    description character varying(255)
);


CREATE TABLE searchapp.search_role_auth_user (
    people_id bigint,
    authorities_id bigint
);


CREATE TABLE searchapp.search_sec_access_level (
    search_sec_access_level_id bigint NOT NULL,
    access_level_name character varying(200),
    access_level_value bigint
);


CREATE TABLE searchapp.search_secure_object (
    search_secure_object_id bigint NOT NULL,
    bio_data_id bigint,
    display_name character varying(100),
    data_type character varying(200),
    bio_data_unique_id character varying(200)
);


CREATE TABLE searchapp.search_secure_object_path (
    search_secure_object_id bigint,
    i2b2_concept_path character varying(2000),
    search_secure_obj_path_id bigint NOT NULL
);



CREATE TABLE searchapp.search_user_settings (
    id bigint NOT NULL,
    setting_name character varying(255) NOT NULL,
    user_id bigint NOT NULL,
    setting_value character varying(255) NOT NULL
);

CREATE SEQUENCE searchapp.seq_search_data_id;
