Big Data: Referentiel des donnees
=================================

Ce rapport illustre les differentes manieres dont nous travaillons avec les donnees fournies, de facon a arriver a nos fins.

Nous verrons en detail l'architecture utilisee, et les differents programmes et phases par lesquelles nos donnees sont passees.

Nous etudierons en detail les donnees recoltees a la suite de ce livrable dans le prochain.

Modele dimensionnel des donnees
-------------------------------

![modele dimmensionel des donnees](./data_warehouse.jpg)

Architecture
------------

L'architecture exposee ci-dessous est composee de 3 parties :

-	Les sources
	-	Fichiers CSV (UTF-8)
	-	Fichiers Excel (xlsx, UTF-8)
	-	Base de donnee Postgres (`pg://postgres:cesi@localhost:5432/soins_medico_administratifs`\)
-	Les transformations
-	Les sorties

Nos entrees ne sont pas des mappages 1-1 avec nos sorties, et certaines sorties sont composees d'aggregats d'autres sorties, telle que la table de fait.

Nous avons donc des etapes intermediaires. Il nous faut par exemple stoquer les transformations des dimensions pour remplir la table de fait. De plus, les dimensions elle-memes peuvent dependre d'autre dimensions, ou tout simplement d'autre aggregats.

<!-- insert diagram here -->
