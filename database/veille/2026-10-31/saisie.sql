-- =====================================================================
-- Repères 2027 · veille du 2026-10-25 au 2026-10-31 · saisie (état a_valider)
-- Version consolidée (Claude, ChatGPT, Gemini), préparée le 3 novembre 2026.
-- À importer dans phpMyAdmin (onglet Importer). Rien n'est publié tant que
-- validation.sql n'est pas exécuté.
-- Réimportable : les sources et le digest ne sont pas dupliqués, les faits
-- non validés de la semaine sont remplacés, le sondage n'est créé qu'une fois.
-- =====================================================================

SET NAMES utf8mb4;

-- ---------------------------------------------------------------------
-- Sources (rapport, section 8)
-- ---------------------------------------------------------------------
INSERT IGNORE INTO source (cle, url, titre, editeur, libelle_court, date_publication, niveau, consultee_le) VALUES
('lcp-2026-10-28-dates', 'https://lcp.fr/actualites/presidentielle-2027-pour-le-gouvernement-il-n-y-a-pas-de-raison-de-changer-les-dates-de', 'Présidentielle 2027: pour le gouvernement, il n''y a "pas de raison de changer" les dates de l''élection', 'LCP', 'LCP', '2026-10-28', 3, '2026-11-03'),
('lcp-2026-10-28-primaire-attal', 'https://lcp.fr/actualites/presidentielle-2027-gabriel-attal-veut-une-grande-primaire-des-democrates-pour-eviter-un', 'Présidentielle 2027: Gabriel Attal veut une "grande primaire des démocrates" pour éviter un second tour RN-LFI', 'LCP', 'LCP', '2026-10-28', 3, '2026-11-03'),
('publicsenat-2026-10-29-primaire', 'https://www.publicsenat.fr/actualites/politique/apres-la-proposition-de-primaire-de-gabriel-attal-rejetee-par-le-camp-philippe-et-retailleau-le-blocage-perdure', 'Après la proposition de primaire de Gabriel Attal, rejetée par le camp Philippe et Retailleau, le blocage perdure', 'Public Sénat', 'Public Sénat', '2026-10-29', 3, '2026-11-03'),
('attal-2026-10-28-economie', 'https://attalpresident.fr/actualites/gabriel-attal-vision-economique-liberer-innover-independance-france', 'Gabriel Attal présente sa vision économique pour libérer, innover et renforcer l''indépendance de la France', 'Gabriel Attal, site de campagne', 'attalpresident.fr', '2026-10-28', 2, '2026-11-03'),
('lcp-2026-10-30-philippe', 'https://lcp.fr/actualites/soupcons-de-detournement-de-fonds-publics-edouard-philippe-place-sous-le-statut-de', 'Soupçons de détournement de fonds publics: Édouard Philippe placé sous le statut de témoin assisté, une "décision favorable" réagit son avocat', 'LCP', 'LCP', '2026-10-30', 3, '2026-11-03'),
('clubdesjuristes-2026-10-30-philippe', 'https://www.leclubdesjuristes.com/en-bref/placement-dedouard-philippe-sous-le-statut-de-temoin-assiste-dans-une-enquete-pour-detournement-de-fonds-publics-18148/', 'Placement d''Edouard Philippe sous le statut de témoin assisté dans une enquête pour détournement de fonds publics', 'Le Club des juristes', 'Le Club des juristes', '2026-10-30', 3, '2026-11-03'),
('cluster17-2026-10-26', 'https://cluster17.com/presidentielle-2027-marine-le-pen-conforte-son-avance-jean-luc-melenchon-devance-desormais-edouard-philippe-philippe/', 'Présidentielle 2027 : Marine Le Pen conforte son avance, Jean-Luc Mélenchon devance désormais Edouard Philippe', 'Cluster17', 'Cluster17', '2026-10-26', 4, '2026-11-03'),
('ipsos-2026-10-24', 'https://www.ipsos.com/fr-fr/presidentielle-2027-melenchon-progresse-le-pen-reste-en-tete', 'Présidentielle 2027 : Mélenchon progresse, Le Pen reste en tête', 'Ipsos bva', 'Ipsos bva', '2026-10-24', 4, '2026-11-03'),
('lcp-2026-09-17-zemmour', 'https://lcp.fr/actualites/presidentielle-2027-eric-zemmour-officialise-sa-candidature-441871', 'Présidentielle 2027: Éric Zemmour officialise sa candidature', 'LCP', 'LCP', '2026-09-17', 3, '2026-11-03'),
('lcp-2026-10-23-ecologistes', 'https://lcp.fr/actualites/presidentielle-une-dynamique-melenchon-chez-les-ecologistes-au-risque-de-fracturer-le', 'Présidentielle: une dynamique Mélenchon chez Les Écologistes au risque de fracturer le parti?', 'LCP', 'LCP', '2026-10-23', 3, '2026-11-03'),
('publicsenat-2026-11-02-le-pen', 'https://www.publicsenat.fr/actualites/politique/presidentielle-2027-le-debat-sur-lineligibilite-de-marine-le-pen-relance', 'Présidentielle 2027 : le débat sur l''inéligibilité de Marine Le Pen relancé', 'Public Sénat', 'Public Sénat', '2026-11-02', 3, '2026-11-03'),
('odilejacob-2026-10-14-shift', 'https://www.odilejacob.fr/catalogue/sciences-humaines/economie-et-finance/reussir-a-l-ere-des-crises_9782415016722.php', 'Réussir à l''ère des crises. Un plan robuste pour l''économie française', 'Odile Jacob', 'Odile Jacob', '2026-10-14', 4, '2026-11-03'),
('servicepublic-2026-07-02-dates', 'https://www.service-public.gouv.fr/particuliers/actualites/A15053', 'Les dates de l''élection présidentielle de 2027 sont annoncées', 'Service-Public.fr', 'Service-Public.fr', '2026-07-02', 1, '2026-11-03');

