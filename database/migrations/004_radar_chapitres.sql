-- =====================================================================
-- Repères 2027 · migration 004 · 4 novembre 2026
-- 1. Radar de la semaine : axe (1 à 8) et portée de chaque fait du digest
--    et de chaque échéance du calendrier. NULL = règle par défaut selon le
--    type (voir app/lib/export.php, EXPORT_RADAR_TYPE).
-- 2. Grille The Shift Project : chapitres du livre « Réussir à l'ère des
--    crises » (Odile Jacob, 2026) et rattachement de chaque chantier.
-- À importer une seule fois dans phpMyAdmin, après 003_debats.sql, puis
-- importer database/seed/070_radar_chapitres_2026-11-04.sql.
-- =====================================================================

SET NAMES utf8mb4;

-- Axes : 1 Candidatures · 2 Règles et calendrier · 3 Programmes · 4 Opinion ·
--        5 Débats de fond · 6 Justice et financement · 7 Médias et numérique · 8 Société civile
-- Portée : course (change le champ des candidatures ou les règles du scrutin),
--          engagement (engage un candidat), signal (à suivre)
ALTER TABLE evenement
  ADD COLUMN axe    TINYINT UNSIGNED NULL COMMENT 'Radar : axe 1 à 8 ; NULL = selon le type' AFTER type,
  ADD COLUMN portee ENUM('course','engagement','signal') NULL COMMENT 'Radar : anneau ; NULL = selon le type' AFTER axe,
  ADD CONSTRAINT ck_evenement_axe CHECK (axe BETWEEN 1 AND 8);

ALTER TABLE calendrier_etape
  ADD COLUMN axe    TINYINT UNSIGNED NULL COMMENT 'Radar : axe 1 à 8 ; NULL = 2, ou 8 si société civile' AFTER societe_civile,
  ADD COLUMN portee ENUM('course','engagement','signal') NULL COMMENT 'Radar : anneau ; NULL = course, ou signal si société civile' AFTER axe,
  ADD CONSTRAINT ck_calendrier_axe CHECK (axe BETWEEN 1 AND 8);

-- Chapitres du livre d'une organisation à grille dédiée.
-- theme_id : thème du comparateur le plus proche (NULL si aucun).
CREATE TABLE livre_chapitre (
  id              SMALLINT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
  organisation_id SMALLINT UNSIGNED NOT NULL,
  numero          TINYINT UNSIGNED NOT NULL,
  titre           VARCHAR(120) NOT NULL,
  page            SMALLINT UNSIGNED NULL,
  partie          TINYINT UNSIGNED NOT NULL,
  partie_titre    VARCHAR(160) NOT NULL,
  theme_id        TINYINT UNSIGNED NULL,
  source_id       INT UNSIGNED NULL COMMENT 'Le livre (table source)',
  UNIQUE KEY uq_livre_chapitre (organisation_id, numero),
  CONSTRAINT fk_chapitre_org    FOREIGN KEY (organisation_id) REFERENCES organisation (id),
  CONSTRAINT fk_chapitre_theme  FOREIGN KEY (theme_id)        REFERENCES theme (id),
  CONSTRAINT fk_chapitre_source FOREIGN KEY (source_id)       REFERENCES source (id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

ALTER TABLE chantier
  ADD COLUMN chapitre_id SMALLINT UNSIGNED NULL COMMENT 'Chapitre du livre qui traite le chantier' AFTER theme_id,
  ADD CONSTRAINT fk_chantier_chapitre FOREIGN KEY (chapitre_id) REFERENCES livre_chapitre (id);

INSERT INTO schema_version (version, libelle) VALUES (4, 'Radar de la semaine et chapitres du livre');
