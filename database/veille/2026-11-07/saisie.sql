-- =====================================================================
-- Repères 2027 · veille du 2026-11-01 au 2026-11-07 · saisie (état a_valider)
-- Préparée le 10 novembre 2026 (Claude), à la demande de Sébastien Noguès.
-- Importée par le workflow « Importer une veille » (étape saisie) ou dans
-- phpMyAdmin (onglet Importer). Rien n'est publié tant que
-- validation.sql n'est pas exécuté.
-- Réimportable : les sources, le digest, le sondage et les positions ne sont
-- pas dupliqués ; les faits non validés de la semaine sont remplacés.
-- Reprend le contenu de database/seed/090_programme_lfi_2026-11-10.sql
-- (programme de La France insoumise) : importer les deux est sans effet de bord.
-- =====================================================================

SET NAMES utf8mb4;

-- ---------------------------------------------------------------------
-- Sources (rapport, section 8)
-- ---------------------------------------------------------------------
INSERT IGNORE INTO source (cle, url, titre, editeur, libelle_court, date_publication, niveau, consultee_le) VALUES
('lcp-2026-11-05-gdr-melenchon', 'https://lcp.fr/actualites/presidentielle-la-moitie-des-deputes-communistes-choisit-jean-luc-melenchon-plutot-que', 'Présidentielle: la moitié des députés communistes choisit Jean-Luc Mélenchon plutôt que Fabien Roussel', 'LCP', 'LCP', '2026-11-05', 3, '2026-11-10'),
('afp-2026-11-07-pcf', 'https://www.boursedirect.fr/fr/actualites/categorie/politique/presidentielle-les-deputes-qui-soutiennent-lfi-se-sont-mis-en-dehors-du-parti-dit-le-pcf-afp-eeb8ae489c8da81969b8b85542078098bbcdf11a', 'Présidentielle : les députés qui soutiennent LFI se sont mis "en dehors du parti", dit le PCF', 'AFP', 'AFP', '2026-11-07', 3, '2026-11-10'),
('afp-2026-11-06-programme-lfi', 'https://www.boursedirect.fr/fr/actualites/categorie/politique/pour-2027-lfi-presente-un-programme-fidele-a-sa-volonte-de-rupture-afp-756b72dfa87a534448dbb17b657b6ba86a839fda', 'Pour 2027, LFI présente un programme fidèle à sa volonté de rupture', 'AFP', 'AFP', '2026-11-06', 3, '2026-11-10'),
('lcp-2026-11-06-programme-melenchon', 'https://lcp.fr/actualites/presidentielle-2027-ce-qui-change-dans-le-nouveau-programme-de-jean-luc-melenchon-444841', 'Présidentielle 2027: ce qui change dans le nouveau programme de Jean-Luc Mélenchon', 'LCP', 'LCP', '2026-11-06', 3, '2026-11-10'),
('lcp-2026-11-07-bourget', 'https://lcp.fr/actualites/je-vais-l-offrir-a-mes-grands-parents-au-meeting-de-melenchon-les-militants-repartent', '"Je vais l''offrir à mes grands-parents": au meeting de Mélenchon, les militants repartent avec le programme et une mission', 'LCP', 'LCP', '2026-11-07', 3, '2026-11-10'),
('commission-sondages-2026-11-03-ifop-lci', 'https://www.commission-des-sondages.fr/notices/files/notices/2026/novembre/10352-pres-iv-ifop-lci-3-novembre.pdf', 'Les intentions de vote au 1er tour de l''élection présidentielle 2027', 'Commission des sondages', 'Commission des sondages', '2026-11-03', 1, '2026-11-10'),
('publicsenat-2026-11-04-ifop', 'https://www.publicsenat.fr/actualites/politique/sondage-presidentielle-2027-un-second-tour-le-pen-melenchon-assure-la-droite-et-le-bloc-central-peine-a-remonter-lisnard-confirme-sa-percee', 'Sondage présidentielle 2027 : un second tour Le Pen - Mélenchon assuré, la droite et le bloc central peinent à remonter, Lisnard confirme sa percée', 'Public Sénat', 'Public Sénat', '2026-11-04', 3, '2026-11-10'),
('lcp-2026-11-01-philippe-primaire', 'https://lcp.fr/actualites/presidentielle-2027-edouard-philippe-ne-veut-pas-de-la-primaire-de-gabriel-attal-444599', 'Présidentielle 2027: Edouard Philippe ne veut pas de la primaire de Gabriel Attal', 'LCP', 'LCP', '2026-11-01', 3, '2026-11-10'),
('lcp-2026-11-02-attal-primaire', 'https://lcp.fr/actualites/c-est-ineluctable-gabriel-attal-s-accroche-a-sa-primaire-malgre-le-refus-d-edouard', '"C''est inéluctable": Gabriel Attal s''accroche à sa primaire, malgré le refus d''Édouard Philippe', 'LCP', 'LCP', '2026-11-02', 3, '2026-11-10'),
('afp-2026-11-04-retailleau-primaire', 'https://www.dhnet.be/dernieres-depeches/2026/11/04/primaire-a-droite-et-au-centre-retailleau-remet-la-pression-sur-philippe-C25CTRDLU5AMRJLJ2B5SM5QT6Q/', 'Primaire à droite et au centre : Retailleau remet la pression sur Philippe', 'AFP', 'AFP', '2026-11-04', 3, '2026-11-10'),
-- Programme de La France insoumise et chapitres cités (niveau 2), identiques au seed 090
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

