-- =====================================================================
-- Repères 2027 · migration 003 · 18 octobre 2026
-- Débats : une mesure débattue, son contexte chiffré, trois arguments pour
-- et trois contre attribués à ceux qui les avancent, puis la position de
-- chaque candidat sur une échelle commune en cinq crans.
-- À importer une seule fois dans phpMyAdmin, après 002_biographies.sql.
-- =====================================================================

SET NAMES utf8mb4;

CREATE TABLE debat (
  id                 SMALLINT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
  slug               VARCHAR(60)  NOT NULL,
  theme_id           TINYINT UNSIGNED NOT NULL,
  variable_id        SMALLINT UNSIGNED NULL COMMENT 'Variable pivot correspondante, pour le lien avec le comparateur',
  chantier_id        SMALLINT UNSIGNED NULL COMMENT 'Chantier du Shift Project correspondant (pastille S)',
  proposition        VARCHAR(160) NOT NULL COMMENT 'Mesure débattue, verbe à l''infinitif : « pour » = soutenir la mesure',
  nom_court          VARCHAR(40)  NOT NULL COMMENT 'Libellé court : boutons, axes du radar, matrice',
  contexte           VARCHAR(500) NOT NULL,
  contexte_source_id INT UNSIGNED NOT NULL,
  chiffre            VARCHAR(20)  NULL COMMENT 'Ex. « 68 % »',
  chiffre_libelle    VARCHAR(220) NULL,
  chiffre_source_id  INT UNSIGNED NULL,
  ordre              TINYINT UNSIGNED NOT NULL DEFAULT 0,
  etat               ENUM('brouillon','a_valider','valide','retire') NOT NULL DEFAULT 'a_valider',
  verifie_le         DATE NULL,
  verifie_par        VARCHAR(40) NULL,
  modifie_le         TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  UNIQUE KEY uq_debat_slug (slug),
  CONSTRAINT fk_debat_theme    FOREIGN KEY (theme_id)           REFERENCES theme (id),
  CONSTRAINT fk_debat_variable FOREIGN KEY (variable_id)        REFERENCES variable (id),
  CONSTRAINT fk_debat_chantier FOREIGN KEY (chantier_id)        REFERENCES chantier (id),
  CONSTRAINT fk_debat_ctx_src  FOREIGN KEY (contexte_source_id) REFERENCES source (id),
  CONSTRAINT fk_debat_chi_src  FOREIGN KEY (chiffre_source_id)  REFERENCES source (id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Arguments : trois pour et trois contre par débat, de longueur comparable.
-- porteur : qui avance l'argument (institution, organisation, acteur), jamais « on ».
CREATE TABLE debat_argument (
  id         INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
  debat_id   SMALLINT UNSIGNED NOT NULL,
  sens       ENUM('pour','contre') NOT NULL,
  texte      VARCHAR(280) NOT NULL,
  porteur    VARCHAR(160) NOT NULL,
  source_id  INT UNSIGNED NOT NULL,
  ordre      TINYINT UNSIGNED NOT NULL DEFAULT 0,
  etat       ENUM('brouillon','a_valider','valide','retire') NOT NULL DEFAULT 'a_valider',
  modifie_le TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  KEY ix_argument_debat (debat_id, sens, ordre),
  CONSTRAINT fk_argument_debat  FOREIGN KEY (debat_id)  REFERENCES debat (id),
  CONSTRAINT fk_argument_source FOREIGN KEY (source_id) REFERENCES source (id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Position d'un candidat : échelle de -2 (contre) à +2 (pour), 0 = nuancé ou conditionnel.
-- non_aborde = 1 : absence de position vérifiée. Ligne absente : « À documenter ».
CREATE TABLE debat_position (
  debat_id        SMALLINT UNSIGNED NOT NULL,
  candidat_id     SMALLINT UNSIGNED NOT NULL,
  echelle         TINYINT NULL COMMENT '-2 contre, -1 plutôt contre, 0 nuancé, 1 plutôt pour, 2 pour',
  non_aborde      TINYINT(1) NOT NULL DEFAULT 0,
  citation        VARCHAR(300) NULL COMMENT 'Extrait court de la source, entre guillemets à l''affichage',
  source_id       INT UNSIGNED NULL COMMENT 'Obligatoire sauf non_aborde (contrôlé à l''export)',
  statut_position ENUM('programme','declaration','evolution','abandon') NOT NULL DEFAULT 'declaration',
  etat            ENUM('brouillon','a_valider','valide','retire') NOT NULL DEFAULT 'a_valider',
  verifie_le      DATE NULL,
  verifie_par     VARCHAR(40) NULL,
  modifie_le      TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (debat_id, candidat_id),
  CONSTRAINT ck_dpos_echelle  CHECK (echelle IS NULL OR echelle BETWEEN -2 AND 2),
  CONSTRAINT fk_dpos_debat    FOREIGN KEY (debat_id)    REFERENCES debat (id),
  CONSTRAINT fk_dpos_candidat FOREIGN KEY (candidat_id) REFERENCES candidat (id),
  CONSTRAINT fk_dpos_source   FOREIGN KEY (source_id)   REFERENCES source (id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

INSERT INTO schema_version (version, libelle) VALUES (3, 'Débats pour et contre');
