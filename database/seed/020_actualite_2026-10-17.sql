-- =====================================================================
-- Repères 2027 · données sourcées au 17 octobre 2026
-- Candidatures déclarées, calendrier, digest de la semaine, sondage de
-- référence, et deux propositions de démonstration du circuit de validation.
-- À importer après database/seed/010_referentiels.sql.
-- =====================================================================

SET NAMES utf8mb4;

-- ---------------------------------------------------------------------
-- Sources
-- ---------------------------------------------------------------------
INSERT INTO source (cle, url, titre, editeur, libelle_court, date_publication, niveau, consultee_le) VALUES
('touteleurope-2026-10-14', 'https://www.touteleurope.eu/vie-politique-des-etats-membres/presidentielle-2027-qui-sont-les-candidats-deja-declares/', 'Présidentielle 2027 : qui sont les principaux candidats déjà déclarés ?', 'Toute l''Europe', 'Toute l''Europe', '2026-10-14', 3, '2026-10-17'),
('publicsenat-2026-10-14', 'https://www.publicsenat.fr/actualites/politique/election-presidentielle-2027-qui-sont-les-candidats-declares-ou-presque', 'Élection présidentielle 2027 : qui sont les candidats déclarés ou presque ?', 'Public Sénat', 'Public Sénat', '2026-10-14', 3, '2026-10-17'),
('publicsenat-2026-10-16', 'https://www.publicsenat.fr/actualites/politique/marine-le-pen-demande-la-demission-de-richard-ferrand-le-president-du-conseil-constitutionnel-est-il-vraiment-sorti-de-sa-reserve', 'Marine Le Pen demande la démission de Richard Ferrand : le président du Conseil constitutionnel est-il vraiment sorti de sa réserve ?', 'Public Sénat', 'Public Sénat', '2026-10-16', 3, '2026-10-17'),
('publicsenat-2026-10-12', 'https://www.publicsenat.fr/actualites/economie/presidentielle-2027-bruno-retailleau-sengage-sur-un-plan-deconomies-de-pres-de-200-milliards-deuros-sil-est-elu', 'Présidentielle 2027 : Bruno Retailleau s''engage sur un plan d''économies de près de 200 milliards d''euros, s''il est élu', 'Public Sénat', 'Public Sénat', '2026-10-12', 3, '2026-10-17'),
('lcp-2026-10-11', 'https://lcp.fr/actualites/primaire-socialiste-vainqueur-des-le-1er-tour-raphael-glucksmann-sera-le-candidat-de-la', 'Primaire socialiste : vainqueur dès le 1er tour, Raphaël Glucksmann sera le candidat de la gauche sociale-démocrate', 'LCP', 'LCP', '2026-10-11', 3, '2026-10-17'),
('lobs-2026-10-15', 'https://www.nouvelobs.com/politique/20261015.OBS119225/presidentielle-2027-quels-sont-les-31-candidats-actuellement-declares.html', 'Présidentielle 2027 : quels sont les 31 candidats actuellement déclarés ?', 'L''Obs', 'L''Obs', '2026-10-15', 3, '2026-10-17'),
('weka-2026-07-02', 'https://www.weka.fr/actualite/elus/article_juridique/parrainages-des-candidats-a-l-election-presidentielle-2027-quel-role-pour-les-elus-216318/', 'Parrainages des candidats à l''élection présidentielle 2027 : quel rôle pour les élus ?', 'Weka', 'Weka', '2026-07-02', 3, '2026-10-17'),
('ipsos-2026-09-13', 'https://www.ipsos.com/fr-fr/presidentielle-2027-le-point-7-mois-du-scrutin', 'Présidentielle 2027 : le point à 7 mois du scrutin', 'Ipsos bva', 'Ipsos bva', '2026-09-13', 4, '2026-10-17');

