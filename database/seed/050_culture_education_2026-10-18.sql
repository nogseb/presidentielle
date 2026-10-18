-- =====================================================================
-- Repères 2027 · thème « Culture et soutien aux artistes » et trois débats,
-- au 18 octobre 2026 : budget de la culture à 1 % du budget de l'État,
-- revenu de remplacement pour les artistes-auteurs, groupes de niveau au collège.
-- À importer après database/seed/040_debats_2026-10-18.sql.
-- =====================================================================

SET NAMES utf8mb4;

-- 15e thème commun
INSERT INTO theme (id, slug, nom, nom_court, nom_radar, a_la_une, ordre) VALUES
(15, 'culture', 'Culture et soutien aux artistes', 'Culture', NULL, 0, 15);

INSERT INTO variable (theme_id, slug, question, type, unite, borne_min, borne_max, graduations, chantier_id, ordre) VALUES
(15, 'budget-culture',   'Budget de l''État pour la culture',  'categorielle', NULL, NULL, NULL, NULL, NULL, 1),
(15, 'revenus-artistes', 'Revenus des artistes-auteurs',       'categorielle', NULL, NULL, NULL, NULL, NULL, 2),
(15, 'pass-culture',     'Avenir du pass Culture',             'categorielle', NULL, NULL, NULL, NULL, NULL, 3);

INSERT INTO modalite (variable_id, libelle, ordre)
SELECT v.id, m.libelle, m.ordre FROM variable v JOIN (
            SELECT 'budget-culture' AS slug, 'Porter à 1 % du budget de l''État' AS libelle, 1 AS ordre
  UNION ALL SELECT 'budget-culture', 'Maintenir le niveau actuel', 2
  UNION ALL SELECT 'budget-culture', 'Réduire', 3
  UNION ALL SELECT 'revenus-artistes', 'Créer un revenu de remplacement', 1
  UNION ALL SELECT 'revenus-artistes', 'Renforcer les aides ciblées', 2
  UNION ALL SELECT 'revenus-artistes', 'Pas de changement', 3
  UNION ALL SELECT 'pass-culture', 'Maintenir', 1
  UNION ALL SELECT 'pass-culture', 'Recentrer sur des critères sociaux', 2
  UNION ALL SELECT 'pass-culture', 'Supprimer', 3
) m ON m.slug = v.slug;

