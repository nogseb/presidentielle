-- =====================================================================
-- Repères 2027 · radar de la semaine et chapitres du livre, 4 novembre 2026
-- 1. Les 16 chapitres thématiques (parties II et III) de « Réussir à l'ère
--    des crises. Un plan robuste pour l'économie française », The Shift
--    Project, Odile Jacob, 14 octobre 2026 (titres et pages du sommaire).
-- 2. Le rattachement de chacun des 19 chantiers de la grille à un chapitre.
--    Ce rattachement est un choix du site, pas une reprise du livre.
-- 3. Le classement des faits et des échéances déjà saisis sur le radar.
-- À importer après database/migrations/004_radar_chapitres.sql.
-- Rejouable : aucune ligne n'est créée deux fois.
-- =====================================================================

SET NAMES utf8mb4;

SET @shift := (SELECT id FROM organisation WHERE slug = 'the-shift-project');

-- Le livre (déjà présent si la veille du 25 au 31 octobre 2026 a été importée)
INSERT INTO source (cle, url, titre, editeur, libelle_court, date_publication, niveau, consultee_le) VALUES
('odilejacob-2026-10-14-shift', 'https://www.odilejacob.fr/catalogue/sciences-humaines/economie-et-finance/reussir-a-l-ere-des-crises_9782415016722.php', 'Réussir à l''ère des crises. Un plan robuste pour l''économie française', 'Odile Jacob', 'Odile Jacob', '2026-10-14', 4, '2026-11-03')
ON DUPLICATE KEY UPDATE id = id;
SET @livre := (SELECT id FROM source WHERE cle = 'odilejacob-2026-10-14-shift');

-- ---------------------------------------------------------------------
-- 1. Chapitres (partie I, chapitres 1 à 3 : diagnostic et méthode, sans chantier)
-- theme_id : thème du comparateur le plus proche, NULL si aucun
-- ---------------------------------------------------------------------
SET @p2 := 'Les chantiers incontournables pour réussir à l''ère des crises';
SET @p3 := 'Des transformations à mener dans l''ensemble de la société';

INSERT INTO livre_chapitre (organisation_id, numero, titre, page, partie, partie_titre, theme_id, source_id) VALUES
(@shift,  4, 'Sécuriser la transition',                     49, 2, @p2, NULL, @livre),
(@shift,  5, 'L''énergie',                                   59, 2, @p2,    6, @livre),
(@shift,  6, 'Le cuivre',                                    71, 2, @p2,   12, @livre),
(@shift,  7, 'Les puits naturels, agricoles et forestiers',  83, 2, @p2,    7, @livre),
(@shift,  8, 'L''agriculture et la pêche',                   97, 2, @p2,    7, @livre),
(@shift,  9, 'L''industrie',                                113, 2, @p2,   12, @livre),
(@shift, 10, 'Les transports',                              129, 2, @p2,   13, @livre),
(@shift, 11, 'Le logement',                                 147, 2, @p2,    1, @livre),
(@shift, 12, 'L''emploi',                                    159, 2, @p2,    3, @livre),
(@shift, 13, 'La santé',                                    173, 3, @p3,    4, @livre),
(@shift, 14, 'L''enseignement et la formation',              185, 3, @p3,    5, @livre),
(@shift, 15, 'La défense',                                  197, 3, @p3,   10, @livre),
(@shift, 16, 'Le numérique',                                207, 3, @p3,   14, @livre),
(@shift, 17, 'Le sport',                                    219, 3, @p3, NULL, @livre),
(@shift, 18, 'Les territoires',                             231, 3, @p3, NULL, @livre),
(@shift, 19, 'La culture',                                  249, 3, @p3,   15, @livre)
ON DUPLICATE KEY UPDATE titre = VALUES(titre), page = VALUES(page), partie = VALUES(partie),
  partie_titre = VALUES(partie_titre), theme_id = VALUES(theme_id), source_id = VALUES(source_id);

-- ---------------------------------------------------------------------
-- 2. Rattachement des chantiers
-- ---------------------------------------------------------------------
UPDATE chantier SET chapitre_id = (SELECT id FROM livre_chapitre WHERE organisation_id = @shift AND numero = 5)
 WHERE organisation_id = @shift AND slug IN ('nucleaire', 'enr', 'bio');
