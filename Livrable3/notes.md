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
Pour connecter notre base de données à PowerBI, il faut appuyer sur `Plus...` dans `Obtenir les données` dans la barre de l'Accueil. 

![image](https://user-images.githubusercontent.com/56393986/169240436-a1f12f83-ed0b-41a9-b8a7-7951f2f19130.png)

Ensuite on choisit Hive et on se connecte (Si ça marche pas sur Hive il faut prendre Impala).
![image](https://user-images.githubusercontent.com/56393986/169240915-f72a321d-1b88-49ac-8ed1-9f4f17a0916d.png)
![image](https://user-images.githubusercontent.com/56393986/169242027-3e553d14-a4c8-47e3-a99c-98658e82bcfe.png)

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