INSERT INTO source (cle, url, titre, editeur, libelle_court, date_publication, niveau, consultee_le) VALUES
('larousse-1993-culture', 'https://www.larousse.fr/archives/journaux_annee/1993/181/environnement', 'Culture : de l''invention à la gestion', 'Larousse, Journal de l''année', 'Larousse', NULL, 3, '2026-10-18'),
('an-qe15903-2026', 'https://www.assemblee-nationale.fr/dyn/17/questions/QANR5L17QE15903', 'Question écrite n° 15903 sur le budget de la culture, et réponse du ministère de la Culture', 'Assemblée nationale', 'Assemblée nationale', '2026-06-16', 1, '2026-10-18'),
('actualitte-elus-ps-culture', 'https://actualitte.com/article/124967/politique-publique/culture-en-danger-les-elus-socialistes-tirent-la-sonnette-d-alarme', 'Culture en danger : les élus socialistes tirent la sonnette d''alarme', 'ActuaLitté', 'ActuaLitté', NULL, 3, '2026-10-18'),
('weka-2026-01-22-spectacle', 'https://www.weka.fr/actualite/communication/article/le-secteur-du-spectacle-vivant-public-craint-un-chomage-massif-pour-2026-209809/', 'Le secteur du spectacle vivant public craint « un chômage massif pour 2026 »', 'WEKA (AFP)', 'WEKA', '2026-01-22', 3, '2026-10-18'),
('europe1-cdc-pass-culture', 'https://www.europe1.fr/culture/le-pass-culture-un-dispositif-cher-aux-effets-limites-pour-la-cour-des-comptes-235710', 'Le pass Culture, un dispositif cher aux effets limités pour la Cour des comptes', 'Europe 1', 'Europe 1', NULL, 3, '2026-10-18'),
('senat-avis-2025-11-26-culture', 'https://www.senat.fr/rap/a25-144-22/a25-144-22-syn.pdf', 'Avis sur les crédits « Création » et « Transmission des savoirs » du projet de loi de finances pour 2026 (synthèse)', 'Sénat, commission de la culture', 'Sénat', '2025-11-26', 1, '2026-10-18'),
('carenews-2026-10-06-mecenat', 'https://www.carenews.com/carenews-info/news/face-a-la-baisse-des-financements-publics-acteurs-culturels-et-mecenes', 'Face à la baisse des financements publics, acteurs culturels et mécènes', 'Carenews', 'Carenews', '2026-10-06', 3, '2026-10-18'),
('livreshebdo-2025-12-18-senat', 'https://www.livreshebdo.fr/article/le-senat-rejette-lassurance-chomage-des-artistes-auteurs', 'Le Sénat rejette l''assurance chômage des artistes-auteurs', 'Livres Hebdo', 'Livres Hebdo', '2025-12-18', 3, '2026-10-18'),
('actualitte-mission-flash-auteurs', 'https://actualitte.com/article/125244/auteurs/l-assemblee-nationale-planche-sur-la-continuite-de-revenus-des-auteurs', 'L''Assemblée nationale planche sur la continuité de revenus des auteurs', 'ActuaLitté', 'ActuaLitté', NULL, 3, '2026-10-18'),
('fraap-2025-continuite', 'https://fraap.org/IMG/pdf/cp-continuite_-de-revenus.pdf', 'Continuité de revenus des artistes-auteurs (communiqué)', 'Fraap', 'Fraap', NULL, 4, '2026-10-18'),
('bdt-2008-02-08-intermittents', 'https://www.banquedesterritoires.fr/regime-des-intermittents-la-reforme-reste-faire', 'Régime des intermittents : la réforme reste à faire', 'Banque des territoires (Localtis)', 'Localtis', '2008-02-08', 3, '2026-10-18'),
('letudiant-2025-11-17-groupes', 'https://www.letudiant.fr/college/moins-dun-college-sur-cinq-applique-les-groupes-de-besoin-en-francais-et-maths-selon-le-snes-fsu.html', 'Moins d''un collège sur cinq applique les groupes de besoin en français et maths, selon le SNES-FSU', 'L''Étudiant', 'L''Étudiant', '2025-11-17', 3, '2026-10-18'),
('publicsenat-2024-02-06-groupes', 'https://publicsenat.fr/actualites/education/greve-des-enseignants-derriere-les-groupes-de-niveau-lavenir-du-college-unique-en-balance', 'Grève des enseignants : derrière les groupes de niveau, l''avenir du collège unique en balance', 'Public Sénat', 'Public Sénat', '2024-02-06', 3, '2026-10-18'),
('bdt-2025-06-17-igesr', 'https://www.banquedesterritoires.fr/groupes-de-besoins-au-college-un-premier-bilan-negatif', 'Groupes de besoins au collège : un premier bilan négatif', 'Banque des territoires (Localtis)', 'Localtis', '2025-06-17', 3, '2026-10-18'),
('letudiant-2024-03-20-chercheurs', 'https://www.letudiant.fr/educpros/enquetes/lefficacite-des-groupes-de-niveau-contestee-par-les-chercheurs.html', 'L''efficacité des groupes de niveau contestée par les chercheurs', 'L''Étudiant (EducPros)', 'EducPros', '2024-03-20', 3, '2026-10-18');

