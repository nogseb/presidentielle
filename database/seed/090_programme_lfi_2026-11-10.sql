-- =====================================================================
-- Repères 2027 · programme de La France insoumise, relevé le 10 novembre 2026
-- « L'Avenir en commun », édition 2027, publié le 6 novembre 2026 : livre
-- (La Dispute) et lecture en ligne, chapitre par chapitre, sur melenchon2027.fr.
-- Aucun PDF du programme n'est proposé par la campagne.
--
-- 1. Sources : le programme et les quatre chapitres cités.
-- 2. Fiche de Jean-Luc Mélenchon : lien et date du programme, publiés dès
--    l'export suivant (compteur « programme publié » de l'onglet Candidats).
-- 3. Positions dans sept débats, extraites du programme, à l'état a_valider :
--    rien n'est publié. Elles n'apparaîtront qu'après relecture et import de
--    reperes-2027_validation_positions-melenchon_2026-11-10.sql, et seulement
--    si le comparateur complet est ouvert à Jean-Luc Mélenchon (arbitrage).
--    Débat « thermiques 2035 » : aucune position relevée (à documenter).
-- Rejouable : un second import ne crée aucun doublon.
-- =====================================================================

SET NAMES utf8mb4;

-- 1. Sources (niveau 2 : document du candidat)
INSERT IGNORE INTO source (cle, url, titre, editeur, libelle_court, date_publication, niveau, consultee_le) VALUES
('melenchon2027-2026-11-06-aec', 'https://melenchon2027.fr/programme/livre/',
 'L''Avenir en commun', 'Mélenchon 2027', 'L''Avenir en commun', '2026-11-06', 2, '2026-11-10'),
('melenchon2027-2026-11-06-aec-1-3', 'https://melenchon2027.fr/programme/livre/pour-une-bifurcation-ecologique-et-sociale/chapitre3',
 'Chapitre 3 : Les grands chantiers de la bifurcation écologique', 'Mélenchon 2027', 'L''Avenir en commun, partie 1, ch. 3', '2026-11-06', 2, '2026-11-10'),
('melenchon2027-2026-11-06-aec-4-2', 'https://melenchon2027.fr/programme/livre/le-gout-du-futur-aux-nouvelles-frontieres-de-l-humanite/chapitre2',
 'Chapitre 2 : Élever le niveau d’éducation et de savoirs', 'Mélenchon 2027', 'L''Avenir en commun, partie 4, ch. 2', '2026-11-06', 2, '2026-11-10'),
('melenchon2027-2026-11-06-aec-4-3', 'https://melenchon2027.fr/programme/livre/le-gout-du-futur-aux-nouvelles-frontieres-de-l-humanite/chapitre3',
 'Chapitre 3 : Humaniser par la culture et le sport', 'Mélenchon 2027', 'L''Avenir en commun, partie 4, ch. 3', '2026-11-06', 2, '2026-11-10'),
('melenchon2027-2026-11-06-aec-4-7', 'https://melenchon2027.fr/programme/livre/le-gout-du-futur-aux-nouvelles-frontieres-de-l-humanite/chapitre7',
 'Chapitre 7 : Démocratiser la révolution numérique', 'Mélenchon 2027', 'L''Avenir en commun, partie 4, ch. 7', '2026-11-06', 2, '2026-11-10');

-- 2. Fiche du candidat : programme publié
UPDATE candidat
SET programme_url = 'https://melenchon2027.fr/programme/livre/', programme_date = '2026-11-06'
WHERE slug = 'melenchon';

-- 3. Positions dans les débats (statut « programme », état a_valider)
--    Échelle : 2 pour, 1 plutôt pour, 0 nuancé, -1 plutôt contre, -2 contre.
--    Citations recopiées des pages du programme, apostrophes typographiques comprises.
INSERT IGNORE INTO debat_position (debat_id, candidat_id, echelle, citation, source_id, statut_position, etat) VALUES
-- Nucléaire : abandon du nouveau programme, fermeture progressive des réacteurs existants
((SELECT id FROM debat WHERE slug = 'nouveaux-reacteurs'), (SELECT id FROM candidat WHERE slug = 'melenchon'), -2,
 'arrêter le programme de nouveau nucléaire (EPR2)',
 (SELECT id FROM source WHERE cle = 'melenchon2027-2026-11-06-aec-1-3'), 'programme', 'a_valider'),
