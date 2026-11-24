# Veille Repères 2027 · semaine du 15 au 21 novembre 2026

Préparée le mardi 24 novembre 2026 par Claude avec le prompt `docs/prompt-veille.md`, en deux temps à la demande de Sébastien Noguès : une veille indépendante, puis l'analyse et la consolidation de la veille S48 déposée le même jour par ChatGPT sur la branche `veille/2026-11-28` (section 7). Chaque élément retenu a été lu sur sa source le 24 novembre.

Digest : du dimanche 15 au samedi 21 novembre 2026, dernière semaine complète et dernière semaine non publiée. Autres mises à jour : tout ce qui est paru depuis la veille du 8 au 14 novembre, jusqu'au 24 novembre.

État de départ : le site en ligne n'est pas lisible depuis l'environnement de cette veille. L'état de référence est celui des traces d'import du dépôt : publication du 16 novembre (`database/veille/2026-11-14/publication.json`), digest du 8 au 14 novembre, enquête Elabe de référence, 31 candidatures. La base locale de test a été reconstruite à l'identique à partir des migrations, des seeds et des trois dernières veilles.

## 1. Synthèse

- Deux changements de candidatures : Dominique de Villepin se déclare le 20 novembre, avec un programme de 258 propositions ; François Ruffin se retire le 21 sans soutenir personne. La base reste à 31 candidatures.
- Édouard Philippe publie le premier volume de son programme (« Croire en nous », 142 propositions) le 18 novembre.
- Les équipes de Gabriel Attal, Bruno Retailleau et David Lisnard envisagent le 17 novembre une primaire ouverte en janvier, sans Édouard Philippe et sans accord formel.
- L'enquête Ifop du 18 novembre place Marine Le Pen entre 32 et 36 % ; l'enquête Toluna Harris Interactive publiée le 23, la plus récente et la seule à tester Dominique de Villepin comme candidat déclaré, devient l'enquête de référence.

## 2. Faits retenus pour le digest (5)

Ordre d'affichage du site : date décroissante ; à date égale, le dernier fait inséré en premier. Axe et portée : règle par défaut du type pour les cinq faits.

| Ordre | Date | Type | Radar | Fait | Candidats liés | Sources |
| --- | --- | --- | --- | --- | --- | --- |
| 1 | 21 nov. | retrait | 1 · course | François Ruffin retire sa candidature en prenant acte de l'« impasse » à gauche ; il ne soutient aucun autre candidat et souhaite « bon courage et bonne campagne » aux candidats de gauche. | ruffin | HuffPost, 21 nov. ; Toute l'Europe, 23 nov. |
| 2 | 20 nov. | candidature | 1 · course | Dominique de Villepin, fondateur de La France humaniste, déclare sa candidature lors d'une conférence de presse (« Je suis candidat à l'élection présidentielle de 2027 ») et publie un programme de 258 propositions. | villepin | LCP, 20 nov. (deux articles) |
| 3 | 18 nov. | programme | 3 · engagement | Édouard Philippe présente le premier volume de son programme, « Croire en nous » (142 propositions), consacré notamment à la sécurité, à la justice, aux comptes publics, à l'école, au travail, au logement, à la famille et à l'intelligence artificielle. | philippe | LCP, 18 nov. ; Avec Édouard 2027, 17 nov. |
| 4 | 18 nov. | sondage | 4 · signal | Sondage Ifop présenté avec TF1-LCI, Le Figaro et Fiducial (terrain du 13 au 16 novembre) : Marine Le Pen de 32 à 36 % selon les hypothèses, Jean-Luc Mélenchon de 17 à 19,5 %, Édouard Philippe de 10 à 15 %, Teddy Riner 4 %. | le-pen, melenchon, philippe, riner | Ifop, 18 nov. |
| 5 | 17 nov. | primaire | 1 · signal | Réunies sans l'équipe d'Édouard Philippe, les équipes de Gabriel Attal, Bruno Retailleau et David Lisnard envisagent une primaire ouverte à deux tours les 17 et 24 ou les 24 et 31 janvier ; Nouvelle Énergie précise qu'« aucun accord n'a été conclu à ce stade ». | attal, retailleau, lisnard, philippe | Public Sénat, 17 nov. |

Choix éditoriaux :