INSERT INTO debat (slug, theme_id, variable_id, chantier_id, proposition, nom_court, contexte, contexte_source_id, chiffre, chiffre_libelle, chiffre_source_id, ordre, etat, verifie_le, verifie_par) VALUES
('budget-culture-1-pourcent', 15, (SELECT id FROM variable WHERE slug = 'budget-culture'), NULL,
 'Porter le budget de la culture à 1 % du budget de l''État', 'Budget de la culture',
 'Revendication ancienne du programme socialiste, le seuil symbolique de 1 % du budget de l''État consacré à la culture a été atteint en 1993, sous Jack Lang, ministre de la Culture de 1981 à 1986 puis de 1988 à 1993.',
 (SELECT id FROM source WHERE cle = 'larousse-1993-culture'),
 '0,8 %', 'du budget de l''État revient aujourd''hui au ministère de la Culture, selon la CGT-Culture ; ses crédits baissent en 2026', (SELECT id FROM source WHERE cle = 'an-qe15903-2026'),
 6, 'valide', '2026-10-18', 'redaction');
INSERT INTO debat_argument (debat_id, sens, texte, porteur, source_id, ordre, etat) VALUES
((SELECT id FROM debat WHERE slug = 'budget-culture-1-pourcent'), 'pour', 'Près d''une collectivité sur deux déclare un budget culturel en baisse (47 %, contre 21 % un an plus tôt) : la culture est « un bien essentiel, à sanctuariser ».', 'Élus socialistes, d''après le baromètre de l''Observatoire des politiques culturelles', (SELECT id FROM source WHERE cle = 'actualitte-elus-ps-culture'), 1, 'valide'),
((SELECT id FROM debat WHERE slug = 'budget-culture-1-pourcent'), 'pour', 'Porter les crédits à au moins 1 % du budget de l''État, car « les ressources privées ne sauraient constituer un substitut à l''engagement de l''État ».', 'CGT-Culture, relayée par une question écrite à l''Assemblée nationale (juin 2026)', (SELECT id FROM source WHERE cle = 'an-qe15903-2026'), 2, 'valide'),
((SELECT id FROM debat WHERE slug = 'budget-culture-1-pourcent'), 'pour', 'Faute de financements, treize organisations du spectacle vivant subventionné craignent « un chômage massif pour 2026 » ; le fonds pour l''emploi du secteur reçoit 36 millions d''euros pour des besoins estimés à 60.', 'Syndeac, CGT Spectacle et onze autres organisations', (SELECT id FROM source WHERE cle = 'weka-2026-01-22-spectacle'), 3, 'valide'),
((SELECT id FROM debat WHERE slug = 'budget-culture-1-pourcent'), 'contre', 'Mieux dépenser avant de dépenser plus : le pass Culture est passé de 93 à 244 millions d''euros entre 2021 et 2024, surtout pour intensifier des pratiques déjà établies ; un « recadrage budgétaire » est « indispensable ».', 'Cour des comptes', (SELECT id FROM source WHERE cle = 'europe1-cdc-pass-culture'), 1, 'valide'),
((SELECT id FROM debat WHERE slug = 'budget-culture-1-pourcent'), 'contre', 'Comme les autres ministères, la Culture doit participer à l''effort de réduction du déficit public, ce qui justifie une baisse sensible de ses crédits en 2026.', 'Gouvernement, projet de loi de finances pour 2026', (SELECT id FROM source WHERE cle = 'senat-avis-2025-11-26-culture'), 2, 'valide'),
((SELECT id FROM debat WHERE slug = 'budget-culture-1-pourcent'), 'contre', 'Plutôt que tout attendre de l''État, inventer de « nouveaux modèles » : coopérations entre public et privé, mécénat pluriannuel, incitations fiscales renforcées.', 'Ministère de la Culture et acteurs du mécénat (rencontre du 29 septembre 2026)', (SELECT id FROM source WHERE cle = 'carenews-2026-10-06-mecenat'), 3, 'valide');

