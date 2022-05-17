-- Table de fait
CREATE TABLE IF NOT EXISTS facts (
	nb_hospitalisations INTEGER,
	nb_deces INTEGER,
	nb_consultations INTEGER,
	satisfaction FLOAT,
	localisation_id INTEGER,
	diagnostique_id INTEGER,
	professionel_id INTEGER,
	date_id INTEGER,
	patient_id INTEGER
)
COMMENT 'Table de faits'
ROW FORMAT DELIMITED
FIELDS TERMINATED BY '\;'
LINES TERMINATED BY '\n'
STORED AS TEXTFILE;

-- Dates
CREATE TABLE IF NOT EXISTS dates (
	id INTEGER,
	year INT8,
	month INT8,
	day INT16
)
ROW FORMAT DELIMITED
FIELDS TERMINATED BY '\;'
LINES TERMINATED BY '\n'
STORED AS TEXTFILE;

-- Localisations
CREATE TABLE IF NOT EXISTS localisations (
	id INTEGER,
	region VARCHAR
)
COMMENT 'Table de localisation, ne stoque que les regions'
ROW FORMAT DELIMITED
FIELDS TERMINATED BY '\;'
LINES TERMINATED BY '\n'
STORED AS TEXTFILE;

-- Diagnostiques
CREATE TABLE IF NOT EXISTS diagnostiques (
	id INTEGER,
	code_diag VARCHAR,
	diagnostique TEXT
)
COMMENT 'Table de diagnostiques, stoque un code de diagnostique ainsi que sa definition'
ROW FORMAT DELIMITED
FIELDS TERMINATED BY '\;'
LINES TERMINATED BY '\n'
STORED AS TEXTFILE;


-- Patients
CREATE TABLE IF NOT EXISTS patients (
	id INTEGER,
	sexe VARCHAR,
	age INT8
)
COMMENT 'Table de patients, sexe et age'
ROW FORMAT DELIMITED
FIELDS TERMINATED BY '\;'
LINES TERMINATED BY '\n'
STORED AS TEXTFILE;

-- Professionels
CREATE TABLE IF NOT EXISTS professionels (
	id INTEGER,
	nom VARCHAR,
	etablissement VARCHAR
)
COMMENT 'Table de pro, stoque le nom et la raison sociale (etablissement)'
ROW FORMAT DELIMITED
FIELD TERMINATED BY '\;'
LINES TERMINATED BY '\n'
STORED AS TEXTFILE;
