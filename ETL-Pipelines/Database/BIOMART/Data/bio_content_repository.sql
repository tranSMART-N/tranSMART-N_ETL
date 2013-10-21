REM INSERTING into BIO_CONTENT_REPOSITORY
SET DEFINE OFF;
Insert into BIO_CONTENT_REPOSITORY (LOCATION,ACTIVE_Y_N,REPOSITORY_TYPE,LOCATION_TYPE) values ('http://www.ctndatashare.org/protocol/','Y','ClinicalTrialsNetwork','URL');
Insert into BIO_CONTENT_REPOSITORY (LOCATION,ACTIVE_Y_N,REPOSITORY_TYPE,LOCATION_TYPE) values ('http://www.clinicaltrials.gov/show/','Y','clinicaltrials.gov','URL');
-- Insert into BIO_CONTENT_REPOSITORY (LOCATION,ACTIVE_Y_N,REPOSITORY_TYPE,LOCATION_TYPE) values ('http://www.ncbi.nlm.nih.gov/pubmed/','Y','PubMed','URL');
Insert into BIO_CONTENT_REPOSITORY (LOCATION,ACTIVE_Y_N,REPOSITORY_TYPE,LOCATION_TYPE) values ('http://www.ncbi.nlm.nih.gov/geo/query/acc.cgi?acc=','Y','GEO','URL');