-- ---------------------------------------------------------------------
-- Digest du 25 au 31 octobre 2026, non publié (rapport, section 2)
-- ---------------------------------------------------------------------
INSERT IGNORE INTO digest (debut, fin, publie) VALUES ('2026-10-25', '2026-10-31', 0);
SET @dg := (SELECT id FROM digest WHERE debut = '2026-10-25');
-- Une réimportation remplace les faits non validés ; si le digest a déjà été validé, aucun fait n'est ajouté.
DELETE FROM evenement WHERE digest_id = @dg AND etat <> 'valide';
SET @deja := (SELECT COUNT(*) FROM evenement WHERE digest_id = @dg AND etat = 'valide');

-- Ordre d'affichage : date décroissante ; à date égale, le dernier fait inséré s'affiche en premier.

-- Fait 1 (29 oct.) : Édouard Philippe, témoin assisté
INSERT INTO evenement (date_evenement, type, titre, digest_id, etat)
SELECT '2026-10-29', 'justice', 'Entendu par deux juges d''instruction financiers à Paris, Édouard Philippe est placé sous le statut de témoin assisté dans une enquête pour détournement de fonds publics, favoritisme et harcèlement moral portant sur Le Havre Seine Métropole, qu''il préside.', @dg, 'a_valider' FROM DUAL WHERE @deja = 0;
SET @e1 := IF(ROW_COUNT() > 0, LAST_INSERT_ID(), NULL);
INSERT INTO evenement_source (evenement_id, source_id, ordre) SELECT @e1, id, 1 FROM source WHERE cle = 'lcp-2026-10-30-philippe' AND @e1 IS NOT NULL;
INSERT INTO evenement_source (evenement_id, source_id, ordre) SELECT @e1, id, 2 FROM source WHERE cle = 'clubdesjuristes-2026-10-30-philippe' AND @e1 IS NOT NULL;
INSERT INTO evenement_candidat (evenement_id, candidat_id) SELECT @e1, id FROM candidat WHERE slug IN ('philippe') AND @e1 IS NOT NULL;

-- Fait 4 (28 oct., affiché en 4e) : projet économique de Gabriel Attal
INSERT INTO evenement (date_evenement, type, titre, digest_id, etat)
SELECT '2026-10-28', 'programme', 'Gabriel Attal présente son projet économique : 150 milliards d''euros d''économies sur cinq ans, une règle d''or budgétaire inscrite dans la Constitution et l''accélération du programme de 14 réacteurs EPR2.', @dg, 'a_valider' FROM DUAL WHERE @deja = 0;
SET @e4 := IF(ROW_COUNT() > 0, LAST_INSERT_ID(), NULL);
INSERT INTO evenement_source (evenement_id, source_id, ordre) SELECT @e4, id, 1 FROM source WHERE cle = 'attal-2026-10-28-economie' AND @e4 IS NOT NULL;
INSERT INTO evenement_candidat (evenement_id, candidat_id) SELECT @e4, id FROM candidat WHERE slug IN ('attal') AND @e4 IS NOT NULL;

