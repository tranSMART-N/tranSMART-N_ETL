
CREATE TABLE biomart.bio_assay (
    bio_assay_id bigint NOT NULL,
    etl_id varchar(100) NOT NULL,
    study varchar(200),
    protocol varchar(200),
    description varchar(4000), --text,
    sample_type varchar(200),
    experiment_id bigint NOT NULL,
    test_date timestamp, 
    sample_receive_date timestamp,
    requestor varchar(200),
    bio_assay_type varchar(200) NOT NULL,
    bio_assay_platform_id bigint
);

CREATE TABLE biomart.bio_assay_analysis (
    analysis_name varchar(500),
    short_description varchar(510),
    analysis_create_date timestamp, 
    analyst_id varchar(510),
    bio_assay_analysis_id bigint NOT NULL,
    analysis_version varchar(200),
    fold_change_cutoff double precision,
    pvalue_cutoff double precision,
    rvalue_cutoff double precision,
    bio_asy_analysis_pltfm_id bigint,
    bio_source_import_id bigint,
    analysis_type varchar(200),
    analyst_name varchar(250),
    analysis_method_cd varchar(50),
    bio_assay_data_type varchar(50),
    etl_id varchar(100),
    long_description varchar(4000),
    qa_criteria varchar(4000),
    data_count bigint,
    tea_data_count bigint
);

CREATE TABLE biomart.bio_assay_analysis_data (
    bio_asy_analysis_data_id bigint NOT NULL,
    fold_change_ratio bigint,
    raw_pvalue double precision,
    adjusted_pvalue double precision,
    r_value double precision,
    rho_value double precision,
    bio_assay_analysis_id bigint NOT NULL,
    adjusted_p_value_code varchar(100),
    feature_group_name varchar(100) NOT NULL,
    bio_experiment_id bigint,
    bio_assay_platform_id bigint,
    etl_id varchar(100),
    preferred_pvalue double precision,
    cut_value double precision,
    results_value varchar(100),
    numeric_value double precision,
    numeric_value_code varchar(50),
    tea_normalized_pvalue double precision,
    bio_assay_feature_group_id bigint
);

CREATE TABLE biomart.bio_assay_analysis_data_tea (
    bio_asy_analysis_data_id bigint NOT NULL,
    fold_change_ratio bigint,
    raw_pvalue double precision,
    adjusted_pvalue double precision,
    r_value double precision,
    rho_value double precision,
    bio_assay_analysis_id bigint NOT NULL,
    adjusted_p_value_code varchar(100),
    feature_group_name varchar(100) NOT NULL,
    bio_experiment_id bigint,
    bio_assay_platform_id bigint,
    etl_id varchar(100),
    preferred_pvalue double precision,
    cut_value double precision,
    results_value varchar(100),
    numeric_value double precision,
    numeric_value_code varchar(50),
    tea_normalized_pvalue double precision,
    bio_experiment_type varchar(50),
    bio_assay_feature_group_id bigint,
    tea_rank bigint
);

CREATE TABLE biomart.bio_assay_data (
    bio_sample_id bigint,
    bio_assay_data_id bigint NOT NULL,
    log2_value double precision,
    log10_value double precision,
    numeric_value bigint,
    text_value varchar(200),
    float_value double precision,
    feature_group_name varchar(100) NOT NULL,
    bio_experiment_id bigint,
    bio_assay_dataset_id bigint,
    bio_assay_id bigint,
    etl_id bigint
);

CREATE TABLE biomart.bio_assay_data_annotation (
    bio_assay_feature_group_id bigint,
    bio_marker_id bigint NOT NULL,
    data_table character(5)
);

CREATE TABLE biomart.bio_assay_data_stats (
    bio_assay_data_stats_id bigint NOT NULL,
    bio_sample_count bigint,
    quartile_1 double precision,
    quartile_2 double precision,
    quartile_3 double precision,
    max_value double precision,
    min_value double precision,
    bio_sample_id bigint,
    feature_group_name varchar(120),
    value_normalize_method varchar(50),
    bio_experiment_id bigint,
    mean_value double precision,
    std_dev_value double precision,
    bio_assay_dataset_id bigint,
    bio_assay_feature_group_id bigint NOT NULL
);

CREATE TABLE biomart.bio_assay_dataset (
    bio_assay_dataset_id bigint NOT NULL,
    dataset_name varchar(400),
    dataset_description varchar(1000),
    dataset_criteria varchar(1000),
    create_date timestamp, 
    bio_experiment_id bigint NOT NULL,
    bio_assay_id bigint,
    etl_id varchar(100),
    accession varchar(50)
);

CREATE TABLE biomart.bio_assay_feature_group (
    bio_assay_feature_group_id bigint NOT NULL,
    feature_group_name varchar(100) NOT NULL,
    feature_group_type varchar(50) NOT NULL
);

CREATE TABLE biomart.bio_assay_platform (
    bio_assay_platform_id bigint NOT NULL,
    platform_name varchar(200),
    platform_version varchar(200),
    platform_description varchar(2000),
    platform_array varchar(50),
    platform_accession varchar(20),
    platform_organism varchar(200),
    platform_vendor varchar(200)
);

CREATE TABLE biomart.bio_assay_sample (
    bio_assay_id bigint NOT NULL,
    bio_sample_id bigint NOT NULL,
    bio_clinic_trial_timepoint_id bigint NOT NULL
);

CREATE TABLE biomart.bio_asy_analysis_dataset (
    bio_assay_dataset_id bigint NOT NULL,
    bio_assay_analysis_id bigint NOT NULL
);

CREATE TABLE biomart.bio_asy_analysis_pltfm (
    bio_asy_analysis_pltfm_id bigint NOT NULL,
    platform_name varchar(200),
    platform_version varchar(200),
    platform_description varchar(1000)
);

CREATE TABLE biomart.bio_asy_data_stats_all (
    bio_assay_data_stats_id bigint NOT NULL,
    bio_sample_count bigint,
    quartile_1 double precision,
    quartile_2 double precision,
    quartile_3 double precision,
    max_value double precision,
    min_value double precision,
    bio_sample_id bigint,
    feature_group_name varchar(120),
    value_normalize_method varchar(50),
    bio_experiment_id bigint,
    mean_value double precision,
    std_dev_value double precision,
    bio_assay_dataset_id bigint
);

CREATE TABLE biomart.bio_cell_line (
    disease varchar(510),
    primary_site varchar(510),
    metastatic_site varchar(510),
    species varchar(510),
    attc_number varchar(510),
    cell_line_name varchar(510),
    bio_cell_line_id bigint NOT NULL,
    bio_disease_id bigint,
    origin varchar(200),
    description varchar(500),
    disease_stage varchar(100),
    disease_subtype varchar(200),
    etl_reference_link varchar(300)
);

CREATE TABLE biomart.bio_cgdcp_data (
    evidence_code varchar(200),
    negation_indicator character(1),
    cell_line_id bigint,
    nci_disease_concept_code varchar(200),
    nci_role_code varchar(200),
    nci_drug_concept_code varchar(200),
    bio_data_id bigint NOT NULL
);

CREATE TABLE biomart.bio_clinc_trial_attr (
    bio_clinc_trial_attr_id bigint NOT NULL,
    property_code varchar(200) NOT NULL,
    property_value varchar(200),
    bio_experiment_id bigint NOT NULL
);

CREATE TABLE biomart.bio_clinc_trial_pt_group (
    bio_experiment_id bigint NOT NULL,
    bio_clinical_trial_p_group_id bigint NOT NULL,
    name varchar(510),
    description varchar(1000),
    number_of_patients integer,
    patient_group_type_code varchar(200)
);

CREATE TABLE biomart.bio_clinc_trial_time_pt (
    bio_clinc_trial_tm_pt_id bigint NOT NULL,
    time_point varchar(200),
    time_point_code varchar(200),
    start_date timestamp, 
    end_date timestamp, 
    bio_experiment_id bigint NOT NULL
);

CREATE TABLE biomart.bio_clinical_trial (
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
    inclusion_criteria varchar(4000),
    exclusion_criteria varchar(4000),
    subjects varchar(2000),
    gender_restriction_mfb varchar(510),
    min_age integer,
    max_age integer,
    secondary_ids varchar(510),
    bio_experiment_id bigint NOT NULL,
    development_partner varchar(100),
    geo_platform varchar(30),
    main_findings varchar(2000),
    platform_name varchar(200),
    search_area varchar(100)
);

CREATE TABLE biomart.bio_clinical_trial_design (
    ref_id varchar(100),
    ref_record_id varchar(100),
    ref_back_reference varchar(100),
    ref_article_pmid varchar(100),
    ref_protocol_id varchar(100),
    ref_title varchar(100),
    study_type varchar(100),
    common_name varchar(100),
    icd10 varchar(100),
    mesh varchar(100),
    disease_type varchar(100),
    physiology_name varchar(100),
    trial_status varchar(100),
    trial_phase varchar(100),
    nature_of_trial varchar(100),
    randomization varchar(100),
    blinded_trial varchar(100),
    trial_type varchar(100),
    run_n_period varchar(100),
    treatment_period varchar(100),
    washout_period varchar(100),
    open_label_extension varchar(100),
    sponsor varchar(100),
    trial_nbr_of_patients_studied varchar(100),
    source_type varchar(100),
    trial_age varchar(100),
    disease_severity varchar(100),
    difficult_to_treat varchar(100),
    asthma_diagnosis varchar(100),
    inhaled_steroid_dose varchar(100),
    laba varchar(100),
    ocs varchar(100),
    xolair varchar(100),
    ltra_inhibitors varchar(100),
    asthma_phenotype varchar(100),
    fev1 varchar(100),
    fev1_reversibility varchar(100),
    tlc varchar(100),
    fev1_fvc varchar(100),
    fvc varchar(100),
    dlco varchar(100),
    sgrq varchar(100),
    hrct varchar(100),
    biopsy varchar(100),
    dyspnea_on_exertion varchar(100),
    concomitant_med varchar(100),
    trial_smokers_pct varchar(100),
    trial_former_smokers_pct varchar(100),
    trial_never_smokers_pct varchar(100),
    trial_pack_years varchar(100),
    exclusion_criteria varchar(100),
    minimal_symptoms varchar(100),
    rescue_medication_use varchar(100),
    control_details varchar(100),
    blinding_procedure varchar(100),
    number_of_arms varchar(100),
    description varchar(100),
    arm varchar(100),
    arm_nbr_of_patients_studied varchar(100),
    arm_classification_type varchar(100),
    arm_classification_value varchar(100),
    arm_asthma_duration varchar(100),
    arm_geographic_region varchar(100),
    arm_age varchar(100),
    arm_gender varchar(100),
    arm_smokers_pct varchar(100),
    arm_former_smokers_pct varchar(100),
    arm_never_smokers_pct varchar(100),
    arm_pack_years varchar(100),
    minority_participation varchar(100),
    baseline_symptom_score varchar(100),
    baseline_rescue_medication_use varchar(100),
    clinical_variable varchar(100),
    clinical_variable_pct varchar(100),
    clinical_variable_value varchar(100),
    prior_med_drug_name varchar(100),
    prior_med_pct varchar(100),
    prior_med_value varchar(100),
    biomarker_name varchar(100),
    biomarker_pct varchar(100),
    biomarkervalue varchar(100),
    cellinfo_type varchar(100),
    cellinfo_count varchar(100),
    cellinfo_source varchar(100),
    pulmonary_pathology_name varchar(100),
    pulmpath_patient_pct varchar(100),
    pulmpath_value_unit varchar(100),
    pulmpath_method varchar(100),
    runin_ocs varchar(100),
    runin_ics varchar(100),
    runin_laba varchar(100),
    runin_ltra varchar(100),
    runin_corticosteroids varchar(100),
    runin_anti_fibrotics varchar(100),
    runin_immunosuppressive varchar(100),
    runin_cytotoxic varchar(100),
    runin_description varchar(100),
    trtmt_ocs varchar(100),
    trtmt_ics varchar(100),
    trtmt_laba varchar(100),
    trtmt_ltra varchar(100),
    trtmt_corticosteroids varchar(100),
    trtmt_anti_fibrotics varchar(100),
    trtmt_immunosuppressive varchar(100),
    trtmt_cytotoxic varchar(100),
    trtmt_description varchar(100),
    drug_inhibitor_common_name varchar(100),
    drug_inhibitor_standard_name varchar(100),
    drug_inhibitor_cas_id varchar(100),
    drug_inhibitor_dose varchar(100),
    drug_inhibitor_route_of_admin varchar(100),
    drug_inhibitor_trtmt_regime varchar(100),
    comparator_name varchar(100),
    comparator_dose varchar(100),
    comparator_time_period varchar(100),
    comparator_route_of_admin varchar(100),
    treatment_regime varchar(100),
    placebo varchar(100),
    experiment_description varchar(100),
    primary_endpoint_type varchar(100),
    primary_endpoint_definition varchar(100),
    primary_endpoint_time_period varchar(100),
    primary_endpoint_change varchar(100),
    primary_endpoint_p_value varchar(100),
    primary_endpoint_stat_test varchar(100),
    secondary_type varchar(100),
    secondary_type_definition varchar(100),
    secondary_type_time_period varchar(100),
    secondary_type_change varchar(100),
    secondary_type_p_value varchar(100),
    secondary_type_stat_test varchar(100),
    clinical_variable_name varchar(100),
    pct_change_from_baseline varchar(100),
    abs_change_from_baseline varchar(100),
    rate_of_change_from_baseline varchar(100),
    average_over_treatment_period varchar(100),
    within_group_changes varchar(100),
    stat_measure_p_value varchar(100),
    definition_of_the_event varchar(100),
    number_of_events varchar(100),
    event_rate varchar(100),
    time_to_event varchar(100),
    event_pct_reduction varchar(100),
    event_p_value varchar(100),
    event_description varchar(100),
    discontinuation_rate varchar(100),
    response_rate varchar(100),
    downstream_signaling_effects varchar(100),
    beneficial_effects varchar(100),
    adverse_effects varchar(100),
    pk_pd_parameter varchar(100),
    pk_pd_value varchar(100),
    effect_description varchar(100),
    biomolecule_name varchar(100),
    biomolecule_id varchar(100),
    biomolecule_type varchar(100),
    biomarker varchar(100),
    biomarker_type varchar(100),
    baseline_expr_pct varchar(100),
    baseline_expr_number varchar(100),
    baseline_expr_value_fold_mean varchar(100),
    baseline_expr_sd varchar(100),
    baseline_expr_sem varchar(100),
    baseline_expr_unit varchar(100),
    expr_after_trtmt_pct varchar(100),
    expr_after_trtmt_number varchar(100),
    expr_aftertrtmt_valuefold_mean varchar(100),
    expr_after_trtmt_sd varchar(100),
    expr_after_trtmt_sem varchar(100),
    expr_after_trtmt_unit varchar(100),
    expr_chg_source_type varchar(100),
    expr_chg_technique varchar(100),
    expr_chg_description varchar(100),
    clinical_correlation varchar(100),
    statistical_test varchar(100),
    statistical_coefficient_value varchar(100),
    statistical_test_p_value varchar(100),
    statistical_test_description varchar(100)
);