- Ordre de priorité du prompt respecté : deux changements de candidatures, un programme, un sondage, un processus de départage. Le fait 5 est un processus de départage (priorité 1) mais sans décision : il reste au digest parce que la réunion a produit des scénarios datés, attribués aux trois équipes, et un désaccord explicite.
- Fait 2 : déclaration et programme publiés le même jour, réunis en un seul fait.
- Fait 3 : les domaines du programme sont repris de la page de campagne plutôt qu'une sélection de mesures, pour ne pas choisir à la place du lecteur.
- Fait 4 : chiffres lus sur la page de l'institut (fourchettes « selon l'offre ») ; le détail par hypothèse n'y figure pas, d'où un sondage de digest différent de l'enquête de référence (section 3.3). Date retenue : publication par l'Ifop le 18 novembre (petit déjeuner électoral) ; un agrégateur la date du 16, fin du terrain.

## 3. Autres mises à jour proposées

| N° | Objet | En ligne aujourd'hui | Proposition | Source | Bloc de `validation.sql` |
| --- | --- | --- | --- | --- | --- |
| 3.1 | Nouvelle candidature | — | Dominique de Villepin : déclaré le 20 novembre (jour), La France humaniste, nuance DIV (hors de l'axe, à arbitrer), programme lié (villepin.fr, 20 novembre), biographie en deux phrases, né le 14 novembre 1953 ; photo demandée au workflow « Photos des candidats » | LCP, 20 nov. ; Wikipédia (biographie) | 1 |
| 3.2 | François Ruffin | Déclaré | Statut « retiré », date de sortie 21 novembre ; fiche conservée pour l'historique, hors des listes | HuffPost, 21 nov. ; Toute l'Europe | 2 |
| 3.3 | Sondage de référence | Elabe (12-13 novembre) | Toluna Harris Interactive pour M6, RTL et L'Express, vague 10 (18-19 novembre, publiée le 23 ; 2 088 inscrits ; trois hypothèses ; 14 candidats, tous dans la base après le bloc 1) | Commission des sondages, notice 10393 | 6 (et 1 pour Dominique de Villepin) |
| 3.4 | Édouard Philippe | Programme « non publié à ce jour » | Lien vers le programme (premier volume, 18 novembre) | Avec Édouard 2027 | 3 |
| 3.5 | Chiffre clé | Note du 16 novembre | Note mise à jour : Riner et Villepin entrés, Ruffin retiré | Toute l'Europe, 23 nov. | 4 |

Fourchettes de l'enquête 3.3 : Le Pen 30-31 ; Mélenchon 18-19 ; Lisnard 11-12 ; Glucksmann 11 ; Philippe 9-10 ; Attal 4-7 ; Riner 4-5 ; Retailleau 4-5 ; Zemmour 3-4 ; Tondelier 1-2 ; Villepin 1-2 ; Arthaud, Roussel, Dupont-Aignan 1. Fourchettes identiques à celles relevées par ChatGPT sur la même notice.

Positions dans les débats : le programme de Dominique de Villepin, selon LCP, n'aborde aucun des huit débats suivis ; celui d'Édouard Philippe traite de l'intelligence artificielle (débat « encadrement de l'IA »), à documenter sur le livret lui-même dans une prochaine veille. Rien n'est saisi.

## 4. Faits écartés

| Date | Fait | Raison |
| --- | --- | --- |
| 17 nov. | Enquête YouGov pour le HuffPost (terrain du 12 au 17 novembre) | Une seule enquête au digest ; échantillon plus réduit (1 030 personnes) |
| 21 nov. | Convention de Gabriel Attal avec 150 jeunes, qui fait évoluer son « pacte pour la jeunesse » | Mesures modifiées publiées le 22 par la presse, sans source de campagne stabilisée (relevé par ChatGPT) |
| 18 nov. | Absence d'Édouard Philippe à un débat télévisé, citée par LCP | Contexte, pas un fait de campagne vérifiable de façon autonome |

## 5. Points à vérifier

- **Lydie Massard** : Toute l'Europe (mise à jour du 23 novembre) indique un retrait le 9 septembre 2026 ; la base la compte comme déclarée. Une seule source, non confirmée par Wikipédia : aucune modification proposée avant une seconde source.
- **Date de publication de l'enquête Ifop** : 18 novembre selon l'institut, 16 selon un agrégateur.
- **Biographie de Dominique de Villepin** : fonctions lues sur Wikipédia (via Wikiwand), qui ne mentionne pas encore La France humaniste ; la qualité de fondateur vient de LCP.
- **Retrait de François Ruffin** : LCP a publié un article le 21 novembre (relevé par ChatGPT) que cette veille n'a pas pu ouvrir ; les deux sources retenues concordent.

