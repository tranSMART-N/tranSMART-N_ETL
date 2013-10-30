--set catalog transmart;
--set schema deapp;

CREATE SEQUENCE deapp.de_chromosomal_region_region_id_seq as bigint INCREMENT BY 1 MINVALUE 1 NO MAXVALUE START WITH 1;
CREATE SEQUENCE deapp.de_parent_cd_seq as bigint INCREMENT BY 1 MINVALUE 1 NO MAXVALUE START WITH 1;
CREATE SEQUENCE deapp.seq_assay_id as bigint INCREMENT BY 1 MINVALUE 1 NO MAXVALUE START WITH 1;
CREATE SEQUENCE deapp.seq_data_id as bigint INCREMENT BY 1 MINVALUE 1 NO MAXVALUE START WITH 1;
CREATE SEQUENCE deapp.seq_mrna_partition_id as bigint INCREMENT BY 1 MINVALUE 1 NO MAXVALUE START WITH 1;

CREATE TABLE deapp.de_chromosomal_region (
    region_id bigint NOT NULL,
    gpl_id varchar(50),
    chromosome varchar(2),
    start_bp bigint,
    end_bp bigint,
    num_probes integer,
    region_name varchar(100),
    gene_symbol varchar(100),
    gene_id bigint,
    organism varchar(200)
);

CREATE TABLE deapp.de_gpl_info (
    platform varchar(50) NOT NULL,
    title varchar(500),
    organism varchar(100),
    annotation_date timestamp, 
    marker_type varchar(100),
    genome_build varchar(20),
    release_nbr numeric
);

CREATE TABLE deapp.de_mrna_annotation (
    gpl_id varchar(100),
    probe_id varchar(100),
    gene_symbol varchar(100),
    probeset_id bigint,
    gene_id bigint,
    organism varchar(200)
);

CREATE TABLE deapp.de_pathway (
    name varchar(300),
    description varchar(510),
    id bigint NOT NULL,
    type varchar(100),
    source varchar(100),
    externalid varchar(100),
    pathway_uid varchar(200),
    user_id bigint
);

CREATE TABLE deapp.de_pathway_gene (
    id bigint NOT NULL,
    pathway_id bigint,
    gene_symbol varchar(200),
    gene_id varchar(200)
);

CREATE TABLE deapp.de_saved_comparison (
    comparison_id bigint NOT NULL,
    query_id1 bigint,
    query_id2 bigint
);

CREATE TABLE deapp.de_snp_calls_by_gsm (
    gsm_num varchar(10),
    patient_num bigint,
    snp_name varchar(100),
    snp_calls varchar(4)
);

CREATE TABLE deapp.de_snp_copy_number (
    patient_num bigint,
    snp_name varchar(50),
    chrom varchar(2),
    chrom_pos bigint,
    copy_number smallint
);

CREATE TABLE deapp.de_snp_data_by_patient (
    snp_data_by_patient_id bigint NOT NULL,
    snp_dataset_id bigint,
    trial_name varchar(255),
    patient_num bigint,
    chrom varchar(16),
    data_by_patient_chr varchar(4000),
    ped_by_patient_chr varchar(4000)
);

CREATE TABLE deapp.de_snp_data_by_probe (
    snp_data_by_probe_id bigint NOT NULL,
    probe_id bigint,
    probe_name varchar(255),
    snp_id bigint,
    snp_name varchar(255),
    trial_name varchar(255),
    data_by_probe varchar(4000)
);

CREATE TABLE deapp.de_snp_data_dataset_loc (
    snp_data_dataset_loc_id bigint,
    trial_name varchar(255),
    snp_dataset_id bigint,
    location bigint
);

CREATE TABLE deapp.de_snp_gene_map (
    snp_id bigint,
    snp_name varchar(255),
    entrez_gene_id bigint
);

CREATE TABLE deapp.de_snp_info (
    snp_info_id bigint NOT NULL,
    name varchar(255),
    chrom varchar(16),
    chrom_pos bigint
);

CREATE TABLE deapp.de_snp_probe (
    snp_probe_id bigint NOT NULL,
    probe_name varchar(255),
    snp_id bigint,
    snp_name varchar(255),
    vendor_name varchar(255)
);

CREATE TABLE deapp.de_snp_probe_sorted_def (
    snp_probe_sorted_def_id bigint NOT NULL,
    platform_name varchar(255),
    num_probe bigint,
    chrom varchar(16),
    probe_def varchar(4000),
    snp_id_def varchar(4000)
);

