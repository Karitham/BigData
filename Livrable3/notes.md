# Livrable 3 : Présentation des résultats et storytelling

La soutenance du projet doit refléter l'interprétation des résultats d'analyse à travers un tableau de bord.  
Il va falloir construire un récit convaincant basé sur des résultats des requêtes et des analyses complexes à travers des graphiques et des tableaux qui aident à soutenir le message de votre histoire pour influencer et informer les décideurs et les praticiens du groupe CHU.

Votre présentation se focalisera sur les aspects suivants :

- Présentation de la méthodologie adoptée pour la conception et l'implémentation du système décisionnel Big Data pour la santé
- Spécification des besoins en matière de pilotage de l'activité médicale des patients
- Conception et constitution de l'entrepôt de données
- Restitution et storytelling
- Démonstration technique

Format : Présentation orale de 20min +10min de questions/réponses Date de réalisation : 20/05/2022


## Connexion à Hive via PowerBI
Pour connecter notre base de données à PowerBI, il faut d'abord configuer l'ODBC Driver.

![image](https://user-images.githubusercontent.com/56252271/169271086-84a29f24-2942-4716-8e81-ed495587cdf1.png)


Il faut ensuite ajouter un utilisateur "Cloudera ODBC Driver for Apache Hive" et cliquer sur finish.
![image](https://user-images.githubusercontent.com/56252271/169271564-68fd34f7-b635-41d3-826c-3025b5de2fb0.png)

On a une nouvelle fenêtre qui s'ouvre où on va configurer notre accès à Hive.
![image](https://user-images.githubusercontent.com/56252271/169271767-383cd45f-c103-4f82-9afa-780aade07f3b.png)

On va ensuite dans PowerBi, on importe des données, on clique sur "plus", on tape ODBC dans la barre de recherche et on se connecte à l'aide de ODBC
On met cloudera en utilisateur et mot de passe et on se connecte.

On sélectionne les tables qu'on a besoin et on les importe dans PowerBI. 
![image](https://user-images.githubusercontent.com/56393986/169242424-0fb77562-3d50-462b-b952-771cbc595145.png)

On peux Transformer les données si besoin. 

## Gestion des relations entre les tables
Notre table de faits as des clés qui relient les mesures à nos dimensions, on doit donc pouvoir être capable de relier les deux. Pour ce faire on ajoute des relations grâce à Power BI.

Dans l'onglet `Modélisation` on fait `Gérer les relations`. D'abord on supprime les relations générées automatiquement dans le cas où il y aurait une erreur, puis on crée une nouvelle relation à l'aide de `Nouveau...`.
![image](https://user-images.githubusercontent.com/56393986/169246569-fc0df0dd-1234-4332-b409-1159da4ffdaa.png)
On doit obtenir ça à la fin. 
![image](https://user-images.githubusercontent.com/56393986/169247064-3b4aa6e2-9752-454e-92e4-b4eaa351a2db.png)

Source : [ Documentation Microsoft ](https://docs.microsoft.com/fr-fr/power-bi/transform-model/desktop-create-and-manage-relationships)

## Création des Graphes PowerBI

On va créer des graphes pour visualiser nos besoins. 
Rappel sur les besoins :
- Taux de consultation des patients dans un établissement X sur une période de temps Y
- Taux de consultation des patients par rapport à un diagnostic X sur une période de temps Y
- Taux global d'hospitalisation des patients dans une période donnée Y
- Taux d'hospitalisation des patients par rapport à des diagnostics sur une période donnée
- Taux d'hospitalisation/consultation par sexe, par âge
- Taux de consultation par professionnel
- Nombre de décès par localisation (région) et sur l'année 2019
- Taux global de satisfaction par région sur l'année 2020

### 1. Taux de consultation des patients dans un établissement X sur une période de temps Y

### 2. Taux de consultation des patients par rapport à un diagnostic X sur une période de temps Y
### 3. Taux global d'hospitalisation des patients dans une période donnée Y
### 4. Taux d'hospitalisation des patients par rapport à des diagnostics sur une période donnée
### 5. Taux d'hospitalisation/consultation par sexe, par âge
### 6. Taux de consultation par professionnel
### 7. Nombre de décès par localisation (région) et sur l'année 2019
### 8. Taux global de satisfaction par région sur l'année 2020