## 6. Arbitrages suggérés

- **Nuance de Dominique de Villepin** : DIV (hors de l'axe) en application de la règle du seed 080, faute de rattachement revendiqué ; alternatives possibles DVD (parcours gaulliste) ou DVC (positionnement « arbitre »). Le motif est affiché au survol de l'échiquier.
- **Tri alphabétique** : la fiche est saisie « Dominique » / « de Villepin » ; elle se classe donc à la lettre D dans les listes. Saisir « Villepin » comme nom la classerait à V.
- **Candidatures confidentielles et Jean Lassalle** (rappel du 16 novembre) : Toute l'Europe le dit « devrait » se présenter, sans déclaration datée : pas d'ajout.
- **Ouvrir le comparateur complet** (inchangé).

## 7. Analyse de la veille de ChatGPT (S48 provisoire, 24 novembre) et consolidation

ChatGPT a déposé sur la branche `veille/2026-11-28` un `rapport.md` seul, intitulé « S48 · du 22 au 28 novembre 2026 · provisoire au 24 novembre », sans fichier SQL.

| Point | ChatGPT | Constat | Suite donnée |
| --- | --- | --- | --- |
| Semaine couverte | S48 (22-28 novembre), non terminée, « provisoire » | Le prompt prévoit la dernière semaine complète ; S48 ne le sera que samedi 28 | La veille publiable est celle du 15 au 21 ; S48 reste un brouillon à clore après le 28 |
| État de départ | Copie du dépôt du 4 novembre : « dernier digest du 25 au 31 octobre », enquête Ipsos | Faux depuis le 10 novembre : trois veilles ont été publiées depuis (traces d'import dans `database/veille/`) | Corrigé ; c'est la deuxième fois, après le plan du 15 novembre, que cette copie induit ChatGPT en erreur (section 8, recommandation) |
| Semaine du 15 au 21 | « Semaines antérieures non rattrapées » ; Villepin, Ruffin et Riner listés comme à « vérifier en production » | Riner est en ligne depuis le 16 ; Villepin et Ruffin relèvent du digest du 15 au 21, qui n'existait pas | Faits 1 et 2 de ce digest, fiches traitées (3.1, 3.2) |
| Génération.s soutient Jean-Luc Mélenchon (23 nov.) | Fait 1 de S48 | Hors de la semaine du 15 au 21 ; vérifiable sur LCP et TF1 Info | Conservé pour le digest S48 (section 9) |
| Enquête Toluna Harris Interactive, vague 10 (23 nov.) | Fait 2 de S48 ; proposée en référence sous réserve des fiches Riner et Villepin | Mêmes fourchettes relevées par les deux veilles sur la notice ; les deux fiches existent après le bloc 1 | Adoptée comme enquête de référence (3.3) ; reste éligible au digest S48 |
| Réunion du 26 novembre sur la primaire, conseil fédéral des Écologistes du 26 | À surveiller | Concordant | Repris en section 9 |
| Popularité Odoxa, Congrès des maires, déplacements de Marine Le Pen | Écartés | Concordant | — |
| Attal, « pacte pour la jeunesse » | Écarté (convention du 21, hors S48) | La convention entre dans la semaine du 15 au 21, mais sans source de campagne stabilisée | Écarté aussi (section 4) |

Apports de ChatGPT conservés : la source LCP sur le retrait de François Ruffin, le ralliement de Génération.s et l'agenda du 26 novembre pour S48, le contrôle croisé des fourchettes Toluna, la prudence sur l'import d'un sondage dont les candidats ne sont pas encore dans la base. Apports de cette veille : la semaine du 15 au 21 traitée en entier (cinq faits), l'état réel de publication, le programme d'Édouard Philippe, l'enquête Ifop, la réunion du 17 novembre, les fiches Villepin et Ruffin, les fichiers SQL testés.

## 8. Sources (consultées le 24 novembre 2026)

- HuffPost (via Yahoo Actualités), « François Ruffin retire sa candidature à la présidentielle 2027 face à « l'impasse » à gauche », 21 novembre 2026. https://fr.news.yahoo.com/sport/francois-ruffin-retire-candidature-a-181352223.html
- Toute l'Europe, « Présidentielle 2027 : qui sont les principaux candidats déjà déclarés ? », mise à jour du 23 novembre 2026. https://www.touteleurope.eu/vie-politique-des-etats-membres/presidentielle-2027-qui-sont-les-candidats-deja-declares/
- LCP, « Présidentielle 2027: Dominique de Villepin officiellement candidat à l'Élysée », 20 novembre 2026. https://lcp.fr/actualites/presidentielle-2027-dominique-de-villepin-officiellement-candidat-a-l-elysee-445372
- LCP, « Présidentielle 2027: que retenir des 258 propositions du programme de Dominique de Villepin? », 20 novembre 2026. https://lcp.fr/actualites/presidentielle-2027-que-retenir-des-258-propositions-du-programme-de-dominique-de
- LCP, « Présidentielle 2027: Édouard Philippe promet "des réformes radicales" pour relancer sa campagne, loin des discussions sur la primaire », 18 novembre 2026. https://lcp.fr/actualites/presidentielle-2027-edouard-philippe-promet-des-reformes-radicales-pour-relancer-sa
- Avec Édouard 2027, « Édouard Philippe présente le premier volume de son programme présidentiel », 17 novembre 2026. https://www.edouardphilippe.fr/actualites/edouard-philippe-presente-le-premier-volume-de-son-programme-presidentiel
- Ifop, « Les intentions de vote à l'élection présidentielle 2027 », 18 novembre 2026. https://www.ifopgroup.com/article/les-intentions-de-vote-a-lelection-presidentielle-2027/
- Public Sénat, « Primaire : les équipes d'Attal, Retailleau et Lisnard s'alignent sur un vote en janvier, moins sur le cas d'Eric Zemmour », 17 novembre 2026. https://www.publicsenat.fr/actualites/politique/primaire-les-equipes-dattal-retailleau-et-lisnard-salignent-sur-un-vote-en-janvier-moins-sur-le-cas-deric-zemmour
- Commission des sondages, notice Toluna Harris Interactive, vague 10, 23 novembre 2026. https://www.commission-des-sondages.fr/notices/files/notices/2026/novembre/10393-pres-iv-vague-10-toluna-harris-interactive-23-novembre.pdf
- Wikipedia (via Wikiwand), « Dominique de Villepin ». https://wikiwand.com/EN/Dominique_de_Villepin
- Consultées sans être retenues comme source : agrégateur sondage-presidentielle.fr (Ifop, YouGov, Toluna) ; Wikipedia, « Lydie Massard » ; veille S48 de ChatGPT et ses sources (LCP et TF1 Info sur Génération.s, Le Parisien sur David Lisnard et Gabriel Attal).

Recommandation de méthode : le `public/data/site.json` du dépôt est une copie d'installation, figée au 4 novembre ; il ne reflète pas la production. Pour l'état de départ, lire le site en ligne, ou à défaut le dernier `database/veille/*/publication.json`. Le prompt de veille gagnerait à le dire explicitement.

## 9. À reprendre dans la veille S48 (22 au 28 novembre), à clore après le samedi 28

| Date | Sujet | Statut au 24 novembre |
| --- | --- | --- |
| 23 nov. | Génération.s soutient Jean-Luc Mélenchon (vote des adhérents à 85 %) et conclut un accord législatif avec LFI | Fait vérifiable, candidat au digest S48 (source : LCP, 23 nov., relevée par ChatGPT) |
| 23 nov. | Enquête Toluna Harris Interactive, vague 10 | Candidate au digest S48 ; déjà enquête de référence par cette veille |
| 24 nov. | Ouverture du Congrès des maires, recherche de parrainages | Contexte ; ne retenir qu'une donnée officielle |
| 26 nov. | Deuxième réunion des équipes Attal, Retailleau et Lisnard (charte des valeurs, cas Zemmour) ; réunion possible autour de Gérard Larcher | À relever après sa tenue ; ne rien présenter comme acté sans accord explicite |
| 26 nov. | Conseil fédéral des Écologistes : scénarios soumis au vote du 13 décembre | À relever après sa tenue |

## Mode d'emploi

1. Relire ce rapport ; retirer de `validation.sql` les blocs refusés (chaque bloc renvoie à une ligne du rapport).
2. Fusionner la pull request `veille/2026-11-21` dans `main`.
3. GitHub → Actions → **Importer une veille** : semaine `2026-11-21`, étape `saisie` (contrôle : 10 sources, 5 faits, 13 résultats), puis étape `validation` (contrôle : « Dominique de Villepin · DIV », Ruffin « retire », 31 candidatures, 5 faits, 14 résultats).