CREATE TABLE deapp.de_snp_subject_sorted_def (
    snp_subject_sorted_def_id bigint NOT NULL,
    trial_name varchar(255),
    patient_position integer,
    patient_num bigint,
    subject_id varchar(255)
);

CREATE TABLE deapp.de_subject_acgh_data (
    trial_name varchar(50),
    region_id bigint NOT NULL,
    assay_id bigint NOT NULL,
    patient_id bigint,
    chip double precision,
    segmented double precision,
    flag smallint,
    probloss double precision,
    probnorm double precision,
    probgain double precision,
    probamp double precision
);

CREATE TABLE deapp.de_subject_microarray_data (
    trial_name varchar(50),
    probeset_id bigint,
    assay_id bigint,
    patient_id bigint,
    raw_intensity double precision,
    log_intensity double precision,
    zscore double precision,
    raw_intensity_4 double precision,
    partition_id numeric
);

CREATE TABLE deapp.de_subject_microarray_logs (
    probeset varchar(50),
    raw_intensity bigint,
    pvalue double precision,
    refseq varchar(50),
    gene_symbol varchar(50),
    assay_id bigint,
    patient_id bigint,
    subject_id varchar(20),
    trial_name varchar(15),
    timepoint varchar(30),
    log_intensity bigint
);

CREATE TABLE deapp.de_subject_microarray_med (
    probeset varchar(50),
    raw_intensity bigint,
    log_intensity bigint,
    gene_symbol varchar(50),
    assay_id bigint,
    patient_id bigint,
    subject_id varchar(20),
    trial_name varchar(15),
    timepoint varchar(30),
    pvalue double precision,
    refseq varchar(50),
    mean_intensity bigint,
    stddev_intensity bigint,
    median_intensity bigint,
    zscore bigint
);

CREATE TABLE deapp.de_subject_protein_data (
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
    zscore bigint
);

CREATE TABLE deapp.de_subject_rbm_data (
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
    rbm_panel varchar(50)
);

CREATE TABLE deapp.de_subject_sample_mapping (
    patient_id bigint,
    site_id varchar(100),
    subject_id varchar(100),
    subject_type varchar(100),
    concept_code varchar(1000),
    assay_id bigint NOT NULL,
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
    source_cd varchar(50),
    omic_source_study varchar(200),
    omic_patient_id bigint,
    partition_id numeric
);

CREATE TABLE deapp.de_subject_snp_dataset (
    subject_snp_dataset_id bigint NOT NULL,
    dataset_name varchar(255),
    concept_cd varchar(255),
    platform_name varchar(255),
    trial_name varchar(255),
    patient_num bigint,
    timepoint varchar(255),
    subject_id varchar(255),
    sample_type varchar(255),
    paired_dataset_id bigint,
    patient_gender varchar(1)
);

CREATE TABLE deapp.de_xtrial_child_map (
    concept_cd varchar(50) NOT NULL,
    parent_cd bigint NOT NULL,
    manually_mapped bigint,
    study_id varchar(50)
);

CREATE TABLE deapp.de_xtrial_parent_names (
    parent_cd bigint NOT NULL,
    across_path varchar(500),
    manually_created bigint
);

CREATE TABLE deapp.deapp_annotation (
    annotation_type varchar(50),
    annotation_value varchar(100),
    gene_id bigint,
    gene_symbol varchar(200)
);

CREATE TABLE deapp.haploview_data (
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
    snp_data varchar(4000)
);


ALTER TABLE deapp.de_gpl_info ADD CONSTRAINT de_gpl_info_pkey PRIMARY KEY (platform);

ALTER TABLE deapp.de_subject_acgh_data ADD CONSTRAINT de_subject_acgh_data_pkey PRIMARY KEY (assay_id, region_id);

ALTER TABLE deapp.de_xtrial_parent_names ADD CONSTRAINT dextpn_parent_node_u UNIQUE (across_path);

ALTER TABLE deapp.de_snp_probe_sorted_def ADD CONSTRAINT sys_c0020600 PRIMARY KEY (snp_probe_sorted_def_id);

ALTER TABLE deapp.de_snp_data_by_probe ADD CONSTRAINT sys_c0020601 PRIMARY KEY (snp_data_by_probe_id);

ALTER TABLE deapp.de_snp_data_by_patient ADD CONSTRAINT sys_c0020602 PRIMARY KEY (snp_data_by_patient_id);

