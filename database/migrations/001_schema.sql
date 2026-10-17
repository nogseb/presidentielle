-- =====================================================================
-- Repères 2027 · schéma de la base MySQL
-- Migration 001 · 17 octobre 2026
--
-- Compatible MySQL 5.7 / 8.0 (OVHcloud) et MariaDB 10.6+.
-- À importer une seule fois dans phpMyAdmin, sur une base vide,
-- AVANT les fichiers de database/seed/.
--
-- Principes
--   * MySQL est la source de vérité ; le site public ne lit que l'instantané
--     public/data/site.json produit par app/lib/export.php.
--   * Seules les lignes à l'état « valide » sont publiées.
--   * Toute information publiée renvoie à une ligne de la table source.
-- =====================================================================

SET NAMES utf8mb4;
SET FOREIGN_KEY_CHECKS = 0;

-- ---------------------------------------------------------------------
-- Suivi des migrations appliquées
-- ---------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS schema_version (
  version     SMALLINT UNSIGNED NOT NULL PRIMARY KEY,
  libelle     VARCHAR(120) NOT NULL,
  applique_le TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ---------------------------------------------------------------------
-- Paramètres du site (dates clés, phase en cours, textes courts)
-- ---------------------------------------------------------------------
CREATE TABLE parametre (
  cle         VARCHAR(60)  NOT NULL PRIMARY KEY,
  valeur      VARCHAR(500) NOT NULL,
  description VARCHAR(255) NULL,
  modifie_le  TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ---------------------------------------------------------------------
-- Sources : chaque information publiée en cite au moins une
-- niveau : 1 officielle · 2 candidat · 3 média · 4 analyse · 5 vérification
-- ---------------------------------------------------------------------
CREATE TABLE source (
  id               INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
  cle              VARCHAR(80)  NOT NULL,
  url              VARCHAR(600) NOT NULL,
  titre            VARCHAR(300) NOT NULL,
  editeur          VARCHAR(120) NOT NULL,
  libelle_court    VARCHAR(80)  NOT NULL COMMENT 'Texte du lien affiché, ex. « Public Sénat »',
  date_publication DATE NULL,
  niveau           TINYINT UNSIGNED NOT NULL,
  consultee_le     DATE NOT NULL,
  url_archive      VARCHAR(600) NULL,
  cree_le          TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  UNIQUE KEY uq_source_cle (cle),
  CONSTRAINT ck_source_niveau CHECK (niveau BETWEEN 1 AND 5)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ---------------------------------------------------------------------
-- Thèmes communs (14) et variables pivots
-- ---------------------------------------------------------------------
CREATE TABLE theme (
  id         TINYINT UNSIGNED NOT NULL PRIMARY KEY,
  slug       VARCHAR(40)  NOT NULL,
  nom        VARCHAR(80)  NOT NULL,
  nom_court  VARCHAR(30)  NOT NULL COMMENT 'Pastille du comparateur',
  nom_radar  VARCHAR(20)  NULL     COMMENT 'Libellé sur les radars, si plus court',
  a_la_une   TINYINT(1)   NOT NULL DEFAULT 0,
  ordre      TINYINT UNSIGNED NOT NULL,
  UNIQUE KEY uq_theme_slug (slug)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE variable (
  id          SMALLINT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
  theme_id    TINYINT UNSIGNED NOT NULL,
  slug        VARCHAR(60)  NOT NULL,
  question    VARCHAR(160) NOT NULL,
  type        ENUM('numerique','categorielle') NOT NULL,
  unite       VARCHAR(20)  NULL COMMENT 'Suffixe affiché, espace compris, ex. « ans »',
  borne_min   DECIMAL(10,2) NULL,
  borne_max   DECIMAL(10,2) NULL,
  graduations VARCHAR(80)  NULL COMMENT 'Valeurs de l’axe séparées par des virgules',
  chantier_id SMALLINT UNSIGNED NULL COMMENT 'Chantier du Shift Project correspondant (pastille S)',
  ordre       TINYINT UNSIGNED NOT NULL DEFAULT 1,
  actif       TINYINT(1) NOT NULL DEFAULT 1,
  note        VARCHAR(255) NULL,
  UNIQUE KEY uq_variable_slug (slug),
  KEY ix_variable_theme (theme_id, ordre),
  CONSTRAINT fk_variable_theme FOREIGN KEY (theme_id) REFERENCES theme (id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE modalite (
  id          SMALLINT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
  variable_id SMALLINT UNSIGNED NOT NULL,
  libelle     VARCHAR(80) NOT NULL,
  ordre       TINYINT UNSIGNED NOT NULL,
  UNIQUE KEY uq_modalite (variable_id, libelle),
  CONSTRAINT fk_modalite_variable FOREIGN KEY (variable_id) REFERENCES variable (id) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ---------------------------------------------------------------------
-- Candidatures
-- statut      : declare · a_confirmer · officiel · retire · non_retenu · qualifie_t2
-- niveau      : complet = comparaison thématique en phase 1 (critère publié)
-- designation : manière dont la candidature est née (libellé de la date)
-- ---------------------------------------------------------------------
CREATE TABLE candidat (
  id                  SMALLINT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
  slug                VARCHAR(60)  NOT NULL,
  prenom              VARCHAR(60)  NOT NULL,
  nom                 VARCHAR(60)  NOT NULL,
  parti               VARCHAR(80)  NULL,
  statut              ENUM('declare','a_confirmer','officiel','retire','non_retenu','qualifie_t2') NOT NULL DEFAULT 'declare',
  niveau              ENUM('complet','fiche') NOT NULL DEFAULT 'fiche',
  designation         ENUM('declaration','annonce','primaire','parti') NOT NULL DEFAULT 'declaration',
  date_declaration    DATE NULL,
  precision_date      ENUM('jour','mois') NOT NULL DEFAULT 'jour',
  hors_primaire       TINYINT(1) NOT NULL DEFAULT 0,
  volet_judiciaire    TINYINT(1) NOT NULL DEFAULT 0,
  mention             VARCHAR(80)  NULL COMMENT 'Badge signalé, ex. « Déclaration formelle attendue »',
  note                VARCHAR(400) NULL,
  programme_url       VARCHAR(600) NULL,
  programme_date      DATE NULL,
  ordre_officiel      TINYINT UNSIGNED NULL COMMENT 'Rang du tirage au sort du Conseil constitutionnel',
  source_id           INT UNSIGNED NOT NULL,
  date_sortie         DATE NULL COMMENT 'Retrait, ralliement ou non-qualification',
  cree_le             TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  modifie_le          TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  UNIQUE KEY uq_candidat_slug (slug),
  CONSTRAINT fk_candidat_source FOREIGN KEY (source_id) REFERENCES source (id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ---------------------------------------------------------------------
-- Positions sur les variables pivots (une ligne par candidat et variable)
-- non_aborde = 1 : absence de position, vérifiée à la date verifie_le
-- statut_position : programme · declaration · evolution · abandon
-- ---------------------------------------------------------------------
CREATE TABLE position_candidat (
  id              INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
  candidat_id     SMALLINT UNSIGNED NOT NULL,
  variable_id     SMALLINT UNSIGNED NOT NULL,
  valeur_num      DECIMAL(10,2) NULL,
  modalite_id     SMALLINT UNSIGNED NULL,
  non_aborde      TINYINT(1) NOT NULL DEFAULT 0,
  statut_position ENUM('programme','declaration','evolution','abandon') NOT NULL DEFAULT 'declaration',
  source_id       INT UNSIGNED NULL COMMENT 'Obligatoire sauf si non_aborde = 1 (contrôlé à l’export)',
  extrait         VARCHAR(400) NULL COMMENT 'Courte citation de la source',
  etat            ENUM('brouillon','a_valider','valide','retire') NOT NULL DEFAULT 'a_valider',
  verifie_le      DATE NULL,
  verifie_par     VARCHAR(40) NULL,
  cree_le         TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  modifie_le      TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  UNIQUE KEY uq_position (candidat_id, variable_id),
  CONSTRAINT fk_position_candidat FOREIGN KEY (candidat_id) REFERENCES candidat (id),
  CONSTRAINT fk_position_variable FOREIGN KEY (variable_id) REFERENCES variable (id),
  CONSTRAINT fk_position_modalite FOREIGN KEY (modalite_id) REFERENCES modalite (id),
  CONSTRAINT fk_position_source   FOREIGN KEY (source_id)   REFERENCES source (id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ---------------------------------------------------------------------
-- Propositions (mesures) : intitulé neutre, verbe à l'infinitif, 15 mots au plus
-- type : chiffree · orientation · engagement
-- ---------------------------------------------------------------------
CREATE TABLE proposition (
  id                    INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
  code                  VARCHAR(20)  NOT NULL COMMENT 'Identifiant stable, ex. P-RET-014',
  candidat_id           SMALLINT UNSIGNED NOT NULL,
  theme_id              TINYINT UNSIGNED NOT NULL,
  intitule              VARCHAR(160) NOT NULL,
  precisions            VARCHAR(600) NULL,
  type                  ENUM('chiffree','orientation','engagement') NOT NULL DEFAULT 'orientation',
  variable_id           SMALLINT UNSIGNED NULL,
  chantier_id           SMALLINT UNSIGNED NULL COMMENT 'Chantier du Shift Project correspondant',
  statut_proposition    ENUM('programme','declaration','evolution','abandon') NOT NULL DEFAULT 'declaration',
  mesure_phare          TINYINT(1) NOT NULL DEFAULT 0,
  source_id             INT UNSIGNED NOT NULL,
  source_page           VARCHAR(40)  NULL,
  version_precedente_id INT UNSIGNED NULL,
  etat                  ENUM('brouillon','a_valider','valide','retire') NOT NULL DEFAULT 'a_valider',
  verifie_le            DATE NULL,
  verifie_par           VARCHAR(40) NULL,
  cree_le               TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  modifie_le            TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  UNIQUE KEY uq_proposition_code (code),
  KEY ix_proposition_cand_theme (candidat_id, theme_id, etat),
  CONSTRAINT fk_proposition_candidat FOREIGN KEY (candidat_id) REFERENCES candidat (id),
  CONSTRAINT fk_proposition_theme    FOREIGN KEY (theme_id)    REFERENCES theme (id),
  CONSTRAINT fk_proposition_variable FOREIGN KEY (variable_id) REFERENCES variable (id),
  CONSTRAINT fk_proposition_source   FOREIGN KEY (source_id)   REFERENCES source (id),
  CONSTRAINT fk_proposition_version  FOREIGN KEY (version_precedente_id) REFERENCES proposition (id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ---------------------------------------------------------------------
-- Fil d'actualité : un digest par semaine, cinq faits au plus
-- ---------------------------------------------------------------------
CREATE TABLE digest (
  id     SMALLINT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
  debut  DATE NOT NULL,
  fin    DATE NOT NULL,
  publie TINYINT(1) NOT NULL DEFAULT 0,
  UNIQUE KEY uq_digest_debut (debut)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE evenement (
  id             INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
  date_evenement DATE NOT NULL,
  type           ENUM('candidature','retrait','ralliement','primaire','programme','debat','sondage','justice','institutions','calendrier','decompte','societe_civile','autre') NOT NULL,
  titre          VARCHAR(300) NOT NULL COMMENT 'Fait rédigé en une phrase neutre',
  digest_id      SMALLINT UNSIGNED NULL,
  etat           ENUM('brouillon','a_valider','valide','retire') NOT NULL DEFAULT 'a_valider',
  verifie_le     DATE NULL,
  verifie_par    VARCHAR(40) NULL,
  cree_le        TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  KEY ix_evenement_date (date_evenement),
  CONSTRAINT fk_evenement_digest FOREIGN KEY (digest_id) REFERENCES digest (id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE evenement_source (
  evenement_id INT UNSIGNED NOT NULL,
  source_id    INT UNSIGNED NOT NULL,
  ordre        TINYINT UNSIGNED NOT NULL DEFAULT 1,
  PRIMARY KEY (evenement_id, source_id),
  CONSTRAINT fk_evsrc_evenement FOREIGN KEY (evenement_id) REFERENCES evenement (id) ON DELETE CASCADE,
  CONSTRAINT fk_evsrc_source    FOREIGN KEY (source_id)    REFERENCES source (id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE evenement_candidat (
  evenement_id INT UNSIGNED NOT NULL,
  candidat_id  SMALLINT UNSIGNED NOT NULL,
  PRIMARY KEY (evenement_id, candidat_id),
  CONSTRAINT fk_evcand_evenement FOREIGN KEY (evenement_id) REFERENCES evenement (id) ON DELETE CASCADE,
  CONSTRAINT fk_evcand_candidat  FOREIGN KEY (candidat_id)  REFERENCES candidat (id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ---------------------------------------------------------------------
-- Sondages : mentions légales reprises (loi n° 77-808)
-- resultat : une fourchette par candidat (min = max pour un scénario unique)
-- ---------------------------------------------------------------------
CREATE TABLE sondage (
  id            SMALLINT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
  institut      VARCHAR(120) NOT NULL,
  commanditaires VARCHAR(300) NOT NULL,
  terrain_debut DATE NOT NULL,
  terrain_fin   DATE NOT NULL,
  echantillon   INT UNSIGNED NOT NULL,
  population    VARCHAR(160) NOT NULL,
  methode       VARCHAR(160) NULL,
  tour          TINYINT UNSIGNED NOT NULL DEFAULT 1,
  unite         VARCHAR(80)  NOT NULL DEFAULT 'En pourcentage des suffrages exprimés',
  lecture       VARCHAR(300) NULL COMMENT 'Comment lire les fourchettes',
  note          VARCHAR(300) NULL,
  url_notice    VARCHAR(600) NULL COMMENT 'Notice de la Commission des sondages',
  source_id     INT UNSIGNED NOT NULL,
  etat          ENUM('brouillon','a_valider','valide','retire') NOT NULL DEFAULT 'a_valider',
  cree_le       TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  CONSTRAINT fk_sondage_source FOREIGN KEY (source_id) REFERENCES source (id),
  CONSTRAINT ck_sondage_tour CHECK (tour IN (1,2))
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE sondage_resultat (
  sondage_id  SMALLINT UNSIGNED NOT NULL,
  candidat_id SMALLINT UNSIGNED NOT NULL,
  valeur_min  DECIMAL(4,1) NOT NULL,
  valeur_max  DECIMAL(4,1) NOT NULL,
  PRIMARY KEY (sondage_id, candidat_id),
  CONSTRAINT fk_sres_sondage  FOREIGN KEY (sondage_id)  REFERENCES sondage (id) ON DELETE CASCADE,
  CONSTRAINT fk_sres_candidat FOREIGN KEY (candidat_id) REFERENCES candidat (id),
  CONSTRAINT ck_sres_bornes CHECK (valeur_min >= 0 AND valeur_max <= 100 AND valeur_min <= valeur_max)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ---------------------------------------------------------------------
-- Calendrier
-- statut : officiel · fait · annonce · calcule (selon la loi, à confirmer)
-- ---------------------------------------------------------------------
CREATE TABLE calendrier_etape (
  id             SMALLINT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
  date_cle       DATE NOT NULL COMMENT 'Sert au tri et à la mise en « passé »',
  libelle_date   VARCHAR(80)  NOT NULL,
  libelle_court  VARCHAR(20)  NULL COMMENT 'Version courte pour l’accueil, ex. « Début févr. »',
  intitule       VARCHAR(240) NOT NULL,
  intitule_court VARCHAR(80)  NULL,
  statut         ENUM('officiel','fait','annonce','calcule') NOT NULL,
  societe_civile TINYINT(1) NOT NULL DEFAULT 0,
  source_id      INT UNSIGNED NULL,
  CONSTRAINT fk_cal_source FOREIGN KEY (source_id) REFERENCES source (id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ---------------------------------------------------------------------
-- Organisations de la société civile (The Shift Project en premier)
-- ---------------------------------------------------------------------
CREATE TABLE organisation (
  id                    SMALLINT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
  slug                  VARCHAR(60)  NOT NULL,
  nom                   VARCHAR(120) NOT NULL,
  presentation          VARCHAR(400) NOT NULL,
  demande               VARCHAR(600) NOT NULL,
  financement           VARCHAR(600) NOT NULL,
  financement_source_id INT UNSIGNED NULL,
  hatvp_url             VARCHAR(600) NULL,
  grille_dediee         TINYINT(1) NOT NULL DEFAULT 0 COMMENT '1 = section dédiée et pastilles sur le site',
  UNIQUE KEY uq_organisation_slug (slug),
  CONSTRAINT fk_org_source FOREIGN KEY (financement_source_id) REFERENCES source (id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE organisation_dispositif (
  id              SMALLINT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
  organisation_id SMALLINT UNSIGNED NOT NULL,
  periode         VARCHAR(120) NOT NULL,
  titre           VARCHAR(160) NOT NULL,
  description     VARCHAR(600) NOT NULL,
  ordre           TINYINT UNSIGNED NOT NULL DEFAULT 1,
  CONSTRAINT fk_disp_org FOREIGN KEY (organisation_id) REFERENCES organisation (id) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE dispositif_source (
  dispositif_id SMALLINT UNSIGNED NOT NULL,
  source_id     INT UNSIGNED NOT NULL,
  ordre         TINYINT UNSIGNED NOT NULL DEFAULT 1,
  PRIMARY KEY (dispositif_id, source_id),
  CONSTRAINT fk_dsrc_disp   FOREIGN KEY (dispositif_id) REFERENCES organisation_dispositif (id) ON DELETE CASCADE,
  CONSTRAINT fk_dsrc_source FOREIGN KEY (source_id)     REFERENCES source (id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Chantiers d'une organisation (les 20 chantiers du Plan robuste du Shift Project)
CREATE TABLE chantier (
  id              SMALLINT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
  organisation_id SMALLINT UNSIGNED NOT NULL,
  slug            VARCHAR(40)  NOT NULL,
  libelle         VARCHAR(120) NOT NULL,
  domaine         VARCHAR(40)  NOT NULL,
  theme_id        TINYINT UNSIGNED NOT NULL,
  ordre           TINYINT UNSIGNED NOT NULL,
  UNIQUE KEY uq_chantier_slug (organisation_id, slug),
  CONSTRAINT fk_chantier_org   FOREIGN KEY (organisation_id) REFERENCES organisation (id),
  CONSTRAINT fk_chantier_theme FOREIGN KEY (theme_id)        REFERENCES theme (id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Clés étrangères vers chantier (déclarées après sa création)
ALTER TABLE variable
  ADD CONSTRAINT fk_variable_chantier FOREIGN KEY (chantier_id) REFERENCES chantier (id);
ALTER TABLE proposition
  ADD CONSTRAINT fk_proposition_chantier FOREIGN KEY (chantier_id) REFERENCES chantier (id);

-- Correspondance candidat × chantier
-- etat : repris · en_partie · oppose · non_aborde
CREATE TABLE correspondance (
  candidat_id    SMALLINT UNSIGNED NOT NULL,
  chantier_id    SMALLINT UNSIGNED NOT NULL,
  etat_chantier  ENUM('repris','en_partie','oppose','non_aborde') NOT NULL,
  source_id      INT UNSIGNED NULL COMMENT 'Obligatoire sauf non_aborde (contrôlé à l’export)',
  proposition_id INT UNSIGNED NULL,
  commentaire    VARCHAR(300) NULL,
  etat           ENUM('brouillon','a_valider','valide','retire') NOT NULL DEFAULT 'a_valider',
  verifie_le     DATE NULL,
  verifie_par    VARCHAR(40) NULL,
  modifie_le     TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (candidat_id, chantier_id),
  CONSTRAINT fk_corr_candidat    FOREIGN KEY (candidat_id)    REFERENCES candidat (id),
  CONSTRAINT fk_corr_chantier    FOREIGN KEY (chantier_id)    REFERENCES chantier (id),
  CONSTRAINT fk_corr_source      FOREIGN KEY (source_id)      REFERENCES source (id),
  CONSTRAINT fk_corr_proposition FOREIGN KEY (proposition_id) REFERENCES proposition (id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ---------------------------------------------------------------------
-- Transparence : publications, signalements, errata, journal
-- ---------------------------------------------------------------------
CREATE TABLE publication (
  id              INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
  publie_le       TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  empreinte_sha256 CHAR(64) NOT NULL,
  declencheur     ENUM('manuel','planifie','deploiement','cron') NOT NULL,
  nb_candidats    SMALLINT UNSIGNED NOT NULL,
  nb_positions    INT UNSIGNED NOT NULL,
  nb_propositions INT UNSIGNED NOT NULL,
  nb_evenements   INT UNSIGNED NOT NULL,
  nb_alertes      SMALLINT UNSIGNED NOT NULL DEFAULT 0,
  KEY ix_publication_date (publie_le)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE signalement (
  id         INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
  recu_le    TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  page       VARCHAR(300) NOT NULL,
  message    TEXT NOT NULL,
  contact    VARCHAR(160) NULL COMMENT 'Facultatif, supprimé après traitement',
  statut     ENUM('nouveau','en_cours','corrige','rejete') NOT NULL DEFAULT 'nouveau',
  traite_le  DATE NULL,
  reponse    VARCHAR(600) NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE erratum (
  id             INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
  date_erratum   DATE NOT NULL,
  page           VARCHAR(300) NOT NULL,
  avant          VARCHAR(600) NOT NULL,
  apres          VARCHAR(600) NOT NULL,
  motif          VARCHAR(300) NOT NULL,
  signalement_id INT UNSIGNED NULL,
  CONSTRAINT fk_erratum_signalement FOREIGN KEY (signalement_id) REFERENCES signalement (id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Alimenté par database/optionnel/journal_triggers.sql si l'hébergement autorise les déclencheurs
CREATE TABLE journal (
  id        BIGINT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
  horodatage TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  table_nom VARCHAR(40)  NOT NULL,
  ligne_cle VARCHAR(40)  NOT NULL,
  action    ENUM('insert','update','delete') NOT NULL,
  avant     TEXT NULL,
  apres     TEXT NULL,
  auteur    VARCHAR(80) NULL,
  KEY ix_journal_table (table_nom, ligne_cle)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

SET FOREIGN_KEY_CHECKS = 1;

INSERT INTO schema_version (version, libelle) VALUES (1, 'Schéma initial');
