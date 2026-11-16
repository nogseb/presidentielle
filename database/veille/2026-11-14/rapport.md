# Veille Repères 2027 · semaine du 8 au 14 novembre 2026

Préparée le lundi 16 novembre 2026 par Claude avec le prompt `docs/prompt-veille.md`, en consolidant le plan de veille rédigé par ChatGPT le 15 novembre (section 7), à la demande de Sébastien Noguès (« analyse, compare, augmente et consolide dans une unique veille. Publie cette veille en ligne »). Chaque élément retenu a été lu sur sa source le 16 novembre.

Digest : du dimanche 8 au samedi 14 novembre 2026, dernière semaine complète. Autres mises à jour : tout ce qui est paru depuis la veille du 1er au 7 novembre.

État de départ relevé sur le site en ligne le 16 novembre (navigateur) : données générées le 10 novembre 2026 ; digest « Du 1er au 7 novembre 2026 » (4 faits) ; enquête de référence Ifop pour LCI (27-29 octobre) ; 30 candidatures ; aucune alerte.

## 1. Synthèse

- Le judoka Teddy Riner se déclare candidat le 9 novembre, sans étiquette : 31e candidature de la base.
- Le départage de la droite et du centre domine la semaine : Bruno Retailleau propose une primaire les 31 janvier et 7 février, refusée par l'équipe d'Édouard Philippe ; Gérard Larcher propose le 14 de réunir les candidats autour d'une « méthode de départage ».
- Quatre enquêtes d'intentions de vote paraissent (Toluna Harris Interactive, Cluster17, OpinionWay, Elabe) ; l'enquête Elabe, la plus récente, devient l'enquête de référence.
- Aucun retrait, aucun programme complet publié, aucun fait institutionnel relevé dans la semaine.

## 2. Faits retenus pour le digest (4)

Ordre d'affichage du site : date décroissante ; à date égale, le dernier fait inséré en premier. Axe et portée : règle par défaut du type pour les quatre faits.

| Ordre | Date | Type | Radar | Fait | Candidats liés | Sources |
| --- | --- | --- | --- | --- | --- | --- |
| 1 | 14 nov. | primaire | 1 · signal | Le président du Sénat, Gérard Larcher, propose de réunir « dans les meilleurs délais » les candidats de la droite et du centre pour définir une « méthode de départage » ; Renaissance y répond « bien évidemment favorablement ». | philippe, attal, retailleau, lisnard | AFP, 14 nov. |
| 2 | 14 nov. | sondage | 4 · signal | Sondage Elabe pour BFMTV et La Tribune Dimanche (terrain des 12 et 13 novembre) : Marine Le Pen de 31 à 33 % selon les hypothèses, Jean-Luc Mélenchon de 17 à 18,5 %, Teddy Riner 4,5 % dans la seule hypothèse où il est testé. | le-pen, melenchon, riner | Elabe (rapport) |
| 3 | 10 nov. | primaire | 1 · signal | Dans une lettre du 10 novembre, Bruno Retailleau propose à Édouard Philippe, Gabriel Attal et David Lisnard une primaire de la droite et du centre les 31 janvier et 7 février ; le porte-parole d'Édouard Philippe répond qu'« il ne participera pas à une primaire ». | retailleau, philippe, attal, lisnard | AFP, 11 nov. ; LCP, 12 nov. |
| 4 | 9 nov. | candidature | 1 · course | Le judoka Teddy Riner annonce sa candidature dans une vidéo publiée sur ses réseaux sociaux, sans étiquette ; interrogé sur le clivage droite-gauche, il répond : « Ni l'un, ni l'autre. » | riner | LCP, 9 nov. ; AFP, 9 nov. ; Public Sénat, 9 nov. |

Choix éditoriaux :