-- ---------------------------------------------------------------------
-- Digest du 1er au 7 novembre 2026, non publié (rapport, section 2)
-- ---------------------------------------------------------------------
INSERT IGNORE INTO digest (debut, fin, publie) VALUES ('2026-11-01', '2026-11-07', 0);
SET @dg := (SELECT id FROM digest WHERE debut = '2026-11-01');
-- Une réimportation remplace les faits non validés ; si le digest a déjà été validé, aucun fait n'est ajouté.
DELETE FROM evenement WHERE digest_id = @dg AND etat <> 'valide';
SET @deja := (SELECT COUNT(*) FROM evenement WHERE digest_id = @dg AND etat = 'valide');

-- Ordre d'affichage : date décroissante. Axe et portée : règle par défaut du type (rapport, section 2).

-- Fait 4 (1er nov.) : primaire de la droite et du centre
INSERT INTO evenement (date_evenement, type, axe, portee, titre, digest_id, etat)
SELECT '2026-11-01', 'primaire', 1, 'signal', 'Sur TF1, Édouard Philippe refuse le 1er novembre la « grande primaire des démocrates » proposée par Gabriel Attal et renvoie les choix à février ; le 2, Gabriel Attal juge cette primaire « inéluctable » ; le 3, Bruno Retailleau estime qu''« il faudra une primaire sans doute en début d''année ».', @dg, 'a_valider' FROM DUAL WHERE @deja = 0;
SET @e4 := IF(ROW_COUNT() > 0, LAST_INSERT_ID(), NULL);
INSERT INTO evenement_source (evenement_id, source_id, ordre) SELECT @e4, id, 1 FROM source WHERE cle = 'lcp-2026-11-01-philippe-primaire' AND @e4 IS NOT NULL;
INSERT INTO evenement_source (evenement_id, source_id, ordre) SELECT @e4, id, 2 FROM source WHERE cle = 'lcp-2026-11-02-attal-primaire' AND @e4 IS NOT NULL;
INSERT INTO evenement_source (evenement_id, source_id, ordre) SELECT @e4, id, 3 FROM source WHERE cle = 'afp-2026-11-04-retailleau-primaire' AND @e4 IS NOT NULL;
INSERT INTO evenement_candidat (evenement_id, candidat_id) SELECT @e4, id FROM candidat WHERE slug IN ('philippe', 'attal', 'retailleau') AND @e4 IS NOT NULL;

