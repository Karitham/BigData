Big Data: Referentiel des donnees
=================================

Ce rapport illustre les differentes manieres dont nous travaillons avec les donnees fournies, de facon a arriver a nos fins.

Nous verrons en detail l'architecture utilisee, et les differents programmes et phases par lesquelles nos donnees sont passees.

Nous etudierons en detail les donnees recoltees a la suite de ce livrable dans le prochain.

Modele dimensionnel des donnees
-------------------------------

![modele dimmensionel des donnees](./data_warehouse.jpg)

Ce schema represente un modele dimensionnel en etoile.

Le modele en etoile a un avantage principal: Il minimise les jointures, ce qui est extremement important en Big Data. De plus, vu que l'on travail avec Hive, et que Hive nous restraint sur le nombre de jointures.

Il a aussi des inconveniants, tels que la de-normalisation partielle de certaines donnees, mais dans notre cas, la vitesse d'execution est plus importante que l'espace pris.

Il existe d'autre modeles, tels que en flocon, ou meme en constellation, que l'on a juge moins adapte a nos besoins et qui ne seront donc pas decris icis.

La table centrale est la table de fait. Elle pourrait etre decoupee en 2 parties:

-	Vert: Liens avec les dimensions autour
-	Jaune: Donnees calculees. Dans notre cas specifique, elles representent les donnees par jour, et par region.

Elle represente les donnees qui nous interessent reelement, et sur lesquelles nous basons nos analyses.

Nous avons besoins d'autre tables autour de la table de Fait, pour etendre nos relations et obtenir un contexte plus pousse pour nos analyses, tout en gardant une certaine forme de normalisation.

Chaque table autour de la table de fait est donc appellee une table de dimension, car elle donne des *dimensions* a nos donnees, elle les contextualise et les rends exploitable.

Le nom de model en etoile est assez simple a comprendre avec ces informations: la table de fait represente le corps de l'etoile, et chaque dimension une de ces branches.