CREATE TABLE biomart.bio_compound (
    bio_compound_id bigint NOT NULL,
    cnto_number varchar(200),
    jnj_number varchar(200),
    cas_registry varchar(400),
    code_name varchar(300),
    generic_name varchar(200),
    brand_name varchar(200),
    chemical_name varchar(100),
    mechanism varchar(400),
    product_category varchar(200),
    description varchar(1000),
    etl_id_retired bigint,
    etl_id varchar(50),
    source_cd varchar(100)
);

CREATE TABLE biomart.bio_concept_code (
    bio_concept_code varchar(200),
    code_name varchar(200),
    code_description varchar(1000),
    code_type_name varchar(200),
    bio_concept_code_id bigint NOT NULL
);

CREATE TABLE biomart.bio_content (
    bio_file_content_id bigint NOT NULL,
    file_name varchar(1000),
    repository_id bigint,
    location varchar(400),
    title varchar(1000),
    abstract varchar(2000),
    file_type varchar(200) NOT NULL,
    etl_id bigint,
    etl_id_c varchar(30),
    study_name varchar(30),
    cel_location varchar(300),
    cel_file_suffix varchar(30)
);

CREATE TABLE biomart.bio_content_reference (
    bio_content_reference_id bigint NOT NULL,
    bio_content_id bigint NOT NULL,
    bio_data_id bigint NOT NULL,
    content_reference_type varchar(200) NOT NULL,
    etl_id bigint,
    etl_id_c varchar(30)
);

CREATE TABLE biomart.bio_content_repository (
    bio_content_repo_id bigint NOT NULL,
    location varchar(510),
    active_y_n character(1),
    repository_type varchar(200) NOT NULL,
    location_type varchar(200)
);

CREATE TABLE biomart.bio_curated_data (
    statement varchar(1000),
    statement_status varchar(200),
    bio_data_id bigint NOT NULL,
    bio_curation_dataset_id bigint NOT NULL,
    reference_id bigint,
    data_type varchar(200)
);

CREATE TABLE biomart.bio_curation_dataset (
    bio_curation_dataset_id bigint NOT NULL,
    bio_asy_analysis_pltfm_id bigint,
    bio_source_import_id bigint,
    bio_curation_type varchar(200) NOT NULL,
    create_date timestamp, 
    creator bigint,
    bio_curation_name varchar(500),
    data_type varchar(100)
);

CREATE TABLE biomart.bio_data_attribute (
    bio_data_attribute_id bigint NOT NULL,
    property_code varchar(200) NOT NULL,
    property_value varchar(200),
    bio_data_id bigint NOT NULL,
    property_unit varchar(100)
);

CREATE TABLE biomart.bio_data_compound (
    bio_data_id bigint NOT NULL,
    bio_compound_id bigint NOT NULL,
    etl_source varchar(100)
);

CREATE TABLE biomart.bio_data_correl_descr (
    bio_data_correl_descr_id bigint NOT NULL,
    correlation varchar(510),
    description varchar(1000),
    type_name varchar(200),
    status varchar(200),
    source varchar(100),
    source_code varchar(200)
);

CREATE TABLE biomart.bio_data_correlation (
    bio_data_id bigint NOT NULL,
    asso_bio_data_id bigint NOT NULL,
    bio_data_correl_descr_id bigint NOT NULL,
    bio_data_correl_id bigint NOT NULL
);

CREATE TABLE biomart.bio_data_disease (
    bio_data_id bigint NOT NULL,
    bio_disease_id bigint NOT NULL,
    etl_source varchar(100)
);

CREATE TABLE biomart.bio_data_ext_code (
    bio_data_id bigint NOT NULL,
    code varchar(500) NOT NULL,
    code_source varchar(200),
    code_type varchar(200),
    bio_data_type varchar(100),
    bio_data_ext_code_id bigint NOT NULL,
    etl_id varchar(50)
);

CREATE TABLE biomart.bio_data_literature (
    bio_data_id bigint NOT NULL,
    bio_lit_ref_data_id bigint,
    bio_curation_dataset_id bigint NOT NULL,
    statement varchar(4000),
    statement_status varchar(200),
    data_type varchar(200)
);

CREATE TABLE biomart.bio_data_omic_marker (
    bio_data_id bigint,
    bio_marker_id bigint NOT NULL,
    data_table varchar(5)
);

CREATE TABLE biomart.bio_data_taxonomy (
    bio_taxonomy_id bigint NOT NULL,
    bio_data_id bigint NOT NULL,
    etl_source varchar(100)
);

CREATE TABLE biomart.bio_data_uid (
    bio_data_id bigint NOT NULL,
    unique_id varchar(300) NOT NULL,
    bio_data_type varchar(100) NOT NULL
);

CREATE TABLE biomart.bio_disease (
    bio_disease_id bigint NOT NULL,
    disease varchar(510) NOT NULL,
    ccs_category varchar(510),
    icd10_code varchar(510),
    mesh_code varchar(510),
    icd9_code varchar(510),
    prefered_name varchar(510),
    etl_id_retired bigint,
    primary_source_cd varchar(30),
    etl_id varchar(50)
);

CREATE TABLE biomart.bio_experiment (
    bio_experiment_id bigint NOT NULL,
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
    access_type varchar(100)
);

CREATE TABLE biomart.bio_lit_alt_data (
    bio_lit_alt_data_id bigint NOT NULL,
    bio_lit_ref_data_id bigint NOT NULL,
    in_vivo_model_id bigint,
    in_vitro_model_id bigint,
    etl_id varchar(50),
    alteration_type varchar(50),
    control varchar(1000),
    effect varchar(500),
    description varchar(1000),
    techniques varchar(1000),
    patients_percent varchar(500),
    patients_number varchar(500),
    pop_number varchar(250),
    pop_inclusion_criteria varchar(1000),
    pop_exclusion_criteria varchar(1000),
    pop_description varchar(1000),
    pop_type varchar(250),
    pop_value varchar(250),
    pop_phase varchar(250),
    pop_status varchar(250),
    pop_experimental_model varchar(250),
    pop_tissue varchar(250),
    pop_body_substance varchar(250),
    pop_localization varchar(1000),
    pop_cell_type varchar(250),
    clin_submucosa_marker_type varchar(250),
    clin_submucosa_unit varchar(250),
    clin_submucosa_value varchar(250),
    clin_asm_marker_type varchar(250),
    clin_asm_unit varchar(250),
    clin_asm_value varchar(250),
    clin_cellular_source varchar(250),
    clin_cellular_type varchar(250),
    clin_cellular_count varchar(250),
    clin_prior_med_percent varchar(250),
    clin_prior_med_dose varchar(250),
    clin_prior_med_name varchar(250),
    clin_baseline_variable varchar(250),
    clin_baseline_percent varchar(250),
    clin_baseline_value varchar(250),
    clin_smoker varchar(250),
    clin_atopy varchar(250),
    control_exp_percent varchar(50),
    control_exp_number varchar(50),
    control_exp_value varchar(50),
    control_exp_sd varchar(50),
    control_exp_unit varchar(100),
    over_exp_percent varchar(50),
    over_exp_number varchar(50),
    over_exp_value varchar(50),
    over_exp_sd varchar(50),
    over_exp_unit varchar(100),
    loss_exp_percent varchar(50),
    loss_exp_number varchar(50),
    loss_exp_value varchar(50),
    loss_exp_sd varchar(50),
    loss_exp_unit varchar(100),
    total_exp_percent varchar(50),
    total_exp_number varchar(50),
    total_exp_value varchar(50),
    total_exp_sd varchar(50),
    total_exp_unit varchar(100),
    glc_control_percent varchar(250),
    glc_molecular_change varchar(250),
    glc_type varchar(50),
    glc_percent varchar(100),
    glc_number varchar(100),
    ptm_region varchar(250),
    ptm_type varchar(250),
    ptm_change varchar(250),
    loh_loci varchar(250),
    mutation_type varchar(250),
    mutation_change varchar(250),
    mutation_sites varchar(250),
    epigenetic_region varchar(250),
    epigenetic_type varchar(250)
);

CREATE TABLE biomart.bio_lit_amd_data (
    bio_lit_amd_data_id bigint NOT NULL,
    bio_lit_alt_data_id bigint NOT NULL,
    etl_id varchar(50),
    molecule varchar(50),
    molecule_type varchar(50),
    total_exp_percent varchar(50),
    total_exp_number varchar(100),
    total_exp_value varchar(100),
    total_exp_sd varchar(50),
    total_exp_unit varchar(50),
    over_exp_percent varchar(50),
    over_exp_number varchar(100),
    over_exp_value varchar(100),
    over_exp_sd varchar(50),
    over_exp_unit varchar(50),
    co_exp_percent varchar(50),
    co_exp_number varchar(100),
    co_exp_value varchar(100),
    co_exp_sd varchar(50),
    co_exp_unit varchar(50),
    mutation_type varchar(50),
    mutation_sites varchar(50),
    mutation_change varchar(50),
    mutation_percent varchar(50),
    mutation_number varchar(100),
    target_exp_percent varchar(50),
    target_exp_number varchar(100),
    target_exp_value varchar(100),
    target_exp_sd varchar(50),
    target_exp_unit varchar(50),
    target_over_exp_percent varchar(50),
    target_over_exp_number varchar(100),
    target_over_exp_value varchar(100),
    target_over_exp_sd varchar(50),
    target_over_exp_unit varchar(50),
    techniques varchar(250),
    description varchar(1000)
);

CREATE TABLE biomart.bio_lit_inh_data (
    bio_lit_inh_data_id bigint NOT NULL,
    bio_lit_ref_data_id bigint,
    etl_id varchar(50),
    trial_type varchar(250),
    trial_phase varchar(250),
    trial_status varchar(250),
    trial_experimental_model varchar(250),
    trial_tissue varchar(250),
    trial_body_substance varchar(250),
    trial_description varchar(1000),
    trial_designs varchar(250),
    trial_cell_line varchar(250),
    trial_cell_type varchar(250),
    trial_patients_number varchar(100),
    trial_inclusion_criteria varchar(2000),
    inhibitor varchar(250),
    inhibitor_standard_name varchar(250),
    casid varchar(250),
    description varchar(1000),
    concentration varchar(250),
    time_exposure varchar(500),
    administration varchar(250),
    treatment varchar(2000),
    techniques varchar(1000),
    effect_molecular varchar(250),
    effect_percent varchar(250),
    effect_number varchar(50),
    effect_value varchar(250),
    effect_sd varchar(250),
    effect_unit varchar(250),
    effect_response_rate varchar(250),
    effect_downstream varchar(2000),
    effect_beneficial varchar(2000),
    effect_adverse varchar(2000),
    effect_description varchar(2000),
    effect_pharmacos varchar(2000),
    effect_potentials varchar(2000)
);

CREATE TABLE biomart.bio_lit_int_data (
    bio_lit_int_data_id bigint NOT NULL,
    bio_lit_ref_data_id bigint NOT NULL,
    in_vivo_model_id bigint,
    in_vitro_model_id bigint,
    etl_id varchar(50),
    source_component varchar(100),
    source_gene_id varchar(50),
    target_component varchar(100),
    target_gene_id varchar(50),
    interaction_mode varchar(250),
    regulation varchar(1000),
    mechanism varchar(250),
    effect varchar(500),
    localization varchar(500),
    region varchar(250),
    techniques varchar(1000)
);

CREATE TABLE biomart.bio_lit_int_model_mv (
    bio_lit_int_data_id bigint,
    experimental_model varchar(250)
);

CREATE TABLE biomart.bio_lit_model_data (
    bio_lit_model_data_id bigint NOT NULL,
    etl_id varchar(50),
    model_type varchar(50),
    description varchar(1000),
    stimulation varchar(1000),
    control_challenge varchar(500),
    challenge varchar(1000),
    sentization varchar(1000),
    zygosity varchar(250),
    experimental_model varchar(250),
    animal_wild_type varchar(250),
    tissue varchar(250),
    cell_type varchar(250),
    cell_line varchar(250),
    body_substance varchar(250),
    component varchar(250),
    gene_id varchar(250)
);


CREATE TABLE biomart.bio_lit_pe_data (
    bio_lit_pe_data_id bigint NOT NULL,
    bio_lit_ref_data_id bigint NOT NULL,
    in_vivo_model_id bigint,
    in_vitro_model_id bigint,
    etl_id varchar(50),
    description varchar(2000)
);

CREATE TABLE biomart.bio_lit_ref_data (
    bio_lit_ref_data_id bigint NOT NULL,
    etl_id varchar(50),
    component varchar(100),
    component_class varchar(250),
    gene_id varchar(50),
    molecule_type varchar(50),
    variant varchar(250),
    reference_type varchar(50),
    reference_id varchar(250),
    reference_title varchar(2000),
    back_references varchar(1000),
    study_type varchar(250),
    disease varchar(250),
    disease_icd10 varchar(250),
    disease_mesh varchar(250),
    disease_site varchar(250),
    disease_stage varchar(250),
    disease_grade varchar(250),
    disease_types varchar(250),
    disease_description varchar(1000),
    physiology varchar(250),
    stat_clinical varchar(500),
    stat_clinical_correlation varchar(250),
    stat_tests varchar(500),
    stat_coefficient varchar(500),
    stat_p_value varchar(100),
    stat_description varchar(1000)
);

CREATE TABLE biomart.bio_lit_sum_data (
    bio_lit_sum_data_id bigint NOT NULL,
    etl_id varchar(50),
    disease_site varchar(250),
    target varchar(50),
    variant varchar(50),
    data_type varchar(50),
    alteration_type varchar(100),
    total_frequency varchar(50),
    total_affected_cases varchar(50),
    summary varchar(1000)
);

CREATE TABLE biomart.bio_marker (
    bio_marker_id bigint NOT NULL,
    bio_marker_name varchar(200),
    bio_marker_description varchar(1000),
    organism varchar(200),
    primary_source_code varchar(200),
    primary_external_id varchar(200),
    bio_marker_type varchar(200) NOT NULL
);

CREATE TABLE biomart.bio_marker_correl_mv (
    bio_marker_id bigint,
    asso_bio_marker_id bigint,
    correl_type varchar(15),
    mv_id bigint
);

