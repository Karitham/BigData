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


Tout d'abord on commence par créer notre base de données. 



### Script pour la création et le chargement de données dans les tables

Voici le script qui permet de créer les différentes tables dans Hive.
Comme vu dans le livrable précédent, nos tables de base de données suivront notre schéma décisionnel en étoile. Nous aurons donc une table de fait qui regroupe nos mesures par dimensions, et des tables qui représentent les dimensions Dates, Localisations, Diagnostiques, Patients, et Professionnels de santé. 


```SQL
-- Table de fait

``` 

Pour la table `Dates` on a besoin de stocker un id généré, le jour, le mois et l'année de la date. 
```SQL
-- Dates

```  

Pour la table `Localisations` on a besoin de stocker un id généré, et la région. 
```SQL
-- Localisations

```  

Pour la table `Diagnostiques` on a besoin de stocker un id qui a été généré, le code du diagnostique et le nom du diagnostique. 
```SQL
-- Diagnostiques

```  

Pour la table `Patients` on a besoin de stocker id généré, le sexe du patient et son age. 
```SQL
-- Patients

```  

Pour la table Professionnels de santé, nommé `Professionels` on a besoin de stocker l'id qui a été généré, le nom du professionnel de santé, et l'établissement dans lequel il exerce (si il exerce en libéral, l'établissement n'est pas spécifié).
```SQL
-- Professionels

```  





### Vérification des données présentes et accès aux données à travers les tables
### Script montrant le peuplement des tables
### Script pour le partitionnement et les buckets

## Graphes des temps de réponses et performance

### Graphes montrant les temps de réponses pour évaluer la performance d'accès à l'entrepôt de données 
### Requêtes faisant foi pour l'évaluation de la performance
