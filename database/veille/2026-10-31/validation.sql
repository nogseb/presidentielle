-- =====================================================================
-- Repères 2027 · veille du 2026-10-25 au 2026-10-31 · validation
-- À exécuter dans l'onglet SQL de phpMyAdmin APRÈS import de saisie.sql
-- et relecture du rapport. Supprimer les blocs refusés avant d'exécuter.
-- Les blocs 3 à 6 modifient des tables sans état de validation : ils sont
-- publiés dès la régénération suivante (Actions → Publier les données).
-- =====================================================================

SET NAMES utf8mb4;
SET @dg := (SELECT id FROM digest WHERE debut = '2026-10-25');
SET @sd := (SELECT id FROM sondage WHERE commanditaires = 'Le Parisien' AND terrain_fin = '2026-10-22' ORDER BY id LIMIT 1);
SET @shift := (SELECT id FROM organisation WHERE slug = 'the-shift-project');

-- Bloc 1 · rapport 2 : les cinq faits du digest et sa publication
UPDATE evenement SET etat = 'valide', verifie_le = CURDATE(), verifie_par = 'SN'
WHERE digest_id = @dg AND etat = 'a_valider';
UPDATE digest SET publie = 1 WHERE id = @dg;

-- Bloc 2 · rapport 3.1 : sondage Ipsos bva-CESI pour Le Parisien (devient l'enquête de référence)
UPDATE sondage SET etat = 'valide' WHERE id = @sd;

-- Bloc 3 · rapport 3.2 : Éric Zemmour, candidature officialisée le 17 septembre 2026 (correction)
UPDATE candidat SET designation = 'declaration', mention = NULL,
       note = 'Candidature officialisée sur BFMTV le 17 septembre 2026 (LCP).',
       source_id = (SELECT id FROM source WHERE cle = 'lcp-2026-09-17-zemmour')
WHERE slug = 'zemmour';

-- Bloc 4 · rapport 3.3 : Marine Tondelier, objet du vote des adhérents du 13 décembre
UPDATE candidat
SET note = 'Vote des adhérents le 13 décembre 2026 : candidature de Marine Tondelier ou soutien à un candidat extérieur au parti (LCP, 23 octobre 2026).'
WHERE slug = 'tondelier';
UPDATE calendrier_etape
SET intitule = 'Vote des adhérents écologistes : candidature de Marine Tondelier ou soutien à un candidat extérieur au parti',
    intitule_court = 'Vote des adhérents écologistes',
    source_id = (SELECT id FROM source WHERE cle = 'lcp-2026-10-23-ecologistes')
WHERE date_cle = '2026-12-13' AND intitule LIKE 'Vote des militants écologistes%';

-- Bloc 5 · rapport 3.4 : Marine Le Pen, état de la procédure
UPDATE candidat
SET note = 'Condamnée en appel le 7 juillet 2026 : 45 mois d''inéligibilité dont 30 avec sursis, sans exécution provisoire. Pourvoi en cassation ; la Cour de cassation a indiqué pouvoir statuer avant début 2027. Son éligibilité d''ici là fait débat entre juristes (Public Sénat, 2 novembre 2026).'
WHERE slug = 'le-pen';

-- Bloc 6 · rapport 3.5 : The Shift Project, parution du livre le 14 octobre 2026
UPDATE calendrier_etape
SET date_cle = '2026-10-14', libelle_date = '14 octobre 2026', statut = 'fait',
    intitule = 'Parution de « Réussir à l''ère des crises », livre du Plan robuste (The Shift Project, Odile Jacob)',
    source_id = (SELECT id FROM source WHERE cle = 'odilejacob-2026-10-14-shift')
WHERE societe_civile = 1 AND intitule LIKE 'Livre de synthèse du Plan robuste%';
UPDATE organisation_dispositif
SET periode = '14 avril 2026 · livre paru le 14 octobre 2026 (Odile Jacob)'
WHERE organisation_id = @shift AND ordre = 1;
INSERT IGNORE INTO dispositif_source (dispositif_id, source_id, ordre)
SELECT d.id, s.id, 2 FROM organisation_dispositif d JOIN source s ON s.cle = 'odilejacob-2026-10-14-shift'
WHERE d.organisation_id = @shift AND d.ordre = 1;

-- Contrôle : digest publié avec 5 faits validés, sondage validé
SELECT
  (SELECT publie FROM digest WHERE id = @dg) AS digest_publie,
  (SELECT COUNT(*) FROM evenement WHERE digest_id = @dg AND etat = 'valide') AS faits_valides,
  (SELECT etat FROM sondage WHERE id = @sd) AS sondage;
