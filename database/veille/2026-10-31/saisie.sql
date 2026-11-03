-- =====================================================================
-- Repères 2027 · veille du 2026-10-25 au 2026-10-31 · saisie (état a_valider)
-- Préparée le 3 novembre 2026. À importer dans phpMyAdmin (onglet Importer).
-- Rien n'est publié tant que validation.sql n'est pas exécuté.
-- Réimportable : les sources et le digest ne sont pas dupliqués, les faits
-- non validés de la semaine sont remplacés, le sondage n'est créé qu'une fois.
-- =====================================================================

SET NAMES utf8mb4;

-- ---------------------------------------------------------------------
-- Sources (rapport, section 7)
-- ---------------------------------------------------------------------
INSERT IGNORE INTO source (cle, url, titre, editeur, libelle_court, date_publication, niveau, consultee_le) VALUES
('lcp-2026-10-28-primaire-attal', 'https://lcp.fr/actualites/presidentielle-2027-gabriel-attal-veut-une-grande-primaire-des-democrates-pour-eviter-un', 'Présidentielle 2027: Gabriel Attal veut une "grande primaire des démocrates" pour éviter un second tour RN-LFI', 'LCP', 'LCP', '2026-10-28', 3, '2026-11-03'),
('publicsenat-2026-10-29-primaire', 'https://www.publicsenat.fr/actualites/politique/apres-la-proposition-de-primaire-de-gabriel-attal-rejetee-par-le-camp-philippe-et-retailleau-le-blocage-perdure', 'Après la proposition de primaire de Gabriel Attal, rejetée par le camp Philippe et Retailleau, le blocage perdure', 'Public Sénat', 'Public Sénat', '2026-10-29', 3, '2026-11-03'),
('lcp-2026-10-28-dates', 'https://lcp.fr/actualites/presidentielle-2027-pour-le-gouvernement-il-n-y-a-pas-de-raison-de-changer-les-dates-de', 'Présidentielle 2027: pour le gouvernement, il n''y a "pas de raison de changer" les dates de l''élection', 'LCP', 'LCP', '2026-10-28', 3, '2026-11-03'),
('publicsenat-2026-10-28-lisnard-amf', 'https://www.publicsenat.fr/actualites/politique/candidat-a-la-presidentielle-et-a-la-presidence-de-lamf-marc-fesneau-denonce-le-melange-des-genres-de-david-lisnard', 'Candidat à la présidentielle et à la présidence de l''AMF : Marc Fesneau dénonce le « mélange des genres » de David Lisnard', 'Public Sénat', 'Public Sénat', '2026-10-28', 3, '2026-11-03'),
('lcp-2026-10-27-braun-pivet', 'https://lcp.fr/actualites/presidentielle-yael-braun-pivet-plaide-pour-un-candidat-unique-du-centre-et-de-la-droite', 'Présidentielle: Yaël Braun-Pivet plaide pour un "candidat unique" du centre et de la droite, mentionnant Gérard Larcher comme recours possible', 'LCP', 'LCP', '2026-10-27', 3, '2026-11-03'),
('publicsenat-2026-10-27-glucksmann-equipe', 'https://www.publicsenat.fr/actualites/politique/presidentielle-la-senatrice-ps-laurence-rossignol-va-gerer-les-finances-de-la-campagne-de-raphael-glucksmann', 'Présidentielle : la sénatrice PS Laurence Rossignol va gérer les finances de la campagne de Raphaël Glucksmann', 'Public Sénat', 'Public Sénat', '2026-10-27', 3, '2026-11-03'),
('ipsos-2026-10-24', 'https://www.ipsos.com/fr-fr/presidentielle-2027-melenchon-progresse-le-pen-reste-en-tete', 'Présidentielle 2027 : Mélenchon progresse, Le Pen reste en tête', 'Ipsos bva', 'Ipsos bva', '2026-10-24', 4, '2026-11-03'),
('lcp-2026-09-17-zemmour', 'https://lcp.fr/actualites/presidentielle-2027-eric-zemmour-officialise-sa-candidature-441871', 'Présidentielle 2027: Éric Zemmour officialise sa candidature', 'LCP', 'LCP', '2026-09-17', 3, '2026-11-03'),
('lcp-2026-10-23-ecologistes', 'https://lcp.fr/actualites/presidentielle-une-dynamique-melenchon-chez-les-ecologistes-au-risque-de-fracturer-le', 'Présidentielle: une dynamique Mélenchon chez Les Écologistes au risque de fracturer le parti?', 'LCP', 'LCP', '2026-10-23', 3, '2026-11-03'),
('publicsenat-2026-11-02-le-pen', 'https://www.publicsenat.fr/actualites/politique/presidentielle-2027-le-debat-sur-lineligibilite-de-marine-le-pen-relance', 'Présidentielle 2027 : le débat sur l''inéligibilité de Marine Le Pen relancé', 'Public Sénat', 'Public Sénat', '2026-11-02', 3, '2026-11-03'),
('odilejacob-2026-10-14-shift', 'https://www.odilejacob.fr/catalogue/sciences-humaines/economie-et-finance/reussir-a-l-ere-des-crises_9782415016722.php', 'Réussir à l''ère des crises. Un plan robuste pour l''économie française', 'Odile Jacob', 'Odile Jacob', '2026-10-14', 4, '2026-11-03');

