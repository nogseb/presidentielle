-- =====================================================================
-- Repères 2027 · veille du 2026-11-15 au 2026-11-21 · saisie (état a_valider)
-- Préparée le 24 novembre 2026 (Claude), consolidée avec la veille S48
-- provisoire de ChatGPT (branche veille/2026-11-28) : rapport, section 7.
-- Importée par le workflow « Importer une veille » (étape saisie) ou dans
-- phpMyAdmin. Rien n'est publié tant que validation.sql n'est pas exécuté.
-- Réimportable : sources, digest et sondage ne sont pas dupliqués ; les faits
-- non validés de la semaine sont remplacés.
-- La fiche de Dominique de Villepin est créée par validation.sql (table sans
-- état de validation) : son rattachement au fait 2 et ses résultats de
-- sondage y sont aussi.
-- =====================================================================

SET NAMES utf8mb4;

-- ---------------------------------------------------------------------
-- Sources (rapport, section 8)
-- ---------------------------------------------------------------------
INSERT IGNORE INTO source (cle, url, titre, editeur, libelle_court, date_publication, niveau, consultee_le) VALUES
('huffpost-2026-11-21-ruffin', 'https://fr.news.yahoo.com/sport/francois-ruffin-retire-candidature-a-181352223.html', 'François Ruffin retire sa candidature à la présidentielle 2027 face à « l''impasse » à gauche', 'HuffPost', 'HuffPost', '2026-11-21', 3, '2026-11-24'),
('touteleurope-2026-11-23-candidats', 'https://www.touteleurope.eu/vie-politique-des-etats-membres/presidentielle-2027-qui-sont-les-candidats-deja-declares/', 'Présidentielle 2027 : qui sont les principaux candidats déjà déclarés ?', 'Toute l''Europe', 'Toute l''Europe', '2026-11-23', 3, '2026-11-24'),
('lcp-2026-11-20-villepin', 'https://lcp.fr/actualites/presidentielle-2027-dominique-de-villepin-officiellement-candidat-a-l-elysee-445372', 'Présidentielle 2027: Dominique de Villepin officiellement candidat à l''Élysée', 'LCP', 'LCP', '2026-11-20', 3, '2026-11-24'),
('lcp-2026-11-20-villepin-programme', 'https://lcp.fr/actualites/presidentielle-2027-que-retenir-des-258-propositions-du-programme-de-dominique-de', 'Présidentielle 2027: que retenir des 258 propositions du programme de Dominique de Villepin?', 'LCP', 'LCP', '2026-11-20', 3, '2026-11-24'),
('lcp-2026-11-18-philippe-programme', 'https://lcp.fr/actualites/presidentielle-2027-edouard-philippe-promet-des-reformes-radicales-pour-relancer-sa', 'Présidentielle 2027: Édouard Philippe promet "des réformes radicales" pour relancer sa campagne, loin des discussions sur la primaire', 'LCP', 'LCP', '2026-11-18', 3, '2026-11-24'),
('edouardphilippe-2026-11-17-programme', 'https://www.edouardphilippe.fr/actualites/edouard-philippe-presente-le-premier-volume-de-son-programme-presidentiel', 'Édouard Philippe présente le premier volume de son programme présidentiel', 'Avec Édouard 2027', 'Avec Édouard 2027', '2026-11-17', 2, '2026-11-24'),
('ifop-2026-11-18-intentions', 'https://www.ifopgroup.com/article/les-intentions-de-vote-a-lelection-presidentielle-2027/', 'Les intentions de vote à l''élection présidentielle 2027', 'Ifop', 'Ifop', '2026-11-18', 4, '2026-11-24'),
('publicsenat-2026-11-17-primaire', 'https://www.publicsenat.fr/actualites/politique/primaire-les-equipes-dattal-retailleau-et-lisnard-salignent-sur-un-vote-en-janvier-moins-sur-le-cas-deric-zemmour', 'Primaire : les équipes d’Attal, Retailleau et Lisnard s’alignent sur un vote en janvier, moins sur le cas d’Eric Zemmour', 'Public Sénat', 'Public Sénat', '2026-11-17', 3, '2026-11-24'),
('commission-sondages-2026-11-23-toluna', 'https://www.commission-des-sondages.fr/notices/files/notices/2026/novembre/10393-pres-iv-vague-10-toluna-harris-interactive-23-novembre.pdf', 'Intentions de vote à l''élection présidentielle 2027', 'Commission des sondages', 'Commission des sondages', '2026-11-23', 1, '2026-11-24'),
('wikipedia-villepin-2026-11-24', 'https://wikiwand.com/EN/Dominique_de_Villepin', 'Dominique de Villepin — Wikipedia', 'Wikipédia', 'Wikipédia', '2026-11-24', 4, '2026-11-24');

-- ---------------------------------------------------------------------
-- Digest du 15 au 21 novembre 2026, non publié (rapport, section 2)
-- ---------------------------------------------------------------------
INSERT IGNORE INTO digest (debut, fin, publie) VALUES ('2026-11-15', '2026-11-21', 0);
SET @dg := (SELECT id FROM digest WHERE debut = '2026-11-15');
DELETE FROM evenement WHERE digest_id = @dg AND etat <> 'valide';
SET @deja := (SELECT COUNT(*) FROM evenement WHERE digest_id = @dg AND etat = 'valide');

