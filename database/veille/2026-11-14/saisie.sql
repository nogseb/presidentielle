-- =====================================================================
-- Repères 2027 · veille du 2026-11-08 au 2026-11-14 · saisie (état a_valider)
-- Préparée le 16 novembre 2026 (Claude), en consolidant le plan de veille de
-- ChatGPT du 15 novembre (rapport, section 7), à la demande de Sébastien Noguès.
-- Importée par le workflow « Importer une veille » (étape saisie) ou dans
-- phpMyAdmin. Rien n'est publié tant que validation.sql n'est pas exécuté.
-- Réimportable : sources, digest et sondage ne sont pas dupliqués ; les faits
-- non validés de la semaine sont remplacés.
-- La fiche de Teddy Riner est créée par validation.sql (table sans état de
-- validation) : son rattachement aux faits 1 et 4 y est aussi.
-- =====================================================================

SET NAMES utf8mb4;

-- ---------------------------------------------------------------------
-- Sources (rapport, section 8)
-- ---------------------------------------------------------------------
INSERT IGNORE INTO source (cle, url, titre, editeur, libelle_court, date_publication, niveau, consultee_le) VALUES
('lcp-2026-11-09-riner', 'https://lcp.fr/actualites/le-judoka-teddy-riner-annonce-sa-candidature-a-l-election-presidentielle-de-2027-444920', 'Le judoka Teddy Riner annonce sa candidature à l''élection présidentielle de 2027', 'LCP', 'LCP', '2026-11-09', 3, '2026-11-16'),
('afp-2026-11-09-riner', 'https://www.lalibre.be/dernieres-depeches/2026/11/09/des-tatamis-a-lelysee-teddy-riner-annonce-sa-candidature-a-la-presidentielle-TN24TXUYZBDHLNYIUW4YHZJEI4/', 'Des tatamis à l''Élysée ? Teddy Riner candidat surprise à la présidentielle', 'AFP', 'AFP', '2026-11-09', 3, '2026-11-16'),
('publicsenat-2026-11-09-riner', 'https://www.publicsenat.fr/actualites/politique/presidentielle-2027-le-judoka-teddy-riner-se-lance-dans-la-course-a-lelysee-au-milieu-dune-multitude-de-candidats', 'Présidentielle 2027 : le judoka Teddy Riner se lance dans la course à l’Élysée, au milieu d’une multitude de candidats', 'Public Sénat', 'Public Sénat', '2026-11-09', 3, '2026-11-16'),
('afp-2026-11-11-retailleau-primaire', 'https://actu.orange.fr/politique/retailleau-propose-une-primaire-les-31-janvier-et-7-fevrier-CNT000002tFStY.html', 'Retailleau propose une primaire les 31 janvier et 7 février', 'AFP', 'AFP', '2026-11-11', 3, '2026-11-16'),
('lcp-2026-11-12-retailleau-primaire', 'https://lcp.fr/actualites/presidentielle-bruno-retailleau-propose-une-primaire-les-31-janvier-et-7-fevrier-445008', 'Présidentielle: Bruno Retailleau propose une primaire les 31 janvier et 7 février', 'LCP', 'LCP', '2026-11-12', 3, '2026-11-16'),
('afp-2026-11-14-larcher', 'https://www.boursorama.com/actualite-economique/actualites/presidentielle-larcher-veut-reunir-les-candidats-de-la-droite-et-du-centre-la-pression-monte-sur-philippe-c0a73dc48120a2eb7fcbc3a048411956', 'Présidentielle: Larcher veut réunir les candidats de la droite et du centre, la pression monte sur Philippe', 'AFP', 'AFP', '2026-11-14', 3, '2026-11-16'),
('elabe-2026-11-14-presidentielle', 'https://elabe.fr/fichier-pdf/13399-les-francais-et-lelection-presidentielle-2027/', 'Les Français et l''élection présidentielle 2027', 'Elabe', 'Elabe', '2026-11-14', 4, '2026-11-16'),
('elabe-2026-11-14-page', 'https://elabe.fr/presidentielle-2027-novembre/', 'Les Français et l''élection présidentielle 2027', 'Elabe', 'Elabe', '2026-11-14', 4, '2026-11-16'),
('lcp-2026-11-14-liste-candidats', 'https://lcp.fr/actualites/presidentielle-2027-la-liste-des-candidats-declares-et-potentiels-444932', 'Présidentielle 2027: la liste des candidats déclarés et potentiels', 'LCP', 'LCP', '2026-11-14', 3, '2026-11-16'),
('wikipedia-riner-2026-11-16', 'https://en.wikipedia.org/wiki/Teddy_Riner', 'Teddy Riner — Wikipedia', 'Wikipédia', 'Wikipédia', '2026-11-16', 4, '2026-11-16');