-- ---------------------------------------------------------------------
-- Digest du 25 au 31 octobre 2026, non publié (rapport, section 2)
-- ---------------------------------------------------------------------
INSERT IGNORE INTO digest (debut, fin, publie) VALUES ('2026-10-25', '2026-10-31', 0);
SET @dg := (SELECT id FROM digest WHERE debut = '2026-10-25');
-- Une réimportation remplace les faits non validés ; si le digest a déjà été validé, aucun fait n'est ajouté.
DELETE FROM evenement WHERE digest_id = @dg AND etat <> 'valide';
SET @deja := (SELECT COUNT(*) FROM evenement WHERE digest_id = @dg AND etat = 'valide');

-- Ordre d'affichage : à date égale, le dernier fait inséré s'affiche en premier.

-- Fait 3 (affiché en 3e) : David Lisnard et la présidence de l'AMF
INSERT INTO evenement (date_evenement, type, titre, digest_id, etat)
SELECT '2026-10-28', 'autre', 'David Lisnard brigue sa réélection à la présidence de l''Association des maires de France, prévue fin novembre ; Marc Fesneau dénonce un « mélange des genres » avec sa candidature à la présidentielle.', @dg, 'a_valider' FROM DUAL WHERE @deja = 0;
SET @e3 := IF(ROW_COUNT() > 0, LAST_INSERT_ID(), NULL);
INSERT INTO evenement_source (evenement_id, source_id, ordre) SELECT @e3, id, 1 FROM source WHERE cle = 'publicsenat-2026-10-28-lisnard-amf' AND @e3 IS NOT NULL;
INSERT INTO evenement_candidat (evenement_id, candidat_id) SELECT @e3, id FROM candidat WHERE slug IN ('lisnard') AND @e3 IS NOT NULL;

-- Fait 2 (affiché en 2e) : proposition de primaire de Gabriel Attal
INSERT INTO evenement (date_evenement, type, titre, digest_id, etat)
SELECT '2026-10-28', 'primaire', 'Gabriel Attal propose sur TF1 une « grande primaire des démocrates », qu''il présente comme un moyen d''éviter un second tour RN-LFI ; les équipes d''Édouard Philippe et de Bruno Retailleau la rejettent le lendemain.', @dg, 'a_valider' FROM DUAL WHERE @deja = 0;
SET @e2 := IF(ROW_COUNT() > 0, LAST_INSERT_ID(), NULL);
INSERT INTO evenement_source (evenement_id, source_id, ordre) SELECT @e2, id, 1 FROM source WHERE cle = 'lcp-2026-10-28-primaire-attal' AND @e2 IS NOT NULL;
INSERT INTO evenement_source (evenement_id, source_id, ordre) SELECT @e2, id, 2 FROM source WHERE cle = 'publicsenat-2026-10-29-primaire' AND @e2 IS NOT NULL;
INSERT INTO evenement_candidat (evenement_id, candidat_id) SELECT @e2, id FROM candidat WHERE slug IN ('attal', 'philippe', 'retailleau') AND @e2 IS NOT NULL;

-- Fait 1 (affiché en 1er) : dates du scrutin maintenues
INSERT INTO evenement (date_evenement, type, titre, digest_id, etat)
SELECT '2026-10-28', 'calendrier', 'Le gouvernement exclut de modifier les dates du scrutin, fixées aux 18 avril et 2 mai 2027, après des demandes en ce sens, dont celle de Bruno Retailleau.', @dg, 'a_valider' FROM DUAL WHERE @deja = 0;
SET @e1 := IF(ROW_COUNT() > 0, LAST_INSERT_ID(), NULL);
INSERT INTO evenement_source (evenement_id, source_id, ordre) SELECT @e1, id, 1 FROM source WHERE cle = 'lcp-2026-10-28-dates' AND @e1 IS NOT NULL;
INSERT INTO evenement_candidat (evenement_id, candidat_id) SELECT @e1, id FROM candidat WHERE slug IN ('retailleau') AND @e1 IS NOT NULL;

