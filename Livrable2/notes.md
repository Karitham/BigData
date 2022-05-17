# livrable 2 : Modèle physique et optimisation

Modèle physique et évaluation de performance par rapport aux temps de réponse des requêtes réalisées sur les tables.

Description :
- Script pour la création et le chargement de données dans les tables
- Vérification des données présentes et accès aux données à travers les tables
- Script montrant le peuplement des tables
- Script pour le partitionnement et les buckets
- Graphes montrant les temps de réponses pour évaluer la performance d'accès à l'entrepôt de données
- Requêtes faisant foi pour l'évaluation de la performance

Format : Rapport + zip contenant les différents jobs Échéance : 18/05/2022



## Contexte

Le potentiel énorme associé aux données médicales a conduit le secteur de la santé à une transformation importante et rapide. Pour progresser dans la bonne voie, les praticiens (médecins, personnel infirmier) et les administrateurs d'établissements doivent pouvoir accéder directement aux informations exploitables dans les données médicales, afin d'améliorer leurs performances et la qualité des soins de manière mesurable.  

le groupe CHU (Cloud Healthcare Unit), faisant partie du secteur hospitalier, as pris conscience de la nécessité d’une transformation digitale, notamment au niveau des données. Notre service est sollicité pour mettre en place leur propre entrepôt de données qui permettra au groupe d'exploiter la quantité considérable de données générées par les systèmes de gestion de soins.  

Dans le dernier rapport nous avions illustré les différentes manières dont nous avons travaillé avec les données fournies, de façon à arriver à nos fins. Nous avons vu en détail l'architecture utilisée, et les différents programmes et phases par lesquelles nos données sont passées. Finalement nous avons étudié en détail les données récoltées à la suite de ce livrable dans le prochain. 

Dans ce rapport nous détaillerons les scripts nécessaires à création des tables dans Hive, le chargement et l'affichage des données pour la vérification. La structure de nos table sera optimisée et partitionnée avec des buckets pour réduire le temps de réponse de nos requêtes. 

## Création des tables et chargements des données

### Script pour la création et le chargement de données dans les tables


```SQL
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

```





### Vérification des données présentes et accès aux données à travers les tables
### Script montrant le peuplement des tables
### Script pour le partitionnement et les buckets

## Graphes des temps de réponses et performance

### Graphes montrant les temps de réponses pour évaluer la performance d'accès à l'entrepôt de données 
### Requêtes faisant foi pour l'évaluation de la performance