INSERT INTO debat (slug, theme_id, variable_id, chantier_id, proposition, nom_court, contexte, contexte_source_id, chiffre, chiffre_libelle, chiffre_source_id, ordre, etat, verifie_le, verifie_par) VALUES
('revenu-artistes-auteurs', 15, (SELECT id FROM variable WHERE slug = 'revenus-artistes'), NULL,
 'Créer un revenu de remplacement pour les artistes-auteurs', 'Revenus des artistes',
 'Inspirée du régime des intermittents du spectacle, une proposition de loi prévoit un revenu de remplacement d''au moins 85 % du Smic pour les artistes-auteurs privés de ressources, financé par une contribution des diffuseurs. Le Sénat l''a rejetée le 18 décembre 2025, par 206 voix contre 116.',
 (SELECT id FROM source WHERE cle = 'livreshebdo-2025-12-18-senat'),
 '350 000', 'artistes-auteurs concernés selon la ministre de la Culture ; coût estimé entre 230 et 800 millions d''euros selon les sources', (SELECT id FROM source WHERE cle = 'livreshebdo-2025-12-18-senat'),
 7, 'valide', '2026-10-18', 'redaction');
INSERT INTO debat_argument (debat_id, sens, texte, porteur, source_id, ordre, etat) VALUES
((SELECT id FROM debat WHERE slug = 'revenu-artistes-auteurs'), 'pour', 'Il s''agit de « réparer une injustice sociale » : contrairement aux intermittents du spectacle, les artistes-auteurs n''ont aucun revenu de remplacement entre deux projets.', 'Monique de Marco, sénatrice, autrice de la proposition de loi', (SELECT id FROM source WHERE cle = 'livreshebdo-2025-12-18-senat'), 1, 'valide'),
((SELECT id FROM debat WHERE slug = 'revenu-artistes-auteurs'), 'pour', 'Le rapport Racine (2020) a documenté la paupérisation des créateurs, dont le statut reste « peu protecteur » et les revenus irréguliers.', 'Mission flash de l''Assemblée nationale sur la continuité de revenus (2025)', (SELECT id FROM source WHERE cle = 'actualitte-mission-flash-auteurs'), 2, 'valide'),
((SELECT id FROM debat WHERE slug = 'revenu-artistes-auteurs'), 'pour', 'La recherche, la préparation et la création « ne sont absolument pas des temps d''inactivité » ; les artistes-auteurs n''ont ni assurance chômage ni prestation en cas d''accident du travail.', 'Fédération des réseaux et associations d''artistes plasticiens (Fraap)', (SELECT id FROM source WHERE cle = 'fraap-2025-continuite'), 3, 'valide'),
((SELECT id FROM debat WHERE slug = 'revenu-artistes-auteurs'), 'contre', 'Une mesure « démagogique », au coût estimé à 800 millions d''euros à ce stade, qui ferait des créateurs des « fonctionnaires de l''art subventionnés par l''assurance chômage ».', 'Rachida Dati, alors ministre de la Culture (décembre 2025)', (SELECT id FROM source WHERE cle = 'livreshebdo-2025-12-18-senat'), 1, 'valide'),
((SELECT id FROM debat WHERE slug = 'revenu-artistes-auteurs'), 'contre', 'Privilégier d''autres voies : des négociations avec producteurs et diffuseurs, et une mission d''inspection sur les aléas de rémunération liés aux cycles de création.', 'Gouvernement (décembre 2025)', (SELECT id FROM source WHERE cle = 'livreshebdo-2025-12-18-senat'), 2, 'valide'),
((SELECT id FROM debat WHERE slug = 'revenu-artistes-auteurs'), 'contre', 'L''exemple des intermittents invite à la prudence : leur régime représentait plus de 30 % du déficit de l''assurance chômage, et la Cour des comptes demandait d''en maîtriser les dépenses.', 'Cour des comptes (rapport public 2008)', (SELECT id FROM source WHERE cle = 'bdt-2008-02-08-intermittents'), 3, 'valide');

