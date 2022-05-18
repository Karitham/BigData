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


Tout d'abord on commence par créer notre base de données, avec la requête : 
```SQL
CREATE DATABASE CHU ;
```
où `CHU` est le nom de la base de données.  


### Script pour la création et le chargement de données dans les tables

#### Création des tables dans Hive

Voici le script qui permet de créer les différentes tables dans Hive.
Comme vu dans le livrable précédent, nos tables de base de données suivront notre schéma décisionnel en étoile. Nous aurons donc une table de fait qui regroupe nos mesures par dimensions, et des tables qui représentent les dimensions Dates, Localisations, Diagnostiques, Patients, et Professionnels de santé. 


```SQL
-- Table de fait
CREATE TABLE IF NOT EXISTS faits (
    nb_hospitalisations INT,
    nb_deces INT,
    nb_consultations INT,
    satisfaction FLOAT,
    localisation_id INT,
    diagnostique_id INT,
    professionnel_id INT,
    date_id INT,
    patient_id INT
) CLUSTERED BY (localisation_id, date_id) INTO 256 BUCKETS ROW FORMAT DELIMITED FIELDS TERMINATED BY '\;' LINES TERMINATED BY '\n' STORED AS TEXTFILE;
``` 

Pour la table `Dates` on a besoin de stocker un id généré, le jour, le mois et l'année de la date. 
```SQL
-- Dates
CREATE TABLE IF NOT EXISTS dates (id INT, year INT, month INT, day INT) CLUSTERED BY (year) SORTED BY (year, month, day) INTO 20 BUCKETS ROW FORMAT DELIMITED FIELDS TERMINATED BY '\;' LINES TERMINATED BY '\n' STORED AS TEXTFILE;
```  

Pour la table `Localisations` on a besoin de stocker un id généré, et la région. 
```SQL
-- Localisations
CREATE TABLE IF NOT EXISTS localisations (id INT, region VARCHAR(256)) ROW FORMAT DELIMITED FIELDS TERMINATED BY '\;' LINES TERMINATED BY '\n' STORED AS TEXTFILE;
```  

Pour la table `Diagnostiques` on a besoin de stocker un id qui a été généré, le code du diagnostique et le nom du diagnostique. 
```SQL
-- Diagnostiques
CREATE TABLE IF NOT EXISTS diagnostiques (
    id INT,
    code_diag VARCHAR(256),
    diagnostique VARCHAR(25565)
) ROW FORMAT DELIMITED FIELDS TERMINATED BY '\;' LINES TERMINATED BY '\n' STORED AS TEXTFILE;
```  

Pour la table `Patients` on a besoin de stocker id généré, le sexe du patient et son age. 
```SQL
-- Patients
CREATE TABLE IF NOT EXISTS patients (id INT, sexe VARCHAR(256), age INT) CLUSTERED BY (sexe, age) INTO 256 BUCKETS ROW FORMAT DELIMITED FIELDS TERMINATED BY '\;' LINES TERMINATED BY '\n' STORED AS TEXTFILE;
```  

Pour la table Professionnels de santé, nommé `Professionels` on a besoin de stocker l'id qui a été généré, le nom du professionnel de santé, et l'établissement dans lequel il exerce (si il exerce en libéral, l'établissement n'est pas spécifié).
```SQL
-- Professionels
CREATE TABLE IF NOT EXISTS professionnels (
    id INT,
    nom VARCHAR(256),
    etablissement VARCHAR(256)
) CLUSTERED BY (id) INTO 32 BUCKETS ROW FORMAT DELIMITED FIELDS TERMINATED BY '\;' LINES TERMINATED BY '\n' STORED AS TEXTFILE;
```  


#### Chargement des données dans la table

Pour charges les données dans Hive, nous avons récupéré les fichiers créés dans HDFS grâce à nos jobs Talend.
On utilise la requête : 
```SQL
LOAD DATA INPATH '/chemin' INTO TABLE table_name
```  
avec `'/chemin'` le chemin du fichier et `table_name` le nom de la table dans la base de données.  

Par exemple : 
```SQL
LOAD DATA INPATH '/user/cloudera/projet/dates.csv' INTO TABLE dates
```


### Vérification des données présentes et accès aux données à travers les tables
### Script montrant le peuplement des tables
### Script pour le partitionnement et les buckets

## Graphes des temps de réponses et performance

### Graphes montrant les temps de réponses pour évaluer la performance d'accès à l'entrepôt de données 
### Requêtes faisant foi pour l'évaluation de la performance
