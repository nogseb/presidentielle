-- =====================================================================
-- Repères 2027 · veille du 2026-11-01 au 2026-11-07 · validation
-- Préparée le 10 novembre 2026 (Claude). Publication demandée par
-- Sébastien Noguès le 10 novembre 2026 (« prépare et publie »).
-- Importée par le workflow « Importer une veille » (étape validation) ou dans
-- l'onglet SQL de phpMyAdmin, APRÈS import de saisie.sql.
-- Le bloc 3 modifie une table sans état de validation : il est publié dès
-- la régénération suivante. Les positions dans les débats (rapport 3.3) ne
-- sont PAS validées ici : elles attendent la relecture des citations et
-- l'arbitrage sur le comparateur.
-- =====================================================================

SET NAMES utf8mb4;
SET @dg := (SELECT id FROM digest WHERE debut = '2026-11-01');
SET @sd := (SELECT id FROM sondage WHERE institut = 'Ifop' AND commanditaires = 'LCI' AND terrain_fin = '2026-10-29' ORDER BY id LIMIT 1);

-- Bloc 1 · rapport 2 : les quatre faits du digest et sa publication
UPDATE evenement SET etat = 'valide', verifie_le = CURDATE(), verifie_par = 'SN'
WHERE digest_id = @dg AND etat = 'a_valider';
UPDATE digest SET publie = 1 WHERE id = @dg;

-- Bloc 2 · rapport 3.1 : sondage Ifop pour LCI (devient l'enquête de référence)
UPDATE sondage SET etat = 'valide' WHERE id = @sd;

-- Bloc 3 · rapport 3.2 : programme de Jean-Luc Mélenchon sur sa fiche
UPDATE candidat
SET programme_url = 'https://melenchon2027.fr/programme/livre/', programme_date = '2026-11-06'
WHERE slug = 'melenchon';

-- Bloc 4 · rapport 3.3 : positions de Jean-Luc Mélenchon dans sept débats
-- Non validées dans cette veille. Pour les publier : relire les citations,
-- puis importer reperes-2027_validation_positions-melenchon_2026-11-10.sql
-- (et ouvrir le comparateur complet, arbitrage du rapport 6).

-- Contrôle : digest publié avec 4 faits validés, sondage validé, programme renseigné
SELECT
  (SELECT publie FROM digest WHERE id = @dg) AS digest_publie,
  (SELECT COUNT(*) FROM evenement WHERE digest_id = @dg AND etat = 'valide') AS faits_valides,
  (SELECT etat FROM sondage WHERE id = @sd) AS sondage,
  (SELECT programme_date FROM candidat WHERE slug = 'melenchon') AS programme_melenchon;