-- Fait 5 (affiché en 5e) : appel de Yaël Braun-Pivet à un candidat unique
INSERT INTO evenement (date_evenement, type, titre, digest_id, etat)
SELECT '2026-10-27', 'autre', 'Dans Le Figaro, Yaël Braun-Pivet plaide pour un candidat unique du centre et de la droite et cite Gérard Larcher parmi ceux qui pourraient incarner ce rassemblement.', @dg, 'a_valider' FROM DUAL WHERE @deja = 0;
SET @e5 := IF(ROW_COUNT() > 0, LAST_INSERT_ID(), NULL);
INSERT INTO evenement_source (evenement_id, source_id, ordre) SELECT @e5, id, 1 FROM source WHERE cle = 'lcp-2026-10-27-braun-pivet' AND @e5 IS NOT NULL;

-- Fait 4 (affiché en 4e) : équipe de campagne de Raphaël Glucksmann
INSERT INTO evenement (date_evenement, type, titre, digest_id, etat)
SELECT '2026-10-27', 'autre', 'Raphaël Glucksmann compose son équipe de campagne : la sénatrice Laurence Rossignol préside son association de financement et le sénateur Alexandre Ouizille doit en devenir le directeur.', @dg, 'a_valider' FROM DUAL WHERE @deja = 0;
SET @e4 := IF(ROW_COUNT() > 0, LAST_INSERT_ID(), NULL);
INSERT INTO evenement_source (evenement_id, source_id, ordre) SELECT @e4, id, 1 FROM source WHERE cle = 'publicsenat-2026-10-27-glucksmann-equipe' AND @e4 IS NOT NULL;
INSERT INTO evenement_candidat (evenement_id, candidat_id) SELECT @e4, id FROM candidat WHERE slug IN ('glucksmann') AND @e4 IS NOT NULL;


-- ---------------------------------------------------------------------
-- Sondage Ipsos bva-CESI pour Le Parisien, terrain du 21 au 22 octobre 2026
-- (rapport, section 3.1) ; devient l'enquête de référence une fois validé
-- ---------------------------------------------------------------------
INSERT INTO sondage (institut, commanditaires, terrain_debut, terrain_fin, echantillon, population, tour, lecture, note, source_id, etat)
SELECT 'Ipsos bva-CESI École d''ingénieurs', 'Le Parisien', '2026-10-21', '2026-10-22', 1500,
       'personnes inscrites sur les listes électorales', 1,
       'Chaque barre va du score le plus bas au plus haut obtenu selon les quatre hypothèses de candidatures testées. Ce n''est pas une marge d''erreur.',
       'Enquête postérieure à la primaire du 11 octobre. Gabriel Attal, David Lisnard et Bruno Retailleau ne sont pas testés dans toutes les hypothèses ; base de 1 048 à 1 069 répondants selon l''hypothèse.',
       (SELECT id FROM source WHERE cle = 'ipsos-2026-10-24'), 'a_valider'
FROM DUAL
WHERE NOT EXISTS (SELECT 1 FROM sondage WHERE commanditaires = 'Le Parisien' AND terrain_fin = '2026-10-22');

SET @sd := (SELECT id FROM sondage WHERE commanditaires = 'Le Parisien' AND terrain_fin = '2026-10-22' ORDER BY id LIMIT 1);
INSERT IGNORE INTO sondage_resultat (sondage_id, candidat_id, valeur_min, valeur_max)
SELECT @sd, id, 0.5, 0.5 FROM candidat WHERE slug = 'arthaud'
UNION ALL SELECT @sd, id, 17.0, 17.0 FROM candidat WHERE slug = 'melenchon'
UNION ALL SELECT @sd, id, 2.0, 2.5 FROM candidat WHERE slug = 'roussel'
UNION ALL SELECT @sd, id, 3.5, 3.5 FROM candidat WHERE slug = 'tondelier'
UNION ALL SELECT @sd, id, 13.0, 15.5 FROM candidat WHERE slug = 'glucksmann'
UNION ALL SELECT @sd, id, 4.0, 9.5 FROM candidat WHERE slug = 'attal'
UNION ALL SELECT @sd, id, 13.0, 15.0 FROM candidat WHERE slug = 'philippe'
UNION ALL SELECT @sd, id, 5.5, 11.5 FROM candidat WHERE slug = 'retailleau'
UNION ALL SELECT @sd, id, 6.5, 6.5 FROM candidat WHERE slug = 'lisnard'
UNION ALL SELECT @sd, id, 1.5, 2.0 FROM candidat WHERE slug = 'dupont-aignan'
UNION ALL SELECT @sd, id, 32.0, 33.5 FROM candidat WHERE slug = 'le-pen'
UNION ALL SELECT @sd, id, 4.0, 4.5 FROM candidat WHERE slug = 'zemmour';

-- Contrôle : 11 sources de la veille, 5 faits, 12 résultats de sondage attendus
SELECT
  (SELECT COUNT(*) FROM source WHERE consultee_le = '2026-11-03') AS sources_veille,
  (SELECT COUNT(*) FROM evenement WHERE digest_id = @dg) AS faits_digest,
  (SELECT COUNT(*) FROM sondage_resultat WHERE sondage_id = @sd) AS resultats_sondage;