CREATE TABLE biomart.bio_patient (
    bio_patient_id bigint NOT NULL,
    first_name varchar(200),
    last_name varchar(200),
    middle_name varchar(200),
    birth_date timestamp, 
    birth_date_orig varchar(200),
    gender_code varchar(200),
    race_code varchar(200),
    ethnic_group_code varchar(200),
    address_zip_code varchar(200),
    country_code varchar(200),
    informed_consent_code varchar(200),
    bio_experiment_id bigint,
    bio_clinical_trial_p_group_id bigint
);

CREATE TABLE biomart.bio_patient_event (
    bio_patient_event_id bigint NOT NULL,
    bio_patient_id bigint NOT NULL,
    event_code varchar(200),
    event_type_code varchar(200),
    event_date timestamp, 
    site varchar(400),
    bio_clinic_trial_timepoint_id bigint NOT NULL
);

CREATE TABLE biomart.bio_patient_event_attr (
    bio_patient_attr_code varchar(200) NOT NULL,
    attribute_text_value varchar(200),
    attribute_numeric_value varchar(200),
    bio_clinic_trial_attr_id bigint NOT NULL,
    bio_patient_attribute_id bigint NOT NULL,
    bio_patient_event_id bigint NOT NULL
);

CREATE TABLE biomart.bio_sample (
    bio_sample_id bigint NOT NULL,
    bio_sample_type varchar(200) NOT NULL,
    characteristics varchar(1000),
    source_code varchar(200),
    experiment_id bigint,
    bio_subject_id bigint,
    source varchar(200),
    bio_bank_id bigint,
    bio_patient_event_id bigint,
    bio_cell_line_id bigint,
    bio_sample_name varchar(100)
);

CREATE TABLE biomart.bio_stats_exp_marker (
    bio_marker_id bigint NOT NULL,
    bio_experiment_id bigint NOT NULL,
    bio_stats_exp_marker_id bigint
);

CREATE TABLE biomart.bio_subject (
    bio_subject_id bigint NOT NULL,
    site_subject_id bigint,
    source varchar(200),
    source_code varchar(200),
    status varchar(200),
    organism varchar(200),
    bio_subject_type varchar(200) NOT NULL
);

CREATE TABLE biomart.bio_taxonomy (
    bio_taxonomy_id bigint NOT NULL,
    taxon_name varchar(200) NOT NULL,
    taxon_label varchar(200) NOT NULL,
    ncbi_tax_id varchar(200)
);

CREATE TABLE biomart.biobank_sample (
    sample_tube_id varchar(255) NOT NULL,
    accession_number varchar(255) NOT NULL,
    client_sample_tube_id varchar(255) NOT NULL,
    container_id varchar(255) NOT NULL,
    import_date timestamp not null,
    source_type varchar(255) NOT NULL
);

CREATE TABLE biomart.ctd2_clin_inhib_effect (
    ctd_cie_seq bigint,
    ctd_study_id bigint,
    event_description_name varchar(2000),
    event_definition_name varchar(2000),
    adverse_effect_name varchar(2000),
    signal_effect_name varchar(2000),
    pharmaco_parameter_name varchar(500),
    discontinuation_rate_value varchar(250),
    beneficial_effect_name varchar(2000),
    drug_effect varchar(2000),
    clinical_variable_name varchar(250),
    qp_sm_percentage_change varchar(250),
    qp_sm_absolute_change varchar(250),
    qp_sm_rate_of_change varchar(250),
    qp_sm_treatment_period varchar(250),
    qp_sm_group_change varchar(250),
    qp_sm_p_value varchar(250),
    ce_sm_no varchar(250),
    ce_sm_event_rate varchar(250),
    ce_time_to_event varchar(250),
    ce_reduction varchar(250),
    ce_p_value varchar(250),
    clinical_correlation varchar(2000),
    coefficient_value varchar(250),
    statistics_p_value varchar(250),
    statistics_description varchar(2000),
    primary_endpoint_type varchar(250),
    primary_endpoint_definition varchar(2000),
    primary_endpoint_test_name varchar(2000),
    primary_endpoint_time_period varchar(2000),
    primary_endpoint_change varchar(2000),
    primary_endpoint_p_value varchar(2000),
    secondary_endpoint_type varchar(2000),
    secondary_endpoint_definition varchar(2000),
    secondary_endpoint_test_name varchar(2000),
    secondary_endpoint_time_period varchar(2000),
    secondary_endpoint_change varchar(2000),
    secondary_endpoint_p_value varchar(2000)
);

CREATE TABLE biomart.ctd2_disease (
    ctd_disease_seq bigint,
    ctd_study_id bigint,
    disease_type_name varchar(500),
    disease_common_name varchar(500),
    icd10_name varchar(250),
    mesh_name varchar(250),
    study_type_name varchar(2000),
    physiology_name varchar(500)
);

CREATE TABLE biomart.ctd2_inhib_details (
    ctd_inhib_seq bigint,
    ctd_study_id bigint,
    common_name_name varchar(500),
    standard_name_name varchar(500),
    experimental_detail_dose varchar(2000),
    exp_detail_exposure_period varchar(4000),
    exp_detail_treatment_name varchar(4000),
    exp_detail_admin_route varchar(4000),
    exp_detail_description varchar(4000),
    exp_detail_placebo varchar(250),
    comparator_name_name varchar(250),
    comp_treatment_name varchar(4000),
    comp_admin_route varchar(4000),
    comp_dose varchar(2000),
    comp_exposure_period varchar(2000)
);

CREATE TABLE biomart.ctd2_study (
    ctd_study_id bigint,
    ref_article_protocol_id varchar(1000),
    reference_id integer NOT NULL,
    pubmed_id varchar(250),
    pubmed_title varchar(2000),
    protocol_id varchar(1000),
    protocol_title varchar(2000)
);

CREATE TABLE biomart.ctd2_trial_details (
    ctd_td_seq bigint,
    ctd_study_id bigint,
    control varchar(1000),
    blinding_procedure varchar(1000),
    no_of_arms varchar(1000),
    sponsor varchar(1000),
    patient_studied varchar(1000),
    source_type varchar(1000),
    trial_description varchar(1000),
    arm_name varchar(250),
    patient_study varchar(250),
    class_type varchar(250),
    class_value varchar(250),
    asthma_duration varchar(250),
    region varchar(250),
    age varchar(100),
    gender varchar(100),
    minor_participation varchar(100),
    symptom_score varchar(100),
    rescue_medication varchar(1000),
    therapeutic_intervention varchar(255),
    smokers varchar(255),
    former_smokers varchar(255),
    never_smokers varchar(255),
    smoking_pack_years varchar(255),
    pulm_path_name varchar(255),
    pulm_path_pct varchar(50),
    pulm_path_value varchar(50),
    pulm_path_method varchar(255),
    allow_med_therapy_ocs varchar(1000),
    allow_med_therapy_ics varchar(1000),
    allow_med_therapy_laba varchar(1000),
    allow_med_therapy_ltra varchar(1000),
    allow_med_therapy_desc varchar(1000),
    allow_med_therapy_cortster varchar(1000),
    allow_med_therapy_immuno varchar(1000),
    allow_med_therapy_cyto varchar(1000),
    allow_med_treat_ocs varchar(1000),
    allow_med_treat_ics varchar(1000),
    allow_med_treat_laba varchar(1000),
    allow_med_treat_ltra varchar(1000),
    allow_med_treat_desc varchar(1000),
    allow_med_treat_cortster varchar(1000),
    allow_med_treat_immuno varchar(1000),
    allow_med_treat_cyto varchar(1000),
    pat_char_base_clin_var varchar(500),
    pat_char_base_clin_var_pct varchar(250),
    pat_char_base_clin_var_value varchar(250),
    biomarker_name_name varchar(250),
    pat_char_biomarker_pct varchar(250),
    pat_char_biomarker_value varchar(250),
    pat_char_cellinfo_name varchar(250),
    pat_char_cellinfo_type varchar(250),
    pat_char_cellinfo_count varchar(250),
    pat_char_priormed_name varchar(250),
    pat_char_priormed_pct varchar(500),
    pat_char_priormed_dose varchar(250),
    disease_phenotype_name varchar(1000),
    disease_severity_name varchar(500),
    incl_age varchar(1000),
    incl_difficult_to_treat varchar(1000),
    incl_disease_diagnosis varchar(1000),
    incl_steroid_dose varchar(1000),
    incl_laba varchar(1000),
    incl_ocs varchar(1000),
    incl_xolair varchar(1000),
    incl_ltra_inhibitor varchar(1000),
    incl_fev1 varchar(1000),
    incl_fev1_reversibility varchar(1000),
    incl_smoking varchar(1000),
    incl_tlc varchar(1000),
    incl_fvc varchar(1000),
    incl_dlco varchar(1000),
    incl_sgrq varchar(1000),
    incl_hrct varchar(1000),
    incl_biopsy varchar(1000),
    incl_dypsnea_on_exertion varchar(1000),
    incl_concomitant_med varchar(1000),
    incl_former_smokers varchar(1000),
    incl_never_smokers varchar(1000),
    incl_smoking_pack_years varchar(1000),
    incl_fev_fvc varchar(1000),
    trial_des_minimal_symptom varchar(1000),
    trial_des_rescue_med varchar(1000),
    trial_des_exclusion_criteria varchar(1000),
    trial_des_open_label_status varchar(250),
    trial_des_random_status varchar(250),
    trial_des_nature_of_trial varchar(250),
    trial_des_blinded_status varchar(250),
    trial_des_run_in_period varchar(1000),
    trial_des_treatment varchar(1000),
    trial_des_washout_period varchar(1000),
    trial_status_name varchar(1000),
    trial_phase_name varchar(1000)
);

CREATE TABLE biomart.ctd_allowed_meds_treatment (
    ctd_study_id bigint,
    trtmt_ocs varchar(4000),
    trtmt_ics varchar(4000),
    trtmt_laba varchar(4000),
    trtmt_ltra varchar(4000),
    trtmt_corticosteroids varchar(4000),
    trtmt_anti_fibrotics varchar(4000),
    trtmt_immunosuppressive varchar(4000),
    trtmt_cytotoxic varchar(4000)
);

CREATE TABLE biomart.ctd_full (
    clinical_trial_design_id bigint,
    ref_article_protocol_id varchar(200),
    ref_record_id varchar(200),
    ref_back_reference varchar(200),
    ref_article_pmid varchar(200),
    ref_protocol_id varchar(200),
    ref_title varchar(200),
    study_type varchar(200),
    common_name varchar(200),
    icd10 varchar(200),
    mesh varchar(200),
    disease_type varchar(200),
    physiology_name varchar(200),
    trial_status varchar(200),
    trial_phase varchar(200),
    nature_of_trial varchar(200),
    randomization varchar(200),
    blinded_trial varchar(200),
    trial_type varchar(200),
    run_in_period varchar(200),
    treatment_period varchar(200),
    washout_period varchar(200),
    open_label_extension varchar(200),
    sponsor varchar(200),
    trial_nbr_of_patients_studied varchar(200),
    source_type varchar(200),
    trial_age varchar(200),
    disease_severity varchar(200),
    difficult_to_treat varchar(200),
    asthma_diagnosis varchar(200),
    inhaled_steroid_dose varchar(200),
    laba varchar(200),
    ocs varchar(200),
    xolair varchar(200),
    ltra_inhibitors varchar(200),
    asthma_phenotype varchar(200),
    fev1 varchar(200),
    fev1_reversibility varchar(200),
    tlc varchar(200),
    fev1_fvc varchar(200),
    fvc varchar(200),
    dlco varchar(200),
    sgrq varchar(200),
    hrct varchar(200),
    biopsy varchar(200),
    dyspnea_on_exertion varchar(200),
    concomitant_med varchar(200),
    trial_smokers_pct varchar(200),
    trial_former_smokers_pct varchar(200),
    trial_never_smokers_pct varchar(200),
    trial_pack_years varchar(200),
    exclusion_criteria varchar(200),
    minimal_symptoms varchar(200),
    rescue_medication_use varchar(200),
    control_details varchar(200),
    blinding_procedure varchar(200),
    number_of_arms varchar(200),
    description varchar(200),
    arm varchar(200),
    arm_nbr_of_patients_studied varchar(200),
    arm_classification_type varchar(200),
    arm_classification_value varchar(200),
    arm_asthma_duration varchar(200),
    arm_geographic_region varchar(200),
    arm_age varchar(200),
    arm_gender varchar(200),
    arm_smokers_pct varchar(200),
    arm_former_smokers_pct varchar(200),
    arm_never_smokers_pct varchar(200),
    arm_pack_years varchar(200),
    minority_participation varchar(200),
    baseline_symptom_score varchar(200),
    baseline_rescue_medication_use varchar(200),
    clinical_variable varchar(200),
    clinical_variable_pct varchar(200),
    clinical_variable_value varchar(200),
    prior_med_drug_name varchar(200),
    prior_med_pct varchar(200),
    prior_med_value varchar(200),
    biomarker_name varchar(200),
    biomarker_pct varchar(200),
    biomarker_value varchar(200),
    cellinfo_type varchar(200),
    cellinfo_count varchar(200),
    cellinfo_source varchar(200),
    pulmonary_pathology_name varchar(200),
    pulmpath_patient_pct varchar(200),
    pulmpath_value_unit varchar(200),
    pulmpath_method varchar(200),
    runin_ocs varchar(200),
    runin_ics varchar(200),
    runin_laba varchar(200),
    runin_ltra varchar(200),
    runin_corticosteroids varchar(200),
    runin_anti_fibrotics varchar(200),
    runin_immunosuppressive varchar(200),
    runin_cytotoxic varchar(200),
    runin_description varchar(200),
    trtmt_ocs varchar(200),
    trtmt_ics varchar(200),
    trtmt_laba varchar(200),
    trtmt_ltra varchar(200),
    trtmt_corticosteroids varchar(200),
    trtmt_anti_fibrotics varchar(200),
    trtmt_immunosuppressive varchar(200),
    trtmt_cytotoxic varchar(200),
    trtmt_description varchar(200),
    drug_inhibitor_common_name varchar(200),
    drug_inhibitor_standard_name varchar(200),
    drug_inhibitor_cas_id varchar(200),
    drug_inhibitor_dose varchar(200),
    drug_inhibitor_route_of_admin varchar(200),
    drug_inhibitor_trtmt_regime varchar(200),
    comparator_name varchar(200),
    comparator_dose varchar(200),
    comparator_time_period varchar(200),
    comparator_route_of_admin varchar(200),
    treatment_regime varchar(200),
    placebo varchar(200),
    experiment_description varchar(200),
    primary_endpoint_type varchar(200),
    primary_endpoint_definition varchar(200),
    primary_endpoint_change varchar(200),
    primary_endpoint_time_period varchar(200),
    primary_endpoint_stat_test varchar(200),
    primary_endpoint_p_value varchar(200),
    secondary_type varchar(200),
    secondary_type_definition varchar(200),
    secondary_type_change varchar(200),
    secondary_type_time_period varchar(200),
    secondary_type_p_value varchar(200),
    secondary_type_stat_test varchar(200),
    clinical_variable_name varchar(200),
    pct_change_from_baseline varchar(200),
    abs_change_from_baseline varchar(200),
    rate_of_change_from_baseline varchar(200),
    average_over_treatment_period varchar(200),
    within_group_changes varchar(200),
    stat_measure_p_value varchar(200),
    definition_of_the_event varchar(200),
    number_of_events varchar(200),
    event_rate varchar(200),
    time_to_event varchar(200),
    event_pct_reduction varchar(200),
    event_p_value varchar(200),
    event_description varchar(200),
    discontinuation_rate varchar(200),
    response_rate varchar(200),
    downstream_signaling_effects varchar(200),
    beneficial_effects varchar(200),
    adverse_effects varchar(200),
    pk_pd_parameter varchar(200),
    pk_pd_value varchar(200),
    effect_description varchar(200),
    biomolecule_name varchar(200),
    biomolecule_id varchar(200),
    biomolecule_type varchar(200),
    biomarker varchar(200),
    biomarker_type varchar(200),
    baseline_expr_pct varchar(200),
    baseline_expr_number varchar(200),
    baseline_expr_value_fold_mean varchar(200),
    baseline_expr_sd varchar(200),
    baseline_expr_sem varchar(200),
    baseline_expr_unit varchar(200),
    expr_after_trtmt_pct varchar(200),
    expr_after_trtmt_number varchar(200),
    expr_aftertrtmt_valuefold_mean varchar(200),
    expr_after_trtmt_sd varchar(200),
    expr_after_trtmt_sem varchar(200),
    expr_after_trtmt_unit varchar(200),
    expr_chg_source_type varchar(200),
    expr_chg_technique varchar(200),
    expr_chg_description varchar(200),
    clinical_correlation varchar(200),
    statistical_test varchar(200),
    statistical_coefficient_value varchar(200),
    statistical_test_p_value varchar(200),
    statistical_test_description varchar(200),
    drug_inhibitor_time_period varchar(200)
);