-- Fait 3 (28 oct., affiché en 3e) : proposition de primaire de Gabriel Attal
INSERT INTO evenement (date_evenement, type, titre, digest_id, etat)
SELECT '2026-10-28', 'primaire', 'Gabriel Attal propose sur TF1 une « grande primaire des démocrates », qu''il présente comme un moyen d''éviter un second tour RN-LFI ; les équipes d''Édouard Philippe et de Bruno Retailleau la rejettent le lendemain.', @dg, 'a_valider' FROM DUAL WHERE @deja = 0;
SET @e3 := IF(ROW_COUNT() > 0, LAST_INSERT_ID(), NULL);
INSERT INTO evenement_source (evenement_id, source_id, ordre) SELECT @e3, id, 1 FROM source WHERE cle = 'lcp-2026-10-28-primaire-attal' AND @e3 IS NOT NULL;
INSERT INTO evenement_source (evenement_id, source_id, ordre) SELECT @e3, id, 2 FROM source WHERE cle = 'publicsenat-2026-10-29-primaire' AND @e3 IS NOT NULL;
INSERT INTO evenement_candidat (evenement_id, candidat_id) SELECT @e3, id FROM candidat WHERE slug IN ('attal', 'philippe', 'retailleau') AND @e3 IS NOT NULL;

-- Fait 2 (28 oct., affiché en 2e) : dates du scrutin maintenues
INSERT INTO evenement (date_evenement, type, titre, digest_id, etat)
SELECT '2026-10-28', 'calendrier', 'Le gouvernement exclut de modifier les dates du scrutin, fixées aux 18 avril et 2 mai 2027, après des demandes en ce sens, dont celle de Bruno Retailleau.', @dg, 'a_valider' FROM DUAL WHERE @deja = 0;
SET @e2 := IF(ROW_COUNT() > 0, LAST_INSERT_ID(), NULL);
INSERT INTO evenement_source (evenement_id, source_id, ordre) SELECT @e2, id, 1 FROM source WHERE cle = 'lcp-2026-10-28-dates' AND @e2 IS NOT NULL;
INSERT INTO evenement_candidat (evenement_id, candidat_id) SELECT @e2, id FROM candidat WHERE slug IN ('retailleau') AND @e2 IS NOT NULL;

-- Fait 5 (26 oct.) : sondage Cluster17 pour POLITICO
INSERT INTO evenement (date_evenement, type, titre, digest_id, etat)
SELECT '2026-10-26', 'sondage', 'Sondage Cluster17 pour POLITICO (terrain du 19 au 22 octobre) : Marine Le Pen de 30,5 à 33 % selon les hypothèses, Jean-Luc Mélenchon de 18,5 à 19,5 %, Édouard Philippe 16 % dans l''hypothèse principale.', @dg, 'a_valider' FROM DUAL WHERE @deja = 0;
SET @e5 := IF(ROW_COUNT() > 0, LAST_INSERT_ID(), NULL);
INSERT INTO evenement_source (evenement_id, source_id, ordre) SELECT @e5, id, 1 FROM source WHERE cle = 'cluster17-2026-10-26' AND @e5 IS NOT NULL;
INSERT INTO evenement_candidat (evenement_id, candidat_id) SELECT @e5, id FROM candidat WHERE slug IN ('le-pen', 'melenchon', 'philippe') AND @e5 IS NOT NULL;

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

-- ---------------------------------------------------------------------
-- Position de Gabriel Attal dans le débat « nouveaux réacteurs » (rapport, section 3.7)
-- ---------------------------------------------------------------------
INSERT IGNORE INTO debat_position (debat_id, candidat_id, echelle, citation, source_id, statut_position, etat)
VALUES ((SELECT id FROM debat WHERE slug = 'nouveaux-reacteurs'),
        (SELECT id FROM candidat WHERE slug = 'attal'),
        2, 'l''accélération du programme de 14 réacteurs EPR2',
        (SELECT id FROM source WHERE cle = 'attal-2026-10-28-economie'), 'programme', 'a_valider');

-- Contrôle : 13 sources de la veille, 5 faits, 12 résultats de sondage, 1 position attendus
SELECT
  (SELECT COUNT(*) FROM source WHERE consultee_le = '2026-11-03') AS sources_veille,
  (SELECT COUNT(*) FROM evenement WHERE digest_id = @dg) AS faits_digest,
  (SELECT COUNT(*) FROM sondage_resultat WHERE sondage_id = @sd) AS resultats_sondage,
  (SELECT COUNT(*) FROM debat_position dp JOIN candidat c ON c.id = dp.candidat_id WHERE c.slug = 'attal') AS positions_attal;