UPDATE chantier SET chapitre_id = (SELECT id FROM livre_chapitre WHERE organisation_id = @shift AND numero = 7)
 WHERE organisation_id = @shift AND slug IN ('puits');
UPDATE chantier SET chapitre_id = (SELECT id FROM livre_chapitre WHERE organisation_id = @shift AND numero = 8)
 WHERE organisation_id = @shift AND slug IN ('elevage', 'azote');
UPDATE chantier SET chapitre_id = (SELECT id FROM livre_chapitre WHERE organisation_id = @shift AND numero = 9)
 WHERE organisation_id = @shift AND slug IN ('acier', 'h2', 'ccs');
UPDATE chantier SET chapitre_id = (SELECT id FROM livre_chapitre WHERE organisation_id = @shift AND numero = 10)
 WHERE organisation_id = @shift AND slug IN ('velo', 'tc', 've', 'train', 'aerien', 'fret', 'camions');
UPDATE chantier SET chapitre_id = (SELECT id FROM livre_chapitre WHERE organisation_id = @shift AND numero = 11)
 WHERE organisation_id = @shift AND slug IN ('renov', 'pac');
UPDATE chantier SET chapitre_id = (SELECT id FROM livre_chapitre WHERE organisation_id = @shift AND numero = 16)
 WHERE organisation_id = @shift AND slug IN ('datacenters');

-- ---------------------------------------------------------------------
-- 3. Radar : faits déjà saisis
-- Écart à la règle par défaut : une primaire dont le résultat désigne un
-- candidat change la course (la règle par défaut range « primaire » en signal).
-- ---------------------------------------------------------------------
UPDATE evenement SET axe = 1, portee = 'course'
 WHERE axe IS NULL AND type = 'primaire' AND date_evenement = '2026-10-11';

UPDATE evenement SET
  axe = CASE type
    WHEN 'candidature' THEN 1 WHEN 'retrait' THEN 1 WHEN 'ralliement' THEN 1
    WHEN 'primaire' THEN 1 WHEN 'decompte' THEN 1
    WHEN 'institutions' THEN 2 WHEN 'calendrier' THEN 2
    WHEN 'programme' THEN 3 WHEN 'sondage' THEN 4 WHEN 'debat' THEN 5
    WHEN 'justice' THEN 6 WHEN 'societe_civile' THEN 8 ELSE 1 END,
  portee = CASE type
    WHEN 'candidature' THEN 'course' WHEN 'retrait' THEN 'course' WHEN 'ralliement' THEN 'course'
    WHEN 'programme' THEN 'engagement' WHEN 'debat' THEN 'engagement'
    ELSE 'signal' END
 WHERE axe IS NULL;

-- ---------------------------------------------------------------------
-- 3 bis. Radar : échéances du calendrier
-- Écarts à la règle par défaut (2 Règles et calendrier, course) :
-- désignations de candidats (axe 1) et gel des sondages (axe 4).
-- ---------------------------------------------------------------------
UPDATE calendrier_etape SET axe = 1, portee = 'course'
 WHERE axe IS NULL AND date_cle IN ('2026-10-11', '2026-12-13') AND societe_civile = 0;
UPDATE calendrier_etape SET axe = 4, portee = 'course'
 WHERE axe IS NULL AND date_cle = '2027-04-16' AND intitule LIKE 'Gel des sondages%';
UPDATE calendrier_etape SET
  axe = IF(societe_civile = 1, 8, 2),
  portee = IF(societe_civile = 1, 'signal', 'course')
 WHERE axe IS NULL;

-- Contrôle : 16 chapitres, 19 chantiers rattachés, aucun fait ni échéance sans axe
SELECT
  (SELECT COUNT(*) FROM livre_chapitre WHERE organisation_id = @shift) AS chapitres,
  (SELECT COUNT(*) FROM chantier WHERE organisation_id = @shift AND chapitre_id IS NOT NULL) AS chantiers_rattaches,
  (SELECT COUNT(*) FROM chantier WHERE organisation_id = @shift AND chapitre_id IS NULL) AS chantiers_sans_chapitre,
  (SELECT COUNT(*) FROM evenement WHERE axe IS NULL) AS faits_sans_axe,
  (SELECT COUNT(*) FROM calendrier_etape WHERE axe IS NULL) AS echeances_sans_axe,
  (SELECT MAX(version) FROM schema_version) AS schema_version;
