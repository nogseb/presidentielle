-- =====================================================================
-- Repères 2027 · veille du 2026-11-15 au 2026-11-21 · validation
-- Préparée le 24 novembre 2026 (Claude). À importer par le workflow
-- « Importer une veille » (étape validation) ou dans l'onglet SQL de
-- phpMyAdmin, APRÈS import de saisie.sql et relecture du rapport.
-- Les blocs 1 à 4 modifient des tables sans état de validation : ils sont
-- publiés dès la régénération suivante. Chaque bloc peut être retiré.
-- Réimportable.
-- =====================================================================

SET NAMES utf8mb4;
SET @dg := (SELECT id FROM digest WHERE debut = '2026-11-15');
SET @sd := (SELECT id FROM sondage WHERE institut = 'Toluna Harris Interactive' AND terrain_fin = '2026-11-19' ORDER BY id LIMIT 1);

-- Bloc 1 · rapport 3.1 : fiche de Dominique de Villepin
-- Nuance DIV (à arbitrer, rapport 6) : La France humaniste, hors grille, sans rattachement revendiqué.
INSERT IGNORE INTO candidat (slug, prenom, nom, date_naissance, parti, nuance, nuance_motif, statut, designation, date_declaration, precision_date,
                             bio, bio_source_id, bio_verifie_le, programme_url, programme_date, source_id)
VALUES ('villepin', 'Dominique', 'de Villepin', '1953-11-14', 'La France humaniste', 'DIV',
        'La France humaniste, mouvement hors grille sans rattachement revendiqué à une famille : hors de l''axe',
        'declare', 'declaration', '2026-11-20', 'jour',
        'Fondateur de La France humaniste. Premier ministre de 2005 à 2007, après avoir été ministre des Affaires étrangères puis de l''Intérieur sous la présidence de Jacques Chirac.',
        (SELECT id FROM source WHERE cle = 'wikipedia-villepin-2026-11-24'), '2026-11-24',
        'https://villepin.fr/#projet', '2026-11-20',
        (SELECT id FROM source WHERE cle = 'lcp-2026-11-20-villepin'));
SET @villepin := (SELECT id FROM candidat WHERE slug = 'villepin');
-- Rattachement au fait 2 (candidature) et résultat dans l'enquête Toluna Harris Interactive
INSERT IGNORE INTO evenement_candidat (evenement_id, candidat_id)
SELECT id, @villepin FROM evenement WHERE digest_id = @dg AND type = 'candidature';
INSERT IGNORE INTO sondage_resultat (sondage_id, candidat_id, valeur_min, valeur_max) VALUES (@sd, @villepin, 1.0, 2.0);

-- Bloc 2 · rapport 3.2 : retrait de François Ruffin (fiche conservée pour l'historique)
UPDATE candidat SET statut = 'retire', date_sortie = '2026-11-21' WHERE slug = 'ruffin';

-- Bloc 3 · rapport 3.4 : programme d'Édouard Philippe sur sa fiche (premier volume)
UPDATE candidat SET programme_url = 'https://www.edouardphilippe.fr/programme', programme_date = '2026-11-18' WHERE slug = 'philippe';

-- Bloc 4 · rapport 3.5 : note du chiffre clé
UPDATE parametre
SET valeur = 'Base de Toute l''Europe au 14 octobre 2026 (30), mise à jour des déclarations et retraits relevés depuis : Teddy Riner (9 novembre) et Dominique de Villepin (20 novembre) candidats, François Ruffin retiré (21 novembre). LCP recense d''autres candidatures plus confidentielles. En 2022, 12 candidats avaient obtenu leurs 500 parrainages.'
WHERE cle = 'chiffre_note';

-- Bloc 5 · rapport 2 : les cinq faits du digest et sa publication
UPDATE evenement SET etat = 'valide', verifie_le = CURDATE(), verifie_par = 'SN'
WHERE digest_id = @dg AND etat = 'a_valider';
UPDATE digest SET publie = 1 WHERE id = @dg;

-- Bloc 6 · rapport 3.3 : enquête Toluna Harris Interactive (devient l'enquête de référence)
UPDATE sondage SET etat = 'valide' WHERE id = @sd;

-- Contrôle : 31 candidatures (Villepin entre, Ruffin sort), 5 faits validés, 14 résultats
SELECT
  (SELECT CONCAT(prenom, ' ', nom, ' · ', nuance) FROM candidat WHERE slug = 'villepin') AS nouvelle_fiche,
  (SELECT statut FROM candidat WHERE slug = 'ruffin') AS ruffin,
  (SELECT COUNT(*) FROM candidat WHERE statut IN ('declare', 'a_confirmer', 'officiel')) AS candidatures,
  (SELECT COUNT(*) FROM candidat WHERE programme_url IS NOT NULL AND statut <> 'retire') AS programmes,
  (SELECT publie FROM digest WHERE id = @dg) AS digest_publie,
  (SELECT COUNT(*) FROM evenement WHERE digest_id = @dg AND etat = 'valide') AS faits_valides,
  (SELECT COUNT(*) FROM sondage_resultat WHERE sondage_id = @sd) AS resultats_sondage;