-- ---------------------------------------------------------------------
-- Candidatures déclarées (30 selon Toute l'Europe au 14 octobre 2026)
-- niveau = 'fiche' pour tous : passer à 'complet' selon le critère publié
-- (parti doté d'un groupe parlementaire ou 2 % de moyenne dans les trois
-- dernières enquêtes), une fois les seuils arbitrés.
-- ---------------------------------------------------------------------
SET @tle := (SELECT id FROM source WHERE cle = 'touteleurope-2026-10-14');

INSERT INTO candidat (slug, prenom, nom, parti, statut, designation, date_declaration, precision_date, hors_primaire, volet_judiciaire, mention, note, source_id) VALUES
('arthaud',       'Nathalie',  'Arthaud',       'Lutte ouvrière',               'declare',     'declaration', NULL,         'jour', 0, 0, NULL, NULL, @tle),
('asselineau',    'François',  'Asselineau',    'Union populaire républicaine', 'declare',     'declaration', NULL,         'jour', 0, 0, NULL, NULL, @tle),
('attal',         'Gabriel',   'Attal',         'Renaissance',                  'declare',     'declaration', '2026-05-22', 'jour', 0, 0, NULL, NULL, @tle),
('batho',         'Delphine',  'Batho',         'Génération Écologie',          'declare',     'declaration', NULL,         'jour', 0, 0, NULL, NULL, @tle),
('becht',         'Olivier',   'Becht',         NULL,                           'declare',     'declaration', '2026-09-24', 'jour', 0, 0, NULL, NULL, @tle),
('bertrand',      'Xavier',    'Bertrand',      'Les Républicains',             'declare',     'declaration', '2026-08-27', 'jour', 0, 0, NULL, 'Refuse de participer à une primaire.', @tle),
('bouamrane',     'Karim',     'Bouamrane',     'Parti socialiste',             'declare',     'declaration', NULL,         'jour', 1, 0, NULL, NULL, @tle),
('branco',        'Juan',      'Branco',        'Les Ruches',                   'declare',     'declaration', NULL,         'jour', 0, 0, NULL, NULL, @tle),
('cazeneuve',     'Bernard',   'Cazeneuve',     'La Convention',                'declare',     'declaration', NULL,         'jour', 1, 0, NULL, 'Candidature annoncée selon Toute l''Europe ; jugée « pressentie » par Public Sénat le 14 octobre 2026.', @tle),
('dupont-aignan', 'Nicolas',   'Dupont-Aignan', 'Debout la France',             'declare',     'declaration', NULL,         'jour', 0, 0, NULL, NULL, @tle),
('egger',         'Clara',     'Egger',         'Solution démocratique',        'declare',     'declaration', NULL,         'jour', 0, 0, NULL, NULL, @tle),
('glucksmann',    'Raphaël',   'Glucksmann',    'Place publique',               'declare',     'primaire',    '2026-10-11', 'jour', 0, 0, NULL, 'Vainqueur de la primaire organisée par le PS, Place publique et la Gauche républicaine et socialiste.', @tle),
('kazib',         'Anasse',    'Kazib',         'Révolution permanente',        'declare',     'declaration', NULL,         'jour', 0, 0, NULL, NULL, @tle),
('labib',         'Selma',     'Labib',         'NPA-Révolutionnaires',         'declare',     'declaration', NULL,         'jour', 0, 0, NULL, NULL, @tle),
('lalanne',       'Francis',   'Lalanne',       NULL,                           'declare',     'declaration', NULL,         'jour', 0, 0, NULL, NULL, @tle),
('le-pen',        'Marine',    'Le Pen',        'Rassemblement national',       'declare',     'declaration', '2026-07-07', 'jour', 0, 1, NULL, 'Condamnée en appel le 7 juillet 2026, pourvoi en cassation en cours ; éligible à ce stade selon Toute l''Europe.', @tle),
('lisnard',       'David',     'Lisnard',       'Nouvelle Énergie',             'declare',     'declaration', '2026-03-31', 'jour', 0, 0, NULL, NULL, @tle),
('markovic',      'Mira',      'Markovic',      'Parti animaliste',             'declare',     'declaration', NULL,         'jour', 0, 0, NULL, NULL, @tle),
('massard',       'Lydie',     'Massard',       'Union démocratique bretonne',  'declare',     'declaration', NULL,         'jour', 0, 0, NULL, NULL, @tle),
('mathieu',       'Benoît',    'Mathieu',       NULL,                           'declare',     'declaration', NULL,         'jour', 0, 0, NULL, NULL, @tle),
('melenchon',     'Jean-Luc',  'Mélenchon',     'La France insoumise',          'declare',     'declaration', '2026-05-03', 'jour', 0, 0, NULL, NULL, @tle),
('mikolajczak',   'Antoine',   'Mikolajczak',   'Équinoxe',                     'declare',     'declaration', NULL,         'jour', 0, 0, NULL, NULL, @tle),
('philippot',     'Florian',   'Philippot',     'Les Patriotes',                'declare',     'declaration', NULL,         'jour', 0, 0, NULL, NULL, @tle),
('philippe',      'Édouard',   'Philippe',      'Horizons',                     'declare',     'declaration', '2024-09-01', 'mois', 0, 0, NULL, NULL, @tle),
('polony',        'Natacha',   'Polony',        NULL,                           'declare',     'declaration', '2026-10-14', 'jour', 0, 0, NULL, NULL, @tle),
('retailleau',    'Bruno',     'Retailleau',    'Les Républicains',             'declare',     'parti',       '2026-04-19', 'jour', 0, 0, NULL, 'Désigné par les adhérents LR avec 73,8 % des voix.', @tle),
('roussel',       'Fabien',    'Roussel',       'Parti communiste français',    'declare',     'parti',       '2026-09-06', 'jour', 0, 0, NULL, 'Candidature validée par les adhérents.', @tle),
('ruffin',        'François',  'Ruffin',        'Debout !',                     'declare',     'declaration', NULL,         'jour', 0, 0, NULL, NULL, @tle),
('tondelier',     'Marine',    'Tondelier',     'Les Écologistes',              'a_confirmer', 'declaration', NULL,         'jour', 0, 0, NULL, 'Vote des militants prévu le 13 décembre 2026 (Public Sénat).', @tle),
('zemmour',       'Éric',      'Zemmour',       'Reconquête !',                 'declare',     'annonce',     '2026-09-17', 'jour', 0, 0, 'Déclaration formelle attendue', 'Candidature annoncée sur BFM TV ; déclaration formelle attendue selon Toute l''Europe.', @tle);

-- ---------------------------------------------------------------------
-- Calendrier
-- ---------------------------------------------------------------------
INSERT INTO calendrier_etape (date_cle, libelle_date, libelle_court, intitule, intitule_court, statut, societe_civile, source_id) VALUES
('2026-07-01', '1er juillet 2026', NULL, 'Dates du scrutin arrêtées en Conseil des ministres', NULL, 'fait', 0, (SELECT id FROM source WHERE cle = 'weka-2026-07-02')),
('2026-10-11', '11 octobre 2026', NULL, 'Primaire sociale-démocrate : Raphaël Glucksmann désigné', NULL, 'fait', 0, (SELECT id FROM source WHERE cle = 'lcp-2026-10-11')),
('2026-10-31', 'Octobre 2026', NULL, 'Livre de synthèse du Plan robuste pour l''économie française (The Shift Project)', NULL, 'annonce', 1, (SELECT id FROM source WHERE cle = 'shift-pref-2026-03-19')),
('2026-12-13', '13 décembre 2026', NULL, 'Vote des militants écologistes sur la candidature de Marine Tondelier', 'Vote des militants écologistes', 'annonce', 0, (SELECT id FROM source WHERE cle = 'publicsenat-2026-10-14')),
('2027-02-05', 'Début février 2027 au plus tard', 'Début févr.', 'Décret de convocation des électeurs et ouverture des parrainages', 'Ouverture des parrainages', 'calcule', 0, (SELECT id FROM source WHERE cle = 'weka-2026-07-02')),
('2027-02-28', 'Février 2027', NULL, 'Fin des travaux de l''assemblée citoyenne « Un commun accord » lancée par Jean-Marc Jancovici', NULL, 'annonce', 1, (SELECT id FROM source WHERE cle = 'carenews-2026-08-26')),
('2027-03-12', 'Vendredi 12 mars 2027, 18 h', NULL, 'Clôture du dépôt des parrainages', 'Clôture des parrainages', 'calcule', 0, (SELECT id FROM source WHERE cle = 'touteleurope-2026-10-14')),
('2027-03-26', 'Au plus tard le vendredi 26 mars 2027', NULL, 'Liste officielle des candidats, ordonnée par tirage au sort', 'Liste officielle', 'calcule', 0, (SELECT id FROM source WHERE cle = 'weka-2026-07-02')),
('2027-04-05', 'Lundi 5 avril 2027', NULL, 'Ouverture de la campagne officielle', NULL, 'calcule', 0, NULL),
('2027-04-16', 'Vendredi 16 avril 2027, 0 h', NULL, 'Gel des sondages sur ce site (la loi l''impose la veille et le jour du scrutin ; plusieurs outre-mer votent le samedi)', NULL, 'calcule', 0, NULL),
('2027-04-18', 'Dimanche 18 avril 2027', NULL, 'Premier tour (samedi 17 avril dans plusieurs outre-mer)', NULL, 'officiel', 0, (SELECT id FROM source WHERE cle = 'weka-2026-07-02')),
('2027-05-02', 'Dimanche 2 mai 2027', NULL, 'Second tour (samedi 1er mai dans plusieurs outre-mer)', NULL, 'officiel', 0, (SELECT id FROM source WHERE cle = 'weka-2026-07-02'));

-- ---------------------------------------------------------------------
-- Digest du 11 au 17 octobre 2026
-- ---------------------------------------------------------------------
INSERT INTO digest (debut, fin, publie) VALUES ('2026-10-11', '2026-10-17', 1);
SET @dg := (SELECT id FROM digest WHERE debut = '2026-10-11');

INSERT INTO evenement (date_evenement, type, titre, digest_id, etat, verifie_le, verifie_par) VALUES
('2026-10-16', 'institutions', 'Des parlementaires RN et UDR saisissent le Conseil constitutionnel pour demander la démission de son président, Richard Ferrand.', @dg, 'valide', '2026-10-17', 'SN'),
('2026-10-15', 'decompte', 'L''Obs recense 31 candidatures déclarées ; Toute l''Europe en compte 30. L''écart tient à la date et à la règle de décompte.', @dg, 'valide', '2026-10-17', 'SN'),
('2026-10-14', 'candidature', 'Natacha Polony annonce sa candidature sur France Inter.', @dg, 'valide', '2026-10-17', 'SN'),
('2026-10-12', 'programme', 'Bruno Retailleau présente un plan de 197 milliards d''euros d''économies et vise un déficit public sous 3 % du PIB en 2031.', @dg, 'valide', '2026-10-17', 'SN'),
('2026-10-11', 'primaire', 'Raphaël Glucksmann remporte dès le premier tour la primaire sociale-démocrate (PS, Place publique, GRS), avec plus de 66 % des voix.', @dg, 'valide', '2026-10-17', 'SN');

INSERT INTO evenement_source (evenement_id, source_id, ordre)
SELECT e.id, s.id, 1 FROM evenement e JOIN source s ON s.cle = 'publicsenat-2026-10-16' WHERE e.date_evenement = '2026-10-16' AND e.digest_id = @dg
UNION ALL SELECT e.id, s.id, 1 FROM evenement e JOIN source s ON s.cle = 'lobs-2026-10-15'        WHERE e.date_evenement = '2026-10-15' AND e.digest_id = @dg
UNION ALL SELECT e.id, s.id, 2 FROM evenement e JOIN source s ON s.cle = 'touteleurope-2026-10-14' WHERE e.date_evenement = '2026-10-15' AND e.digest_id = @dg
UNION ALL SELECT e.id, s.id, 1 FROM evenement e JOIN source s ON s.cle = 'publicsenat-2026-10-14' WHERE e.date_evenement = '2026-10-14' AND e.digest_id = @dg
UNION ALL SELECT e.id, s.id, 1 FROM evenement e JOIN source s ON s.cle = 'publicsenat-2026-10-12' WHERE e.date_evenement = '2026-10-12' AND e.digest_id = @dg
UNION ALL SELECT e.id, s.id, 1 FROM evenement e JOIN source s ON s.cle = 'lcp-2026-10-11'         WHERE e.date_evenement = '2026-10-11' AND e.digest_id = @dg
UNION ALL SELECT e.id, s.id, 2 FROM evenement e JOIN source s ON s.cle = 'touteleurope-2026-10-14' WHERE e.date_evenement = '2026-10-11' AND e.digest_id = @dg;

INSERT INTO evenement_candidat (evenement_id, candidat_id)
SELECT e.id, c.id FROM evenement e JOIN candidat c ON c.slug = 'polony'     WHERE e.date_evenement = '2026-10-14' AND e.digest_id = @dg
UNION ALL SELECT e.id, c.id FROM evenement e JOIN candidat c ON c.slug = 'retailleau' WHERE e.date_evenement = '2026-10-12' AND e.digest_id = @dg
UNION ALL SELECT e.id, c.id FROM evenement e JOIN candidat c ON c.slug = 'glucksmann' WHERE e.date_evenement = '2026-10-11' AND e.digest_id = @dg;

-- ---------------------------------------------------------------------
-- Sondage de référence : Enquête électorale française, vague de septembre 2026
-- ---------------------------------------------------------------------
INSERT INTO sondage (institut, commanditaires, terrain_debut, terrain_fin, echantillon, population, tour, lecture, note, source_id, etat) VALUES
('Ipsos bva-CESI École d''ingénieurs', 'le CEVIPOF, la Fondation Jean-Jaurès, l''Institut Montaigne et Le Monde', '2026-09-03', '2026-09-09', 13060, 'personnes inscrites sur les listes électorales', 1,
 'Chaque barre va du score le plus bas au plus haut obtenu selon les hypothèses de candidatures testées. Ce n''est pas une marge d''erreur.',
 'Enquête antérieure à la primaire du 11 octobre.', (SELECT id FROM source WHERE cle = 'ipsos-2026-09-13'), 'valide');

SET @sd := LAST_INSERT_ID();
INSERT INTO sondage_resultat (sondage_id, candidat_id, valeur_min, valeur_max)
SELECT @sd, id, 6.0,  15.5 FROM candidat WHERE slug = 'attal'
UNION ALL SELECT @sd, id, 11.5, 13.5 FROM candidat WHERE slug = 'glucksmann'
UNION ALL SELECT @sd, id, 33.0, 35.0 FROM candidat WHERE slug = 'le-pen'
UNION ALL SELECT @sd, id, 15.5, 17.0 FROM candidat WHERE slug = 'melenchon'
UNION ALL SELECT @sd, id, 14.0, 21.0 FROM candidat WHERE slug = 'philippe'
UNION ALL SELECT @sd, id, 7.0,  10.5 FROM candidat WHERE slug = 'retailleau';

-- ---------------------------------------------------------------------
-- Circuit de validation : deux propositions et une position saisies
-- « à valider ». Elles ne sont pas publiées tant qu'une relecture humaine
-- ne les passe pas à « valide » (voir docs/saisie.md).
-- ---------------------------------------------------------------------
SET @ret := (SELECT id FROM candidat WHERE slug = 'retailleau');
SET @src := (SELECT id FROM source WHERE cle = 'publicsenat-2026-10-12');

INSERT INTO proposition (code, candidat_id, theme_id, intitule, precisions, type, variable_id, statut_proposition, mesure_phare, source_id, etat) VALUES
('P-RET-001', @ret, 2, 'Réaliser 197 milliards d''euros d''économies sur les dépenses publiques',
 'Dont 56 milliards d''euros redirigés vers des baisses d''impôts pour les entreprises et les ménages ; effort porté principalement par l''État et les dépenses sociales.',
 'chiffree', NULL, 'declaration', 1, @src, 'a_valider'),
('P-RET-002', @ret, 2, 'Ramener le déficit public sous 3 % du PIB en 2031', NULL,
 'chiffree', (SELECT id FROM variable WHERE slug = 'deficit-annee'), 'declaration', 1, @src, 'a_valider');

INSERT INTO position_candidat (candidat_id, variable_id, valeur_num, statut_position, source_id, extrait, etat) VALUES
(@ret, (SELECT id FROM variable WHERE slug = 'deficit-annee'), 2031, 'declaration', @src, 'Objectif de ramener le déficit sous les 3 % du PIB en 2031', 'a_valider');