- Quatre faits plutôt que cinq : aucun autre fait de la semaine ne relève des priorités 1 à 3 avec une source de référence lue (section 4).
- Faits 1 et 3 : deux initiatives distinctes, de deux acteurs, sur le même sujet ; elles sont gardées séparées parce que la seconde ne remplace pas la première (la réunion des directeurs de campagne du 17 novembre est maintenue, selon l'entourage de Gérard Larcher).
- Fait 3 : la lettre est datée du mardi 10 novembre d'après l'AFP du 11 (« mardi ») ; le porte-parole cité est Jérémie Patrier-Leitus, sur BFMTV.
- Fait 2 : une seule enquête au digest, la plus récente et la seule à tester à la fois Teddy Riner et toutes les candidatures majeures ; les trois autres figurent en section 4.
- Le rattachement de Teddy Riner aux faits 2 et 4 est fait par `validation.sql`, après création de sa fiche.

## 3. Autres mises à jour proposées

| N° | Objet | En ligne aujourd'hui | Proposition | Source | Bloc de `validation.sql` |
| --- | --- | --- | --- | --- | --- |
| 3.1 | Nouvelle candidature | — | Teddy Riner : déclaré le 9 novembre (jour), sans parti, nuance DIV (« ni de droite ni de gauche », affiché hors de l'axe de l'échiquier), biographie en deux phrases, date de naissance 7 avril 1989 ; photo demandée au workflow « Photos des candidats » (`outils/photos/candidats.json`) | LCP, 9 nov. ; Wikipédia (biographie) | 1 |
| 3.2 | Sondage de référence | Ifop pour LCI (27-29 octobre) | Elabe pour BFMTV et La Tribune Dimanche (12-13 novembre, 1 391 inscrits, six hypothèses, 15 candidats en fourchette) | Elabe, rapport du 14 novembre | 4 (et 1 pour Teddy Riner) |
| 3.3 | Chiffre clé | « Selon Toute l'Europe au 14 octobre 2026 ; L'Obs en compte 31 » | Note réécrite : base de Toute l'Europe (30) complétée de Teddy Riner ; mention des candidatures confidentielles recensées par LCP | LCP, liste du 14 novembre | 2 |

Fourchettes du sondage 3.2 : Le Pen 31-33 ; Mélenchon 17-18,5 ; Philippe 9,5-15 ; Glucksmann 10,5-14 ; Lisnard 8-10,5 ; Attal 4-10 ; Retailleau 4-9 ; Riner 4,5 ; Zemmour 3-4,5 ; Tondelier 3-3,5 ; Ruffin 3 ; Dupont-Aignan 2-3 ; Roussel 1,5-2,5 ; Polony 1,5 ; Arthaud 0,5-1. Dominique de Villepin (2,5 à 3 % dans deux hypothèses), non déclaré, n'est pas affiché : la note de l'enquête le précise.

Pourquoi Elabe plutôt que les trois autres enquêtes de la semaine : terrain le plus récent (12-13 novembre) et rapport complet de l'institut. Toluna Harris Interactive (terrain du 3 au 5 novembre) est plus ancienne ; Cluster17 teste Christine Lagarde, non candidate ; la notice OpinionWay n'a pas pu être lue (redirection en boucle du site de la Commission des sondages).

## 4. Faits écartés

| Date | Fait | Raison |
| --- | --- | --- |
| 9 nov. | Enquête Toluna Harris Interactive pour M6 et RTL (terrain du 3 au 5 novembre) | Une seule enquête au digest ; plus ancienne qu'Elabe |
| 11 nov. | Enquête Cluster17 pour POLITICO, qui teste Christine Lagarde | Une seule enquête au digest ; personnalité non candidate |
| 12 nov. | Enquête OpinionWay pour CNEWS (Teddy Riner à 4 %) | Une seule enquête au digest ; notice non lue |
| 9 nov. | Réactions d'Emmanuel Macron, d'Édouard Philippe et de Dominique de Villepin à la candidature de Teddy Riner | Réactions, pas un fait de campagne nouveau |
| 12 et 13 nov. | Édouard Philippe : « Je ne changerai pas d'avis » sur la primaire | Repris dans l'esprit du fait 3 |
| 14 nov. | Liste LCP des candidatures : Jean Lassalle, Augustin Billetdoux, Joël Chevé, Christian Collovati, Sylvain Durif, Jean-François Legendre, Manolo Mlekuz et Erwan Rohou y figurent sans être dans la base | Déclarations antérieures, non datées par LCP : à arbitrer (section 6) |

Hors période ou hors sujet : programme d'économies de Bruno Retailleau (12 octobre), manifeste de Bruno Le Maire (23 août), « deal » de 250 milliards d'Édouard Philippe (novembre 2025), lancement d'Agri2050 (novembre 2025).

## 5. Points à vérifier

- **Date de la lettre de Bruno Retailleau** : « mardi » selon l'AFP du mercredi 11 novembre, soit le 10 ; LCP (12 novembre) dit aussi « mardi ».
- **Palmarès de Teddy Riner (biographie)** : lu sur Wikipédia en anglais, qui ne mentionne pas encore la candidature ; titres arrêtés aux Jeux de 2024.
- **Date de publication de l'enquête Elabe** : 14 novembre selon la page de l'institut ; pas de notice de la Commission des sondages trouvée à cette date.

## 6. Arbitrages suggérés

- **Candidatures confidentielles** : la liste LCP du 14 novembre recense au moins huit candidatures absentes de la base (section 4). Règle à fixer : les ajouter toutes, n'ajouter que celles qui annoncent une campagne de parrainages, ou attendre la liste officielle du 26 mars.
- **Dominique de Villepin** : testé par Elabe et Toluna Harris Interactive, il a dit début novembre qu'il serait candidat sans l'officialiser. La règle actuelle (déclaration explicite) est maintenue dans cette veille.
- **Ouvrir le comparateur complet** (inchangé) : les positions tirées du programme de La France insoumise restent à l'état « à valider ».

## 7. Analyse et consolidation du plan de veille de ChatGPT (15 novembre)

Le document fourni est un plan de collecte pour la semaine du 15 au 21 novembre, encore en cours ; il indique lui-même qu'il « ne doit pas être importé en base ». Comparaison :

| Point | Plan de ChatGPT | Constat de cette veille | Suite donnée |
| --- | --- | --- | --- |
| État de départ | Lu dans `public/data/site.json` du dépôt (4 novembre) : digest du 25 au 31 octobre, enquête Ipsos | Cette copie n'est pas l'état de production : le site en ligne publie depuis le 10 novembre le digest du 1er au 7 novembre et l'enquête Ifop pour LCI | Corrigé : l'état de départ se relève sur le site en ligne, pas dans le dépôt |
| Semaines « manquantes » | 1er-7 et 8-14 novembre | La première est publiée depuis le 10 novembre ; la seconde manquait bien | Publiée par cette veille |
| Teddy Riner | Candidature du 9 novembre, hors du digest du 15 au 21 | Exact ; elle relève du digest du 8 au 14 | Fait 4 et fiche créée |
| Primaire de la droite et du centre | Lettre de Bruno Retailleau, réunion du 17 novembre, refus du camp Philippe | Confirmé par l'AFP et LCP | Fait 3 ; réunion du 17 à suivre (section 9) |
| Initiative de Gérard Larcher | Signal du 14 novembre | Confirmé par l'AFP ; Renaissance favorable | Fait 1 |
| Sondages | Cluster17, OpinionWay, Elabe et enquêtes sur Teddy Riner, « point de comparaison » | Toutes dans la période du 8 au 14 : éligibles à ce digest | Elabe au digest et en référence ; les autres en section 4 |
| Personnalités non déclarées | Bertrand, Villepin, Hollande, Breton, Borne, Le Maire, Lagarde | Liste LCP du 14 novembre confirmée ; Xavier Bertrand figure déjà dans la base comme déclaré depuis le 27 août | À maintenir comme règle ; ajout du cas Bertrand à vérifier (section 9) |
| Règles, Shift Project | Rien de daté dans la période | Confirmé pour le 8 au 14 | — |
| Grille de collecte et contrôle de fin de semaine | Proposés | Repris dans la section 9 | Plan de la semaine suivante |

Apports de ChatGPT conservés : les pistes Riner, Retailleau et Larcher, la vigilance sur les personnalités non déclarées, la grille de contrôle. Apports de cette consolidation : l'état de production réel, la bonne affectation des faits à la semaine du 8 au 14, la lecture des sources primaires (rapport Elabe, dépêches AFP), la fiche de Teddy Riner avec sa nuance, le choix argumenté de l'enquête de référence.

## 8. Sources (consultées le 16 novembre 2026)

- LCP, « Le judoka Teddy Riner annonce sa candidature à l'élection présidentielle de 2027 », 9 novembre 2026. https://lcp.fr/actualites/le-judoka-teddy-riner-annonce-sa-candidature-a-l-election-presidentielle-de-2027-444920
- AFP (La Libre), « Des tatamis à l'Élysée ? Teddy Riner candidat surprise à la présidentielle », 9 novembre 2026. https://www.lalibre.be/dernieres-depeches/2026/11/09/des-tatamis-a-lelysee-teddy-riner-annonce-sa-candidature-a-la-presidentielle-TN24TXUYZBDHLNYIUW4YHZJEI4/
- Public Sénat, « Présidentielle 2027 : le judoka Teddy Riner se lance dans la course à l'Élysée, au milieu d'une multitude de candidats », 9 novembre 2026. https://www.publicsenat.fr/actualites/politique/presidentielle-2027-le-judoka-teddy-riner-se-lance-dans-la-course-a-lelysee-au-milieu-dune-multitude-de-candidats
- AFP (Orange), « Retailleau propose une primaire les 31 janvier et 7 février », 11 novembre 2026. https://actu.orange.fr/politique/retailleau-propose-une-primaire-les-31-janvier-et-7-fevrier-CNT000002tFStY.html
- LCP, « Présidentielle: Bruno Retailleau propose une primaire les 31 janvier et 7 février », 12 novembre 2026. https://lcp.fr/actualites/presidentielle-bruno-retailleau-propose-une-primaire-les-31-janvier-et-7-fevrier-445008
- AFP (Boursorama), « Présidentielle: Larcher veut réunir les candidats de la droite et du centre, la pression monte sur Philippe », 14 novembre 2026. https://www.boursorama.com/actualite-economique/actualites/presidentielle-larcher-veut-reunir-les-candidats-de-la-droite-et-du-centre-la-pression-monte-sur-philippe-c0a73dc48120a2eb7fcbc3a048411956
- Elabe, « Les Français et l'élection présidentielle 2027 », rapport et page de présentation, 14 novembre 2026. https://elabe.fr/fichier-pdf/13399-les-francais-et-lelection-presidentielle-2027/ ; https://elabe.fr/presidentielle-2027-novembre/
- LCP, « Présidentielle 2027: la liste des candidats déclarés et potentiels », mise à jour le 14 novembre 2026. https://lcp.fr/actualites/presidentielle-2027-la-liste-des-candidats-declares-et-potentiels-444932
- Wikipedia, « Teddy Riner » (biographie). https://en.wikipedia.org/wiki/Teddy_Riner
- Consultées sans être retenues comme source : notices de la Commission des sondages (Toluna Harris Interactive, 9 novembre ; Cluster17, 11 novembre ; OpinionWay, 12 novembre, illisibles) ; Public Sénat, programme d'économies de Bruno Retailleau (12 octobre) ; La Gazette France (AFP), manifeste de Bruno Le Maire (23 août).

## 9. À surveiller du 15 au 21 novembre (plan consolidé pour la prochaine veille)

| Date | Sujet | Ce qu'il faudra relever |
| --- | --- | --- |
| Mardi 17 nov. | Réunion des directeurs de campagne de Gabriel Attal, Bruno Retailleau et David Lisnard sur une primaire ; siège réservé à l'équipe d'Édouard Philippe, qui a annoncé ne pas venir | Accord ou non sur le principe, périmètre, dates, corps électoral, engagement à soutenir le vainqueur ; ne pas présenter une primaire comme actée sans accord explicite |
| Non datée | Réunion proposée par Gérard Larcher | Date, réponse de chaque candidat (dont Édouard Philippe et David Lisnard), méthode retenue |
| Semaine | Teddy Riner | Équipe, site, propositions chiffrées, positions sur les huit débats suivis ; pas de nouveau fait sur la seule candidature |
| Semaine | Personnalités non déclarées (Villepin, Hollande, Breton, Borne, Le Maire, Lagarde, Pigasse) | Uniquement une déclaration explicite |
| Semaine | Sondages | Institut et notice, terrain, toutes les hypothèses ; Toluna Harris Interactive publie un baromètre chaque semaine |
| Semaine | Institutions (Conseil constitutionnel, Journal officiel, Arcom, CNCCFP, Commission des sondages) | Tout texte qui touche aux dates, aux parrainages, au temps de parole ou au financement |
| À vérifier | Xavier Bertrand | Présenté par LCP comme devant « préciser ses intentions d'ici la fin de l'année », alors que la base le compte comme déclaré depuis le 27 août (source Toute l'Europe) : vérifier sa situation |

Contrôle de fin de semaine (repris de ChatGPT) : période du dimanche au samedi ; cinq faits au plus ; aucun fait d'une semaine antérieure recyclé ; état de production relevé en ligne ; anti-doublon ; candidature sur déclaration explicite ; sondages vérifiés auprès de l'institut et de la Commission ; citations exactes ; faits incertains hors SQL.

## Mode d'emploi

1. GitHub → Actions → **Importer une veille** → Run workflow : semaine `2026-11-14`, étape `saisie`. Contrôle attendu : 10 sources, 4 faits, 14 résultats de sondage.
2. Relire ce rapport ; retirer de `validation.sql` les blocs refusés.
3. Même workflow, étape `validation` : contrôle attendu « Teddy Riner · DIV », 31 candidatures, 4 faits validés, 15 résultats.

Publication du 16 novembre 2026 : étapes 1 et 3 lancées par Claude à la demande de Sébastien Noguès.
