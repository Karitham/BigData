    -- Table de fait
CREATE TABLE IF NOT EXISTS facts (
 nb_hospitalisations INT,
 nb_deces INT,
 nb_consultations INT,
 satisfaction FLOAT,
 localisation_id INT,
 diagnostique_id INT,
 professionnel_id INT,
 date_id INT,
 patient_id INT
)
CLUSTERED BY (localisation_id, date_id) INTO 256 BUCKETS
COMMENT 'Table de faits'
ROW FORMAT DELIMITED
FIELDS TERMINATED BY '\;'
LINES TERMINATED BY '\n'
STORED AS TEXTFILE;

-- Dates
CREATE TABLE IF NOT EXISTS dates (
 id INT,
 year INT,
 month INT,
 day INT
)
CLUSTERED BY (year) SORTED BY (year, month, day) INTO 20 BUCKETS
ROW FORMAT DELIMITED
FIELDS TERMINATED BY '\;'
LINES TERMINATED BY '\n'
STORED AS TEXTFILE;

-- Localisations
CREATE TABLE IF NOT EXISTS localisations (
 id INT,
 region VARCHAR(256)
)
COMMENT 'Table de localisation, ne stoque que les regions'
ROW FORMAT DELIMITED
FIELDS TERMINATED BY '\;'
LINES TERMINATED BY '\n'
STORED AS TEXTFILE;

-- Diagnostiques
CREATE TABLE IF NOT EXISTS diagnostiques (
 id INT,
 code_diag VARCHAR(256),
 diagnostique VARCHAR(25565)
)
COMMENT 'Table de diagnostiques, stoque un code de diagnostique ainsi que sa definition'
ROW FORMAT DELIMITED
FIELDS TERMINATED BY '\;'
LINES TERMINATED BY '\n'
STORED AS TEXTFILE;


-- Patients
CREATE TABLE IF NOT EXISTS patients (
 id INT,
 sexe VARCHAR(256),
 age INT
)
CLUSTERED BY (sexe,age) INTO 256 BUCKETS
COMMENT 'Table de patients, sexe et age'
ROW FORMAT DELIMITED
FIELDS TERMINATED BY '\;'
LINES TERMINATED BY '\n'
STORED AS TEXTFILE;

-- Professionels
CREATE TABLE IF NOT EXISTS professionnels (
 id INT,
 nom VARCHAR(256),
 etablissement VARCHAR(256)
)
CLUSTERED BY (id) INTO 32 BUCKETS;
COMMENT 'Table de pro, stoque le nom et la raison sociale (etablissement)'
ROW FORMAT DELIMITED
FIELDS TERMINATED BY '\;'
LINES TERMINATED BY '\n'
STORED AS TEXTFILE;
