-- =====================================================================
-- Repères 2027 · veille du 2026-11-08 au 2026-11-14 · validation
-- Préparée le 16 novembre 2026 (Claude). Publication demandée par
-- Sébastien Noguès le 16 novembre 2026 (« Publie cette veille en ligne »).
-- Importée par le workflow « Importer une veille » (étape validation) ou dans
-- l'onglet SQL de phpMyAdmin, APRÈS import de saisie.sql.
-- Les blocs 2 et 4 modifient des tables sans état de validation : ils sont
-- publiés dès la régénération suivante. Réimportable.
-- =====================================================================

SET NAMES utf8mb4;
SET @dg := (SELECT id FROM digest WHERE debut = '2026-11-08');
SET @sd := (SELECT id FROM sondage WHERE institut = 'Elabe' AND terrain_fin = '2026-11-13' ORDER BY id LIMIT 1);

-- Bloc 1 · rapport 3.1 : fiche de Teddy Riner (31e candidature de la base)
-- Nuance DIV : sans parti, « ni de droite ni de gauche » ; affiché hors de l'axe de l'échiquier.
INSERT IGNORE INTO candidat (slug, prenom, nom, date_naissance, parti, nuance, nuance_motif, statut, designation, date_declaration, precision_date,
                             bio, bio_source_id, bio_verifie_le, source_id)
VALUES ('riner', 'Teddy', 'Riner', '1989-04-07', NULL, 'DIV',
        'Sans parti, se dit « ni de droite ni de gauche » : hors de l''axe',
        'declare', 'declaration', '2026-11-09', 'jour',
        'Judoka, sans parti ni mandat électif. Champion olympique des plus de 100 kg en 2012, 2016 et 2024, deux fois champion olympique par équipes et onze fois champion du monde en individuel.',
        (SELECT id FROM source WHERE cle = 'wikipedia-riner-2026-11-16'), '2026-11-16',
        (SELECT id FROM source WHERE cle = 'lcp-2026-11-09-riner'));
SET @riner := (SELECT id FROM candidat WHERE slug = 'riner');
-- Rattachement aux faits 1 (candidature) et 4 (sondage) du digest
INSERT IGNORE INTO evenement_candidat (evenement_id, candidat_id)
SELECT id, @riner FROM evenement WHERE digest_id = @dg AND type IN ('candidature', 'sondage');
-- Résultat de Teddy Riner dans le sondage Elabe (hypothèse 6 seulement)
INSERT IGNORE INTO sondage_resultat (sondage_id, candidat_id, valeur_min, valeur_max) VALUES (@sd, @riner, 4.5, 4.5);

-- Bloc 2 · rapport 3.3 : note du chiffre clé (31 candidatures dans la base)
UPDATE parametre
SET valeur = 'Base de Toute l''Europe au 14 octobre 2026 (30), complétée des déclarations relevées depuis : Teddy Riner le 9 novembre. LCP recense d''autres candidatures plus confidentielles. En 2022, 12 candidats avaient obtenu leurs 500 parrainages.'
WHERE cle = 'chiffre_note';

-- Bloc 3 · rapport 2 : les quatre faits du digest et sa publication
UPDATE evenement SET etat = 'valide', verifie_le = CURDATE(), verifie_par = 'SN'
WHERE digest_id = @dg AND etat = 'a_valider';
UPDATE digest SET publie = 1 WHERE id = @dg;

-- Bloc 4 · rapport 3.2 : sondage Elabe (devient l'enquête de référence)
UPDATE sondage SET etat = 'valide' WHERE id = @sd;

-- Contrôle : fiche créée, digest publié avec 4 faits, 15 résultats de sondage validés
SELECT
  (SELECT CONCAT(prenom, ' ', nom, ' · ', nuance) FROM candidat WHERE slug = 'riner') AS nouvelle_fiche,
  (SELECT COUNT(*) FROM candidat WHERE statut IN ('declare', 'a_confirmer', 'officiel')) AS candidatures,
  (SELECT publie FROM digest WHERE id = @dg) AS digest_publie,
  (SELECT COUNT(*) FROM evenement WHERE digest_id = @dg AND etat = 'valide') AS faits_valides,
  (SELECT COUNT(*) FROM sondage_resultat WHERE sondage_id = @sd) AS resultats_sondage,
  (SELECT etat FROM sondage WHERE id = @sd) AS sondage;