-- ---------------------------------------------------------------------
-- Digest du 8 au 14 novembre 2026, non publié (rapport, section 2)
-- ---------------------------------------------------------------------
INSERT IGNORE INTO digest (debut, fin, publie) VALUES ('2026-11-08', '2026-11-14', 0);
SET @dg := (SELECT id FROM digest WHERE debut = '2026-11-08');
DELETE FROM evenement WHERE digest_id = @dg AND etat <> 'valide';
SET @deja := (SELECT COUNT(*) FROM evenement WHERE digest_id = @dg AND etat = 'valide');

-- Ordre d'affichage : date décroissante ; à date égale, le dernier fait inséré s'affiche en premier.
-- Axe et portée : règle par défaut du type pour les quatre faits.

-- Fait 1 (9 nov.) : candidature de Teddy Riner (candidat rattaché par validation.sql)
INSERT INTO evenement (date_evenement, type, axe, portee, titre, digest_id, etat)
SELECT '2026-11-09', 'candidature', 1, 'course', 'Le judoka Teddy Riner annonce sa candidature dans une vidéo publiée sur ses réseaux sociaux, sans étiquette ; interrogé sur le clivage droite-gauche, il répond : « Ni l''un, ni l''autre. »', @dg, 'a_valider' FROM DUAL WHERE @deja = 0;
SET @e1 := IF(ROW_COUNT() > 0, LAST_INSERT_ID(), NULL);
INSERT INTO evenement_source (evenement_id, source_id, ordre) SELECT @e1, id, 1 FROM source WHERE cle = 'lcp-2026-11-09-riner' AND @e1 IS NOT NULL;
INSERT INTO evenement_source (evenement_id, source_id, ordre) SELECT @e1, id, 2 FROM source WHERE cle = 'afp-2026-11-09-riner' AND @e1 IS NOT NULL;
INSERT INTO evenement_source (evenement_id, source_id, ordre) SELECT @e1, id, 3 FROM source WHERE cle = 'publicsenat-2026-11-09-riner' AND @e1 IS NOT NULL;

-- Fait 2 (10 nov.) : proposition de primaire de Bruno Retailleau
INSERT INTO evenement (date_evenement, type, axe, portee, titre, digest_id, etat)
SELECT '2026-11-10', 'primaire', 1, 'signal', 'Dans une lettre du 10 novembre, Bruno Retailleau propose à Édouard Philippe, Gabriel Attal et David Lisnard une primaire de la droite et du centre les 31 janvier et 7 février ; le porte-parole d''Édouard Philippe répond qu''« il ne participera pas à une primaire ».', @dg, 'a_valider' FROM DUAL WHERE @deja = 0;
SET @e2 := IF(ROW_COUNT() > 0, LAST_INSERT_ID(), NULL);
INSERT INTO evenement_source (evenement_id, source_id, ordre) SELECT @e2, id, 1 FROM source WHERE cle = 'afp-2026-11-11-retailleau-primaire' AND @e2 IS NOT NULL;
INSERT INTO evenement_source (evenement_id, source_id, ordre) SELECT @e2, id, 2 FROM source WHERE cle = 'lcp-2026-11-12-retailleau-primaire' AND @e2 IS NOT NULL;
INSERT INTO evenement_candidat (evenement_id, candidat_id) SELECT @e2, id FROM candidat WHERE slug IN ('retailleau', 'philippe', 'attal', 'lisnard') AND @e2 IS NOT NULL;