-- Fait 3 (3 nov.) : sondage Ifop pour LCI
INSERT INTO evenement (date_evenement, type, axe, portee, titre, digest_id, etat)
SELECT '2026-11-03', 'sondage', 4, 'signal', 'Sondage Ifop pour LCI (terrain du 27 au 29 octobre) : Marine Le Pen de 35 à 37 % selon les hypothèses, Jean-Luc Mélenchon de 17,5 à 18 %, Édouard Philippe 15 % comme seul candidat du bloc central, Raphaël Glucksmann de 10 à 13 %.', @dg, 'a_valider' FROM DUAL WHERE @deja = 0;
SET @e3 := IF(ROW_COUNT() > 0, LAST_INSERT_ID(), NULL);
INSERT INTO evenement_source (evenement_id, source_id, ordre) SELECT @e3, id, 1 FROM source WHERE cle = 'commission-sondages-2026-11-03-ifop-lci' AND @e3 IS NOT NULL;
INSERT INTO evenement_source (evenement_id, source_id, ordre) SELECT @e3, id, 2 FROM source WHERE cle = 'publicsenat-2026-11-04-ifop' AND @e3 IS NOT NULL;
INSERT INTO evenement_candidat (evenement_id, candidat_id) SELECT @e3, id FROM candidat WHERE slug IN ('le-pen', 'melenchon', 'philippe', 'glucksmann') AND @e3 IS NOT NULL;

-- Fait 2 (5 nov.) : députés du groupe GDR et Parti communiste
INSERT INTO evenement (date_evenement, type, axe, portee, titre, digest_id, etat)
SELECT '2026-11-05', 'ralliement', 1, 'course', 'Neuf députés du groupe GDR, dont son président Stéphane Peu (quatre communistes et cinq ultramarins), annoncent soutenir Jean-Luc Mélenchon plutôt que Fabien Roussel ; le 7, le Conseil national du PCF estime que les adhérents soutenant un autre candidat se placent « en dehors du parti ».', @dg, 'a_valider' FROM DUAL WHERE @deja = 0;
SET @e2 := IF(ROW_COUNT() > 0, LAST_INSERT_ID(), NULL);
INSERT INTO evenement_source (evenement_id, source_id, ordre) SELECT @e2, id, 1 FROM source WHERE cle = 'lcp-2026-11-05-gdr-melenchon' AND @e2 IS NOT NULL;
INSERT INTO evenement_source (evenement_id, source_id, ordre) SELECT @e2, id, 2 FROM source WHERE cle = 'afp-2026-11-07-pcf' AND @e2 IS NOT NULL;
INSERT INTO evenement_candidat (evenement_id, candidat_id) SELECT @e2, id FROM candidat WHERE slug IN ('melenchon', 'roussel') AND @e2 IS NOT NULL;

-- Fait 1 (6 nov.) : programme de La France insoumise
INSERT INTO evenement (date_evenement, type, axe, portee, titre, digest_id, etat)
SELECT '2026-11-06', 'programme', 3, 'engagement', 'La France insoumise publie « L''Avenir en commun », programme de Jean-Luc Mélenchon (1 069 mesures selon le mouvement, dont 238 nouvelles), présenté le lendemain lors d''un meeting au Bourget ; son financement doit être présenté début 2027.', @dg, 'a_valider' FROM DUAL WHERE @deja = 0;
SET @e1 := IF(ROW_COUNT() > 0, LAST_INSERT_ID(), NULL);
INSERT INTO evenement_source (evenement_id, source_id, ordre) SELECT @e1, id, 1 FROM source WHERE cle = 'afp-2026-11-06-programme-lfi' AND @e1 IS NOT NULL;
INSERT INTO evenement_source (evenement_id, source_id, ordre) SELECT @e1, id, 2 FROM source WHERE cle = 'lcp-2026-11-06-programme-melenchon' AND @e1 IS NOT NULL;
INSERT INTO evenement_source (evenement_id, source_id, ordre) SELECT @e1, id, 3 FROM source WHERE cle = 'lcp-2026-11-07-bourget' AND @e1 IS NOT NULL;
INSERT INTO evenement_source (evenement_id, source_id, ordre) SELECT @e1, id, 4 FROM source WHERE cle = 'melenchon2027-2026-11-06-aec' AND @e1 IS NOT NULL;
INSERT INTO evenement_candidat (evenement_id, candidat_id) SELECT @e1, id FROM candidat WHERE slug IN ('melenchon') AND @e1 IS NOT NULL;

