# Livrable 2 : Modèle physique et optimisation

Ressources : 
- [ Script Tables ](https://github.com/Karitham/BigData/blob/master/Livrable2/tables.sql)
- [ Sccript Requêtes ](https://github.com/Karitham/BigData/blob/master/Livrable2/requetes.sql)

***
## Table des matières :

1. [ Contexte ](#contexte)    
2. [ Création des tables et chargements des données ](#part1)  
	a. [ Script pour la création des tables ](#part1_1)  
	b. [ Chargement des données dans la table ](#part1_2)  
	c. [ Vérification des données dans les tables ](#part1_3)  
4. [ Graphes des temps de réponses et performance ](#part2)  
	a. [ Nos expériences ](#part2_1)   
	b. [ Conclusion ](#part2_2)  
6. [ Conclusion Livrable ](#part3)
***

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
CREATE DATABASE CHU;
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
CREATE TABLE patients (
    id INT,
    age INT
) PARTITIONED BY (sexe VARCHAR(256)) INTO 50 BUCKETS ROW FORMAT DELIMITED FIELDS TERMINATED BY '\;' LINES TERMINATED BY '\n' STORED AS TEXTFILE;
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

Pour évaluer notre temps de réponse (et donc la performance d'accès à l'entrepôt de données) on utilise cette requêtes, avec laquelle nous avons eu les plus gros problemes de performance :

```SQL
SELECT sum(faits.nb_consultations) + sum(faits.nb_hospitalisations),
	patients.sexe,
	patients.age
FROM faits
	INNER JOIN patients ON faits.patient_id = patients.id
GROUP BY sexe,
	age;
```

Cette requete prenait plus de 10 minutes (timeout) sans bucketing, ainsi que partitionnement, mais le temps significatif effectue sur la requete etait inferieur a une minute.

Apres bucketing et partitionnement, nous avons aussi timeout, et n'avons pas vu de difference significatives lors du planning de la requete ainsi que l'execution.

Il est evident que le partitionnement aurait du avoir un impact, ainsi que le bucketing.

Nos resultats en demontre le contraire, mais il est flagrant que notre VM a des problemes de performances, et que notre environnement est defecteux.

Pour le prouver, il me suffit d'effectuer une requete `SELECT count(*) FROM clients`. Cette requete mets plus de 1 minute a s'effectuer, pour compter 0 lignes, sur une table vide.

```sql
CREATE DATABASE shiny_new_test; -- 0.8s
USE shiny_new_test; -- 0.1s
CREATE TABLE clients (
    id INT,
    name VARCHAR(256),
    surname VARCHAR(256)
); -- 1.4s
SELECT count(*) FROM clients; -- 114s de runtime
```

Il est donc tout simplement impossible de mesurer les performances de facon fiable, et de demontrer de reels changements.

Theoriquement, plus nos donnees sont grosses, plus nous beneficions des avantages du parallelismes, permis par le partitionement et le bucketing.

La [Loi_d'Amdahl](https://fr.wikipedia.org/wiki/Loi_d%27Amdahl) nous le demontre facilement, et nous ne doutons pas de l'avantage du bucketing ou du partitionnement, que nous avons evidemment utilise. (cf https://github.com/Karitham/BigData/blob/master/Livrable2/tables.sql)

![AmdahlsLaw](https://upload.wikimedia.org/wikipedia/commons/thumb/e/ea/AmdahlsLaw.svg/1280px-AmdahlsLaw.svg.png)

Neanmoins, nos experiences se montrent peu concluentes sur les gains de performances, et nous voyons meme des regressions sur certaines tables.

Il est evident que cela ne devrait pas etre le cas, mais les conditions ne nous ont pas permis de le prouver.


<a name="part2_1"></a>
### Nos expériences

Notre table `test` n'est pas partionnée, la table `test2` est partitionnée. 

#### Taux de consultation des patients dans un établissement X sur une période de temps Y
```SQL
-- Taux de consultation des patients dans un établissement X sur une période de temps Y
SELECT sum(faits.nb_consultations) / (count(*) over()),
	faits.professionnel_id
FROM faits
	INNER JOIN dates ON faits.date_id = dates.id
WHERE faits.nb_consultations IS NOT NULL
	AND dates.year = ?
GROUP BY faits.professionnel_id;
```
##### test
![image](https://user-images.githubusercontent.com/56393986/169105806-7bf2e778-1710-4416-ae75-45ea11bd2219.png)
![image](https://user-images.githubusercontent.com/56393986/169108747-c0bb680f-8f14-49d2-b20f-0148375b4012.png)
##### test2
![image](https://user-images.githubusercontent.com/56393986/169106832-d3bd5c0d-490c-422c-a8a2-b16f5f9515f6.png)
![image](https://user-images.githubusercontent.com/56393986/169107414-136f24a8-cc51-4fe1-b6ee-3d82436f23e0.png)



#### Taux de consultation des patients par rapport à un diagnostic X sur une période de temps Y
```SQL
-- Taux de consultation des patients par rapport à un diagnostic X sur une période de temps Y
SELECT sum(faits.nb_consultations) / (count(*) over()),
	diagnostique_id
FROM faits
	INNER JOIN dates ON faits.date_id = dates.id
WHERE faits.nb_consultations IS NOT NULL
	AND dates.year = ?
GROUP BY diagnostique_id;
```
##### test
![image](https://user-images.githubusercontent.com/56393986/169109336-54c3691b-cabb-4429-946d-52f6b3cc7ed4.png)
##### test2
![image](https://user-images.githubusercontent.com/56393986/169110672-8e9a419a-16ae-4d44-a40b-e37c667ff22a.png)

#### Taux global de satisfaction par région sur l'année 2020
```SQL
-- Taux global de satisfaction par région sur l'année 2020
SELECT faits.satisfaction,
	localisations.id
FROM faits
	INNER JOIN localisations ON faits.localisation_id = localisations.id
WHERE faits.satisfaction IS NOT NULL;
```
##### test
![image](https://user-images.githubusercontent.com/56393986/169111660-3032f8af-bd47-4b72-a558-bfafb20c3de3.png)
##### test2
![image](https://user-images.githubusercontent.com/56393986/169112264-b48449c9-9056-4f1d-a35f-6699c773c99f.png)

#### Nombre de décès par localisation (région) et sur l'année 2019
```SQL
-- Nombre de décès par localisation (région) et sur l'année 2019
SELECT sum(faits.nb_deces),
	faits.localisation_id
FROM faits
	INNER JOIN localisations ON faits.localisation_id = localisations.id
WHERE faits.nb_deces IS NOT NULL
GROUP BY faits.localisation_id;
```
##### test 
![image](https://user-images.githubusercontent.com/56393986/169113327-9aee8640-510e-4f56-9772-3f596ac130d8.png)
##### test2
![image](https://user-images.githubusercontent.com/56393986/169116288-ae29464c-0025-428e-ad99-b2403bbc296c.png)

#### Taux de consultation par professionnel
```SQL
-- Taux de consultation par professionnel
SELECT sum(faits.nb_consultations) / (count(*) over()),
	faits.professionnel_id
FROM faits
WHERE faits.nb_consultations IS NOT NULL
GROUP BY faits.professionnel_id;
```
##### test
![image](https://user-images.githubusercontent.com/56393986/169116790-08c09e4e-1a97-463b-9815-2cb24749b476.png)
##### test2
![image](https://user-images.githubusercontent.com/56393986/169117156-0c8d5c9d-4936-48e7-8114-0a101dc89475.png)

#### Taux d'hospitalisation/consultation par sexe, par âge
```SQL
-- Taux d'hospitalisation/consultation par sexe, par âge
SELECT sum(faits.nb_consultations) + sum(faits.nb_hospitalisations),
	patients.sexe,
	patients.age
FROM faits
	INNER JOIN patients ON faits.patient_id = patients.id
GROUP BY sexe,
	age;
```
Dans les deux bases de données cette requête se fait timeout, mais à des durées différentes.
##### test
![image](https://user-images.githubusercontent.com/56393986/169117555-bc125cf4-d503-48cf-8401-dc3036d8a804.png)
##### test2
![image](https://user-images.githubusercontent.com/56393986/169117859-7bb3a58c-846c-4792-b2f2-360d37b4eb7d.png)


<a name="part2_2"></a>
### Conclusion 
Les données récoltées sont trop peu nombreuses pour montrer un écart significatif, on peut néamoins voir que l'on gagne quelques secondes sur notre base de données où l'on a partitionné et installé des buckets. 


| Nom de la requête                                                                          | test   | test2  |
|--------------------------------------------------------------------------------------------|--------|--------|
| Taux de consultation des patients dans un établissement X sur une période de temps Y       | 87     | 88     |
| Taux de consultation des patients par rapport à un diagnostic X sur une période de temps Y | 95     | 88     |
| Taux global de satisfaction par région sur l'année 2020                                    | 39.34  | 51.46  |
| Nombre de décès par localisation (région) et sur l'année 2019                              | 58.21  | 50.66  |
| Taux de consultation par professionnel                                                     | 71     | 60     | 
| Taux d'hospitalisation/consultation par sexe, par âge                                      | 90     | 80     |
| Total                                                                                      | 440.55 | 418.12 |


![image](https://user-images.githubusercontent.com/56393986/169132004-a4c6fed5-7790-4802-990d-c2b61395f752.png)

<a name="part3"></a>
## Conclusion Livrable

Pour ce Livrable, nous avons mis en place notre base de données avec les tables nécessaires pour réaliser notre model  décisionnel en étoile. Nous avons donc définis une table de faits, et nos tables qui représentent les dimensions, -insérer les différentes dimensions-. Ensuite nous avons rempli nos tables avec les données précédemment traitées et enregistrées dans HDFS, grâce à nos jobs Talend. Puis nous avons vérifié nos données en faisant des sélections sur nos tables. Nous avons aussi partitionné nos tables en partitions et buckets pour gagner en performance.  
Pour terminer nous avons traduits nos requêtes en besoins et nous les avons executé pour mesurer les performances. 


