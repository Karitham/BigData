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




