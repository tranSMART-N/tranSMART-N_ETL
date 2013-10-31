--
-- CREATE SCHEMA i2b2metadata;
--

CREATE TABLE i2b2metadata.birn (
    c_hlevel numeric(22,0) NOT NULL,
    c_fullname varchar(700) NOT NULL,
    c_name varchar(2000) NOT NULL,
    c_synonym_cd character(1) NOT NULL,
    c_visualattributes character(3) NOT NULL,
    c_totalnum numeric(22,0),
    c_basecode varchar(50),
    c_metadataxml varchar(4000),
    c_facttablecolumn varchar(50) NOT NULL,
    c_tablename varchar(50) NOT NULL,
    c_columnname varchar(50) NOT NULL,
    c_columndatatype varchar(50) NOT NULL,
    c_operator varchar(10) NOT NULL,
    c_dimcode varchar(700) NOT NULL,
    c_comment varchar(4000),
    c_tooltip varchar(900),
    m_applied_path varchar(700) NOT NULL,
    update_date timestamp NOT NULL,
    download_date timestamp,
    import_date timestamp,
    sourcesystem_cd varchar(50),
    valuetype_cd varchar(50),
    m_exclusion_cd varchar(25),
    c_path varchar(700),
    c_symbol varchar(50)
);

CREATE TABLE i2b2metadata.custom_meta (
    c_hlevel numeric(22,0) NOT NULL,
    c_fullname varchar(700) NOT NULL,
    c_name varchar(2000) NOT NULL,
    c_synonym_cd character(1) NOT NULL,
    c_visualattributes character(3) NOT NULL,
    c_totalnum numeric(22,0),
    c_basecode varchar(50),
    c_metadataxml varchar(4000),
    c_facttablecolumn varchar(50) NOT NULL,
    c_tablename varchar(50) NOT NULL,
    c_columnname varchar(50) NOT NULL,
    c_columndatatype varchar(50) NOT NULL,
    c_operator varchar(10) NOT NULL,
    c_dimcode varchar(700) NOT NULL,
    c_comment varchar(4000),
    c_tooltip varchar(900),
    m_applied_path varchar(700) NOT NULL,
    update_date timestamp NOT NULL,
    download_date timestamp,
    import_date timestamp,
    sourcesystem_cd varchar(50),
    valuetype_cd varchar(50),
    m_exclusion_cd varchar(25),
    c_path varchar(700),
    c_symbol varchar(50)
);

CREATE TABLE i2b2metadata.i2b2 (
    c_hlevel numeric(22,0) NOT NULL,
    c_fullname varchar(700) NOT NULL,
    c_name varchar(2000) NOT NULL,
    c_synonym_cd character(1) NOT NULL,
    c_visualattributes character(3) NOT NULL,
    c_totalnum numeric(22,0),
    c_basecode varchar(50),
    c_metadataxml varchar(4000),
    c_facttablecolumn varchar(50) NOT NULL,
    c_tablename varchar(150) NOT NULL,
    c_columnname varchar(50) NOT NULL,
    c_columndatatype varchar(50) NOT NULL,
    c_operator varchar(10) NOT NULL,
    c_dimcode varchar(700) NOT NULL,
    c_comment varchar(4000),
    c_tooltip varchar(900),
    m_applied_path varchar(700) NOT NULL,
    update_date timestamp NOT NULL,
    download_date timestamp,
    import_date timestamp,
    sourcesystem_cd varchar(50),
    valuetype_cd varchar(50),
    m_exclusion_cd varchar(25),
    c_path varchar(700),
    c_symbol varchar(50)
);

CREATE TABLE i2b2metadata.i2b2_secure (
    c_hlevel numeric(22,0),
    c_fullname varchar(700),
    c_name varchar(2000),
    c_synonym_cd character(1),
    c_visualattributes character(3),
    c_totalnum numeric(22,0),
    c_basecode varchar(50),
    c_metadataxml varchar(4000),
    c_facttablecolumn varchar(50),
    c_tablename varchar(150),
    c_columnname varchar(50),
    c_columndatatype varchar(50),
    c_operator varchar(10),
    c_dimcode varchar(700),
    c_comment varchar(4000),
    c_tooltip varchar(900),
    m_applied_path varchar(700),
    update_date timestamp,
    download_date timestamp,
    import_date timestamp,
    sourcesystem_cd varchar(50),
    valuetype_cd varchar(50),
    m_exclusion_cd varchar(25),
    c_path varchar(700),
    c_symbol varchar(50),
    i2b2_id numeric(18,0),
    secure_obj_token varchar(50)
);

CREATE TABLE i2b2metadata.i2b2_tags (
    tag_id integer NOT NULL,
    path varchar(400),
    tag varchar(400),
    tag_type varchar(400),
    tags_idx integer NOT NULL
);

CREATE SEQUENCE i2b2metadata.ont_sq_ps_prid as bigint START WITH 1 INCREMENT BY 1 NO MINVALUE NO MAXVALUE;

CREATE TABLE i2b2metadata.ont_process_status (
    process_id numeric(5,0) NOT NULL,
    process_type_cd varchar(50),
    start_date timestamp,
    end_date timestamp,
    process_step_cd varchar(50),
    process_status_cd varchar(50),
    crc_upload_id numeric(38,0),
    status_cd varchar(50),
    message varchar(2000),
    entry_date timestamp,
    change_date timestamp,
    changedby_char character(50)
);

CREATE TABLE i2b2metadata.schemes (
    c_key varchar(50) NOT NULL,
    c_name varchar(50) NOT NULL,
    c_description varchar(100)
);

CREATE TABLE i2b2metadata.table_access (
    c_table_cd varchar(50) NOT NULL,
    c_table_name varchar(50) NOT NULL,
    c_protected_access character(1),
    c_hlevel numeric(22,0) NOT NULL,
    c_fullname varchar(700) NOT NULL,
    c_name varchar(2000) NOT NULL,
    c_synonym_cd character(1) NOT NULL,
    c_visualattributes character(3) NOT NULL,
    c_totalnum numeric(22,0),
    c_basecode varchar(50),
    c_metadataxml varchar(4000),
    c_facttablecolumn varchar(50) NOT NULL,
    c_dimtablename varchar(50) NOT NULL,
    c_columnname varchar(50) NOT NULL,
    c_columndatatype varchar(50) NOT NULL,
    c_operator varchar(10) NOT NULL,
    c_dimcode varchar(700) NOT NULL,
    c_comment varchar(4000),
    c_tooltip varchar(900),
    c_entry_date timestamp,
    c_change_date timestamp,
    c_status_cd character(1),
    valuetype_cd varchar(50)
);

ALTER TABLE i2b2metadata.ont_process_status
    ADD CONSTRAINT ont_process_status_pkey PRIMARY KEY (process_id);

ALTER TABLE i2b2metadata.schemes
    ADD CONSTRAINT schemes_pk PRIMARY KEY (c_key);

ALTER TABLE i2b2metadata.table_access
    ADD CONSTRAINT table_access_pk PRIMARY KEY (c_table_cd);