-- Ordre d'affichage : date décroissante ; à date égale, le dernier fait inséré s'affiche en premier.
-- Axe et portée : règle par défaut du type pour les cinq faits.

-- Fait 5 (17 nov.) : réunion sur une primaire de la droite et du centre
INSERT INTO evenement (date_evenement, type, axe, portee, titre, digest_id, etat)
SELECT '2026-11-17', 'primaire', 1, 'signal', 'Réunies sans l''équipe d''Édouard Philippe, les équipes de Gabriel Attal, Bruno Retailleau et David Lisnard envisagent une primaire ouverte à deux tours les 17 et 24 ou les 24 et 31 janvier ; Nouvelle Énergie précise qu''« aucun accord n''a été conclu à ce stade ».', @dg, 'a_valider' FROM DUAL WHERE @deja = 0;
SET @e5 := IF(ROW_COUNT() > 0, LAST_INSERT_ID(), NULL);
INSERT INTO evenement_source (evenement_id, source_id, ordre) SELECT @e5, id, 1 FROM source WHERE cle = 'publicsenat-2026-11-17-primaire' AND @e5 IS NOT NULL;
INSERT INTO evenement_candidat (evenement_id, candidat_id) SELECT @e5, id FROM candidat WHERE slug IN ('attal', 'retailleau', 'lisnard', 'philippe') AND @e5 IS NOT NULL;

