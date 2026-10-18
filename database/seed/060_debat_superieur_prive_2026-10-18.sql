-- =====================================================================
-- Repères 2027 · débat enseignement supérieur, 18 octobre 2026
-- Remplace le débat sur les groupes de niveau (retiré, conservé pour l'historique)
-- par un débat sur la régulation de l'enseignement supérieur privé.
-- À importer après database/seed/050_culture_education_2026-10-18.sql.
-- =====================================================================

SET NAMES utf8mb4;

UPDATE debat SET etat = 'retire' WHERE slug = 'groupes-de-niveau';

INSERT INTO source (cle, url, titre, editeur, libelle_court, date_publication, niveau, consultee_le) VALUES
('bdt-2026-06-senat-prive', 'https://www.banquedesterritoires.fr/le-senat-adopte-un-projet-de-loi-pour-mieux-reguler-lenseignement-superieur-prive', 'Le Sénat adopte un projet de loi pour mieux réguler l''enseignement supérieur privé', 'Banque des territoires (Localtis)', 'Localtis', '2026-06-02', 3, '2026-10-18'),
('an-dossier-prive-2026', 'https://www.assemblee-nationale.fr/dyn/17/dossiers/regulation_enseignement_superieur_prive_2026', 'Projet de loi relatif à la régulation de l''enseignement supérieur privé (dossier législatif)', 'Assemblée nationale', 'Assemblée nationale', '2026-06-02', 1, '2026-10-18'),
('cfdt-2026-04-02-prive', 'https://sgen-cfdt.fr/contenu/uploads/2026/04/20260402-Communique-de-presse-Enseignement-superieur-prive-il-y-a-urgence-a-legiferer.pdf', 'Enseignement supérieur privé : il y a urgence à légiférer (communiqué)', 'Sgen-CFDT et Fep-CFDT', 'Sgen-CFDT', '2026-04-02', 4, '2026-10-18'),
('publicsenat-2026-06-01-prive', 'https://www.publicsenat.fr/actualites/politique/parcoursup-apprentissage-que-contient-le-projet-de-regulation-de-lenseignement-superieur-prive-examine-ce-lundi-par-le-senat', 'Parcoursup, apprentissage : que contient le projet de régulation de l''enseignement supérieur privé examiné ce lundi par le Sénat', 'Public Sénat', 'Public Sénat', '2026-06-01', 3, '2026-10-18'),
('educpros-2026-04-07-ugei', 'https://www.letudiant.fr/educpros/actualite/l-ugei-prend-la-parole-pour-defendre-la-qualite-de-l-enseignement-superieur-prive.html', 'L''UGEI prend la parole pour défendre la qualité de l''enseignement supérieur privé', 'L''Étudiant (EducPros)', 'EducPros', '2026-04-07', 3, '2026-10-18');

INSERT INTO debat (slug, theme_id, variable_id, chantier_id, proposition, nom_court, contexte, contexte_source_id, chiffre, chiffre_libelle, chiffre_source_id, ordre, etat, verifie_le, verifie_par) VALUES
('enseignement-superieur-prive', 5, NULL, NULL,
 'Soumettre les écoles privées à un agrément de l''État pour figurer sur Parcoursup', 'Supérieur privé',
 'Un projet de loi crée un agrément de l''État pour les établissements privés, condition pour figurer sur Parcoursup, et un « agrément d''intérêt général » réservé aux établissements à but non lucratif. Adopté par le Sénat le 1er juin 2026, il a été transmis à l''Assemblée nationale.',
 (SELECT id FROM source WHERE cle = 'bdt-2026-06-senat-prive'),
 '790 000', 'étudiants dans l''enseignement supérieur privé en 2023, contre 490 000 en 2015 : plus d''un quart des effectifs', (SELECT id FROM source WHERE cle = 'bdt-2026-06-senat-prive'),
 8, 'valide', '2026-10-18', 'redaction');
INSERT INTO debat_argument (debat_id, sens, texte, porteur, source_id, ordre, etat) VALUES
((SELECT id FROM debat WHERE slug = 'enseignement-superieur-prive'), 'pour', 'Le secteur mêle établissements d''excellence et « simples officines commerciales », une « confusion préjudiciable aux étudiants et à leurs familles » : il faut des règles de qualité et de transparence.', 'Philippe Baptiste, ministre de l''Enseignement supérieur, au Sénat (juin 2026)', (SELECT id FROM source WHERE cle = 'bdt-2026-06-senat-prive'), 1, 'valide'),
((SELECT id FROM debat WHERE slug = 'enseignement-superieur-prive'), 'pour', 'Il y a urgence à légiférer pour « mieux protéger les étudiantes et étudiants », « contrôler le bon emploi des fonds publics » et garantir la qualité des formations.', 'Fédérations CFDT de l''éducation (Sgen-CFDT, Fep-CFDT)', (SELECT id FROM source WHERE cle = 'cfdt-2026-04-02-prive'), 2, 'valide'),
((SELECT id FROM debat WHERE slug = 'enseignement-superieur-prive'), 'pour', 'Sur Parcoursup ne figureraient que « les formations auxquelles l''État aura donné une confiance » ; la Conférence des grandes écoles soutient le texte et voudrait aller plus loin hors Parcoursup.', 'Stéphane Piednoir, rapporteur au Sénat, et Conférence des grandes écoles', (SELECT id FROM source WHERE cle = 'publicsenat-2026-06-01-prive'), 3, 'valide'),
((SELECT id FROM debat WHERE slug = 'enseignement-superieur-prive'), 'contre', 'Un agrément facultatif risque de ne toucher que les écoles déjà encadrées : les officines visées, qui mettent en avant leur absence de Parcoursup, ne le demanderont pas.', 'Yan Chantrel, sénateur socialiste, et commission de la culture du Sénat', (SELECT id FROM source WHERE cle = 'bdt-2026-06-senat-prive'), 1, 'valide'),
((SELECT id FROM debat WHERE slug = 'enseignement-superieur-prive'), 'contre', 'Réunir public et privé dans une même loi crée un risque d''amalgame ; des catégories comme « partenaire » ou « agréée » pourraient « masquer la qualité des écoles ».', 'Union des grandes écoles indépendantes (UGEI)', (SELECT id FROM source WHERE cle = 'educpros-2026-04-07-ugei'), 2, 'valide'),
((SELECT id FROM debat WHERE slug = 'enseignement-superieur-prive'), 'contre', 'Plusieurs groupes privés doutent de l''intérêt d''entrer sur Parcoursup et contestent le droit de rétractation des étudiants jusqu''à un mois avant la rentrée.', 'Groupes d''enseignement supérieur privé', (SELECT id FROM source WHERE cle = 'publicsenat-2026-06-01-prive'), 3, 'valide');