CREATE TABLE biomart.ctd_biomarker (
    ctd_study_id bigint,
    biomarker_name varchar(2000),
    biomarker_pct varchar(4000),
    biomarker_value varchar(4000)
);

CREATE TABLE biomart.ctd_disease (
    ctd_study_id bigint,
    common_name varchar(4000),
    icd10 varchar(4000),
    mesh varchar(4000),
    disease_severity varchar(4000)
);

CREATE TABLE biomart.ctd_drug_inhib (
    ctd_study_id bigint,
    drug_inhibitor_common_name varchar(4000),
    drug_inhibitor_standard_name varchar(4000),
    drug_inhibitor_cas_id varchar(4000)
);

CREATE TABLE biomart.ctd_inclusion_criteria (
    ctd_study_id bigint,
    inhaled_steroid_dose varchar(4000),
    laba varchar(4000),
    ocs varchar(4000),
    xolair varchar(4000),
    ltra_inhibitors varchar(4000),
    asthma_phenotype varchar(4000),
    fev1 varchar(4000)
);

CREATE TABLE biomart.ctd_primary_endpts (
    ctd_study_id bigint,
    primary_type varchar(4000),
    primary_type_definition varchar(4000),
    primary_type_time_period varchar(4000),
    primary_type_change varchar(4000),
    primary_type_p_value varchar(4000),
    id bigint
);

CREATE TABLE biomart.ctd_sec_endpts (
    ctd_study_id bigint,
    secondary_type varchar(4000),
    secondary_type_definition varchar(4000),
    secondary_type_time_period varchar(4000),
    secondary_type_change varchar(4000),
    secondary_type_p_value varchar(4000),
    id bigint
);

CREATE TABLE biomart.ctd_study (
    ctd_study_id bigint,
    ref_article_protocol_id varchar(4000),
    ref_article_pmid varchar(4000),
    ref_protocol_id varchar(4000)
);

CREATE TABLE "BIOMART"."BIO_AD_HOC_PROPERTY" 
   ("AD_HOC_PROPERTY_ID"numeric(22,0), 
	"BIO_DATA_ID" numeric(22,0), 
	"PROPERTY_KEY" varchar(50), 
	"PROPERTY_VALUE" varchar(2000)
   )  ;

CREATE SEQUENCE biomart.bio_assay_data_stats_seq as bigint NO MINVALUE no MAXVALUE INCREMENT BY 1 START WITH 1;

CREATE SEQUENCE biomart.hibernate_sequence as bigint NO MINVALUE no MAXVALUE INCREMENT BY 1 START WITH 1;

CREATE SEQUENCE biomart.seq_bio_data_fact_id as bigint NO MINVALUE no MAXVALUE INCREMENT BY 1 START WITH 1;

CREATE SEQUENCE biomart.seq_bio_data_id as bigint NO MINVALUE no MAXVALUE INCREMENT BY 1 START WITH 1;

CREATE SEQUENCE biomart.seq_clinical_trial_design_id as bigint NO MINVALUE no MAXVALUE INCREMENT BY 1 START WITH 1;


ALTER TABLE biomart.bio_assay_analysis_data_tea
    ADD CONSTRAINT bio_aa_data_t_pk PRIMARY KEY (bio_asy_analysis_data_id);

ALTER TABLE biomart.bio_asy_analysis_pltfm
    ADD CONSTRAINT bio_assay_analysis_platform_pk PRIMARY KEY (bio_asy_analysis_pltfm_id);

ALTER TABLE biomart.bio_assay_platform
    ADD CONSTRAINT bio_assay_platform_pk PRIMARY KEY (bio_assay_platform_id);

ALTER TABLE biomart.bio_assay_sample
    ADD CONSTRAINT bio_assay_sample_pk PRIMARY KEY (bio_assay_id, bio_sample_id, bio_clinic_trial_timepoint_id);

ALTER TABLE biomart.bio_asy_data_stats_all
    ADD CONSTRAINT bio_asy_dt_stats_pk PRIMARY KEY (bio_assay_data_stats_id);

ALTER TABLE biomart.bio_assay_data_stats
    ADD CONSTRAINT bio_asy_dt_stats_s_pk PRIMARY KEY (bio_assay_data_stats_id);

ALTER TABLE biomart.bio_assay_feature_group
    ADD CONSTRAINT bio_asy_feature_grp_pk PRIMARY KEY (bio_assay_feature_group_id);

ALTER TABLE biomart.bio_cgdcp_data
    ADD CONSTRAINT bio_cancer_gene_curation_fact_ PRIMARY KEY (bio_data_id);

ALTER TABLE biomart.bio_clinc_trial_attr
    ADD CONSTRAINT bio_clinical_trial_patient_grp PRIMARY KEY (bio_clinc_trial_attr_id);

ALTER TABLE biomart.bio_clinc_trial_pt_group
    ADD CONSTRAINT bio_clinical_trial_pt_group PRIMARY KEY (bio_clinical_trial_p_group_id);

ALTER TABLE biomart.bio_clinc_trial_time_pt
    ADD CONSTRAINT bio_clinical_trial_time_point_ PRIMARY KEY (bio_clinc_trial_tm_pt_id);

ALTER TABLE biomart.bio_concept_code
    ADD CONSTRAINT bio_concept_code_pk PRIMARY KEY (bio_concept_code_id);

ALTER TABLE biomart.bio_concept_code
    ADD CONSTRAINT bio_concept_code_uk UNIQUE (bio_concept_code, code_type_name);

ALTER TABLE biomart.bio_content_reference
    ADD CONSTRAINT bio_content_ref_n_pk PRIMARY KEY (bio_content_reference_id);

ALTER TABLE biomart.bio_asy_analysis_dataset
    ADD CONSTRAINT bio_data_analysis_dataset_pk PRIMARY KEY (bio_assay_dataset_id, bio_assay_analysis_id);

ALTER TABLE biomart.bio_assay_analysis
    ADD CONSTRAINT bio_data_anl_pk PRIMARY KEY (bio_assay_analysis_id);

ALTER TABLE biomart.bio_data_attribute
    ADD CONSTRAINT bio_data_attr_pk PRIMARY KEY (bio_data_attribute_id);

ALTER TABLE biomart.bio_data_compound
    ADD CONSTRAINT bio_data_compound_pk PRIMARY KEY (bio_data_id, bio_compound_id);

ALTER TABLE biomart.bio_data_correlation
    ADD CONSTRAINT bio_data_correlation_pk PRIMARY KEY (bio_data_correl_id);

ALTER TABLE biomart.bio_data_disease
    ADD CONSTRAINT bio_data_disease_pk PRIMARY KEY (bio_data_id, bio_disease_id);

ALTER TABLE biomart.bio_data_ext_code
    ADD CONSTRAINT bio_data_ext_code_pk PRIMARY KEY (bio_data_ext_code_id);

ALTER TABLE biomart.bio_data_literature
    ADD CONSTRAINT bio_data_literature_pk PRIMARY KEY (bio_data_id);

ALTER TABLE biomart.bio_data_uid
    ADD CONSTRAINT bio_data_uid_pk PRIMARY KEY (bio_data_id);

ALTER TABLE biomart.bio_data_uid
    ADD CONSTRAINT bio_data_uid_uk UNIQUE (unique_id);

ALTER TABLE biomart.bio_assay_dataset
    ADD CONSTRAINT bio_dataset_pk PRIMARY KEY (bio_assay_dataset_id);

ALTER TABLE biomart.bio_assay_data
    ADD CONSTRAINT bio_experiment_data_fact_pk PRIMARY KEY (bio_assay_data_id);

ALTER TABLE biomart.bio_curation_dataset
    ADD CONSTRAINT bio_external_analysis_pk PRIMARY KEY (bio_curation_dataset_id);

ALTER TABLE biomart.bio_curated_data
    ADD CONSTRAINT bio_externalanalysis_fact_pk PRIMARY KEY (bio_data_id);

ALTER TABLE biomart.bio_lit_alt_data
    ADD CONSTRAINT bio_lit_alt_data_pk PRIMARY KEY (bio_lit_alt_data_id);

ALTER TABLE biomart.bio_lit_amd_data
    ADD CONSTRAINT bio_lit_amd_data_pk PRIMARY KEY (bio_lit_amd_data_id);

ALTER TABLE biomart.bio_lit_inh_data
    ADD CONSTRAINT bio_lit_inh_data_pk PRIMARY KEY (bio_lit_inh_data_id);

ALTER TABLE biomart.bio_lit_int_data
    ADD CONSTRAINT bio_lit_int_data_pk PRIMARY KEY (bio_lit_int_data_id);

ALTER TABLE biomart.bio_lit_model_data
    ADD CONSTRAINT bio_lit_model_data_pk PRIMARY KEY (bio_lit_model_data_id);

ALTER TABLE biomart.bio_lit_pe_data
    ADD CONSTRAINT bio_lit_pe_data_pk PRIMARY KEY (bio_lit_pe_data_id);

ALTER TABLE biomart.bio_lit_ref_data
    ADD CONSTRAINT bio_lit_ref_data_pk PRIMARY KEY (bio_lit_ref_data_id);

ALTER TABLE biomart.bio_lit_sum_data
    ADD CONSTRAINT bio_lit_sum_data_pk PRIMARY KEY (bio_lit_sum_data_id);

ALTER TABLE biomart.bio_data_correl_descr
    ADD CONSTRAINT bio_marker_relationship_pk PRIMARY KEY (bio_data_correl_descr_id);

ALTER TABLE biomart.bio_patient_event_attr
    ADD CONSTRAINT bio_patient_attribute_pk PRIMARY KEY (bio_patient_attribute_id);

ALTER TABLE biomart.bio_patient_event
    ADD CONSTRAINT bio_patient_event_pk PRIMARY KEY (bio_patient_event_id);

ALTER TABLE biomart.bio_patient
    ADD CONSTRAINT bio_patient_pk PRIMARY KEY (bio_patient_id);

ALTER TABLE biomart.bio_stats_exp_marker
    ADD CONSTRAINT bio_s_e_m_pk PRIMARY KEY (bio_marker_id, bio_experiment_id);

ALTER TABLE biomart.bio_subject
    ADD CONSTRAINT bio_subject_pk PRIMARY KEY (bio_subject_id);

ALTER TABLE biomart.bio_taxonomy
    ADD CONSTRAINT bio_taxon_pk PRIMARY KEY (bio_taxonomy_id);

ALTER TABLE biomart.biobank_sample
    ADD CONSTRAINT biobank_sample_pkey PRIMARY KEY (sample_tube_id);

ALTER TABLE biomart.bio_marker
    ADD CONSTRAINT biomarker_pk PRIMARY KEY (bio_marker_id);

ALTER TABLE biomart.bio_sample
    ADD CONSTRAINT biosample_pk PRIMARY KEY (bio_sample_id);

ALTER TABLE biomart.bio_cell_line
    ADD CONSTRAINT celllinedictionary_pk PRIMARY KEY (bio_cell_line_id);

ALTER TABLE biomart.bio_clinical_trial
    ADD CONSTRAINT clinicaltrialdim_pk PRIMARY KEY (bio_experiment_id);

ALTER TABLE biomart.bio_compound
    ADD CONSTRAINT compounddim_pk PRIMARY KEY (bio_compound_id);

ALTER TABLE biomart.bio_disease
    ADD CONSTRAINT diseasedim_pk PRIMARY KEY (bio_disease_id);

ALTER TABLE biomart.bio_experiment
    ADD CONSTRAINT experimentdim_pk PRIMARY KEY (bio_experiment_id);

ALTER TABLE biomart.bio_content
    ADD CONSTRAINT external_file_pk PRIMARY KEY (bio_file_content_id);

ALTER TABLE biomart.bio_content_repository
    ADD CONSTRAINT external_file_repository_pk PRIMARY KEY (bio_content_repo_id);

ALTER TABLE biomart.bio_assay
    ADD CONSTRAINT rbmorderdim_pk PRIMARY KEY (bio_assay_id);

ALTER TABLE biomart.bio_marker
    ADD CONSTRAINT sys_c0020430 UNIQUE (organism, primary_external_id);

ALTER TABLE biomart.bio_assay_analysis_data
    ADD CONSTRAINT bio_assay_analysis_data_n_fk1 FOREIGN KEY (bio_assay_analysis_id) references biomart.bio_assay_analysis(bio_assay_analysis_id);

ALTER TABLE biomart.bio_assay_analysis_data
    ADD CONSTRAINT bio_assay_analysis_data_n_fk2 FOREIGN KEY (bio_experiment_id) references biomart.bio_experiment(bio_experiment_id);

