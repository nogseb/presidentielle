-- =====================================================================
-- Repères 2027 · migration 005 · 4 novembre 2026
-- Nuance politique de chaque candidature, pour la vue « Échiquier » de
-- l'onglet Candidats. Codes et ordre de la grille des nuances du ministère
-- de l'Intérieur (élections municipales 2026), de l'extrême gauche à
-- l'extrême droite : l'ordre de l'ENUM est l'ordre d'affichage.
-- NULL = nuance à documenter ; DIV = divers ou sans étiquette, affiché à
-- part, hors de l'axe gauche-droite.
-- À importer une seule fois dans phpMyAdmin, après 004_radar_chapitres.sql,
-- puis importer database/seed/080_nuances_2026-11-04.sql.
-- =====================================================================

SET NAMES utf8mb4;

ALTER TABLE candidat
  ADD COLUMN nuance ENUM('EXG','FI','COM','SOC','VEC','UG','DVG','ECO','REG','DIV','REN','MDM','HOR','UDI','UC','DVC','LR','UD','DVD','DSV','UDR','RN','REC','UXD','EXD') NULL
    COMMENT 'Nuance de la grille du ministère de l''Intérieur ; NULL = à documenter' AFTER parti,
  ADD COLUMN nuance_motif VARCHAR(200) NULL
    COMMENT 'Pourquoi cette nuance : parti nommé dans la grille, ou règle appliquée' AFTER nuance;

INSERT INTO schema_version (version, libelle) VALUES (5, 'Nuance politique des candidatures');
