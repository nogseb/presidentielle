-- =====================================================================
-- Repères 2027 · référentiels
-- Paramètres, 14 thèmes, organisation The Shift Project et ses chantiers,
-- variables pivots et leurs modalités.
-- À importer après database/migrations/001_schema.sql.
--
-- Les variables pivots et leurs modalités sont une PROPOSITION à valider
-- au cadrage (test de formulation : partisans et opposants d'une mesure
-- doivent accepter l'intitulé). Les modifier ici avant le premier import,
-- ou plus tard dans phpMyAdmin en le signalant dans le journal.
-- =====================================================================

SET NAMES utf8mb4;

-- ---------------------------------------------------------------------
-- Paramètres
-- ---------------------------------------------------------------------
INSERT INTO parametre (cle, valeur, description) VALUES
('premier_tour',     '2027-04-18', 'Date du premier tour (métropole)'),
('second_tour',      '2027-05-02', 'Date du second tour (métropole)'),
('liste_officielle', '2027-03-26', 'Date limite de publication de la liste officielle ; à remplacer par la date réelle'),
('debut_suivi',      '2026-07-01', 'Début de la phase 1 (dates du scrutin arrêtées)'),
('phase',            'declares',   'declares · officiels · entre_deux_tours ; pilote le périmètre du comparateur'),
('chiffre_note',     'Selon Toute l''Europe au 14 octobre 2026 ; L''Obs en compte 31. En 2022, 12 candidats avaient obtenu leurs 500 parrainages.', 'Texte sous le chiffre de la semaine'),
('empreinte_min',    '10',         'Nombre minimal de propositions validées pour afficher le radar d''un candidat'),
('site_url',         'https://nogues.app/presidentielle', 'Adresse publique du site');

-- ---------------------------------------------------------------------
-- Thèmes (l'identifiant fixe l'ordre des axes des radars)
-- ---------------------------------------------------------------------
INSERT INTO theme (id, slug, nom, nom_court, nom_radar, a_la_une, ordre) VALUES
( 1, 'pouvoir-achat-logement', 'Pouvoir d''achat et logement',                   'Achat',           NULL,        0,  1),
( 2, 'finances-fiscalite',     'Finances publiques et fiscalité',               'Finances',        NULL,        0,  2),
( 3, 'travail-retraites',      'Travail, emploi et retraites',                  'Retraites',       NULL,        0,  3),
( 4, 'sante',                  'Santé et autonomie',                            'Santé',           NULL,        0,  4),
( 5, 'education',              'Éducation, jeunesse et enseignement supérieur', 'Éducation',       NULL,        0,  5),
( 6, 'environnement',          'Environnement, climat et énergie',              'Environnement',   NULL,        1,  6),
( 7, 'agriculture',            'Agriculture et alimentation',                   'Agriculture',     NULL,        0,  7),
( 8, 'securite-justice',       'Sécurité et justice',                           'Sécurité',        NULL,        0,  8),
( 9, 'immigration',            'Immigration et intégration',                    'Immigration',     NULL,        0,  9),
(10, 'europe-defense',         'Europe, international et défense',              'Europe',          NULL,        0, 10),
(11, 'institutions',           'Institutions et démocratie',                    'Institutions',    NULL,        0, 11),
(12, 'economie-industrie',     'Économie et industrie',                         'Économie',        NULL,        0, 12),
(13, 'transports',             'Transports et mobilités',                       'Transports',      NULL,        1, 13),
(14, 'numerique-ia',           'Numérique, innovation technologique et IA',     'Numérique et IA', 'Numérique', 1, 14);

-- ---------------------------------------------------------------------
-- Sources des référentiels (The Shift Project)
-- ---------------------------------------------------------------------
INSERT INTO source (cle, url, titre, editeur, libelle_court, date_publication, niveau, consultee_le) VALUES
('shift-pref-2026-03-19', 'https://theshiftproject.org/publications/plan-robuste-economie/', 'Le Shift lance son Plan robuste pour l''économie française', 'The Shift Project', 'The Shift Project', '2026-03-19', 4, '2026-10-17'),
('shift-communique-2026-04-14', 'https://theshiftproject.org/app/uploads/2026/04/Communique-de-presse-Transition-Robuste-avril26.pdf', 'Réussir la transition dans l''incertitude (communiqué de presse)', 'The Shift Project', 'Communiqué', '2026-04-14', 4, '2026-10-17'),
('carenews-2026-08-26', 'https://www.carenews.com/carenews-info/news/jean-marc-jancovici-lance-une-assemblee-citoyenne-en-perspective-de-2027', 'Jean-Marc Jancovici lance une assemblée citoyenne pour préparer 2027', 'Carenews', 'Carenews, 26 août 2026', '2026-08-26', 3, '2026-10-17'),
('frenchweb-2025-06-20', 'https://www.frenchweb.fr/jean-marc-jancovici-leve-33-millions-deuros-avec-le-shift-project-pour-imposer-la-decarbonation-dans-le-debat-de-2027/455625', 'Jean-Marc Jancovici lève 3,3 millions d''euros avec le Shift Project pour imposer la décarbonation dans le débat de 2027', 'FrenchWeb', 'FrenchWeb, 20 juin 2025', '2025-06-20', 3, '2026-10-17'),
('shifters-pref-2027', 'https://initiatives.theshifters.org/initiative/I20260405185057/', 'Portage du Plan robuste de l''économie française (PREF) - Présidentielles 2027', 'The Shifters', 'The Shifters', NULL, 4, '2026-10-17');

-- ---------------------------------------------------------------------
-- The Shift Project : organisation, dispositifs, chantiers
-- ---------------------------------------------------------------------
INSERT INTO organisation (slug, nom, presentation, demande, financement, financement_source_id, grille_dediee) VALUES
('the-shift-project', 'The Shift Project',
 'Think tank consacré à la transition bas-carbone, présidé par Jean-Marc Jancovici.',
 'Faire de la décarbonation une priorité politique et économique dès le prochain quinquennat, en menant de front une vingtaine de chantiers.',
 'Campagne de dons « Décarbonons la France ! » en 2025 : 3,3 millions d''euros auprès de plus de 26 000 contributeurs. Autres financements et inscription au répertoire de la HATVP à documenter.',
 (SELECT id FROM source WHERE cle = 'frenchweb-2025-06-20'), 1);

SET @shift := (SELECT id FROM organisation WHERE slug = 'the-shift-project');

INSERT INTO organisation_dispositif (organisation_id, periode, titre, description, ordre) VALUES
(@shift, '14 avril 2026 · livre de synthèse annoncé pour octobre 2026', 'Plan robuste pour l''économie française',
 'Premier volet, « Réussir la transition dans l''incertitude » : 20 chantiers et 5 leviers (énergies bas-carbone, électrification, sobriété, émissions hors combustion, puits de carbone). Objectif affiché : éclairer le débat à un an de la présidentielle.', 1),
(@shift, 'Septembre 2026 à février 2027', 'Assemblée citoyenne « Un commun accord »',
 'Lancée par Jean-Marc Jancovici : 150 citoyens tirés au sort par Toluna Harris Interactive, six week-ends de travail au Cnam. Les membres décideront eux-mêmes de présenter ou non leurs propositions aux candidats.', 2),
(@shift, '2025-2027', 'Réseau bénévole des Shifters',
 'Initiatives locales de portage du Plan robuste pendant la campagne. Suivi comme signal de veille.', 3);

INSERT INTO dispositif_source (dispositif_id, source_id, ordre)
SELECT d.id, s.id, 1 FROM organisation_dispositif d JOIN source s ON s.cle = 'shift-pref-2026-03-19' WHERE d.organisation_id = @shift AND d.ordre = 1
UNION ALL
SELECT d.id, s.id, 2 FROM organisation_dispositif d JOIN source s ON s.cle = 'shift-communique-2026-04-14' WHERE d.organisation_id = @shift AND d.ordre = 1
UNION ALL
SELECT d.id, s.id, 1 FROM organisation_dispositif d JOIN source s ON s.cle = 'carenews-2026-08-26' WHERE d.organisation_id = @shift AND d.ordre = 2
UNION ALL
SELECT d.id, s.id, 1 FROM organisation_dispositif d JOIN source s ON s.cle = 'shifters-pref-2027' WHERE d.organisation_id = @shift AND d.ordre = 3;

-- Le communiqué annonce 20 chantiers et en détaille 19 : ajouter le 20e dès sa publication.
INSERT INTO chantier (organisation_id, slug, libelle, domaine, theme_id, ordre) VALUES
(@shift, 'velo',        'Vélo',                                     'Transports',  13,  1),
(@shift, 'tc',          'Transports en commun',                     'Transports',  13,  2),
(@shift, 've',          'Voiture électrique sobre',                 'Transports',  13,  3),
(@shift, 'train',       'Train',                                    'Transports',  13,  4),
(@shift, 'aerien',      'Aérien décarboné',                         'Transports',  13,  5),
(@shift, 'fret',        'Fret ferroviaire',                         'Transports',  13,  6),
(@shift, 'camions',     'Camions électriques',                      'Transports',  13,  7),
(@shift, 'renov',       'Rénovation des logements',                 'Logement',     1,  8),
(@shift, 'pac',         'Pompes à chaleur',                         'Logement',     1,  9),
(@shift, 'datacenters', 'Maîtrise des centres de données',          'Numérique',   14, 10),
(@shift, 'acier',       'Acier bas-carbone',                        'Industrie',   12, 11),
(@shift, 'h2',          'Hydrogène bas-carbone',                    'Industrie',   12, 12),
(@shift, 'ccs',         'Captage et stockage du carbone',           'Industrie',   12, 13),
(@shift, 'elevage',     'Transformation de l''élevage bovin',       'Agriculture',  7, 14),
(@shift, 'azote',       'Gestion de l''azote (légumineuses)',       'Agriculture',  7, 15),
(@shift, 'puits',       'Puits de carbone naturels et forestiers',  'Agriculture',  7, 16),
(@shift, 'nucleaire',   'Nucléaire historique et EPR2',             'Énergie',      6, 17),
(@shift, 'enr',         'Solaire et éolien',                        'Énergie',      6, 18),
(@shift, 'bio',         'Bioénergies',                              'Énergie',      6, 19);

-- ---------------------------------------------------------------------
-- Variables pivots (proposition à valider au cadrage)
-- unite : suffixe affiché ; « 000 » affiche 400 en « 400 000 »
-- ---------------------------------------------------------------------
INSERT INTO variable (theme_id, slug, question, type, unite, borne_min, borne_max, graduations, chantier_id, ordre) VALUES
( 1, 'smic',                'Niveau du SMIC net mensuel proposé',                     'numerique',    ' €',      1300, 2000, '1400,1600,1800,2000', NULL, 1),
( 1, 'indexation-salaires', 'Indexation des salaires sur l''inflation',                'categorielle', NULL,      NULL, NULL, NULL, NULL, 2),
( 1, 'logements-neufs',     'Logements neufs par an',                                 'numerique',    ' 000',    200,  600,  '200,300,400,500,600', NULL, 3),
( 1, 'renovations',         'Rénovations performantes de logements par an',           'numerique',    ' 000',    0,    1000, '0,250,500,750,1000', (SELECT id FROM chantier WHERE organisation_id = @shift AND slug = 'renov'), 4),
( 2, 'deficit-annee',       'Année visée pour un déficit public sous 3 % du PIB',      'numerique',    NULL,      2027, 2035, '2027,2029,2031,2033,2035', NULL, 1),
( 2, 'prelevements',        'Évolution des prélèvements obligatoires',                 'categorielle', NULL,      NULL, NULL, NULL, NULL, 2),
( 2, 'patrimoine',          'Imposition du patrimoine',                                'categorielle', NULL,      NULL, NULL, NULL, NULL, 3),
( 3, 'age-legal',           'Âge légal de départ à la retraite',                       'numerique',    ' ans',    59,   66,   '60,62,64,66', NULL, 1),
( 3, 'duree-cotisation',    'Durée de cotisation pour une pension à taux plein',       'numerique',    ' ans',    40,   44,   '40,41,42,43,44', NULL, 2),
( 3, 'chomage-duree',       'Durée maximale d''indemnisation du chômage',              'numerique',    ' mois',   12,   36,   '12,18,24,30,36', NULL, 3),
( 4, 'installation-medecins','Installation des médecins',                              'categorielle', NULL,      NULL, NULL, NULL, NULL, 1),
( 4, 'ondam',               'Hausse annuelle des dépenses d''assurance maladie',       'numerique',    ' %',      0,    6,    '0,2,4,6', NULL, 2),
( 5, 'enseignants',         'Revalorisation des salaires des enseignants',             'numerique',    ' %',      0,    30,   '0,10,20,30', NULL, 1),
( 5, 'parcoursup',          'Avenir de Parcoursup',                                    'categorielle', NULL,      NULL, NULL, NULL, NULL, 2),
( 5, 'autonomie-etudiants', 'Aide à l''autonomie des étudiants',                       'categorielle', NULL,      NULL, NULL, NULL, NULL, 3),
( 6, 'reacteurs',           'Nouveaux réacteurs nucléaires à lancer',                  'numerique',    NULL,      0,    15,   '0,5,10,15', (SELECT id FROM chantier WHERE organisation_id = @shift AND slug = 'nucleaire'), 1),
( 6, 'renouvelables',       'Part des renouvelables visée dans l''électricité en 2035', 'numerique',   ' %',      20,   90,   '20,40,60,80', (SELECT id FROM chantier WHERE organisation_id = @shift AND slug = 'enr'), 2),
( 6, 'neutralite-carbone',  'Année visée pour la neutralité carbone',                  'categorielle', NULL,      NULL, NULL, NULL, NULL, 3),
( 7, 'libre-echange',       'Accords de libre-échange (dont Mercosur)',                'categorielle', NULL,      NULL, NULL, NULL, NULL, 1),
( 7, 'pesticides',          'Encadrement des pesticides',                              'categorielle', NULL,      NULL, NULL, NULL, NULL, 2),
( 7, 'elevage',             'Évolution de l''élevage',                                 'categorielle', NULL,      NULL, NULL, NULL, (SELECT id FROM chantier WHERE organisation_id = @shift AND slug = 'elevage'), 3),
( 8, 'forces-ordre',        'Policiers et gendarmes supplémentaires',                  'numerique',    ' 000',    0,    30,   '0,10,20,30', NULL, 1),
( 8, 'places-prison',       'Places de prison supplémentaires',                        'numerique',    ' 000',    0,    30,   '0,10,20,30', NULL, 2),
( 8, 'peines-minimales',    'Peines minimales',                                        'categorielle', NULL,      NULL, NULL, NULL, NULL, 3),
( 9, 'droit-du-sol',        'Droit du sol',                                            'categorielle', NULL,      NULL, NULL, NULL, NULL, 1),
( 9, 'ame',                 'Aide médicale de l''État',                                'categorielle', NULL,      NULL, NULL, NULL, NULL, 2),
( 9, 'referendum-immigration','Référendum sur l''immigration',                         'categorielle', NULL,      NULL, NULL, NULL, NULL, 3),
(10, 'defense',             'Effort de défense visé, en % du PIB',                     'numerique',    ' %',      2,    5,    '2,3,4,5', NULL, 1),
(10, 'traites',             'Évolution des traités européens',                         'categorielle', NULL,      NULL, NULL, NULL, NULL, 2),
(10, 'ukraine',             'Soutien à l''Ukraine',                                    'categorielle', NULL,      NULL, NULL, NULL, NULL, 3),
(11, 'mode-scrutin',        'Mode de scrutin aux élections législatives',              'categorielle', NULL,      NULL, NULL, NULL, NULL, 1),
(11, 'ric',                 'Référendum d''initiative citoyenne',                      'categorielle', NULL,      NULL, NULL, NULL, NULL, 2),
(11, 'vote-16-ans',         'Droit de vote à 16 ans',                                  'categorielle', NULL,      NULL, NULL, NULL, NULL, 3),
(12, 'impot-societes',      'Taux de l''impôt sur les sociétés',                       'numerique',    ' %',      15,   35,   '15,20,25,30,35', NULL, 1),
(12, 'industrie-bas-carbone','Soutien public à l''industrie bas-carbone',              'categorielle', NULL,      NULL, NULL, NULL, (SELECT id FROM chantier WHERE organisation_id = @shift AND slug = 'acier'), 2),
(13, 'ferroviaire',         'Investissement public annuel dans le ferroviaire',        'numerique',    ' Md€',    0,    12,   '0,4,8,12', (SELECT id FROM chantier WHERE organisation_id = @shift AND slug = 'train'), 1),
(13, 'voitures-thermiques', 'Fin de vente des voitures thermiques neuves',             'categorielle', NULL,      NULL, NULL, NULL, (SELECT id FROM chantier WHERE organisation_id = @shift AND slug = 've'), 2),
(13, 'transports-commun',   'Tarifs des transports en commun',                         'categorielle', NULL,      NULL, NULL, NULL, (SELECT id FROM chantier WHERE organisation_id = @shift AND slug = 'tc'), 3),
(14, 'encadrement-ia',      'Encadrement de l''intelligence artificielle',             'categorielle', NULL,      NULL, NULL, NULL, NULL, 1),
(14, 'centres-donnees',     'Nouveaux centres de données',                             'categorielle', NULL,      NULL, NULL, NULL, (SELECT id FROM chantier WHERE organisation_id = @shift AND slug = 'datacenters'), 2),
(14, 'cloud-souverain',     'Hébergement des données publiques',                       'categorielle', NULL,      NULL, NULL, NULL, NULL, 3);

-- ---------------------------------------------------------------------
-- Modalités des variables catégorielles
-- ---------------------------------------------------------------------
INSERT INTO modalite (variable_id, libelle, ordre)
SELECT v.id, m.libelle, m.ordre FROM variable v JOIN (
            SELECT 'indexation-salaires' AS slug, 'Indexer tous les salaires' AS libelle, 1 AS ordre
  UNION ALL SELECT 'indexation-salaires', 'Indexer les bas salaires', 2
  UNION ALL SELECT 'indexation-salaires', 'Pas d''indexation', 3
  UNION ALL SELECT 'prelevements', 'Hausse', 1
  UNION ALL SELECT 'prelevements', 'Stabilité', 2
  UNION ALL SELECT 'prelevements', 'Baisse', 3
  UNION ALL SELECT 'patrimoine', 'Rétablir un impôt sur la fortune', 1
  UNION ALL SELECT 'patrimoine', 'Taxer les très hauts patrimoines', 2
  UNION ALL SELECT 'patrimoine', 'Maintenir l''impôt sur la fortune immobilière', 3
  UNION ALL SELECT 'patrimoine', 'Supprimer l''impôt sur la fortune immobilière', 4
  UNION ALL SELECT 'installation-medecins', 'Réguler l''installation', 1
  UNION ALL SELECT 'installation-medecins', 'Inciter sans contraindre', 2
  UNION ALL SELECT 'installation-medecins', 'Liberté d''installation', 3
  UNION ALL SELECT 'parcoursup', 'Maintenir', 1
  UNION ALL SELECT 'parcoursup', 'Réformer', 2
  UNION ALL SELECT 'parcoursup', 'Supprimer', 3
  UNION ALL SELECT 'autonomie-etudiants', 'Allocation pour tous les étudiants', 1
  UNION ALL SELECT 'autonomie-etudiants', 'Bourses élargies', 2
  UNION ALL SELECT 'autonomie-etudiants', 'Système actuel', 3
  UNION ALL SELECT 'neutralite-carbone', '2040', 1
  UNION ALL SELECT 'neutralite-carbone', '2045', 2
  UNION ALL SELECT 'neutralite-carbone', '2050', 3
  UNION ALL SELECT 'neutralite-carbone', 'Année non précisée', 4
  UNION ALL SELECT 'libre-echange', 'Ratifier', 1
  UNION ALL SELECT 'libre-echange', 'Renégocier', 2
  UNION ALL SELECT 'libre-echange', 'Refuser', 3
  UNION ALL SELECT 'pesticides', 'Renforcer', 1
  UNION ALL SELECT 'pesticides', 'Maintenir', 2
  UNION ALL SELECT 'pesticides', 'Assouplir', 3
  UNION ALL SELECT 'elevage', 'Réduire le cheptel', 1
  UNION ALL SELECT 'elevage', 'Maintenir le cheptel', 2
  UNION ALL SELECT 'elevage', 'Accroître le cheptel', 3
  UNION ALL SELECT 'peines-minimales', 'Pour', 1
  UNION ALL SELECT 'peines-minimales', 'Contre', 2
  UNION ALL SELECT 'droit-du-sol', 'Maintenir', 1
  UNION ALL SELECT 'droit-du-sol', 'Restreindre', 2
  UNION ALL SELECT 'droit-du-sol', 'Supprimer', 3
  UNION ALL SELECT 'ame', 'Maintenir', 1
  UNION ALL SELECT 'ame', 'Limiter aux soins urgents', 2
  UNION ALL SELECT 'ame', 'Supprimer', 3
  UNION ALL SELECT 'referendum-immigration', 'Pour', 1
  UNION ALL SELECT 'referendum-immigration', 'Contre', 2
  UNION ALL SELECT 'traites', 'Approfondir l''intégration', 1
  UNION ALL SELECT 'traites', 'Pas de changement', 2
  UNION ALL SELECT 'traites', 'Réviser les traités', 3
  UNION ALL SELECT 'traites', 'Sortir de l''Union européenne', 4
  UNION ALL SELECT 'ukraine', 'Renforcer', 1
  UNION ALL SELECT 'ukraine', 'Maintenir', 2
  UNION ALL SELECT 'ukraine', 'Réduire', 3
  UNION ALL SELECT 'ukraine', 'Suspendre', 4
  UNION ALL SELECT 'mode-scrutin', 'Scrutin majoritaire actuel', 1
  UNION ALL SELECT 'mode-scrutin', 'Dose de proportionnelle', 2
  UNION ALL SELECT 'mode-scrutin', 'Proportionnelle intégrale', 3
  UNION ALL SELECT 'ric', 'Pour', 1
  UNION ALL SELECT 'ric', 'Contre', 2
  UNION ALL SELECT 'vote-16-ans', 'Pour', 1
  UNION ALL SELECT 'vote-16-ans', 'Contre', 2
  UNION ALL SELECT 'industrie-bas-carbone', 'Renforcer le soutien public', 1
  UNION ALL SELECT 'industrie-bas-carbone', 'Maintenir le soutien actuel', 2
  UNION ALL SELECT 'industrie-bas-carbone', 'Pas de soutien spécifique', 3
  UNION ALL SELECT 'voitures-thermiques', 'Maintenir l''échéance de 2035', 1
  UNION ALL SELECT 'voitures-thermiques', 'Reporter après 2035', 2
  UNION ALL SELECT 'voitures-thermiques', 'Abandonner l''échéance', 3
  UNION ALL SELECT 'transports-commun', 'Gratuité', 1
  UNION ALL SELECT 'transports-commun', 'Baisse des tarifs', 2
  UNION ALL SELECT 'transports-commun', 'Tarifs actuels', 3
  UNION ALL SELECT 'encadrement-ia', 'Aller au-delà du règlement européen', 1
  UNION ALL SELECT 'encadrement-ia', 'Appliquer le règlement européen', 2
  UNION ALL SELECT 'encadrement-ia', 'Assouplir les règles européennes', 3
  UNION ALL SELECT 'centres-donnees', 'Moratoire', 1
  UNION ALL SELECT 'centres-donnees', 'Encadrer leur consommation d''énergie et d''eau', 2
  UNION ALL SELECT 'centres-donnees', 'Aucune restriction', 3
  UNION ALL SELECT 'cloud-souverain', 'Imposer un hébergeur européen', 1
  UNION ALL SELECT 'cloud-souverain', 'Encourager un hébergeur européen', 2
  UNION ALL SELECT 'cloud-souverain', 'Libre choix', 3
) m ON m.slug = v.slug;