ALTER TABLE biomart.bio_assay_analysis_data
    ADD CONSTRAINT bio_assay_analysis_data_n_fk3 FOREIGN KEY (bio_assay_platform_id) references biomart.bio_assay_platform(bio_assay_platform_id);

ALTER TABLE biomart.bio_assay_analysis_data_tea
    ADD CONSTRAINT bio_assay_analysis_data_t_fk1 FOREIGN KEY (bio_assay_analysis_id) references biomart.bio_assay_analysis(bio_assay_analysis_id);

ALTER TABLE biomart.bio_assay_analysis_data_tea
    ADD CONSTRAINT bio_assay_analysis_data_t_fk2 FOREIGN KEY (bio_experiment_id) references biomart.bio_experiment(bio_experiment_id);

ALTER TABLE biomart.bio_assay_analysis_data_tea
    ADD CONSTRAINT bio_assay_analysis_data_t_fk3 FOREIGN KEY (bio_assay_platform_id) references biomart.bio_assay_platform(bio_assay_platform_id);

ALTER TABLE biomart.bio_assay_analysis
    ADD CONSTRAINT bio_assay_ans_pltfm_fk FOREIGN KEY (bio_asy_analysis_pltfm_id) references biomart.bio_asy_analysis_pltfm(bio_asy_analysis_pltfm_id);

ALTER TABLE biomart.bio_assay_sample
    ADD CONSTRAINT bio_assay_sample_bio_assay_fk FOREIGN KEY (bio_assay_id) references biomart.bio_assay(bio_assay_id);

ALTER TABLE biomart.bio_assay_sample
    ADD CONSTRAINT bio_assay_sample_bio_sample_fk FOREIGN KEY (bio_sample_id) references biomart.bio_sample(bio_sample_id);

ALTER TABLE biomart.bio_assay_analysis_data
    ADD CONSTRAINT bio_asy_ad_fg_fk FOREIGN KEY (bio_assay_feature_group_id) references biomart.bio_assay_feature_group(bio_assay_feature_group_id);

ALTER TABLE biomart.bio_assay_analysis_data_tea
    ADD CONSTRAINT bio_asy_ad_tea_fg_fk FOREIGN KEY (bio_assay_feature_group_id) references biomart.bio_assay_feature_group(bio_assay_feature_group_id);

ALTER TABLE biomart.bio_assay
    ADD CONSTRAINT bio_asy_asy_pfm_fk FOREIGN KEY (bio_assay_platform_id) references biomart.bio_assay_platform(bio_assay_platform_id);

ALTER TABLE biomart.bio_assay_data
    ADD CONSTRAINT bio_asy_dt_ds_fk FOREIGN KEY (bio_assay_dataset_id) references biomart.bio_assay_dataset(bio_assay_dataset_id);

ALTER TABLE biomart.bio_assay_data_stats
    ADD CONSTRAINT bio_asy_dt_fg_fk FOREIGN KEY (bio_assay_feature_group_id) references biomart.bio_assay_feature_group(bio_assay_feature_group_id);

ALTER TABLE biomart.bio_assay_data_stats
    ADD CONSTRAINT bio_asy_dt_stat_exp_s_fk FOREIGN KEY (bio_experiment_id) references biomart.bio_experiment(bio_experiment_id);

ALTER TABLE biomart.bio_assay_data_stats
    ADD CONSTRAINT bio_asy_dt_stats_ds_s_fk FOREIGN KEY (bio_assay_dataset_id) references biomart.bio_assay_dataset(bio_assay_dataset_id);

ALTER TABLE biomart.bio_asy_data_stats_all
    ADD CONSTRAINT bio_asy_dt_stats_smp_fk FOREIGN KEY (bio_sample_id) references biomart.bio_sample(bio_sample_id);

ALTER TABLE biomart.bio_assay_data_stats
    ADD CONSTRAINT bio_asy_dt_stats_smp_s_fk FOREIGN KEY (bio_sample_id) references biomart.bio_sample(bio_sample_id);

ALTER TABLE biomart.bio_assay_data
    ADD CONSTRAINT bio_asy_exp_fk FOREIGN KEY (bio_experiment_id) references biomart.bio_experiment(bio_experiment_id);

ALTER TABLE biomart.bio_clinc_trial_time_pt
    ADD CONSTRAINT bio_cli_trial_time_trl_fk FOREIGN KEY (bio_experiment_id) references biomart.bio_clinical_trial(bio_experiment_id);

ALTER TABLE biomart.bio_clinc_trial_pt_group
    ADD CONSTRAINT bio_clinc_trl_pt_grp_exp_fk FOREIGN KEY (bio_experiment_id) references biomart.bio_clinical_trial(bio_experiment_id);

ALTER TABLE biomart.bio_clinical_trial
    ADD CONSTRAINT bio_clinical_trial_bio_experim FOREIGN KEY (bio_experiment_id) references biomart.bio_experiment(bio_experiment_id);

ALTER TABLE biomart.bio_clinc_trial_attr
    ADD CONSTRAINT bio_clinical_trial_property_bi FOREIGN KEY (bio_experiment_id) references biomart.bio_clinical_trial(bio_experiment_id);

ALTER TABLE biomart.bio_content_reference
    ADD CONSTRAINT bio_content_ref_cont_fk FOREIGN KEY (bio_content_id) references biomart.bio_content(bio_file_content_id);

ALTER TABLE biomart.bio_asy_analysis_dataset
    ADD CONSTRAINT bio_data_anl_ds_anl_fk FOREIGN KEY (bio_assay_analysis_id) references biomart.bio_assay_analysis(bio_assay_analysis_id);

ALTER TABLE biomart.bio_asy_analysis_dataset
    ADD CONSTRAINT bio_data_anl_ds_fk FOREIGN KEY (bio_assay_dataset_id) references biomart.bio_assay_dataset(bio_assay_dataset_id);

ALTER TABLE biomart.bio_assay_dataset
    ADD CONSTRAINT bio_dataset_experiment_fk FOREIGN KEY (bio_experiment_id) references biomart.bio_experiment(bio_experiment_id);

ALTER TABLE biomart.bio_data_compound
    ADD CONSTRAINT bio_df_cmp_fk FOREIGN KEY (bio_compound_id) references biomart.bio_compound(bio_compound_id);

ALTER TABLE biomart.bio_data_disease
    ADD CONSTRAINT bio_df_disease_fk FOREIGN KEY (bio_disease_id) references biomart.bio_disease(bio_disease_id);

ALTER TABLE biomart.bio_assay_data
    ADD CONSTRAINT bio_exp_data_fact_samp_fk FOREIGN KEY (bio_sample_id) references biomart.bio_sample(bio_sample_id);

ALTER TABLE biomart.bio_curated_data
    ADD CONSTRAINT bio_ext_analys_ext_anl_fk FOREIGN KEY (bio_curation_dataset_id) references biomart.bio_curation_dataset(bio_curation_dataset_id);

ALTER TABLE biomart.bio_curation_dataset
    ADD CONSTRAINT bio_ext_anl_pltfm_fk FOREIGN KEY (bio_asy_analysis_pltfm_id) references biomart.bio_asy_analysis_pltfm(bio_asy_analysis_pltfm_id);

ALTER TABLE biomart.bio_lit_alt_data
    ADD CONSTRAINT bio_lit_alt_ref_fk FOREIGN KEY (bio_lit_ref_data_id) references biomart.bio_lit_ref_data(bio_lit_ref_data_id);

ALTER TABLE biomart.bio_lit_amd_data
    ADD CONSTRAINT bio_lit_amd_alt_fk FOREIGN KEY (bio_lit_alt_data_id) references biomart.bio_lit_alt_data(bio_lit_alt_data_id);

ALTER TABLE biomart.bio_data_literature
    ADD CONSTRAINT bio_lit_curation_dataset_fk FOREIGN KEY (bio_curation_dataset_id) references biomart.bio_curation_dataset(bio_curation_dataset_id);

ALTER TABLE biomart.bio_lit_inh_data
    ADD CONSTRAINT bio_lit_inh_ref_fk FOREIGN KEY (bio_lit_ref_data_id) references biomart.bio_lit_ref_data(bio_lit_ref_data_id);

ALTER TABLE biomart.bio_lit_int_data
    ADD CONSTRAINT bio_lit_int_ref_fk FOREIGN KEY (bio_lit_ref_data_id) references biomart.bio_lit_ref_data(bio_lit_ref_data_id);

ALTER TABLE biomart.bio_lit_pe_data
    ADD CONSTRAINT bio_lit_pe_ref_fk FOREIGN KEY (bio_lit_ref_data_id) references biomart.bio_lit_ref_data(bio_lit_ref_data_id);

ALTER TABLE biomart.bio_data_correlation
    ADD CONSTRAINT bio_marker_link_bio_marker_rel FOREIGN KEY (bio_data_correl_descr_id) references biomart.bio_data_correl_descr(bio_data_correl_descr_id);

ALTER TABLE biomart.bio_patient
    ADD CONSTRAINT bio_patient_bio_clinic_tri_fk FOREIGN KEY (bio_clinical_trial_p_group_id) references biomart.bio_clinc_trial_pt_group(bio_clinical_trial_p_group_id);

ALTER TABLE biomart.bio_patient
    ADD CONSTRAINT bio_patient_bio_clinical_trial FOREIGN KEY (bio_experiment_id) references biomart.bio_clinical_trial(bio_experiment_id);

ALTER TABLE biomart.bio_patient
    ADD CONSTRAINT bio_patient_bio_subject_fk FOREIGN KEY (bio_patient_id) references biomart.bio_subject(bio_subject_id);

ALTER TABLE biomart.bio_patient_event_attr
    ADD CONSTRAINT bio_pt_attr_trl_attr_fk FOREIGN KEY (bio_clinic_trial_attr_id) references biomart.bio_clinc_trial_attr(bio_clinc_trial_attr_id);

ALTER TABLE biomart.bio_patient_event_attr
    ADD CONSTRAINT bio_pt_event_attr_evt_fk FOREIGN KEY (bio_patient_event_id) references biomart.bio_patient_event(bio_patient_event_id);

ALTER TABLE biomart.bio_patient_event
    ADD CONSTRAINT bio_pt_event_bio_pt_fk FOREIGN KEY (bio_patient_id) references biomart.bio_patient(bio_patient_id);

ALTER TABLE biomart.bio_patient_event
    ADD CONSTRAINT bio_pt_event_bio_trl_tp_fk FOREIGN KEY (bio_clinic_trial_timepoint_id) references biomart.bio_clinc_trial_time_pt(bio_clinc_trial_tm_pt_id);

ALTER TABLE biomart.bio_sample
    ADD CONSTRAINT bio_sample_bio_subject_fk FOREIGN KEY (bio_subject_id) references biomart.bio_subject(bio_subject_id);

ALTER TABLE biomart.bio_sample
    ADD CONSTRAINT bio_sample_cl_fk FOREIGN KEY (bio_cell_line_id) references biomart.bio_cell_line(bio_cell_line_id);

ALTER TABLE biomart.bio_sample
    ADD CONSTRAINT bio_sample_pt_evt_fk FOREIGN KEY (bio_patient_event_id) references biomart.bio_patient_event(bio_patient_event_id);

ALTER TABLE biomart.bio_data_taxonomy
    ADD CONSTRAINT bio_taxon_fk FOREIGN KEY (bio_taxonomy_id) references biomart.bio_taxonomy(bio_taxonomy_id);

ALTER TABLE biomart.bio_cell_line
    ADD CONSTRAINT cd_disease_fk FOREIGN KEY (bio_disease_id) references biomart.bio_disease(bio_disease_id);

ALTER TABLE biomart.bio_assay
    ADD CONSTRAINT dataset_experiment_fk FOREIGN KEY (experiment_id) references biomart.bio_experiment(bio_experiment_id);

ALTER TABLE biomart.bio_content
    ADD CONSTRAINT ext_file_cnt_cnt_repo_fk FOREIGN KEY (repository_id) references biomart.bio_content_repository(bio_content_repo_id);

-- Views
--set schema biomart;

--WARNING! ERRORS ENCOUNTERED DURING SQL PARSING!

