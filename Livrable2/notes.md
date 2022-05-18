# Livrable 2 : Modèle physique et optimisation

Modèle physique et évaluation de performance par rapport aux temps de réponse des requêtes réalisées sur les tables.

Description :
- Script pour la création et le chargement de données dans les tables
- Vérification des données présentes et accès aux données à travers les tables
- Script montrant le peuplement des tables
- Script pour le partitionnement et les buckets
- Graphes montrant les temps de réponses pour évaluer la performance d'accès à l'entrepôt de données
- Requêtes faisant foi pour l'évaluation de la performance

Format : Rapport + zip contenant les différents jobs Échéance : 18/05/2022

Table des matières :

1. [ Contexte ](#contexte)
2. [ Création des tables et chargements des données ](#part1)
        a. [ Script pour la création des tables ](#part1_1)
        a. [ Chargement des données dans la table ](#part1_2)
        a. [ Vérification des données dans les tables ](#part1_3)
4. [ Graphes des temps de réponses et performance ](#part2)




<a name="contexte"></a>
## Contexte

Le potentiel énorme associé aux données médicales a conduit le secteur de la santé à une transformation importante et rapide. Pour progresser dans la bonne voie, les praticiens (médecins, personnel infirmier) et les administrateurs d'établissements doivent pouvoir accéder directement aux informations exploitables dans les données médicales, afin d'améliorer leurs performances et la qualité des soins de manière mesurable.  

le groupe CHU (Cloud Healthcare Unit), faisant partie du secteur hospitalier, as pris conscience de la nécessité d’une transformation digitale, notamment au niveau des données. Notre service est sollicité pour mettre en place leur propre entrepôt de données qui permettra au groupe d'exploiter la quantité considérable de données générées par les systèmes de gestion de soins.  

Dans le dernier rapport nous avions illustré les différentes manières dont nous avons travaillé avec les données fournies, de façon à arriver à nos fins. Nous avons vu en détail l'architecture utilisée, et les différents programmes et phases par lesquelles nos données sont passées. Finalement nous avons étudié en détail les données récoltées à la suite de ce livrable dans le prochain. 

Dans ce rapport nous détaillerons les scripts nécessaires à création des tables dans Hive, le chargement et l'affichage des données pour la vérification. La structure de nos table sera optimisée et partitionnée avec des buckets pour réduire le temps de réponse de nos requêtes. 

<a name="part1"></a>
## Création des tables et chargements des données et vérification


Tout d'abord on commence par créer notre base de données, avec la requête : 
```SQL
CREATE DATABASE CHU ;
```
où `CHU` est le nom de la base de données.  

<a name="part1_1"></a>
### Script pour la création des tables

#### Création des tables dans Hive

Voici le script qui permet de créer les différentes tables dans Hive.
Comme vu dans le livrable précédent, nos tables de base de données suivront notre schéma décisionnel en étoile. Nous aurons donc une table de fait qui regroupe nos mesures par dimensions, et des tables qui représentent les dimensions Dates, Localisations, Diagnostiques, Patients, et Professionnels de santé. 

#### Table de faits
Dans notre table de faits on stocke nos mesures, l'identifiant de la dimension à laquelle cette mesure est reliée. 
Le `CLUSTERED BY (localisation_id, date_id) INTO 256 BUCKETS` permet de partionner notre table en 256 buckets. 

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

#### Dimension Dates
Pour la table `Dates` on a besoin de stocker un id généré, le jour, le mois et l'année de la date. 
De même ici on partionne notre table en 20 buckets. 

```SQL
-- Dates
CREATE TABLE IF NOT EXISTS dates (
    id INT,
    year INT,
    month INT,
    day INT
) CLUSTERED BY (year) SORTED BY (year, month, day) INTO 20 BUCKETS ROW FORMAT DELIMITED FIELDS TERMINATED BY '\;' LINES TERMINATED BY '\n' STORED AS TEXTFILE;
```  
#### Dimension Localisations 
Pour la table `Localisations` on a besoin de stocker un id généré, et la région. 

```SQL
-- Localisations
CREATE TABLE IF NOT EXISTS localisations (
    id INT,
    region VARCHAR(256)
) ROW FORMAT DELIMITED FIELDS TERMINATED BY '\;' LINES TERMINATED BY '\n' STORED AS TEXTFILE;
```  
#### Dimension Diagnostiques
Pour la table `Diagnostiques` on a besoin de stocker un id qui a été généré, le code du diagnostique et le nom du diagnostique.

```SQL
-- Diagnostiques
CREATE TABLE IF NOT EXISTS diagnostiques (
    id INT,
    code_diag VARCHAR(256),
    diagnostique VARCHAR(25565)
) ROW FORMAT DELIMITED FIELDS TERMINATED BY '\;' LINES TERMINATED BY '\n' STORED AS TEXTFILE;
```  
#### Dimension Patients
Pour la table `Patients` on a besoin de stocker id généré, le sexe du patient et son age. 
On partitionne nos patients par sexe, on a donc deux partitions.

```SQL
-- Patients
CREATE TABLE IF NOT EXISTS patients (
    id INT,
    sexe VARCHAR(256),
    age INT
) CLUSTERED BY (sexe, age) INTO 256 BUCKETS ROW FORMAT DELIMITED FIELDS TERMINATED BY '\;' LINES TERMINATED BY '\n' STORED AS TEXTFILE;
```  
#### Dimension Professionnels
Pour la table Professionnels de santé, nommé `Professionels` on a besoin de stocker l'id qui a été généré, le nom du professionnel de santé, et l'établissement dans lequel il exerce (si il exerce en libéral, l'établissement n'est pas spécifié).

```SQL
-- Professionels
CREATE TABLE IF NOT EXISTS professionnels (
    id INT,
    nom VARCHAR(256),
    etablissement VARCHAR(256)
) CLUSTERED BY (id) INTO 32 BUCKETS ROW FORMAT DELIMITED FIELDS TERMINATED BY '\;' LINES TERMINATED BY '\n' STORED AS TEXTFILE;
```  

<a name="part1_2"></a>
### Chargement des données dans la table

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

Si jamais on doit récupérer un fichier de backup, qui n'est donc pas dans HDFS, pour remplir nos tables, on peut utiliser la même requête en ajoutant `LOCAL`, ce qui donnerais une requête dans cette forme : 
```SQL
LOAD DATA LOCAL INPATH '/chemin' INTO TABLE table_name
```
<a name="part1_3"></a>
### Vérification des données dans les tables 

Après avoir chargé nos données dans nos tables, nous vérifions la présence et la cohérence de données pour les différentes tables. 

#### Dimension Dates
```SQL 
SELECT * FROM dates 
```  
![image](https://user-images.githubusercontent.com/56393986/169074411-61b892b2-ed12-49b0-adf6-d3b67d6b244b.png)

#### Dimension Diagnostiques
```SQL 
SELECT * FROM diagnostiques 
```  
![image](https://user-images.githubusercontent.com/56393986/169074976-ba4189d2-9e51-4fd5-a613-fe82cb13a990.png)

#### Dimension Localisations
```SQL 
SELECT * FROM localisations
```  
![image](https://user-images.githubusercontent.com/56393986/169075559-7b3f63f4-8dff-4ab8-a499-8f84da6c1873.png)

#### Dimension Patients
```SQL 
SELECT * FROM patients 
```  
![image](https://user-images.githubusercontent.com/56393986/169075792-56c8bdd5-2164-4c39-8931-84fc0339dd9d.png)

#### Dimension Professionnels
```SQL 
SELECT * FROM professionnels 
```  
![image](https://user-images.githubusercontent.com/56393986/169080901-779a173f-477a-4e73-aabb-8d3a5a996c5d.png)

Pour les médecins libéraux on ne note pas l'éblissement auquel le professionnel est relié, car il n'est pas relié à un établissement. 
![image](https://user-images.githubusercontent.com/56393986/169081989-eadd4004-198c-4e97-a0ed-97d5ed20decc.png)

#### Table de faits
```SQL 
SELECT * FROM faits 
``` 
![image](https://user-images.githubusercontent.com/56393986/169088416-ac4a4f10-7cf5-4028-8de4-bddd3725e0f0.png)
On peux ici voir dans notre table de faits la mesure 'nombre de décès' et les références aux dimensions qui lui sont associées, ici la localisation.  

![image](https://user-images.githubusercontent.com/56393986/169089109-2c41635f-41c0-4b18-8bca-ca19d9a51dcc.png)
De même ici avec la satisfaction reliée à la localisation.  

![image](https://user-images.githubusercontent.com/56393986/169089532-bce0aa21-61c0-4373-b6ca-6beac80e0c85.png)
Ici on voit le nombre d'hospitalisations par diagnostique, professionnel, date et par patient.

![image](https://user-images.githubusercontent.com/56393986/169091945-3bd6a9e6-0345-4e4b-9a44-e9a6240e5412.png)
ici on a le nombre de consultations, par diagnostique, professionnel, date et patient. 

<a name="part2"></a>
## Graphes des temps de réponses et performance

Pour analyser le temps d'execution entre notre base de données partitionnée et la même base de donnée mais non partitionnée, on crée une deuxième base de données sans les partitions et on relève le temps d'executions des requêtes sur les deux bases différentes. 

Pour évaluer notre temps de réponse (et donc la performance d'accès à l'entrepôt de données) on utilise plusieurs requêtes :
```SQL
requetes sql de pl
``` 

### Graphes montrant les temps de réponses pour évaluer la performance d'accès à l'entrepôt de données 
### Requêtes faisant foi pour l'évaluation de la performance