ALTER TABLE deapp.de_xtrial_parent_names ADD CONSTRAINT sys_c0020604 PRIMARY KEY (parent_cd);

ALTER TABLE deapp.de_xtrial_child_map ADD CONSTRAINT sys_c0020605 PRIMARY KEY (concept_cd);

ALTER TABLE deapp.de_subject_snp_dataset ADD CONSTRAINT sys_c0020606 PRIMARY KEY (subject_snp_dataset_id);

ALTER TABLE deapp.de_snp_subject_sorted_def ADD CONSTRAINT sys_c0020607 PRIMARY KEY (snp_subject_sorted_def_id);

ALTER TABLE deapp.de_snp_probe ADD CONSTRAINT sys_c0020609 PRIMARY KEY (snp_probe_id);

ALTER TABLE deapp.de_snp_info ADD CONSTRAINT sys_c0020611 PRIMARY KEY (snp_info_id);

ALTER TABLE deapp.de_snp_info ADD CONSTRAINT u_snp_info_name UNIQUE (name);

ALTER TABLE deapp.de_snp_probe ADD CONSTRAINT u_snp_probe_name UNIQUE (probe_name);

ALTER TABLE deapp.de_chromosomal_region ADD CONSTRAINT de_chromosomal_region_region_id_pkey PRIMARY KEY (region_id);

ALTER TABLE deapp.de_chromosomal_region ADD CONSTRAINT de_chromosomal_region_gpl_id_fkey FOREIGN KEY (gpl_id) REFERENCES deapp.de_gpl_info(platform);

ALTER TABLE deapp.de_subject_acgh_data ADD CONSTRAINT de_subject_acgh_data_region_id_fkey FOREIGN KEY (region_id) REFERENCES deapp.de_chromosomal_region(region_id);

ALTER TABLE deapp.de_snp_gene_map ADD CONSTRAINT fk_snp_gene_map_snp_id FOREIGN KEY (snp_id) REFERENCES deapp.de_snp_info(snp_info_id);

ALTER TABLE deapp.de_snp_data_dataset_loc ADD CONSTRAINT fk_snp_loc_dataset_id FOREIGN KEY (snp_dataset_id) REFERENCES deapp.de_subject_snp_dataset(subject_snp_dataset_id);

ALTER TABLE deapp.de_snp_probe ADD CONSTRAINT fk_snp_probe_snp_id FOREIGN KEY (snp_id) REFERENCES deapp.de_snp_info(snp_info_id);

/*

CREATE TRIGGER de_parent_cd_trg BEFORE INSERT ON de_xtrial_parent_names FOR EACH ROW WHEN ((COALESCE((new.parent_cd)::text, ''::text) = ''::text)) EXECUTE PROCEDURE tf_de_parent_cd_trg();

CREATE TRIGGER trg_de_snp_info_id BEFORE INSERT ON de_snp_info FOR EACH ROW EXECUTE PROCEDURE tf_trg_de_snp_info_id();

CREATE TRIGGER trg_de_snp_probe_id BEFORE INSERT ON de_snp_probe FOR EACH ROW EXECUTE PROCEDURE tf_trg_de_snp_probe_id();

CREATE TRIGGER trg_de_snp_probe_sorted_def_id BEFORE INSERT ON de_snp_probe_sorted_def FOR EACH ROW EXECUTE PROCEDURE tf_trg_de_snp_probe_sorted_def_id();

CREATE TRIGGER trg_de_subject_snp_dataset_id BEFORE INSERT ON de_subject_snp_dataset FOR EACH ROW EXECUTE PROCEDURE tf_trg_de_subject_snp_dataset_id();

CREATE TRIGGER trg_de_subject_sorted_def_id BEFORE INSERT ON de_snp_subject_sorted_def FOR EACH ROW EXECUTE PROCEDURE tf_trg_de_subject_sorted_def_id();

CREATE TRIGGER trg_snp_data_by_patient_id BEFORE INSERT ON de_snp_data_by_patient FOR EACH ROW EXECUTE PROCEDURE tf_trg_snp_data_by_patient_id();

CREATE TRIGGER trg_snp_data_by_pprobe_id BEFORE INSERT ON de_snp_data_by_probe FOR EACH ROW EXECUTE PROCEDURE tf_trg_snp_data_by_pprobe_id();

CREATE TRIGGER trg_snp_subject_sorted_def_id BEFORE INSERT ON de_snp_subject_sorted_def FOR EACH ROW EXECUTE PROCEDURE tf_trg_snp_subject_sorted_def_id();

*/