/*
CREATE VIEW biomart.bio_lit_int_model_view
AS
SELECT DISTINCT s.bio_lit_int_data_id, s.experimental_model
FROM
(
SELECT a.bio_lit_int_data_id, b.experimental_model
FROM (
	bio_lit_int_data a INNER JOIN bio_lit_model_data b
		ON ((a.in_vivo_model_id = b.bio_lit_model_data_id))
	)
WHERE (b.experimental_model IS NOT NULL)

UNION

SELECT a.bio_lit_int_data_id, b.experimental_model
FROM (
	bio_lit_int_data a INNER JOIN bio_lit_model_data b
		ON ((a.in_vitro_model_id = b.bio_lit_model_data_id))
	)
WHERE (b.experimental_model IS NOT NULL) ) s;

CREATE VIEW biomart.ctd_arm_view
AS
SELECT row_number() OVER (
		ORDER BY v.ref_article_protocol_id, v.arm, v.arm_nbr_of_patients_studied
		) AS id, v.ref_article_protocol_id, v.arm, v.arm_nbr_of_patients_studied, v.arm_classification_type, v.
	arm_classification_value, v.arm_asthma_duration, v.arm_geographic_region, v.arm_age, v.arm_gender, v.arm_smokers_pct, v.
	arm_former_smokers_pct, v.arm_never_smokers_pct, v.arm_pack_years, v.minority_participation, v.baseline_symptom_score, v.
	baseline_rescue_medication_use
FROM (
	SELECT DISTINCT ctd_full.ref_article_protocol_id, ctd_full.arm, to_number((ctd_full.arm_nbr_of_patients_studied
				)::TEXT, '999999999999999'::TEXT) AS arm_nbr_of_patients_studied, ctd_full.arm_classification_type, ctd_full.
		arm_classification_value, ctd_full.arm_asthma_duration, ctd_full.arm_geographic_region, ctd_full.arm_age, ctd_full.
		arm_gender, ctd_full.arm_smokers_pct, ctd_full.arm_former_smokers_pct, ctd_full.arm_never_smokers_pct, ctd_full.
		arm_pack_years, ctd_full.minority_participation, ctd_full.baseline_symptom_score, ctd_full.
		baseline_rescue_medication_use
	FROM ctd_full
	WHERE (
			(ctd_full.arm IS NOT NULL) AND ((ctd_full.arm)::TEXT <> ''::TEXT
				)
			)
	ORDER BY ctd_full.ref_article_protocol_id, ctd_full.arm, to_number((ctd_full.arm_nbr_of_patients_studied
				)::TEXT, '999999999999999'::TEXT)
	) v;

CREATE VIEW biomart.ctd_biomarker_view
AS
SELECT row_number() OVER (
		ORDER BY v.ref_article_protocol_id, v.biomarker_name
		) AS id, v.ref_article_protocol_id, v.biomarker_name, v.biomarker_pct, v.biomarker_value
FROM (
	SELECT DISTINCT ctd_full.ref_article_protocol_id, ctd_full.biomarker_name, ctd_full.biomarker_pct, ctd_full.
		biomarker_value
	FROM ctd_full
	WHERE (
			(ctd_full.biomarker_name IS NOT NULL) AND ((ctd_full.biomarker_name)::TEXT <> ''::TEXT
				)
			)
	ORDER BY ctd_full.ref_article_protocol_id, ctd_full.biomarker_name
	) v;

CREATE VIEW biomart.ctd_cell_info_view
AS
SELECT row_number() OVER (
		ORDER BY v.ref_article_protocol_id, v.cellinfo_type
		) AS id, v.ref_article_protocol_id, v.cellinfo_type, v.cellinfo_count, v.cellinfo_source
FROM (
	SELECT DISTINCT ctd_full.ref_article_protocol_id, ctd_full.cellinfo_type, ctd_full.cellinfo_count, ctd_full.
		cellinfo_source
	FROM ctd_full
	WHERE (
			(ctd_full.cellinfo_type IS NOT NULL) AND ((ctd_full.cellinfo_type)::TEXT <> ''::TEXT
				)
			)
	ORDER BY ctd_full.ref_article_protocol_id, ctd_full.cellinfo_type
	) v;

CREATE VIEW biomart.ctd_clinical_chars_view
AS
SELECT row_number() OVER (
		ORDER BY v.ref_article_protocol_id, v.clinical_variable
		) AS id, v.ref_article_protocol_id, v.clinical_variable, v.clinical_variable_pct, v.clinical_variable_value
FROM (
	SELECT DISTINCT ctd_full.ref_article_protocol_id, ctd_full.clinical_variable, ctd_full.clinical_variable_pct, ctd_full.
		clinical_variable_value
	FROM ctd_full
	WHERE (
			(ctd_full.clinical_variable IS NOT NULL) AND ((ctd_full.clinical_variable)::TEXT <> ''::TEXT
				)
			)
	ORDER BY ctd_full.ref_article_protocol_id, ctd_full.clinical_variable
	) v;

CREATE VIEW biomart.ctd_drug_effects_view
AS
SELECT row_number() OVER (
		ORDER BY v.ref_article_protocol_id, v.beneficial_effects, v.adverse_effects
		) AS id, v.ref_article_protocol_id, v.discontinuation_rate, v.response_rate, v.downstream_signaling_effects, v.
	beneficial_effects, v.adverse_effects, v.pk_pd_parameter, v.pk_pd_value, v.effect_description
FROM (
	SELECT DISTINCT ctd_full.ref_article_protocol_id, ctd_full.discontinuation_rate, ctd_full.response_rate, ctd_full.
		downstream_signaling_effects, ctd_full.beneficial_effects, ctd_full.adverse_effects, ctd_full.pk_pd_parameter, 
		ctd_full.pk_pd_value, ctd_full.effect_description
	FROM ctd_full
	ORDER BY ctd_full.ref_article_protocol_id, ctd_full.beneficial_effects, ctd_full.adverse_effects
	) v;

CREATE VIEW biomart.ctd_drug_inhibitor_view
AS
SELECT row_number() OVER (
		ORDER BY v.ref_article_protocol_id, v.drug_inhibitor_common_name
		) AS id, v.ref_article_protocol_id, v.drug_inhibitor_common_name, v.drug_inhibitor_standard_name, v.
	drug_inhibitor_cas_id
FROM (
	SELECT DISTINCT ctd_full.ref_article_protocol_id, ctd_full.drug_inhibitor_common_name, ctd_full.
		drug_inhibitor_standard_name, ctd_full.drug_inhibitor_cas_id
	FROM ctd_full
	ORDER BY ctd_full.ref_article_protocol_id, ctd_full.drug_inhibitor_common_name
	) v;

CREATE VIEW biomart.ctd_events_view
AS
SELECT row_number() OVER (
		ORDER BY v.ref_article_protocol_id, v.definition_of_the_event
		) AS id, v.ref_article_protocol_id, v.definition_of_the_event, v.number_of_events, v.event_rate, v.time_to_event, v.
	event_pct_reduction, v.event_p_value, v.event_description
FROM (
	SELECT DISTINCT ctd_full.ref_article_protocol_id, ctd_full.definition_of_the_event, ctd_full.number_of_events, ctd_full.
		event_rate, ctd_full.time_to_event, ctd_full.event_pct_reduction, ctd_full.event_p_value, ctd_full.event_description
	FROM ctd_full
	WHERE (
			(
				(ctd_full.definition_of_the_event IS NOT NULL) AND ((ctd_full.definition_of_the_event)::TEXT <> ''::TEXT
					)
				) OR (
				(ctd_full.event_description IS NOT NULL) AND ((ctd_full.event_description)::TEXT <> ''::TEXT
					)
				)
			)
	ORDER BY ctd_full.ref_article_protocol_id, ctd_full.definition_of_the_event
	) v;

CREATE VIEW biomart.ctd_experiments_view
AS
SELECT row_number() OVER (
		ORDER BY v.ref_article_protocol_id, v.drug_inhibitor_common_name, v.drug_inhibitor_trtmt_regime
		) AS id, v.ref_article_protocol_id, v.drug_inhibitor_common_name, v.drug_inhibitor_dose, v.drug_inhibitor_time_period, 
	v.drug_inhibitor_route_of_admin, v.drug_inhibitor_trtmt_regime, v.comparator_name, v.comparator_dose, v.
	comparator_time_period, v.comparator_route_of_admin, v.treatment_regime, v.placebo, v.experiment_description
FROM (
	SELECT DISTINCT ctd_full.ref_article_protocol_id, ctd_full.drug_inhibitor_common_name, ctd_full.
		drug_inhibitor_time_period, ctd_full.drug_inhibitor_dose, ctd_full.drug_inhibitor_route_of_admin, ctd_full.
		drug_inhibitor_trtmt_regime, ctd_full.comparator_name, ctd_full.comparator_dose, ctd_full.comparator_time_period, 
		ctd_full.comparator_route_of_admin, ctd_full.treatment_regime, ctd_full.placebo, ctd_full.experiment_description
	FROM ctd_full
	ORDER BY ctd_full.ref_article_protocol_id, ctd_full.drug_inhibitor_common_name, ctd_full.drug_inhibitor_trtmt_regime
	) v;

CREATE VIEW biomart.ctd_expr_after_view
AS
SELECT row_number() OVER (
		ORDER BY v.ref_article_protocol_id, v.biomolecule_name
		) AS id, v.ref_article_protocol_id, v.biomolecule_name, v.expr_after_trtmt_pct, v.expr_after_trtmt_number, v.
	expr_aftertrtmt_valuefold_mean, v.expr_after_trtmt_sd, v.expr_after_trtmt_sem, v.expr_after_trtmt_unit
FROM (
	SELECT DISTINCT ctd_full.ref_article_protocol_id, ctd_full.biomolecule_name, ctd_full.expr_after_trtmt_pct, ctd_full.
		expr_after_trtmt_number, ctd_full.expr_aftertrtmt_valuefold_mean, ctd_full.expr_after_trtmt_sd, ctd_full.
		expr_after_trtmt_sem, ctd_full.expr_after_trtmt_unit
	FROM ctd_full
	WHERE (
			(
				(ctd_full.biomolecule_name IS NOT NULL) AND ((ctd_full.biomolecule_name)::TEXT <> ''::TEXT
					)
				) OR (
				(ctd_full.expr_aftertrtmt_valuefold_mean IS NOT NULL) AND ((ctd_full.expr_aftertrtmt_valuefold_mean)::TEXT <> ''::TEXT
					)
				)
			)
	ORDER BY ctd_full.ref_article_protocol_id, ctd_full.biomolecule_name
	) v;

CREATE VIEW biomart.ctd_expr_baseline_view
AS
SELECT row_number() OVER (
		ORDER BY v.ref_article_protocol_id, v.biomolecule_name
		) AS id, v.ref_article_protocol_id, v.biomolecule_name, v.baseline_expr_pct, v.baseline_expr_number, v.
	baseline_expr_value_fold_mean, v.baseline_expr_sd, v.baseline_expr_sem, v.baseline_expr_unit
FROM (
	SELECT DISTINCT ctd_full.ref_article_protocol_id, ctd_full.biomolecule_name, ctd_full.baseline_expr_pct, ctd_full.
		baseline_expr_number, ctd_full.baseline_expr_value_fold_mean, ctd_full.baseline_expr_sd, ctd_full.baseline_expr_sem
		, ctd_full.baseline_expr_unit
	FROM ctd_full
	WHERE (
			(
				(ctd_full.biomolecule_name IS NOT NULL) AND ((ctd_full.biomolecule_name)::TEXT <> ''::TEXT
					)
				) OR (
				(ctd_full.baseline_expr_value_fold_mean IS NOT NULL) AND ((ctd_full.baseline_expr_value_fold_mean)::TEXT <> ''::TEXT
					)
				)
			)
	ORDER BY ctd_full.ref_article_protocol_id, ctd_full.biomolecule_name
	) v;

CREATE VIEW biomart.ctd_expr_bio_view
AS
SELECT row_number() OVER (
		ORDER BY v.ref_article_protocol_id, v.biomolecule_name
		) AS id, v.ref_article_protocol_id, v.biomolecule_name, v.biomolecule_id, v.biomolecule_type, v.biomarker, v.
	biomarker_type
FROM (
	SELECT DISTINCT ctd_full.ref_article_protocol_id, ctd_full.biomolecule_name, ctd_full.biomolecule_id, ctd_full.
		biomolecule_type, ctd_full.biomarker, ctd_full.biomarker_type
	FROM ctd_full
	WHERE (
			(
				(ctd_full.biomolecule_name IS NOT NULL) AND ((ctd_full.biomolecule_name)::TEXT <> ''::TEXT
					)
				) OR (
				(ctd_full.biomolecule_id IS NOT NULL) AND ((ctd_full.biomolecule_id)::TEXT <> ''::TEXT
					)
				)
			)
	ORDER BY ctd_full.ref_article_protocol_id, ctd_full.biomolecule_name
	) v;

CREATE VIEW biomart.ctd_expr_source_view
AS
SELECT row_number() OVER (
		ORDER BY v.ref_article_protocol_id, v.expr_chg_source_type
		) AS id, v.ref_article_protocol_id, v.expr_chg_source_type, v.expr_chg_technique, v.expr_chg_description
FROM (
	SELECT DISTINCT ctd_full.ref_article_protocol_id, ctd_full.expr_chg_source_type, ctd_full.expr_chg_technique, ctd_full.
		expr_chg_description
	FROM ctd_full
	WHERE (
			(
				(ctd_full.expr_chg_source_type IS NOT NULL) AND ((ctd_full.expr_chg_source_type)::TEXT <> ''::TEXT
					)
				) OR (
				(ctd_full.expr_chg_description IS NOT NULL) AND ((ctd_full.expr_chg_description)::TEXT <> ''::TEXT
					)
				)
			)
	ORDER BY ctd_full.ref_article_protocol_id, ctd_full.expr_chg_source_type
	) v;

CREATE VIEW biomart.ctd_full_clinical_endpts_view
AS
SELECT row_number() OVER (
		ORDER BY v.ref_article_protocol_id
		) AS id, v.ref_article_protocol_id, v.primary_endpoint_type, v.primary_endpoint_definition, v.primary_endpoint_change, 
	v.primary_endpoint_time_period, v.primary_endpoint_p_value, v.primary_endpoint_stat_test, v.secondary_type, v.
	secondary_type_definition, v.secondary_type_change, v.secondary_type_time_period, v.secondary_type_p_value, v.
	secondary_type_stat_test
FROM (
	SELECT DISTINCT ctd_full.ref_article_protocol_id, ctd_full.primary_endpoint_type, ctd_full.primary_endpoint_definition, 
		ctd_full.primary_endpoint_change, ctd_full.primary_endpoint_time_period, ctd_full.primary_endpoint_p_value, 
		ctd_full.primary_endpoint_stat_test, ctd_full.secondary_type, ctd_full.secondary_type_definition, ctd_full.
		secondary_type_change, ctd_full.secondary_type_time_period, ctd_full.secondary_type_p_value, ctd_full.
		secondary_type_stat_test
	FROM ctd_full
	ORDER BY ctd_full.ref_article_protocol_id
	) v;

CREATE VIEW biomart.ctd_full_search_view
AS
SELECT row_number() OVER (
		ORDER BY t.ref_article_protocol_id
		) AS fact_id, t.ref_article_protocol_id, t.mesh, t.common_name, t.drug_inhibitor_standard_name, t.primary_endpoint_type
	, t.secondary_type, t.biomarker_name, t.disease_severity, t.inhaled_steroid_dose, t.fev1, t.primary_endpoint_time_period, t
	.primary_endpoint_change, t.primary_endpoint_p_value
FROM (
	SELECT DISTINCT ctd_full.ref_article_protocol_id, ctd_full.mesh, ctd_full.common_name, ctd_full.
		drug_inhibitor_standard_name, ctd_full.primary_endpoint_type, ctd_full.secondary_type, ctd_full.biomarker_name, 
		ctd_full.disease_severity, ctd_full.inhaled_steroid_dose, ctd_full.fev1, ctd_full.primary_endpoint_time_period, 
		ctd_full.primary_endpoint_change, ctd_full.primary_endpoint_p_value
	FROM ctd_full
	) t;

CREATE VIEW biomart.ctd_primary_endpts_view
AS
SELECT row_number() OVER (
		ORDER BY v.ref_article_protocol_id, v.primary_endpoint_type
		) AS id, v.ref_article_protocol_id, v.primary_endpoint_type, v.primary_endpoint_definition, v.primary_endpoint_change, 
	v.primary_endpoint_time_period, v.primary_endpoint_p_value, v.primary_endpoint_stat_test
FROM (
	SELECT DISTINCT ctd_full.ref_article_protocol_id, ctd_full.primary_endpoint_type, ctd_full.primary_endpoint_definition, 
		ctd_full.primary_endpoint_change, ctd_full.primary_endpoint_time_period, ctd_full.primary_endpoint_p_value, 
		ctd_full.primary_endpoint_stat_test
	FROM ctd_full
	WHERE (
			(
				(ctd_full.primary_endpoint_type IS NOT NULL) AND ((ctd_full.primary_endpoint_type)::TEXT <> ''::TEXT
					)
				) OR (
				(ctd_full.primary_endpoint_definition IS NOT NULL) AND ((ctd_full.primary_endpoint_definition)::TEXT <> ''::TEXT
					)
				)
			)
	ORDER BY ctd_full.ref_article_protocol_id, ctd_full.primary_endpoint_type
	) v;

CREATE VIEW biomart.ctd_prior_med_use_view
AS
SELECT row_number() OVER (
		ORDER BY v.ref_article_protocol_id, v.prior_med_drug_name
		) AS id, v.ref_article_protocol_id, v.prior_med_drug_name, v.prior_med_pct, v.prior_med_value
FROM (
	SELECT DISTINCT ctd_full.ref_article_protocol_id, ctd_full.prior_med_drug_name, ctd_full.prior_med_pct, ctd_full.
		prior_med_value
	FROM ctd_full
	WHERE (
			(ctd_full.prior_med_drug_name IS NOT NULL) AND ((ctd_full.prior_med_drug_name)::TEXT <> ''::TEXT
				)
			)
	ORDER BY ctd_full.ref_article_protocol_id, ctd_full.prior_med_drug_name
	) v;

CREATE VIEW biomart.ctd_pulmonary_path_view
AS
SELECT row_number() OVER (
		ORDER BY v.ref_article_protocol_id, v.pulmonary_pathology_name
		) AS id, v.ref_article_protocol_id, v.pulmonary_pathology_name, v.pulmpath_patient_pct, v.pulmpath_value_unit, v.
	pulmpath_method
FROM (
	SELECT DISTINCT ctd_full.ref_article_protocol_id, ctd_full.pulmonary_pathology_name, ctd_full.pulmpath_patient_pct, 
		ctd_full.pulmpath_value_unit, ctd_full.pulmpath_method
	FROM ctd_full
	WHERE (
			(ctd_full.pulmonary_pathology_name IS NOT NULL) AND ((ctd_full.pulmonary_pathology_name)::TEXT <> ''::TEXT
				)
			)
	ORDER BY ctd_full.ref_article_protocol_id, ctd_full.pulmonary_pathology_name
	) v;

CREATE VIEW biomart.ctd_quant_params_view
AS
SELECT row_number() OVER (
		ORDER BY v.ref_article_protocol_id
		) AS id, v.ref_article_protocol_id, v.clinical_variable_name, v.pct_change_from_baseline, v.abs_change_from_baseline, v
	.rate_of_change_from_baseline, v.average_over_treatment_period, v.within_group_changes, v.stat_measure_p_value
FROM (
	SELECT DISTINCT ctd_full.ref_article_protocol_id, ctd_full.clinical_variable_name, ctd_full.pct_change_from_baseline, 
		ctd_full.abs_change_from_baseline, ctd_full.rate_of_change_from_baseline, ctd_full.average_over_treatment_period, 
		ctd_full.within_group_changes, ctd_full.stat_measure_p_value
	FROM ctd_full
	WHERE (
			(ctd_full.clinical_variable_name IS NOT NULL) AND ((ctd_full.clinical_variable_name)::TEXT <> ''::TEXT
				)
			)
	ORDER BY ctd_full.ref_article_protocol_id
	) v;

CREATE VIEW biomart.ctd_reference_view
AS
SELECT row_number() OVER (
		ORDER BY v.ref_article_protocol_id, v.ref_record_id
		) AS id, v.ref_article_protocol_id, v.ref_article_pmid, v.ref_protocol_id, v.ref_title, v.ref_record_id, v.
	ref_back_reference
FROM (
	SELECT DISTINCT ctd_full.ref_article_protocol_id, ctd_full.ref_article_pmid, ctd_full.ref_protocol_id, ctd_full.ref_title
		, ctd_full.ref_record_id, ctd_full.ref_back_reference
	FROM ctd_full
	ORDER BY ctd_full.ref_article_protocol_id, ctd_full.ref_record_id
	) v;

CREATE VIEW biomart.ctd_runin_therapies_view
AS
SELECT row_number() OVER (
		ORDER BY v.ref_article_protocol_id, v.runin_description
		) AS id, v.ref_article_protocol_id, v.runin_ocs, v.runin_ics, v.runin_laba, v.runin_ltra, v.runin_corticosteroids, v.
	runin_anti_fibrotics, v.runin_immunosuppressive, v.runin_cytotoxic, v.runin_description
FROM (
	SELECT DISTINCT ctd_full.ref_article_protocol_id, ctd_full.runin_ocs, ctd_full.runin_ics, ctd_full.runin_laba, ctd_full.
		runin_ltra, ctd_full.runin_corticosteroids, ctd_full.runin_anti_fibrotics, ctd_full.runin_immunosuppressive, 
		ctd_full.runin_cytotoxic, ctd_full.runin_description
	FROM ctd_full
	WHERE (
			(
				(
					(ctd_full.runin_ocs IS NOT NULL) AND ((ctd_full.runin_ocs)::TEXT <> ''::TEXT
						)
					) OR (
					(ctd_full.runin_description IS NOT NULL) AND ((ctd_full.runin_description)::TEXT <> ''::TEXT
						)
					)
				) OR (
				(ctd_full.runin_immunosuppressive IS NOT NULL) AND ((ctd_full.runin_immunosuppressive)::TEXT <> ''::TEXT
					)
				)
			)
	ORDER BY ctd_full.ref_article_protocol_id, ctd_full.runin_description
	) v;

CREATE VIEW biomart.ctd_secondary_endpts_view
AS
SELECT row_number() OVER (
		ORDER BY v.ref_article_protocol_id, v.secondary_type
		) AS id, v.ref_article_protocol_id, v.secondary_type, v.secondary_type_definition, v.secondary_type_change, v.
	secondary_type_time_period, v.secondary_type_p_value, v.secondary_type_stat_test
FROM (
	SELECT DISTINCT ctd_full.ref_article_protocol_id, ctd_full.secondary_type, ctd_full.secondary_type_definition, ctd_full.
		secondary_type_change, ctd_full.secondary_type_time_period, ctd_full.secondary_type_p_value, ctd_full.
		secondary_type_stat_test
	FROM ctd_full
	WHERE (
			(
				(ctd_full.secondary_type IS NOT NULL) AND ((ctd_full.secondary_type)::TEXT <> ''::TEXT
					)
				) OR (
				(ctd_full.secondary_type_definition IS NOT NULL) AND ((ctd_full.secondary_type_definition)::TEXT <> ''::TEXT
					)
				)
			)
	ORDER BY ctd_full.ref_article_protocol_id, ctd_full.secondary_type
	) v;

CREATE VIEW biomart.ctd_stats_view
AS
SELECT row_number() OVER (
		ORDER BY v.ref_article_protocol_id, v.statistical_test
		) AS id, v.ref_article_protocol_id, v.clinical_correlation, v.statistical_test, v.statistical_coefficient_value, v.
	statistical_test_p_value, v.statistical_test_description
FROM (
	SELECT DISTINCT ctd_full.ref_article_protocol_id, ctd_full.clinical_correlation, ctd_full.statistical_test, ctd_full.
		statistical_coefficient_value, ctd_full.statistical_test_p_value, ctd_full.statistical_test_description
	FROM ctd_full
	WHERE (
			(
				(ctd_full.statistical_test_description IS NOT NULL) AND ((ctd_full.statistical_test_description)::TEXT <> ''::TEXT
					)
				) OR (
				(ctd_full.statistical_test IS NOT NULL) AND ((ctd_full.statistical_test)::TEXT <> ''::TEXT
					)
				)
			)
	ORDER BY ctd_full.ref_article_protocol_id, ctd_full.statistical_test
	) v;

CREATE VIEW biomart.ctd_study_details_view
AS
SELECT row_number() OVER (
		ORDER BY v.ref_article_protocol_id, v.common_name
		) AS id, v.ref_article_protocol_id, v.study_type, v.common_name, v.icd10, v.mesh, v.disease_type, v.physiology_name
FROM (
	SELECT DISTINCT ctd_full.ref_article_protocol_id, ctd_full.study_type, ctd_full.common_name, ctd_full.icd10, ctd_full.mesh
		, ctd_full.disease_type, ctd_full.physiology_name
	FROM ctd_full
	WHERE (
			(ctd_full.common_name IS NOT NULL) AND ((ctd_full.common_name)::TEXT <> ''::TEXT
				)
			)
	ORDER BY ctd_full.ref_article_protocol_id, ctd_full.common_name
	) v;

CREATE VIEW biomart.ctd_td_design_view
AS
SELECT row_number() OVER (
		ORDER BY v.ref_article_protocol_id, v.nature_of_trial, v.trial_type
		) AS id, v.ref_article_protocol_id, v.nature_of_trial, v.randomization, v.blinded_trial, v.trial_type, v.run_in_period, v
	.treatment_period, v.washout_period, v.open_label_extension
FROM (
	SELECT DISTINCT ctd_full.ref_article_protocol_id, ctd_full.nature_of_trial, ctd_full.randomization, ctd_full.
		blinded_trial, ctd_full.trial_type, ctd_full.run_in_period, ctd_full.treatment_period, ctd_full.washout_period, 
		ctd_full.open_label_extension
	FROM ctd_full
	WHERE (
			(
				(ctd_full.trial_type IS NOT NULL) AND ((ctd_full.trial_type)::TEXT <> ''::TEXT
					)
				) OR (
				(ctd_full.nature_of_trial IS NOT NULL) AND ((ctd_full.nature_of_trial)::TEXT <> ''::TEXT
					)
				)
			)
	ORDER BY ctd_full.ref_article_protocol_id, ctd_full.nature_of_trial, ctd_full.trial_type
	) v;

CREATE VIEW biomart.ctd_td_excl_view
AS
SELECT row_number() OVER (
		ORDER BY v.ref_article_protocol_id
		) AS id, v.ref_article_protocol_id, v.exclusion_criteria1, v.exclusion_criteria2, v.minimal_symptoms, v.
	rescue_medication_use, v.control_details, v.blinding_procedure, v.number_of_arms, v.description1, v.description2
FROM (
	SELECT DISTINCT ctd_full.ref_article_protocol_id, "substring" (ctd_full.exclusion_criteria, 1, 4000) AS 
		exclusion_criteria1, "substring" (ctd_full.exclusion_criteria, 4001, 2000) AS exclusion_criteria2, ctd_full
		.minimal_symptoms, ctd_full.rescue_medication_use, ctd_full.control_details, ctd_full.blinding_procedure, ctd_full.
		number_of_arms, "substring" (ctd_full.description, 1, 4000) AS description1, "substring" (ctd_full.description, 4001, 2000
			) AS description2
	FROM ctd_full
	WHERE (
			(
				(ctd_full.blinding_procedure IS NOT NULL) AND ((ctd_full.blinding_procedure)::TEXT <> ''::TEXT
					)
				) OR (
				(ctd_full.number_of_arms IS NOT NULL) AND ((ctd_full.number_of_arms)::TEXT <> ''::TEXT
					)
				)
			)
	ORDER BY ctd_full.ref_article_protocol_id
	) v;

CREATE VIEW biomart.ctd_td_inclusion_view
AS
SELECT row_number() OVER (
		ORDER BY v.ref_article_protocol_id, v.disease_severity, v.fev1
		) AS id, v.ref_article_protocol_id, v.trial_age, v.disease_severity, v.difficult_to_treat, v.asthma_diagnosis, v.
	inhaled_steroid_dose, v.laba, v.ocs, v.xolair, v.ltra_inhibitors, v.asthma_phenotype, v.fev1, v.fev1_reversibility, v.tlc, v.
	fev1_fvc, v.fvc, v.dlco, v.sgrq, v.hrct, v.biopsy, v.dyspnea_on_exertion, v.concomitant_med
FROM (
	SELECT DISTINCT ctd_full.ref_article_protocol_id, ctd_full.trial_age, ctd_full.disease_severity, ctd_full.
		difficult_to_treat, ctd_full.asthma_diagnosis, ctd_full.inhaled_steroid_dose, ctd_full.laba, ctd_full.ocs, ctd_full.
		xolair, ctd_full.ltra_inhibitors, ctd_full.asthma_phenotype, ctd_full.fev1, ctd_full.fev1_reversibility, ctd_full.tlc
		, ctd_full.fev1_fvc, ctd_full.fvc, ctd_full.dlco, ctd_full.sgrq, ctd_full.hrct, ctd_full.biopsy, ctd_full.
		dyspnea_on_exertion, ctd_full.concomitant_med
	FROM ctd_full
	WHERE (
			(
				(
					(ctd_full.fev1 IS NOT NULL) AND ((ctd_full.fev1)::TEXT <> ''::TEXT
						)
					) OR (
					(ctd_full.disease_severity IS NOT NULL) AND ((ctd_full.disease_severity)::TEXT <> ''::TEXT
						)
					)
				) OR (
				(ctd_full.trial_age IS NOT NULL) AND ((ctd_full.trial_age)::TEXT <> ''::TEXT
					)
				)
			)
	ORDER BY ctd_full.ref_article_protocol_id, ctd_full.disease_severity, ctd_full.fev1
	) v;

CREATE VIEW biomart.ctd_td_smoker_view
AS
SELECT row_number() OVER (
		ORDER BY v.ref_article_protocol_id, v.trial_smokers_pct
		) AS id, v.ref_article_protocol_id, v.trial_smokers_pct, v.trial_former_smokers_pct, v.trial_never_smokers_pct, v.
	trial_pack_years
FROM (
	SELECT DISTINCT ctd_full.ref_article_protocol_id, ctd_full.trial_smokers_pct, ctd_full.trial_former_smokers_pct, ctd_full
		.trial_never_smokers_pct, ctd_full.trial_pack_years
	FROM ctd_full
	WHERE (
			(
				(ctd_full.trial_smokers_pct IS NOT NULL) AND ((ctd_full.trial_smokers_pct)::TEXT <> ''::TEXT
					)
				) OR (
				(ctd_full.trial_never_smokers_pct IS NOT NULL) AND ((ctd_full.trial_never_smokers_pct)::TEXT <> ''::TEXT
					)
				)
			)
	ORDER BY ctd_full.ref_article_protocol_id, ctd_full.trial_smokers_pct
	) v;

CREATE VIEW biomart.ctd_td_sponsor_view
AS
SELECT row_number() OVER (
		ORDER BY v.ref_article_protocol_id, v.sponsor, v.trial_nbr_of_patients_studied
		) AS id, v.ref_article_protocol_id, v.sponsor, v.trial_nbr_of_patients_studied, v.source_type
FROM (
	SELECT DISTINCT ctd_full.ref_article_protocol_id, ctd_full.sponsor, ctd_full.trial_nbr_of_patients_studied, ctd_full.
		source_type
	FROM ctd_full
	WHERE (
			(
				(ctd_full.sponsor IS NOT NULL) AND ((ctd_full.sponsor)::TEXT <> ''::TEXT
					)
				) OR (
				(ctd_full.trial_nbr_of_patients_studied IS NOT NULL) AND ((ctd_full.trial_nbr_of_patients_studied)::TEXT <> ''::TEXT
					)
				)
			)
	ORDER BY ctd_full.ref_article_protocol_id, ctd_full.sponsor, ctd_full.trial_nbr_of_patients_studied
	) v;

CREATE VIEW biomart.ctd_td_status_view
AS
SELECT row_number() OVER (
		ORDER BY v.ref_article_protocol_id
		) AS id, v.ref_article_protocol_id, v.trial_status, v.trial_phase
FROM (
	SELECT DISTINCT ctd_full.ref_article_protocol_id, ctd_full.trial_status, ctd_full.trial_phase
	FROM ctd_full
	WHERE (
			(
				(ctd_full.trial_status IS NOT NULL) AND ((ctd_full.trial_status)::TEXT <> ''::TEXT
					)
				) OR (
				(ctd_full.trial_phase IS NOT NULL) AND ((ctd_full.trial_phase)::TEXT <> ''::TEXT
					)
				)
			)
	ORDER BY ctd_full.ref_article_protocol_id
	) v;

CREATE VIEW biomart.ctd_treatment_phases_view
AS
SELECT row_number() OVER (
		ORDER BY v.ref_article_protocol_id, v.trtmt_description, v.trtmt_ocs
		) AS id, v.ref_article_protocol_id, v.trtmt_ocs, v.trtmt_ics, v.trtmt_laba, v.trtmt_ltra, v.trtmt_corticosteroids, v.
	trtmt_anti_fibrotics, v.trtmt_immunosuppressive, v.trtmt_cytotoxic, v.trtmt_description
FROM (
	SELECT DISTINCT ctd_full.ref_article_protocol_id, ctd_full.trtmt_ocs, ctd_full.trtmt_ics, ctd_full.trtmt_laba, ctd_full.
		trtmt_ltra, ctd_full.trtmt_corticosteroids, ctd_full.trtmt_anti_fibrotics, ctd_full.trtmt_immunosuppressive, 
		ctd_full.trtmt_cytotoxic, ctd_full.trtmt_description
	FROM ctd_full
	WHERE (
			(
				(
					(ctd_full.trtmt_ocs IS NOT NULL) AND ((ctd_full.trtmt_ocs)::TEXT <> ''::TEXT
						)
					) OR (
					(ctd_full.trtmt_description IS NOT NULL) AND ((ctd_full.trtmt_description)::TEXT <> ''::TEXT
						)
					)
				) OR (
				(ctd_full.trtmt_immunosuppressive IS NOT NULL) AND ((ctd_full.trtmt_immunosuppressive)::TEXT <> ''::TEXT
					)
				)
			)
	ORDER BY ctd_full.ref_article_protocol_id, ctd_full.trtmt_description, ctd_full.trtmt_ocs
	) v;

CREATE VIEW biomart.bio_marker_correl_view
AS
(
		SELECT DISTINCT b.bio_marker_id, b.bio_marker_id AS asso_bio_marker_id, 'GENE'::TEXT AS correl_type, 1 AS mv_id
		FROM bio_marker b
		WHERE ((b.bio_marker_type)::TEXT = 'GENE'::TEXT)
		
		UNION
		
		SELECT DISTINCT c.bio_data_id AS bio_marker_id, c.asso_bio_data_id AS asso_bio_marker_id, 'PATHWAY_GENE'::TEXT AS 
			correl_type, 2 AS mv_id
		FROM bio_marker b, bio_data_correlation c, bio_data_correl_descr d
		WHERE (
				(
					(
						(b.bio_marker_id = c.bio_data_id) AND (c.bio_data_correl_descr_id = d.bio_data_correl_descr_id
							)
						) AND ((b.primary_source_code)::TEXT <> 'ARIADNE'::TEXT
						)
					) AND ((d.correlation)::TEXT = 'PATHWAY GENE'::TEXT)
				)
		)

UNION

SELECT DISTINCT c.bio_data_id AS bio_marker_id, c.asso_bio_data_id AS asso_bio_marker_id, 'HOMOLOGENE_GENE'::TEXT AS correl_type, 3 
	AS mv_id
FROM bio_marker b, bio_data_correlation c, bio_data_correl_descr d
WHERE (
		(
			(b.bio_marker_id = c.bio_data_id) AND (c.bio_data_correl_descr_id = d.bio_data_correl_descr_id
				)
			) AND ((d.correlation)::TEXT = 'HOMOLOGENE GENE'::TEXT)
		);

CREATE VIEW biomart.bio_marker_exp_analysis_mv
AS
SELECT DISTINCT t3.bio_marker_id, t1.bio_experiment_id, t1.bio_assay_analysis_id, ((t1.bio_assay_analysis_id * 100) + t3.bio_marker_id
		) AS mv_id
FROM bio_assay_analysis_data t1, bio_experiment t2, bio_marker t3, bio_assay_data_annotation t4
WHERE (
		(
			(
				(t1.bio_experiment_id = t2.bio_experiment_id) AND ((t2.bio_experiment_type)::TEXT = 'Experiment'::TEXT
					)
				) AND (t3.bio_marker_id = t4.bio_marker_id)
			) AND (t1.bio_assay_feature_group_id = t4.bio_assay_feature_group_id)
		);
*/
--WARNING! ERRORS ENCOUNTERED DURING SQL PARSING!


