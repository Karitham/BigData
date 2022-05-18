-- Taux de consultation des patients dans un établissement X sur une période de temps Y
SELECT sum(faits.nb_consultations) / (count(*) over()),
	faits.professionnel_id
FROM faits
	INNER JOIN dates ON faits.date_id = dates.id
WHERE faits.nb_consultations IS NOT NULL
	AND dates.year = ?
GROUP BY faits.professionnel_id;
-- Taux de consultation des patients par rapport à un diagnostic X sur une période de temps Y
SELECT sum(faits.nb_consultations) / (count(*) over()),
	diagnostique_id
FROM faits
	INNER JOIN dates ON faits.date_id = dates.id
WHERE faits.nb_consultations IS NOT NULL
	AND dates.year = ?
GROUP BY diagnostique_id;
-- Taux global d'hospitalisation des patients dans une période donnée Y
SELECT sum(faits.nb_hospitalisations) / (count(*) over()),
	dates.year -- TODO FIXME WTF CA MARCHE PAS
FROM faits
	INNER JOIN dates ON faits.date_id = dates.id
WHERE faits.nb_hospitalisations IS NOT NULL
GROUP BY dates.year;
-- Taux d'hospitalisation des patients par rapport à des diagnostics sur une période donnée
SELECT sum(faits.nb_hospitalisations) / (sum(faits.nb_hospitalisations) over()),
	faits.diagnostique_id -- TODO FIX 
FROM faits
	INNER JOIN dates ON faits.date_id = dates.id
WHERE faits.nb_hospitalisations IS NOT NULL
	AND dates.year = ?
GROUP BY faits.diagnostique_id;
-- Taux global de satisfaction par région sur l'année 2020
SELECT faits.satisfaction,
	localisations.id
FROM faits
	INNER JOIN localisations ON faits.localisation_id = localisations.id
WHERE faits.satisfaction IS NOT NULL;
-- Nombre de décès par localisation (région) et sur l'année 2019
SELECT sum(faits.nb_deces),
	faits.localisation_id
FROM faits
	INNER JOIN localisations ON faits.localisation_id = localisations.id
WHERE faits.nb_deces IS NOT NULL
GROUP BY faits.localisation_id;
-- Taux de consultation par professionnel
SELECT sum(faits.nb_consultations) / (count(*) over()),
	faits.professionnel_id
FROM faits
WHERE faits.nb_consultations IS NOT NULL
GROUP BY faits.professionnel_id;
-- Taux d'hospitalisation/consultation par sexe, par âge
SELECT sum(faits.nb_consultations) + sum(faits.nb_hospitalisations),
	patients.sexe,
	patients.age
FROM faits
	INNER JOIN patients ON faits.patient_id = patients.id
GROUP BY sexe,
	age;