-- ---------------------------------------------------------------------
-- Sondage Ifop pour LCI, terrain du 27 au 29 octobre 2026 (rapport, section 3.1)
-- Résultats lus sur la notice de la Commission des sondages, qui sert de
-- source (lien « Voir l'enquête ») ; devient l'enquête de référence une fois
-- validé (terrain le plus récent).
-- ---------------------------------------------------------------------
INSERT INTO sondage (institut, commanditaires, terrain_debut, terrain_fin, echantillon, population, methode, tour, lecture, note, source_id, etat)
SELECT 'Ifop', 'LCI', '2026-10-27', '2026-10-29', 1501,
       'personnes inscrites sur les listes électorales',
       'Questionnaire auto-administré en ligne, méthode des quotas', 1,
       'Chaque barre va du score le plus bas au plus haut obtenu selon les quatre hypothèses de candidatures testées. Ce n''est pas une marge d''erreur.',
       'Gabriel Attal, Édouard Philippe, Bruno Retailleau et David Lisnard ne sont pas testés dans toutes les hypothèses ; base de 1 134 à 1 160 répondants exprimés selon l''hypothèse.',
       (SELECT id FROM source WHERE cle = 'commission-sondages-2026-11-03-ifop-lci'), 'a_valider'
FROM DUAL
WHERE NOT EXISTS (SELECT 1 FROM sondage WHERE institut = 'Ifop' AND commanditaires = 'LCI' AND terrain_fin = '2026-10-29');

SET @sd := (SELECT id FROM sondage WHERE institut = 'Ifop' AND commanditaires = 'LCI' AND terrain_fin = '2026-10-29' ORDER BY id LIMIT 1);
INSERT IGNORE INTO sondage_resultat (sondage_id, candidat_id, valeur_min, valeur_max)
SELECT @sd, id, 0.5, 1.0 FROM candidat WHERE slug = 'arthaud'
UNION ALL SELECT @sd, id, 17.5, 18.0 FROM candidat WHERE slug = 'melenchon'
UNION ALL SELECT @sd, id, 1.5, 2.0 FROM candidat WHERE slug = 'roussel'
UNION ALL SELECT @sd, id, 3.0, 3.5 FROM candidat WHERE slug = 'tondelier'
UNION ALL SELECT @sd, id, 10.0, 13.0 FROM candidat WHERE slug = 'glucksmann'
UNION ALL SELECT @sd, id, 5.0, 9.0 FROM candidat WHERE slug = 'attal'
UNION ALL SELECT @sd, id, 9.5, 15.0 FROM candidat WHERE slug = 'philippe'
UNION ALL SELECT @sd, id, 4.0, 7.0 FROM candidat WHERE slug = 'retailleau'
UNION ALL SELECT @sd, id, 7.0, 9.0 FROM candidat WHERE slug = 'lisnard'
UNION ALL SELECT @sd, id, 1.5, 2.0 FROM candidat WHERE slug = 'dupont-aignan'
UNION ALL SELECT @sd, id, 35.0, 37.0 FROM candidat WHERE slug = 'le-pen'
UNION ALL SELECT @sd, id, 4.0, 4.5 FROM candidat WHERE slug = 'zemmour';

-- ---------------------------------------------------------------------
-- Positions de Jean-Luc Mélenchon dans sept débats, tirées du programme
-- (rapport, section 3.3) : restent a_valider, non publiées
-- ---------------------------------------------------------------------
INSERT IGNORE INTO debat_position (debat_id, candidat_id, echelle, citation, source_id, statut_position, etat) VALUES
((SELECT id FROM debat WHERE slug = 'nouveaux-reacteurs'), (SELECT id FROM candidat WHERE slug = 'melenchon'), -2,
 'arrêter le programme de nouveau nucléaire (EPR2)',
 (SELECT id FROM source WHERE cle = 'melenchon2027-2026-11-06-aec-1-3'), 'programme', 'a_valider'),
((SELECT id FROM debat WHERE slug = 'moratoire-centres-donnees'), (SELECT id FROM candidat WHERE slug = 'melenchon'), 1,
 'Décréter un moratoire sur l’installation de centres de données non souverains (sans aucune participation publique)',
 (SELECT id FROM source WHERE cle = 'melenchon2027-2026-11-06-aec-4-7'), 'programme', 'a_valider'),
((SELECT id FROM debat WHERE slug = 'encadrement-ia'), (SELECT id FROM candidat WHERE slug = 'melenchon'), 2,
 'Créer une autorité nationale de l’intelligence artificielle qui délivre aux systèmes d’IA définis comme à haut risque une autorisation de mise sur le marché afin de s’assurer qu’ils respectent la législation en vigueur et qu’ils ne risquent pas de mettre en danger la société',
 (SELECT id FROM source WHERE cle = 'melenchon2027-2026-11-06-aec-4-7'), 'programme', 'a_valider'),
((SELECT id FROM debat WHERE slug = 'hebergement-souverain'), (SELECT id FROM candidat WHERE slug = 'melenchon'), 2,
 'Garantir l’hébergement des données des services publics français et des entreprises essentielles sur des serveurs publics situés en France',
 (SELECT id FROM source WHERE cle = 'melenchon2027-2026-11-06-aec-4-7'), 'programme', 'a_valider'),
((SELECT id FROM debat WHERE slug = 'budget-culture-1-pourcent'), (SELECT id FROM candidat WHERE slug = 'melenchon'), 2,
 'Porter la dépense publique consacrée à l’art, à la culture et à la création à 1 % du produit intérieur brut (PIB) par an pour mener une politique culturelle ambitieuse, émancipatrice et à l’image de la France d’aujourd’hui',
 (SELECT id FROM source WHERE cle = 'melenchon2027-2026-11-06-aec-4-3'), 'programme', 'a_valider'),
((SELECT id FROM debat WHERE slug = 'revenu-artistes-auteurs'), (SELECT id FROM candidat WHERE slug = 'melenchon'), 2,
 'Mettre en place de véritables droits sociaux pour les artistes-auteurs, notamment grâce à un système de continuité de revenus financé par une hausse de cotisation des diffuseurs, d’élections professionnelles adaptées et d’instances de démocratie sociale représentatives de ces professions',
 (SELECT id FROM source WHERE cle = 'melenchon2027-2026-11-06-aec-4-3'), 'programme', 'a_valider'),
((SELECT id FROM debat WHERE slug = 'enseignement-superieur-prive'), (SELECT id FROM candidat WHERE slug = 'melenchon'), 1,
 'renforcer le contrôle pédagogique de toutes les formations privées',
 (SELECT id FROM source WHERE cle = 'melenchon2027-2026-11-06-aec-4-2'), 'programme', 'a_valider');

-- Contrôle : 15 sources de la veille, 4 faits, 12 résultats de sondage, 7 positions attendus
SELECT
  (SELECT COUNT(*) FROM source WHERE consultee_le = '2026-11-10') AS sources_veille,
  (SELECT COUNT(*) FROM evenement WHERE digest_id = @dg) AS faits_digest,
  (SELECT COUNT(*) FROM sondage_resultat WHERE sondage_id = @sd) AS resultats_sondage,
  (SELECT COUNT(*) FROM debat_position dp JOIN candidat c ON c.id = dp.candidat_id
    WHERE c.slug = 'melenchon' AND dp.statut_position = 'programme') AS positions_melenchon;
