-- =====================================================================
-- Repères 2027 · nuance politique des 30 candidatures déclarées, 4 novembre 2026
-- Référence : grille des nuances du ministère de l'Intérieur (municipales 2026),
-- https://www.resultats-elections.interieur.gouv.fr/municipales2026/referentiel.html
-- Règle : la nuance suit le parti du candidat. Un parti qui a sa propre nuance
-- dans la grille la reçoit ; un parti hors grille reçoit la nuance « divers »
-- de sa famille (divers gauche, divers centre, divers droite), ou sa catégorie
-- (écologiste, régionaliste, droite souverainiste, extrême gauche) ; sans parti
-- ni rattachement établi : DIV, affiché hors de l'axe.
-- À importer après database/migrations/005_nuances.sql. Rejouable.
-- =====================================================================

SET NAMES utf8mb4;

-- Nuances propres à un parti, nommé dans la grille
UPDATE candidat SET nuance = 'FI',  nuance_motif = 'La France insoumise : nuance propre dans la grille' WHERE slug = 'melenchon';
UPDATE candidat SET nuance = 'COM', nuance_motif = 'Parti communiste français : nuance propre dans la grille' WHERE slug = 'roussel';
UPDATE candidat SET nuance = 'SOC', nuance_motif = 'Parti socialiste : nuance propre dans la grille' WHERE slug = 'bouamrane';
UPDATE candidat SET nuance = 'VEC', nuance_motif = 'Les Écologistes : nuance propre dans la grille' WHERE slug = 'tondelier';
UPDATE candidat SET nuance = 'REN', nuance_motif = 'Renaissance : nuance propre dans la grille' WHERE slug = 'attal';
UPDATE candidat SET nuance = 'HOR', nuance_motif = 'Horizons : nuance propre dans la grille' WHERE slug = 'philippe';
UPDATE candidat SET nuance = 'LR',  nuance_motif = 'Les Républicains : nuance propre dans la grille' WHERE slug IN ('bertrand', 'retailleau');
UPDATE candidat SET nuance = 'RN',  nuance_motif = 'Rassemblement national : nuance propre dans la grille' WHERE slug = 'le-pen';
UPDATE candidat SET nuance = 'REC', nuance_motif = 'Reconquête ! : nuance propre dans la grille' WHERE slug = 'zemmour';

-- Catégories de la grille
UPDATE candidat SET nuance = 'EXG', nuance_motif = 'Lutte ouvrière : extrême gauche' WHERE slug = 'arthaud';
UPDATE candidat SET nuance = 'EXG', nuance_motif = 'Révolution permanente, parti trotskiste : extrême gauche' WHERE slug = 'kazib';
UPDATE candidat SET nuance = 'EXG', nuance_motif = 'NPA-Révolutionnaires : extrême gauche' WHERE slug = 'labib';
UPDATE candidat SET nuance = 'UG',  nuance_motif = 'Candidat commun du PS, de Place publique et de la GRS (primaire du 11 octobre 2026) : union à gauche' WHERE slug = 'glucksmann';
UPDATE candidat SET nuance = 'DVG', nuance_motif = 'Debout !, mouvement de gauche hors grille : divers gauche' WHERE slug = 'ruffin';
UPDATE candidat SET nuance = 'DVG', nuance_motif = 'La Convention, mouvement de gauche hors grille : divers gauche' WHERE slug = 'cazeneuve';
UPDATE candidat SET nuance = 'ECO', nuance_motif = 'Génération écologie : écologiste, hors Les Écologistes' WHERE slug = 'batho';
UPDATE candidat SET nuance = 'REG', nuance_motif = 'Union démocratique bretonne : régionaliste' WHERE slug = 'massard';
UPDATE candidat SET nuance = 'DVC', nuance_motif = 'Sans parti, ancien ministre des gouvernements Borne et Attal : divers centre' WHERE slug = 'becht';
UPDATE candidat SET nuance = 'DVD', nuance_motif = 'Nouvelle Énergie, parti de droite hors grille : divers droite' WHERE slug = 'lisnard';
UPDATE candidat SET nuance = 'DSV', nuance_motif = 'Debout la France : droite souverainiste' WHERE slug = 'dupont-aignan';
UPDATE candidat SET nuance = 'DSV', nuance_motif = 'Les Patriotes : droite souverainiste' WHERE slug = 'philippot';
UPDATE candidat SET nuance = 'DSV', nuance_motif = 'Union populaire républicaine, parti souverainiste : droite souverainiste' WHERE slug = 'asselineau';

-- Divers ou sans étiquette : affichés hors de l'axe
UPDATE candidat SET nuance = 'DIV', nuance_motif = 'Parti animaliste : hors grille, sans rattachement à une famille' WHERE slug = 'markovic';
UPDATE candidat SET nuance = 'DIV', nuance_motif = 'Les Ruches : hors grille, sans rattachement établi' WHERE slug = 'branco';
UPDATE candidat SET nuance = 'DIV', nuance_motif = 'Solution démocratique : hors grille, sans rattachement établi' WHERE slug = 'egger';
UPDATE candidat SET nuance = 'DIV', nuance_motif = 'Équinoxe : hors grille, sans rattachement établi' WHERE slug = 'mikolajczak';
UPDATE candidat SET nuance = 'DIV', nuance_motif = 'Sans parti indiqué' WHERE slug IN ('lalanne', 'mathieu', 'polony');

-- Contrôle : chaque candidature déclarée a une nuance
SELECT nuance, COUNT(*) AS candidatures, GROUP_CONCAT(slug ORDER BY nom SEPARATOR ', ') AS slugs
FROM candidat WHERE statut IN ('declare', 'a_confirmer', 'officiel')
GROUP BY nuance ORDER BY nuance;