Ce schema de la documentation microsoft powerBI la represente de facon tres explicite: ![schema etoile doc microsoft](https://docs.microsoft.com/fr-fr/power-bi/guidance/media/star-schema/star-schema-example1.png)

Pour en apprendre plus sur les schemas en etoile, vous trouverez [ici](https://docs.microsoft.com/fr-fr/power-bi/guidance/star-schema) des explications plus poussees sur les nombreux avantages qu'elle nous fournit.

Dans notre cas, nous avons fait le choix d'avoir 5 dimensions:

-	Professionels de sante:
    -	Taux de consultation des patients dans un établissement X
    -	Taux de consultation par professionnel
-	Diagnostiques
    -	Taux de consultation des patients par rapport à un diagnostic X sur une période de temps Y
    -	Taux d'hospitalisation des patients par rapport à des diagnostics sur une période donnée
-	Dates
    -	Taux de consultation des patients dans un établissement X sur une période de temps Y
    -	Taux de consultation des patients par rapport à un diagnostic X sur une période de temps Y
    -	Taux global d'hospitalisation des patients dans une période donnée Y
    -	Nombre de décès par localisation (région) et sur l'année 2019
    -	Taux global de satisfaction par région sur l'année 2020
-	Patients
    -	Taux d'hospitalisation/consultation par sexe, par âge
-	Localisation
    -	Nombre de décès par localisation (région) et sur l'année 2019

Ces dimensions sont intemement liees aux besoins des decideurs, car nous ne souhaitons ne stoquer que les donnees necessaires, mais il faut evidemment en stoquer assez.

Une fois notre modele choisis, il nous faut transformer nos donnees sources, tres disparates, de facon a les integrer pour pouvoir operer dessus.

Architecture
------------

L'architecture exposee ci-dessous est composee de 3 parties :

-	Les sources
	-	Fichiers CSV (UTF-8)
	-	Fichiers Excel (xlsx, UTF-8)
	-	Base de donnee Postgres (`pg://postgres:cesi@localhost:5432/soins_medico_administratifs`)
-	Les transformations
-	Les sorties

Nos entrees n'ont pas de relations 1-1 avec nos sorties, et certaines sorties sont composees d'aggregats d'autres sorties, telle que la table de fait.

Nous avons donc des etapes intermediaires. Il nous faut par exemple stoquer les transformations des dimensions pour remplir la table de fait. De plus, les dimensions elle-memes peuvent dependre d'autre dimensions, ou tout simplement d'autre aggregats.

![image](https://user-images.githubusercontent.com/57440386/168479668-5c24650c-8db9-4158-916f-65200e2436fd.png)

Nous utilisons plusieurs etapes intermediaires de facon a reduire les transformations necessaires, et nous utilisons donc des fichiers delimites (CSV) en tant que cache de fortune, que l'on stoque dans l'HDFS.

Toutes les differentes transformations nous permettent de construire les differentes dimensions, avec lesquelles nous pouvons creer notre table de fait finale.

En fonction de nos besoins, la construction de notre table de fait va differer. Ici, nous avons fait le choix de stoquer les faits en fonction de 3 dimensions clefs: `jour`, `sexe` et `region`, qui vont nous permettre d'avoir des mesures assez precise sans avoir trop d'impact sur le temps d'execution de nos requetes plus tard.

Ces dimensions choisies ont aussi un autre role: il nous est possible de partitionner les tables dans Hive avec ces dimensions, ce qui nous permet encore de reduire les temps de requetes. L'avantage est donc double, puisque nous gagnons du temps d'execution, et que nous n'avons que tres peu de transformations a effectuer pour le partitionnement.

Ci-dessous, des exemples de tâches effectuées par l'ensemble de l'equipe:

### Localisations

Le job localisation permet d'avoir les informations du nombre de personnes décédées ou le taux de satisfaction par régions

exemple pour les décès par régions : 

On récupère le nombre de personnes décédés et les régions de leurs décès dans les CSV ( ici 2019 ).
Puis on additionne les doublons dans le tAggregate.

Dans le tMap on fait sortir que le Nom et le Code de la région avec le nombre de personne décédés par région.
On utilise Uniqrow pour obtenir une seul fois la ligne de la région dans le tableau.

![image](https://user-images.githubusercontent.com/94054434/168470768-092d6971-5c0f-49ed-b46d-e2ee1fc181ed.png)

on obtient donc : 

![image](https://user-images.githubusercontent.com/94054434/168473249-a5a033e5-3909-43c5-ba77-70e2fd0e3964.png)

![image](https://user-images.githubusercontent.com/94054434/168473279-5242801e-cc64-43fc-943e-7c067b5e8828.png)

Pour le taux de satisfaction par région il faut faire la moyenne par région des taux globaux des hospitalisation moins de 48heures ou plus 48 heures.

On importe dans le tMap les résultats par régions que l'on fait ressortir puis on évite d'avoir des doublons de régions dans le Uniqrow pour obtenir qu'une seule fois chaque région avec la moyenne correspondante a cette dernière.

![image](https://user-images.githubusercontent.com/94054434/168473370-a2e06f46-8dfe-415e-beda-baa4a1bbeb98.png)

![image](https://user-images.githubusercontent.com/94054434/168473403-5edca131-9846-44a9-a206-555baa7ef5c5.png)

### Professionel de Santé

Le job Professionels de santé permets de remplir notre dimension Professionnels de santé qui contient un id généré, le nom du praticien, et l'établissement de santé auquel il est relié. 

![image](https://user-images.githubusercontent.com/56393986/168463712-5ff0c9b5-d7a1-4bd3-ae6c-b3fe9b106cdf.png)

On récupère les informations de différentes sources : les fichiers CSV et la base de données postgres.
Tout d'abord (en haut, au milieu du schéma) on récupère les informations des CSV "etablissement_sante" et "activite_professionels_sante" que l'on joint avec un tmap pour récupérer les identifiants des établissements qui sont reliés à des professionnels de santé, les identifiants des professionnels de santé et la raison sociale de l'établissement (équivalente à son nom)

![image](https://user-images.githubusercontent.com/56393986/168463884-bf70b0ca-ccba-462d-80ef-dff8fae15066.png)

Ensuite on se connecte à la table des professionnels de santé de postgres et on récupère les informations du CSV des professionnels de santé, et on joint les deux pour récupérer tous les professionnels de santé. On part du principe que certaines informations peuvent différer dans les fichiers CSV et postgres et on joint donc les deux pour bien récupérer toutes les informations. A l'aide du Tmap on trie les informations necessaires et on ne garde que l'identifiant et le nom du professionnel de santé.

![image](https://user-images.githubusercontent.com/56393986/168470186-c03c2d1e-0436-4035-8302-3bae64099397.png)

Ensuite on joint nos deux output tmap pour pouvoir générer notre dimension finale avec un identifiant autogénéré, le nom du praticien et l'établissement dans lequel il exerce (si le praticien est en libéral, la colonne établissement reste vide). 

![image](https://user-images.githubusercontent.com/56393986/168470197-9e675619-5b74-44f9-be3b-c3b26f71a69e.png)

On enregistre ensuite le tout dans HDFS, et on affiche notre résultat dans un LogRow. 
![image](https://user-images.githubusercontent.com/56393986/168464122-7c69add8-2151-4f71-81e8-f1e6ede6aff3.png)

### Diagnostiques

Le job dans Talend, ne pas oublier d'enlever tout le surplus dans la requête

```SQL
"SELECT
\"Code_diag\",
\"Diagnostic\"
FROM \"Diagnostic\""
```
![image](https://user-images.githubusercontent.com/56252271/168082095-7c7f2c6c-540c-4a79-be39-4fd0619c1e8d.png)

tMap du job Diagnostic:

![image](https://user-images.githubusercontent.com/56252271/168082727-5ba7dc28-8487-40c1-ab4c-ccf058b82d4b.png)

### Patients

SQL:

```SQL
SELECT
"Id_patient",
"Sexe",
"Age"
FROM "Patient"
```
![image](https://user-images.githubusercontent.com/56252271/168428595-b7d2db6c-9cfb-4304-af0e-c5f5d5491dc0.png)

Le mapping:

![image](https://user-images.githubusercontent.com/56252271/168429117-d41ccab4-b098-411a-b81e-1bac61e398df.png)

Le résultat:

![image](https://user-images.githubusercontent.com/56252271/168429158-8a79c341-ae9d-4e58-b575-64c8698cf0d7.png)

Evidemment nous avons fait d'autre tâches intermediaires pour remplir la table de fait, et d'autres dimensions "secondaires" telles que les dates,

![image](https://user-images.githubusercontent.com/57440386/168025168-ded94fb0-2684-4e1b-8deb-cb9fc99252a3.png)

![image](https://user-images.githubusercontent.com/57440386/168076405-d8aa6e21-f84a-40dd-b7fe-7aaa82f3623a.png)

Pour lesquelles nous avons besoins de plusieurs sources de données différentes a aggreger.