-- Fait 4 (18 nov.) : sondage Ifop (inséré avant le fait 3 pour s'afficher après lui)
INSERT INTO evenement (date_evenement, type, axe, portee, titre, digest_id, etat)
SELECT '2026-11-18', 'sondage', 4, 'signal', 'Sondage Ifop présenté avec TF1-LCI, Le Figaro et Fiducial (terrain du 13 au 16 novembre) : Marine Le Pen de 32 à 36 % selon les hypothèses, Jean-Luc Mélenchon de 17 à 19,5 %, Édouard Philippe de 10 à 15 %, Teddy Riner 4 %.', @dg, 'a_valider' FROM DUAL WHERE @deja = 0;
SET @e4 := IF(ROW_COUNT() > 0, LAST_INSERT_ID(), NULL);
INSERT INTO evenement_source (evenement_id, source_id, ordre) SELECT @e4, id, 1 FROM source WHERE cle = 'ifop-2026-11-18-intentions' AND @e4 IS NOT NULL;
INSERT INTO evenement_candidat (evenement_id, candidat_id) SELECT @e4, id FROM candidat WHERE slug IN ('le-pen', 'melenchon', 'philippe', 'riner') AND @e4 IS NOT NULL;

-- Fait 3 (18 nov.) : programme d'Édouard Philippe, premier volume
INSERT INTO evenement (date_evenement, type, axe, portee, titre, digest_id, etat)
SELECT '2026-11-18', 'programme', 3, 'engagement', 'Édouard Philippe présente le premier volume de son programme, « Croire en nous » (142 propositions), consacré notamment à la sécurité, à la justice, aux comptes publics, à l''école, au travail, au logement, à la famille et à l''intelligence artificielle.', @dg, 'a_valider' FROM DUAL WHERE @deja = 0;
SET @e3 := IF(ROW_COUNT() > 0, LAST_INSERT_ID(), NULL);
INSERT INTO evenement_source (evenement_id, source_id, ordre) SELECT @e3, id, 1 FROM source WHERE cle = 'lcp-2026-11-18-philippe-programme' AND @e3 IS NOT NULL;
INSERT INTO evenement_source (evenement_id, source_id, ordre) SELECT @e3, id, 2 FROM source WHERE cle = 'edouardphilippe-2026-11-17-programme' AND @e3 IS NOT NULL;
INSERT INTO evenement_candidat (evenement_id, candidat_id) SELECT @e3, id FROM candidat WHERE slug IN ('philippe') AND @e3 IS NOT NULL;

-- Fait 2 (20 nov.) : candidature et programme de Dominique de Villepin (candidat rattaché par validation.sql)
INSERT INTO evenement (date_evenement, type, axe, portee, titre, digest_id, etat)
SELECT '2026-11-20', 'candidature', 1, 'course', 'Dominique de Villepin, fondateur de La France humaniste, déclare sa candidature lors d''une conférence de presse (« Je suis candidat à l''élection présidentielle de 2027 ») et publie un programme de 258 propositions.', @dg, 'a_valider' FROM DUAL WHERE @deja = 0;
SET @e2 := IF(ROW_COUNT() > 0, LAST_INSERT_ID(), NULL);
INSERT INTO evenement_source (evenement_id, source_id, ordre) SELECT @e2, id, 1 FROM source WHERE cle = 'lcp-2026-11-20-villepin' AND @e2 IS NOT NULL;
INSERT INTO evenement_source (evenement_id, source_id, ordre) SELECT @e2, id, 2 FROM source WHERE cle = 'lcp-2026-11-20-villepin-programme' AND @e2 IS NOT NULL;

-- Fait 1 (21 nov.) : retrait de François Ruffin
INSERT INTO evenement (date_evenement, type, axe, portee, titre, digest_id, etat)
SELECT '2026-11-21', 'retrait', 1, 'course', 'François Ruffin retire sa candidature en prenant acte de l''« impasse » à gauche ; il ne soutient aucun autre candidat et souhaite « bon courage et bonne campagne » aux candidats de gauche.', @dg, 'a_valider' FROM DUAL WHERE @deja = 0;
SET @e1 := IF(ROW_COUNT() > 0, LAST_INSERT_ID(), NULL);
INSERT INTO evenement_source (evenement_id, source_id, ordre) SELECT @e1, id, 1 FROM source WHERE cle = 'huffpost-2026-11-21-ruffin' AND @e1 IS NOT NULL;
INSERT INTO evenement_source (evenement_id, source_id, ordre) SELECT @e1, id, 2 FROM source WHERE cle = 'touteleurope-2026-11-23-candidats' AND @e1 IS NOT NULL;
INSERT INTO evenement_candidat (evenement_id, candidat_id) SELECT @e1, id FROM candidat WHERE slug IN ('ruffin') AND @e1 IS NOT NULL;

-- ---------------------------------------------------------------------
-- Sondage Toluna Harris Interactive pour M6, RTL et L'Express, vague 10,
-- terrain des 18 et 19 novembre 2026, publié le 23 (rapport, section 3.3).
-- Résultats lus sur la notice de la Commission des sondages. Devient
-- l'enquête de référence une fois validé. Le résultat de Dominique de
-- Villepin est ajouté par validation.sql, après création de sa fiche.
-- ---------------------------------------------------------------------
INSERT INTO sondage (institut, commanditaires, terrain_debut, terrain_fin, echantillon, population, methode, tour, lecture, note, source_id, etat)
SELECT 'Toluna Harris Interactive', 'M6, RTL et L''Express', '2026-11-18', '2026-11-19', 2088,
       'personnes inscrites sur les listes électorales, extraites d''un échantillon de 2 378 personnes',
       'Questionnaire en ligne, méthode des quotas', 1,
       'Chaque barre va du score le plus bas au plus haut obtenu selon les trois hypothèses de candidatures testées. Ce n''est pas une marge d''erreur.',
       'Trois hypothèses de candidatures au centre ; base de 1 451 à 1 460 répondants exprimés selon l''hypothèse. François Ruffin, retiré le 21 novembre, n''est pas testé.',
       (SELECT id FROM source WHERE cle = 'commission-sondages-2026-11-23-toluna'), 'a_valider'
FROM DUAL
WHERE NOT EXISTS (SELECT 1 FROM sondage WHERE institut = 'Toluna Harris Interactive' AND terrain_fin = '2026-11-19');

SET @sd := (SELECT id FROM sondage WHERE institut = 'Toluna Harris Interactive' AND terrain_fin = '2026-11-19' ORDER BY id LIMIT 1);
INSERT IGNORE INTO sondage_resultat (sondage_id, candidat_id, valeur_min, valeur_max)
SELECT @sd, id, 1.0, 1.0 FROM candidat WHERE slug = 'arthaud'
UNION ALL SELECT @sd, id, 18.0, 19.0 FROM candidat WHERE slug = 'melenchon'
UNION ALL SELECT @sd, id, 1.0, 1.0 FROM candidat WHERE slug = 'roussel'
UNION ALL SELECT @sd, id, 1.0, 2.0 FROM candidat WHERE slug = 'tondelier'
UNION ALL SELECT @sd, id, 11.0, 11.0 FROM candidat WHERE slug = 'glucksmann'
UNION ALL SELECT @sd, id, 4.0, 7.0 FROM candidat WHERE slug = 'attal'
UNION ALL SELECT @sd, id, 9.0, 10.0 FROM candidat WHERE slug = 'philippe'
UNION ALL SELECT @sd, id, 11.0, 12.0 FROM candidat WHERE slug = 'lisnard'
UNION ALL SELECT @sd, id, 4.0, 5.0 FROM candidat WHERE slug = 'retailleau'
UNION ALL SELECT @sd, id, 1.0, 1.0 FROM candidat WHERE slug = 'dupont-aignan'
UNION ALL SELECT @sd, id, 30.0, 31.0 FROM candidat WHERE slug = 'le-pen'
UNION ALL SELECT @sd, id, 3.0, 4.0 FROM candidat WHERE slug = 'zemmour'
UNION ALL SELECT @sd, id, 4.0, 5.0 FROM candidat WHERE slug = 'riner';

-- Contrôle : 10 sources de la veille, 5 faits, 13 résultats de sondage (14 après validation)
SELECT
  (SELECT COUNT(*) FROM source WHERE consultee_le = '2026-11-24') AS sources_veille,
  (SELECT COUNT(*) FROM evenement WHERE digest_id = @dg) AS faits_digest,
  (SELECT COUNT(*) FROM sondage_resultat WHERE sondage_id = @sd) AS resultats_sondage;