/* Triggers ( not supported by netezza))

CREATE TRIGGER trg_bio_assay_analysis_id BEFORE INSERT ON bio_assay_analysis FOR EACH ROW EXECUTE PROCEDURE tf_trg_bio_assay_analysis_id();

CREATE TRIGGER trg_bio_assay_data_id BEFORE INSERT ON bio_assay_data FOR EACH ROW EXECUTE PROCEDURE tf_trg_bio_assay_data_id();

CREATE TRIGGER trg_bio_assay_dataset_id BEFORE INSERT ON bio_assay_dataset FOR EACH ROW EXECUTE PROCEDURE tf_trg_bio_assay_dataset_id();

CREATE TRIGGER trg_bio_assay_f_g_id BEFORE INSERT ON bio_assay_feature_group FOR EACH ROW EXECUTE PROCEDURE tf_trg_bio_assay_f_g_id();

CREATE TRIGGER trg_bio_assay_id BEFORE INSERT ON bio_assay FOR EACH ROW EXECUTE PROCEDURE tf_trg_bio_assay_id();

CREATE TRIGGER trg_bio_assay_platform_id BEFORE INSERT ON bio_assay_platform FOR EACH ROW EXECUTE PROCEDURE tf_trg_bio_assay_platform_id();

CREATE TRIGGER trg_bio_asy_analysis_pltfm_id BEFORE INSERT ON bio_asy_analysis_pltfm FOR EACH ROW EXECUTE PROCEDURE tf_trg_bio_asy_analysis_pltfm_id();

CREATE TRIGGER trg_bio_asy_dt_stats_id BEFORE INSERT ON bio_asy_data_stats_all FOR EACH ROW EXECUTE PROCEDURE tf_trg_bio_asy_dt_stats_id();

CREATE TRIGGER trg_bio_cell_line_id BEFORE INSERT ON bio_cell_line FOR EACH ROW EXECUTE PROCEDURE tf_trg_bio_cell_line_id();

CREATE TRIGGER trg_bio_cl_trl_time_pt_id BEFORE INSERT ON bio_clinc_trial_time_pt FOR EACH ROW EXECUTE PROCEDURE tf_trg_bio_cl_trl_time_pt_id();

CREATE TRIGGER trg_bio_clin_trl_pt_grp_id BEFORE INSERT ON bio_clinc_trial_pt_group FOR EACH ROW EXECUTE PROCEDURE tf_trg_bio_clin_trl_pt_grp_id();

CREATE TRIGGER trg_bio_cln_trl_attr_id BEFORE INSERT ON bio_clinc_trial_attr FOR EACH ROW EXECUTE PROCEDURE tf_trg_bio_cln_trl_attr_id();

CREATE TRIGGER trg_bio_compound_id BEFORE INSERT ON bio_compound FOR EACH ROW EXECUTE PROCEDURE tf_trg_bio_compound_id();

CREATE TRIGGER trg_bio_concept_code_id BEFORE INSERT ON bio_concept_code FOR EACH ROW EXECUTE PROCEDURE tf_trg_bio_concept_code_id();

CREATE TRIGGER trg_bio_content_ref_id BEFORE INSERT ON bio_content_reference FOR EACH ROW EXECUTE PROCEDURE tf_trg_bio_content_ref_id();

CREATE TRIGGER trg_bio_content_repo_id BEFORE INSERT ON bio_content_repository FOR EACH ROW EXECUTE PROCEDURE tf_trg_bio_content_repo_id();

CREATE TRIGGER trg_bio_curation_dataset_id BEFORE INSERT ON bio_curation_dataset FOR EACH ROW EXECUTE PROCEDURE tf_trg_bio_curation_dataset_id();

CREATE TRIGGER trg_bio_data_attr_id BEFORE INSERT ON bio_data_attribute FOR EACH ROW EXECUTE PROCEDURE tf_trg_bio_data_attr_id();

CREATE TRIGGER trg_bio_data_correl_id BEFORE INSERT ON bio_data_correlation FOR EACH ROW EXECUTE PROCEDURE tf_trg_bio_data_correl_id();

CREATE TRIGGER trg_bio_data_ext_code_id BEFORE INSERT ON bio_data_ext_code FOR EACH ROW EXECUTE PROCEDURE tf_trg_bio_data_ext_code_id();

CREATE TRIGGER trg_bio_disease_id BEFORE INSERT ON bio_disease FOR EACH ROW EXECUTE PROCEDURE tf_trg_bio_disease_id();

CREATE TRIGGER trg_bio_experiment_id BEFORE INSERT ON bio_experiment FOR EACH ROW EXECUTE PROCEDURE tf_trg_bio_experiment_id();

CREATE TRIGGER trg_bio_file_content_id BEFORE INSERT ON bio_content FOR EACH ROW EXECUTE PROCEDURE tf_trg_bio_file_content_id();

CREATE TRIGGER trg_bio_lit_alt_data_id BEFORE INSERT ON bio_lit_alt_data FOR EACH ROW EXECUTE PROCEDURE tf_trg_bio_lit_alt_data_id();

CREATE TRIGGER trg_bio_lit_amd_data_id BEFORE INSERT ON bio_lit_amd_data FOR EACH ROW EXECUTE PROCEDURE tf_trg_bio_lit_amd_data_id();

CREATE TRIGGER trg_bio_lit_inh_data_id BEFORE INSERT ON bio_lit_inh_data FOR EACH ROW EXECUTE PROCEDURE tf_trg_bio_lit_inh_data_id();

CREATE TRIGGER trg_bio_lit_int_data_id BEFORE INSERT ON bio_lit_int_data FOR EACH ROW EXECUTE PROCEDURE tf_trg_bio_lit_int_data_id();

CREATE TRIGGER trg_bio_lit_model_data_id BEFORE INSERT ON bio_lit_model_data FOR EACH ROW EXECUTE PROCEDURE tf_trg_bio_lit_model_data_id();

CREATE TRIGGER trg_bio_lit_pe_data_id BEFORE INSERT ON bio_lit_pe_data FOR EACH ROW EXECUTE PROCEDURE tf_trg_bio_lit_pe_data_id();

CREATE TRIGGER trg_bio_lit_ref_data_id BEFORE INSERT ON bio_lit_ref_data FOR EACH ROW EXECUTE PROCEDURE tf_trg_bio_lit_ref_data_id();

CREATE TRIGGER trg_bio_lit_sum_data_id BEFORE INSERT ON bio_lit_sum_data FOR EACH ROW EXECUTE PROCEDURE tf_trg_bio_lit_sum_data_id();

CREATE TRIGGER trg_bio_marker_id BEFORE INSERT ON bio_marker FOR EACH ROW EXECUTE PROCEDURE tf_trg_bio_marker_id();

CREATE TRIGGER trg_bio_mkr_correl_descr_id BEFORE INSERT ON bio_data_correl_descr FOR EACH ROW EXECUTE PROCEDURE tf_trg_bio_mkr_correl_descr_id();

CREATE TRIGGER trg_bio_patient_event_id BEFORE INSERT ON bio_patient_event FOR EACH ROW EXECUTE PROCEDURE tf_trg_bio_patient_event_id();

CREATE TRIGGER trg_bio_patient_id BEFORE INSERT ON bio_patient FOR EACH ROW EXECUTE PROCEDURE tf_trg_bio_patient_id();

CREATE TRIGGER trg_bio_pt_evt_attr_id BEFORE INSERT ON bio_patient_event_attr FOR EACH ROW EXECUTE PROCEDURE tf_trg_bio_pt_evt_attr_id();

CREATE TRIGGER trg_bio_sample_id BEFORE INSERT ON bio_sample FOR EACH ROW EXECUTE PROCEDURE tf_trg_bio_sample_id();

CREATE TRIGGER trg_bio_subject_id BEFORE INSERT ON bio_subject FOR EACH ROW EXECUTE PROCEDURE tf_trg_bio_subject_id();

CREATE TRIGGER trg_bio_taxon_id BEFORE INSERT ON bio_taxonomy FOR EACH ROW EXECUTE PROCEDURE tf_trg_bio_taxon_id();

CREATE TRIGGER trg_ctd2_clin_inhib_effect BEFORE INSERT ON ctd2_clin_inhib_effect FOR EACH ROW EXECUTE PROCEDURE tf_trg_ctd2_clin_inhib_effect();

CREATE TRIGGER trg_ctd2_disease BEFORE INSERT ON ctd2_disease FOR EACH ROW EXECUTE PROCEDURE tf_trg_ctd2_disease();

CREATE TRIGGER trg_ctd2_inhib_details BEFORE INSERT ON ctd2_inhib_details FOR EACH ROW EXECUTE PROCEDURE tf_trg_ctd2_inhib_details();

CREATE TRIGGER trg_ctd2_study_id BEFORE INSERT ON ctd2_study FOR EACH ROW EXECUTE PROCEDURE tf_trg_ctd2_study_id();

CREATE TRIGGER trg_ctd2_trial_details BEFORE INSERT ON ctd2_trial_details FOR EACH ROW EXECUTE PROCEDURE tf_trg_ctd2_trial_details();

CREATE TRIGGER trig_clinical_trial_design_id BEFORE INSERT ON ctd_full FOR EACH ROW EXECUTE PROCEDURE tf_trig_clinical_trial_design_id();
*/
	