-- Centres de données : moratoire limité aux centres « non souverains » (même cran que François Ruffin)
((SELECT id FROM debat WHERE slug = 'moratoire-centres-donnees'), (SELECT id FROM candidat WHERE slug = 'melenchon'), 1,
 'Décréter un moratoire sur l’installation de centres de données non souverains (sans aucune participation publique)',
 (SELECT id FROM source WHERE cle = 'melenchon2027-2026-11-06-aec-4-7'), 'programme', 'a_valider'),
-- IA : autorisation de mise sur le marché par une autorité nationale, au-delà du règlement européen
((SELECT id FROM debat WHERE slug = 'encadrement-ia'), (SELECT id FROM candidat WHERE slug = 'melenchon'), 2,
 'Créer une autorité nationale de l’intelligence artificielle qui délivre aux systèmes d’IA définis comme à haut risque une autorisation de mise sur le marché afin de s’assurer qu’ils respectent la législation en vigueur et qu’ils ne risquent pas de mettre en danger la société',
 (SELECT id FROM source WHERE cle = 'melenchon2027-2026-11-06-aec-4-7'), 'programme', 'a_valider'),
-- Hébergement : serveurs publics situés en France (au-delà d'un hébergeur européen)
((SELECT id FROM debat WHERE slug = 'hebergement-souverain'), (SELECT id FROM candidat WHERE slug = 'melenchon'), 2,
 'Garantir l’hébergement des données des services publics français et des entreprises essentielles sur des serveurs publics situés en France',
 (SELECT id FROM source WHERE cle = 'melenchon2027-2026-11-06-aec-4-7'), 'programme', 'a_valider'),
-- Culture : objectif exprimé en part du PIB (dépense publique), au-delà de 1 % du budget de l'État
((SELECT id FROM debat WHERE slug = 'budget-culture-1-pourcent'), (SELECT id FROM candidat WHERE slug = 'melenchon'), 2,
 'Porter la dépense publique consacrée à l’art, à la culture et à la création à 1 % du produit intérieur brut (PIB) par an pour mener une politique culturelle ambitieuse, émancipatrice et à l’image de la France d’aujourd’hui',
 (SELECT id FROM source WHERE cle = 'melenchon2027-2026-11-06-aec-4-3'), 'programme', 'a_valider'),
-- Artistes-auteurs : « système de continuité de revenus »
((SELECT id FROM debat WHERE slug = 'revenu-artistes-auteurs'), (SELECT id FROM candidat WHERE slug = 'melenchon'), 2,
 'Mettre en place de véritables droits sociaux pour les artistes-auteurs, notamment grâce à un système de continuité de revenus financé par une hausse de cotisation des diffuseurs, d’élections professionnelles adaptées et d’instances de démocratie sociale représentatives de ces professions',
 (SELECT id FROM source WHERE cle = 'melenchon2027-2026-11-06-aec-4-3'), 'programme', 'a_valider'),
-- Enseignement supérieur privé : contrôle renforcé de l'État, mais Parcoursup démantelé
((SELECT id FROM debat WHERE slug = 'enseignement-superieur-prive'), (SELECT id FROM candidat WHERE slug = 'melenchon'), 1,
 'renforcer le contrôle pédagogique de toutes les formations privées',
 (SELECT id FROM source WHERE cle = 'melenchon2027-2026-11-06-aec-4-2'), 'programme', 'a_valider');

-- Contrôle : 5 sources, programme renseigné, 7 positions à valider
SELECT
  (SELECT COUNT(*) FROM source WHERE cle LIKE 'melenchon2027-2026-11-06-aec%') AS sources,
  (SELECT CONCAT(programme_date, ' · ', programme_url) FROM candidat WHERE slug = 'melenchon') AS programme,
  (SELECT COUNT(*) FROM debat_position dp JOIN candidat c ON c.id = dp.candidat_id
    WHERE c.slug = 'melenchon' AND dp.statut_position = 'programme') AS positions_melenchon;
