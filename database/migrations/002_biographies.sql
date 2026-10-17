-- =====================================================================
-- Repères 2027 · migration 002 · 17 octobre 2026
-- Biographies des candidats : date de naissance (pour l'âge), bio de deux
-- phrases au même gabarit, source et date de vérification.
-- À importer une seule fois dans phpMyAdmin, après 001_schema.sql.
-- =====================================================================

SET NAMES utf8mb4;

ALTER TABLE candidat
  ADD COLUMN date_naissance DATE NULL COMMENT 'Sert à afficher l''âge' AFTER nom,
  ADD COLUMN bio VARCHAR(400) NULL COMMENT 'Deux phrases : fonction actuelle, puis un ou deux jalons. Ni adjectif ni appréciation.' AFTER note,
  ADD COLUMN bio_source_id INT UNSIGNED NULL AFTER bio,
  ADD COLUMN bio_verifie_le DATE NULL AFTER bio_source_id,
  ADD CONSTRAINT fk_candidat_bio_source FOREIGN KEY (bio_source_id) REFERENCES source (id);

INSERT INTO schema_version (version, libelle) VALUES (2, 'Biographies des candidats');