-- Fait 4 (14 nov.) : sondage Elabe (inséré avant le fait 3 pour s'afficher après lui)
INSERT INTO evenement (date_evenement, type, axe, portee, titre, digest_id, etat)
SELECT '2026-11-14', 'sondage', 4, 'signal', 'Sondage Elabe pour BFMTV et La Tribune Dimanche (terrain des 12 et 13 novembre) : Marine Le Pen de 31 à 33 % selon les hypothèses, Jean-Luc Mélenchon de 17 à 18,5 %, Teddy Riner 4,5 % dans la seule hypothèse où il est testé.', @dg, 'a_valider' FROM DUAL WHERE @deja = 0;
SET @e4 := IF(ROW_COUNT() > 0, LAST_INSERT_ID(), NULL);
INSERT INTO evenement_source (evenement_id, source_id, ordre) SELECT @e4, id, 1 FROM source WHERE cle = 'elabe-2026-11-14-presidentielle' AND @e4 IS NOT NULL;
INSERT INTO evenement_candidat (evenement_id, candidat_id) SELECT @e4, id FROM candidat WHERE slug IN ('le-pen', 'melenchon') AND @e4 IS NOT NULL;

-- Fait 3 (14 nov.) : initiative de Gérard Larcher
INSERT INTO evenement (date_evenement, type, axe, portee, titre, digest_id, etat)
SELECT '2026-11-14', 'primaire', 1, 'signal', 'Le président du Sénat, Gérard Larcher, propose de réunir « dans les meilleurs délais » les candidats de la droite et du centre pour définir une « méthode de départage » ; Renaissance y répond « bien évidemment favorablement ».', @dg, 'a_valider' FROM DUAL WHERE @deja = 0;
SET @e3 := IF(ROW_COUNT() > 0, LAST_INSERT_ID(), NULL);
INSERT INTO evenement_source (evenement_id, source_id, ordre) SELECT @e3, id, 1 FROM source WHERE cle = 'afp-2026-11-14-larcher' AND @e3 IS NOT NULL;
INSERT INTO evenement_candidat (evenement_id, candidat_id) SELECT @e3, id FROM candidat WHERE slug IN ('philippe', 'attal', 'retailleau', 'lisnard') AND @e3 IS NOT NULL;

-- ---------------------------------------------------------------------
-- Sondage Elabe pour BFMTV et La Tribune Dimanche, terrain des 12 et 13
-- novembre 2026 (rapport, section 3.2). Devient l'enquête de référence une
-- fois validé (terrain le plus récent). Dominique de Villepin, testé dans
-- deux hypothèses mais non déclaré, n'est pas saisi ; le résultat de Teddy
-- Riner est ajouté par validation.sql, après création de sa fiche.
-- ---------------------------------------------------------------------
INSERT INTO sondage (institut, commanditaires, terrain_debut, terrain_fin, echantillon, population, methode, tour, lecture, note, source_id, etat)
SELECT 'Elabe', 'BFMTV et La Tribune Dimanche', '2026-11-12', '2026-11-13', 1391,
       'personnes inscrites sur les listes électorales, extraites d''un échantillon de 1 500 personnes',
       'Questionnaire en ligne', 1,
       'Chaque barre va du score le plus bas au plus haut obtenu selon les six hypothèses de candidatures testées. Ce n''est pas une marge d''erreur.',
       'Dominique de Villepin, testé dans deux hypothèses (2,5 à 3 %), n''est pas candidat déclaré : non affiché. François Ruffin, Natacha Polony et Teddy Riner ne sont testés que dans une hypothèse.',
       (SELECT id FROM source WHERE cle = 'elabe-2026-11-14-presidentielle'), 'a_valider'
FROM DUAL
WHERE NOT EXISTS (SELECT 1 FROM sondage WHERE institut = 'Elabe' AND terrain_fin = '2026-11-13');

SET @sd := (SELECT id FROM sondage WHERE institut = 'Elabe' AND terrain_fin = '2026-11-13' ORDER BY id LIMIT 1);
INSERT IGNORE INTO sondage_resultat (sondage_id, candidat_id, valeur_min, valeur_max)
SELECT @sd, id, 0.5, 1.0 FROM candidat WHERE slug = 'arthaud'
UNION ALL SELECT @sd, id, 1.5, 2.5 FROM candidat WHERE slug = 'roussel'
UNION ALL SELECT @sd, id, 17.0, 18.5 FROM candidat WHERE slug = 'melenchon'
UNION ALL SELECT @sd, id, 3.0, 3.5 FROM candidat WHERE slug = 'tondelier'
UNION ALL SELECT @sd, id, 3.0, 3.0 FROM candidat WHERE slug = 'ruffin'
UNION ALL SELECT @sd, id, 10.5, 14.0 FROM candidat WHERE slug = 'glucksmann'
UNION ALL SELECT @sd, id, 1.5, 1.5 FROM candidat WHERE slug = 'polony'
UNION ALL SELECT @sd, id, 9.5, 15.0 FROM candidat WHERE slug = 'philippe'
UNION ALL SELECT @sd, id, 4.0, 10.0 FROM candidat WHERE slug = 'attal'
UNION ALL SELECT @sd, id, 4.0, 9.0 FROM candidat WHERE slug = 'retailleau'
UNION ALL SELECT @sd, id, 8.0, 10.5 FROM candidat WHERE slug = 'lisnard'
UNION ALL SELECT @sd, id, 2.0, 3.0 FROM candidat WHERE slug = 'dupont-aignan'
UNION ALL SELECT @sd, id, 31.0, 33.0 FROM candidat WHERE slug = 'le-pen'
UNION ALL SELECT @sd, id, 3.0, 4.5 FROM candidat WHERE slug = 'zemmour';

-- Contrôle : 10 sources de la veille, 4 faits, 14 résultats de sondage (15 après validation)
SELECT
  (SELECT COUNT(*) FROM source WHERE consultee_le = '2026-11-16') AS sources_veille,
  (SELECT COUNT(*) FROM evenement WHERE digest_id = @dg) AS faits_digest,
  (SELECT COUNT(*) FROM sondage_resultat WHERE sondage_id = @sd) AS resultats_sondage;
