# Modèle de données

MySQL est la source de vérité. Le site public ne lit jamais la base : il lit `data/site.json`, produit par `app/lib/export.php`. Seules les lignes à l'état `valide` et sourcées sont exportées.

## Tables

### Référentiels

| Table | Rôle | Points d'attention |
| --- | --- | --- |
| `parametre` | réglages clé/valeur : `phase`, dates des tours, `liste_officielle`, `empreinte_min`, `chiffre_note` | `phase` pilote l'affichage : `declares`, `officiels`, `entre_deux_tours` |
| `source` | toute référence citée sur le site | `cle` unique et lisible ; `niveau` de 1 (texte officiel) à 5 (presse d'opinion) |
| `theme` | les 15 thèmes communs | identifiants fixes ; `a_la_une` = Environnement (6), Transports (13), Numérique et IA (14) |
| `variable` | variables pivots d'un thème, au plus 3 | `numerique` (bornes, unité, graduations) ou `categorielle` ; `chantier_id` relie une variable à un chantier du Shift Project |
| `modalite` | options d'une variable catégorielle | ordre d'affichage par `ordre` |

### Candidatures et propositions

| Table | Rôle | Points d'attention |
| --- | --- | --- |
| `candidat` | une candidature | `date_naissance` (affichage de l'âge), `bio` (deux phrases au même gabarit, publiée seulement avec `bio_source_id`), `bio_verifie_le` ; `statut` : `declare`, `a_confirmer`, `officiel`, `retire`, `non_retenu`, `qualifie_t2` ; `niveau = 'complet'` l'ouvre au comparateur en phase 1 ; `source_id` obligatoire |
| `position_candidat` | position d'un candidat sur une variable pivot | une ligne par couple candidat × variable ; `non_aborde = 1` distingue « Non abordé » de « À documenter » (ligne absente) |
| `proposition` | une mesure, codée `P-XXX-NNN` | intitulé de 160 caractères au plus ; `mesure_phare` (3 au plus par thème) ; `chantier_id` pour la pastille Shift ; `version_precedente_id` garde l'historique d'une mesure modifiée |

### Actualité

| Table | Rôle | Points d'attention |
| --- | --- | --- |
| `digest` | une semaine de veille | `publie = 1` pour l'afficher ; seul le plus récent publié est exporté |
| `evenement` | un fait daté | `type` : candidature, programme, sondage, institutions, décompte, société civile… ; 5 faits au plus par digest ; `axe` (1 à 8) et `portee` (`course`, `engagement`, `signal`) placent le fait sur le radar, NULL = règle par défaut selon le type |
| `evenement_source`, `evenement_candidat` | liens d'un fait vers ses sources et candidats | un fait sans source n'est pas publié |
| `sondage`, `sondage_resultat` | enquêtes d'intentions de vote | résultats en fourchette `valeur_min` / `valeur_max` ; mentions obligatoires (institut, commanditaire, échantillon, marge) |
| `calendrier_etape` | jalons de la campagne | `statut` : `officiel`, `fait`, `annonce`, `calcule` ; `societe_civile = 1` pour les étapes hors institutions ; `axe` et `portee` pour le radar (NULL = axe 2 et `course`, ou axe 8 et `signal` pour la société civile) |

### Débats

| Table | Rôle | Points d'attention |
| --- | --- | --- |
| `debat` | une mesure débattue | `proposition` à l'infinitif (« pour » = soutenir la mesure) ; `nom_court` sert aux boutons, au radar et à la matrice ; contexte et chiffre sourcés ; liens facultatifs vers une variable pivot et un chantier du Shift Project |
| `debat_argument` | un argument pour ou contre | `porteur` : qui l'avance ; source obligatoire ; autant d'arguments de chaque côté (alerte sinon) |
| `debat_position` | position d'un candidat | `echelle` de −2 (contre) à +2 (pour), 0 = nuancé ; `non_aborde = 1` pour une absence vérifiée ; citation et source obligatoires sinon ; publiée seulement pour les candidats du comparateur |

### The Shift Project

| Table | Rôle | Points d'attention |
| --- | --- | --- |
| `organisation` | organisation suivie | `grille_dediee = 1` ouvre la section dédiée (The Shift Project) |
| `organisation_dispositif`, `dispositif_source` | actions de plaidoyer (propositions, consultation des Shifters, communiqués) | chaque dispositif est sourcé |
| `chantier` | les 19 chantiers de la grille | `slug` court (`train`, `nucleaire`, `datacenters`…) ; `chapitre_id` : chapitre du livre qui le traite (rattachement choisi par le site) |
| `livre_chapitre` | chapitres du livre de l'organisation (migration 004) | `numero`, `titre`, `page`, `partie` et `partie_titre`, `theme_id` (thème du comparateur le plus proche, ou NULL), `source_id` (le livre) |
| `correspondance` | position d'un candidat sur un chantier | `etat_chantier` : `repris`, `en_partie`, `oppose`, `non_aborde` ; source obligatoire pour être publiée |

### Traçabilité

| Table | Rôle |
| --- | --- |
| `publication` | une ligne par génération de `site.json` : déclencheur, empreinte, statistiques, alertes |
| `signalement` | erreurs signalées par les lecteurs |
| `erratum` | corrections publiées |
| `journal` | historique des modifications, alimenté par les déclencheurs facultatifs |
| `schema_version` | version du schéma appliquée |

## Contrat JSON (`data/site.json`, version 1)

| Clé | Contenu |
| --- | --- |
| `meta` | `version`, `genere_le`, `maj`, dates des tours, `liste_officielle`, `phase`, `demo`, `chiffre_note`, `empreinte_min`, `empreinte` (SHA-256 des données) |
| `semaine` | `periode` et `faits[]` : `d` date, `ty` type, `tag` libellé du type, `axe` (1 à 8) et `por` portée (`course`, `engagement`, `signal`) pour le radar, `t` texte, `src` liste de couples [libellé, URL] |
| `phases` | les 3 phases : `n` nom, `from`, `to`, `d` description |
| `calendrier` | `d` date, `l` libellé de date, `lc` libellé court, `t` intitulé, `court` intitulé court, `s` statut, `soc` société civile, `axe` et `por` pour le radar, `src` |
| `candidats` | `id`, `p` prénom, `n` nom, `parti`, `nu` nuance et `nuM` motif (échiquier), `st` statut (`declare`, `a_confirmer`, `officiel`…), `d` date de déclaration, `dp` précision, `dk` type de désignation, `b` badges, `f` points d'attention, `note`, `prog` programme, `nb` nombre de propositions, `cmp` présent au comparateur, `src`, `nai` date de naissance, `bio`, `bioSrc` source de la biographie |
| `comparateur` | `candidats[]` : `id`, `nom`, `court` |
| `themes` | `id`, `slug`, `n` nom, `c` nom court, `une`, `pivots`, `vars[]` (`slug`, `q` question, `type` num ou cat, `v` valeurs par candidat, `src`, `shift`, et `unit`/`min`/`max`/`ticks` ou `mods`), `r` scores radar et `mesures` lorsqu'il y a des données |
| `empreinte` | répartition des propositions par thème, publiée à partir de `empreinte_min` propositions |
| `sondage` | `rows`, `mentions`, `lecture`, `url`, `notice` |
| `debats` | `echelle` (5 crans, libellés) et `liste[]` : `id`, `th` thème, `q` mesure, `c` nom court, `ctx`, `ctxSrc`, `chiffre` (`v`, `l`, `src`), `var`, `shift`, `pour[]` et `contre[]` (`t`, `qui`, `src`), `pos` par candidat (`e` cran, `cit`, `src`, ou `na`) |
| `shift` | `nom`, `qui`, `demande`, `finance`, `financeSrc`, `hatvp`, `dispositifs`, `livre` (`t`, `ed`, `d`, `src`), `chapitres[]` (`n` numéro, `t` titre, `p` page, `pa` partie, `pat` titre de la partie, `th` thème), `chantiers[]` (`id`, `l`, `dom` domaine, `th` thème, `chap` numéro de chapitre), `etats`, `src` |

## Contrat JSON du quiz (`data/quiz-2022.json`, version 1)

Fichier versionné dans le dépôt, hors base, contrôlé par `outils/quiz/verifier.mjs` à chaque push. Chargé par la page à la première ouverture de l'onglet Quiz ; les réponses des visiteurs ne quittent pas leur navigateur.

| Clé | Contenu |
| --- | --- |
| `version`, `edition`, `titre`, `maj`, `presentation` | identification de l'édition (2022 : candidats du premier tour de 2022) |
| `echelle` | 5 crans de −2 à 2 : `rep` libellé de réponse du visiteur, `pos` libellé de la position d'un candidat |
| `importance` | `k`, `l` libellé, `w` poids (0,5 ; 1 ; 2) |
| `candidats` | `id`, `p` prénom, `n` nom, `parti`, dans l'ordre officiel du premier tour |
| `sources` | par clé : `e` éditeur, `t` titre exact, `d` date (AAAA-MM-JJ ou AAAA-MM), `u` URL |
| `questions[]` | `id`, `th` thème (1 à 15), `q` affirmation à l'infinitif, `court` (une par thème, version courte), `pos` par candidat : `e` cran, `x` position relevée, `src` clé de source ; ou `na: true` (absence de proposition constatée par la source) |

Contrôles : une affirmation au moins par thème, exactement une en version courte par thème, trois positions documentées au moins par affirmation, toute position sourcée, aucune source inutilisée.

Les portraits ne passent pas par la base : `public/photos/<id>.webp` et `public/photos/credits.json` (auteur, licence, page Commons) sont produits par le workflow « Photos des candidats » à partir de `outils/photos/candidats.json`.

Toute évolution incompatible du contrat incrémente `meta.version` ; `public/assets/app.js` et `outils/demo.mjs` sont à mettre à jour dans le même commit.

## Règles appliquées à l'export

- Une ligne `valide` sans source n'est pas publiée et produit une alerte.
- Plus de trois mesures phares par candidat et par thème, ou plus de cinq faits dans le digest : alerte.
- Vérification de plus de 30 jours sur une position : alerte.
- `site.json` n'est réécrit que si l'empreinte des données change ; l'écriture est atomique (fichier temporaire puis renommage).

## Radar de la semaine

| Axe | Domaine | Types de faits rangés par défaut |
| --- | --- | --- |
| 1 | Candidatures | candidature, retrait, ralliement (portée `course`) ; primaire, décompte, autre (`signal`) |
| 2 | Règles et calendrier | institutions, calendrier (`signal`) ; échéances du calendrier (`course`) |
| 3 | Programmes | programme (`engagement`) |
| 4 | Opinion | sondage (`signal`) |
| 5 | Débats de fond | debat (`engagement`) |
| 6 | Justice et financement | justice (`signal`) |
| 7 | Médias et numérique | aucun type par défaut : saisir `axe = 7` |
| 8 | Société civile | societe_civile (`signal`) ; échéances `societe_civile = 1` (`signal`) |

Portée : `course` = modifie le champ des candidatures ou les règles du scrutin (centre) ; `engagement` = engagement pris par un candidat (milieu) ; `signal` = à suivre (bord). Une valeur saisie dans `axe` ou `portee` prime sur la règle par défaut, par exemple une primaire dont le résultat désigne un candidat (`axe = 1`, `portee = 'course'`). Le radar place les faits du dernier digest publié (points pleins) et les cinq prochaines échéances du calendrier (points creux).

## Échiquier politique

La colonne `candidat.nuance` (migration 005) reprend les codes de la grille des nuances du ministère de l'Intérieur (municipales 2026), dans leur ordre, de l'extrême gauche à l'extrême droite : `EXG`, `FI`, `COM`, `SOC`, `VEC`, `UG`, `DVG`, `ECO`, `REG`, `DIV`, `REN`, `MDM`, `HOR`, `UDI`, `UC`, `DVC`, `LR`, `UD`, `DVD`, `DSV`, `UDR`, `RN`, `REC`, `UXD`, `EXD`. L'ordre de l'ENUM est l'ordre d'affichage. `nuance_motif` dit pourquoi : parti doté d'une nuance propre, ou règle appliquée à un parti hors grille. `DIV` et `NULL` sont affichés hors de l'axe ; une candidature sans nuance déclenche une alerte à l'export.

