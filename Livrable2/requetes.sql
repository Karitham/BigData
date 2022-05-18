-- Taux de consultation des patients dans un établissement X sur une période de temps Y
SELECT avg(faits.nb_consultations)
FROM faits
	INNER JOIN dates ON faits.date_id = dates.id
WHERE faits.date_id % 10 = 0 -- consultation
	AND dates.year = ?
	AND faits.professionnel_id = ?;
-- Taux de consultation des patients par rapport à un diagnostic X sur une période de temps Y
SELECT sum(faits.nb_consultations) / (sum(faits.nb_consultations) over())
FROM faits
	INNER JOIN dates ON faits.date_id = dates.id
WHERE faits.date_id % 10 = 0 -- consultation
	AND faits.diagnostique_id = ?
	AND dates.year = ?;
-- Taux global d'hospitalisation des patients dans une période donnée Y
SELECT sum(faits.nb_hospitalisations) / (sum(faits.nb_hospitalisations) over())
FROM faits
	INNER JOIN dates ON faits.date_id = dates.id
WHERE faits.date_id % 10 = 1 -- hospi
	AND faits.diagnostique_id = ?
	AND dates.year = ?;
-- Taux d'hospitalisation des patients par rapport à des diagnostics sur une période donnée
SELECT sum(faits.nb_hospitalisations) / (sum(faits.nb_hospitalisations) over())
FROM faits
	INNER JOIN dates ON faits.date_id = dates.id
WHERE faits.date_id % 10 = 1 -- hospi
	AND dates.year = ?
GROUP BY faits.diagnostique_id;
-- Taux global de satisfaction par région sur l'année 2020
SELECT faits.satisfaction
FROM faits
	INNER JOIN localisations ON faits.localisation_id = localisations.id
WHERE faits.date_id % 10 = 3
GROUP BY faits.localisation_id;
-- Nombre de décès par localisation (région) et sur l'année 2019
SELECT sum(faits.nb_deces),
	faits.localisation_id
FROM faits
	INNER JOIN localisations ON faits.localisation_id = localisations.id
WHERE faits.date_id % 10 = 2
GROUP BY faits.localisation_id;
-- Taux de consultation par professionnel
SELECT sum(faits.nb_consultations),
	faits.professionnel_id
FROM faits
WHERE faits.date_id % 10 = 0
GROUP BY faits.professionnel_id;
-- Taux d'hospitalisation/consultation par sexe, par âge
SELECT sum(faits.nb_consultations),
	patients.sexe,
	patients.age
FROM faits
	INNER JOIN patients ON faits.patient_id = patients.id
GROUP BY sexe,
	age;