INSERT INTO debat (slug, theme_id, variable_id, chantier_id, proposition, nom_court, contexte, contexte_source_id, chiffre, chiffre_libelle, chiffre_source_id, ordre, etat, verifie_le, verifie_par) VALUES
('groupes-de-niveau', 5, NULL, NULL,
 'Généraliser les groupes de niveau au collège', 'Groupes de niveau',
 'Annoncés en décembre 2023 dans le cadre du « choc des savoirs », les groupes de besoin en français et en mathématiques ont été instaurés en 6e et 5e. Le ministère y a renoncé pour la 4e et la 3e, et le ministre Édouard Geffray a reconnu un « bilan mitigé ».',
 (SELECT id FROM source WHERE cle = 'letudiant-2025-11-17-groupes'),
 '< 19 %', 'des collèges appliquent strictement les groupes de besoin en 6e et 5e, contre 26 % un an plus tôt (enquête du SNES-FSU, novembre 2025)', (SELECT id FROM source WHERE cle = 'letudiant-2025-11-17-groupes'),
 8, 'valide', '2026-10-18', 'redaction');
INSERT INTO debat_argument (debat_id, sens, texte, porteur, source_id, ordre, etat) VALUES
((SELECT id FROM debat WHERE slug = 'groupes-de-niveau'), 'pour', '« Je crois aux groupes de niveau » : l''hétérogénéité des classes est la principale difficulté des enseignants.', 'Max Brisson, sénateur Les Républicains', (SELECT id FROM source WHERE cle = 'publicsenat-2024-02-06-groupes'), 1, 'valide'),
((SELECT id FROM debat WHERE slug = 'groupes-de-niveau'), 'pour', 'Relever un niveau en baisse dans les enquêtes PISA, avec des groupes d''une quinzaine d''élèves pour les plus en difficulté et des heures supplémentaires pour eux.', 'Gouvernement, lors du lancement de la réforme (2024)', (SELECT id FROM source WHERE cle = 'publicsenat-2024-02-06-groupes'), 2, 'valide'),
((SELECT id FROM debat WHERE slug = 'groupes-de-niveau'), 'pour', 'Dans les groupes surtout composés d''élèves à faibles besoins, des enseignants ont trouvé des conditions de travail favorables et la possibilité d''aller plus loin.', 'Inspection générale de l''éducation (rapport intermédiaire, juin 2025)', (SELECT id FROM source WHERE cle = 'bdt-2025-06-17-igesr'), 3, 'valide'),
((SELECT id FROM debat WHERE slug = 'groupes-de-niveau'), 'contre', 'Les élèves à forts besoins n''ont « clairement pas bénéficié » de la mesure ; le risque de voir les écarts se creuser est jugé « majeur », et la mobilité entre groupes quasi absente.', 'Inspection générale de l''éducation (rapport intermédiaire, juin 2025)', (SELECT id FROM source WHERE cle = 'bdt-2025-06-17-igesr'), 1, 'valide'),
((SELECT id FROM debat WHERE slug = 'groupes-de-niveau'), 'contre', 'Selon la synthèse PISA 2022, la séparation en groupes de niveau n''améliore pas les résultats ; les regroupements par aptitude tendent à « stigmatiser et démotiver » les plus faibles.', 'OCDE et chercheurs en éducation', (SELECT id FROM source WHERE cle = 'letudiant-2024-03-20-chercheurs'), 2, 'valide'),
((SELECT id FROM debat WHERE slug = 'groupes-de-niveau'), 'contre', 'Stress, compétition entre élèves, emplois du temps dégradés pour les élèves comme pour les enseignants : « Nous ne trierons pas les élèves ! »', 'SNES-FSU, syndicat d''enseignants', (SELECT id FROM source WHERE cle = 'letudiant-2025-11-17-groupes'), 3, 'valide');

