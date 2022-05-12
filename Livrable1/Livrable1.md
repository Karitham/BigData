# Livrable 1 : Référentiel de données

Modèle conceptuel des données et jobs nécessaires pour alimenter le schéma décisionnel

Description :
- Modélisation des différents axes d'analyse ainsi que les mesures
- Développement des jobs d'alimentation du schéma décisionnel
- Description de l'architecture de l’entrepôt de données

Format : Rapport
Échéance : 13/05/2022

# Livrable 1

## Modélisation des différents axes d'analyse ainsi que les mesures

**Besoins utilisateurs** :
Une première consultation a permis de mettre en évidence le type d'analyses souhaitées par les utilisateurs :
- Taux de consultation des patients dans un établissement X sur une période de temps Y
- Taux de consultation des patients par rapport à un diagnostic X sur une période de temps Y
- Taux global d'hospitalisation des patients dans une période donnée Y
- Taux d'hospitalisation des patients par rapport à des diagnostics sur une période donnée
- Taux d'hospitalisation/consultation par sexe, par âge
- Taux de consultation par professionnel
- Nombre de décès par localisation (région) et sur l'année 2019
- Taux global de satisfaction par région sur l'année 2020

https://www.figma.com/file/EL2AWFi2fTb4YMNwyjobal/BigData?node-id=0%3A1
![image](https://user-images.githubusercontent.com/57440386/168024178-2aec1741-6448-4b45-a257-e990703a8c81.png)


## Développement des jobs d'alimentation du schéma décisionnel

comme sur le WSProsit 2

## Description de l'architecture de l’entrepôt de données

datawharehouse => prosit 2

# Notes

## Jobs Talend

BM_Livrable => nom du nouveau buisness model  
objectifs : Livrable

nom du Job : AlimentationLivrable
objectif : bdd livrable1

**Sources de données:**
DB Postgres : soins_medico_administratifs
CSV : activité professionnel de santé, etablissement santé, professionnel de santé, satisfaction (2016,17-18,19,20), liste des personnes décédées (2010-2021), Hospitalisations

## connection talend aux sources de données :

**connexion à la base de donnée PG**

PgProjet
connecter à la base pg soin medico administratifs
permets de connecter à la base de données postgres 'soins_medico_administratifs'

mot de passe = cesi  
![image](https://user-images.githubusercontent.com/56393986/168025172-4f3e7aee-dc48-44f4-9347-49003699342d.png)

**CSV etablissements**  
![image](https://user-images.githubusercontent.com/56393986/168025870-a3c3ecc2-3332-4f2b-8a9f-6f21a3e76e25.png)
![image](https://user-images.githubusercontent.com/56393986/168026051-126a303a-7421-4bee-a317-90e427f2f28a.png)
cocher la case définir les nom de colonne en entête (ou je sais plus c'est quoi le nom)  
![image](https://user-images.githubusercontent.com/56393986/168026166-87d5e801-acac-4d75-8499-3b23d7f85e76.png)
![image](https://user-images.githubusercontent.com/56393986/168026463-3d6b35c5-c518-40bf-a8e8-b78314c43c72.png)

**CSV ProSanté**  
![image](https://user-images.githubusercontent.com/56393986/168027264-98ecd001-f232-4cbf-82fd-9275414a854c.png)
![image](https://user-images.githubusercontent.com/56393986/168027483-fbd4bdaf-1608-4433-8664-695319aa89d4.png)
![image](https://user-images.githubusercontent.com/56393986/168027703-85e5e612-bfef-41b2-bfd1-c45b1585e8c8.png)







 

