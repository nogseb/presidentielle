# Veille Repères 2027 · semaine du 25 au 31 octobre 2026 · version consolidée

Préparée le mardi 3 novembre 2026 à partir de trois veilles produites avec le même prompt (`docs/prompt-veille.md`) : Claude, ChatGPT et Gemini. Chaque élément retenu a été revérifié sur sa source le 3 novembre ; ce qui n'a pas pu l'être figure en section 5.

Digest : du dimanche 25 au samedi 31 octobre 2026. Autres mises à jour : tout ce qui est paru depuis les données du 17 octobre.

État de départ : le `site.json` de production n'était lisible par aucune des trois veilles. L'état de référence est celui du dépôt (`database/seed/`), qui correspond à la base importée le 18 octobre. Une saisie faite depuis dans phpMyAdmin n'est pas prise en compte.

## 1. Synthèse

- Le gouvernement maintient les dates du scrutin (18 avril et 2 mai 2027).
- Gabriel Attal présente son projet économique et propose une « grande primaire des démocrates », rejetée par les équipes d'Édouard Philippe et de Bruno Retailleau.
- Édouard Philippe est placé sous le statut de témoin assisté dans une enquête portant sur Le Havre Seine Métropole.
- Deux enquêtes de premier tour réalisées du 19 au 22 octobre (Cluster17 pour POLITICO, Ipsos bva-CESI pour Le Parisien) placent Marine Le Pen en tête et Jean-Luc Mélenchon deuxième.
- The Shift Project a publié le 14 octobre « Réussir à l'ère des crises » (Odile Jacob).

## 2. Faits retenus pour le digest (5)

Ordre d'affichage du site : date décroissante.

| Ordre | Date | Type | Fait | Candidats liés | Sources | Proposé par |
| --- | --- | --- | --- | --- | --- | --- |
| 1 | 29 oct. | justice | Entendu par deux juges d'instruction financiers à Paris, Édouard Philippe est placé sous le statut de témoin assisté dans une enquête pour détournement de fonds publics, favoritisme et harcèlement moral portant sur Le Havre Seine Métropole, qu'il préside. | philippe | LCP, 30 oct. ; Le Club des juristes, 30 oct. | ChatGPT |
| 2 | 28 oct. | calendrier | Le gouvernement exclut de modifier les dates du scrutin, fixées aux 18 avril et 2 mai 2027, après des demandes en ce sens, dont celle de Bruno Retailleau. | retailleau | LCP, 28 oct. | les trois |
| 3 | 28 oct. | primaire | Gabriel Attal propose sur TF1 une « grande primaire des démocrates », qu'il présente comme un moyen d'éviter un second tour RN-LFI ; les équipes d'Édouard Philippe et de Bruno Retailleau la rejettent le lendemain. | attal, philippe, retailleau | LCP, 28 oct. ; Public Sénat, 29 oct. | les trois (rejet : Claude) |
| 4 | 28 oct. | programme | Gabriel Attal présente son projet économique : 150 milliards d'euros d'économies sur cinq ans, une règle d'or budgétaire inscrite dans la Constitution et l'accélération du programme de 14 réacteurs EPR2. | attal | attalpresident.fr, 28 oct. | ChatGPT |
| 5 | 26 oct. | sondage | Sondage Cluster17 pour POLITICO (terrain du 19 au 22 octobre) : Marine Le Pen de 30,5 à 33 % selon les hypothèses, Jean-Luc Mélenchon de 18,5 à 19,5 %, Édouard Philippe 16 % dans l'hypothèse principale. | le-pen, melenchon, philippe | Cluster17, 26 oct. | ChatGPT |

Choix éditoriaux :

- Ordre de priorité du prompt appliqué : règles du scrutin, désignation des candidats, programmes, sondages, puis le reste. Le fait judiciaire concernant un candidat de premier plan est retenu comme acte de procédure, sans qualificatif.
- Projet économique d'Attal : l'objectif de 150 milliards d'euros et le « plan Messmer II » figuraient déjà dans une annonce du 23 septembre (attalpresident.fr). Le fait du 28 octobre porte sur la présentation d'ensemble du projet ; la formulation ne le présente pas comme une annonce inédite.
- Sondage Cluster17 : seuls les chiffres lus sur la page de l'institut sont repris.
- Équilibre : Gabriel Attal apparaît dans deux faits. Le premier meeting de Marine Le Pen (25 octobre) pourrait remplacer le fait 4 après vérification (section 5).

## 3. Autres mises à jour proposées

| N° | Objet | En ligne aujourd'hui | Proposition | Source | Bloc de `validation.sql` | Proposé par |
| --- | --- | --- | --- | --- | --- | --- |
| 3.1 | Sondage de référence | Enquête électorale Ipsos bva (3-9 septembre, 13 060 inscrits) | Ipsos bva-CESI pour Le Parisien (21-22 octobre, 1 500 inscrits, quatre hypothèses, 12 candidats en fourchette) | Ipsos, 24 oct. ; rapport complet (cesi.fr) | 2 | Claude ; Gemini |
| 3.2 | Éric Zemmour | « Annonce », badge « Déclaration formelle attendue » | « Déclaration », badge retiré | LCP, 17 sept. | 3, à arbitrer | Claude |
| 3.3 | Marine Tondelier | Vote des militants le 13 décembre | Objet du vote précisé : sa candidature ou le soutien à un candidat extérieur au parti | LCP, 23 oct. | 4 | Claude |
| 3.4 | Marine Le Pen | Condamnée en appel, pourvoi en cours, éligible à ce stade | Note complétée : peine, absence d'exécution provisoire, calendrier de la cassation, débat entre juristes | Public Sénat, 2 nov. | 5 | Claude |
| 3.5 | The Shift Project | Livre « annoncé », octobre 2026 | Paru le 14 octobre 2026 ; dispositif mis à jour | Odile Jacob | 6 | Claude ; ChatGPT |
| 3.6 | Dates des tours | Source : Weka (niveau 3) | Source officielle : Service-Public.fr, 2 juillet 2026 (niveau 1) | Service-Public.fr | 7 | Gemini (date corrigée) |
| 3.7 | Débat « nouveaux réacteurs » | Aucune position | Gabriel Attal : pour (+2), « l'accélération du programme de 14 réacteurs EPR2 » | attalpresident.fr, 28 oct. | 8 | ChatGPT |
| 3.8 | Édouard Philippe | Pas de note | Note de procédure (bloc 9) ; badge « Volet judiciaire » (bloc 10, à arbitrer) | LCP, 30 oct. | 9 et 10 | consolidation |

Fourchettes du sondage 3.1 : Le Pen 32-33,5 ; Mélenchon 17 ; Glucksmann 13-15,5 ; Philippe 13-15 ; Retailleau 5,5-11,5 ; Attal 4-9,5 ; Lisnard 6,5 ; Zemmour 4-4,5 ; Tondelier 3,5 ; Roussel 2-2,5 ; Dupont-Aignan 1,5-2 ; Arthaud 0,5.

Pourquoi Ipsos plutôt que Cluster17 comme enquête de référence : les deux terrains s'achèvent le 22 octobre. Les résultats Ipsos sont lisibles en entier dans le rapport de l'institut ; ceux de Cluster17 ne l'ont été que pour les principaux candidats, et l'enquête teste François Hollande, qui n'est pas candidat déclaré et n'existe pas dans la base. Si la notice Cluster17 de la Commission des sondages est contrôlée (section 5), elle peut remplacer l'enquête Ipsos dans une prochaine veille.

Le programme publié par Gabriel Attal le 28 octobre contient d'autres mesures, à saisir comme propositions à l'ouverture du comparateur, avec le même traitement pour tous les candidats : stabilité fiscale des entreprises pendant dix ans ; réduction d'un quart de leur charge administrative ; réécriture du Code du travail (« Constitution du travail ») ; 1 000 euros versés à chaque naissance (« baby bonds ») ; formation de 20 millions de salariés à l'IA d'ici 2030 ; planification industrielle sur dix ans dans cinq filières.

## 4. Faits écartés

| Date | Fait | Raison | Relevé par |
| --- | --- | --- | --- |
| 28 oct. | David Lisnard brigue sa réélection à la présidence de l'AMF ; Marc Fesneau dénonce un « mélange des genres » | Moins prioritaire que les cinq faits retenus | Claude |
| 27 oct. | Raphaël Glucksmann compose son équipe de campagne (Laurence Rossignol, Alexandre Ouizille) | Organisation interne, moins prioritaire | Claude |
| 27 oct. | Yaël Braun-Pivet plaide pour un candidat unique du centre et de la droite | Appel d'une personnalité non candidate, sans processus engagé | Claude ; Gemini ; écarté par ChatGPT |
| 25 oct. | Premier grand meeting de Marine Le Pen à Orléans | Source non lue en entier : voir section 5 | ChatGPT |
| 27 oct. | France Hydrogène interpelle les candidats | Aucune source trouvée lors du contrôle | Gemini |
| 30 oct. | « Les dates de l'élection présidentielle de 2027 sont annoncées » (Service-Public.fr) | Article du 2 juillet 2026, pas du 30 octobre ; utilisé comme source du calendrier (3.6) | Gemini |
| 27 oct. | Baromètre Odoxa-Mascaret : cotes d'adhésion de Glucksmann et Lisnard en hausse | Popularité, pas intention de vote ; mentions légales absentes de l'article | Claude |
| 28 oct. | Entretien de Didier Guérin (Le Monde) sur l'éligibilité de Marine Le Pen | Opinion d'un juriste, pas un acte de procédure | Claude |
| 27 oct. | Bruno Retailleau à HEC Débats | Pas de mesure nouvelle précise | ChatGPT |
| 30 oct. | Rassemblement contre le racisme à Trappes | Sans effet sur la course | ChatGPT |
| 30 oct. | Propositions des candidats sur les salaires (Public Sénat) | Synthèse d'annonces déjà connues | Gemini |

Hors période : semaine du 18 au 24 octobre sans digest (enquête Ipsos-Le Parisien reprise en 3.1 ; Dominique de Villepin à « plus de 300 signatures » d'élus ; Michel Barnier pour une primaire de la droite et du centre). À reprendre dans le digest du 1er au 7 novembre : Édouard Philippe écarte la primaire d'Attal (1er nov.) ; Gabriel Attal maintient sa proposition (2 nov.) ; débat sur l'éligibilité de Marine Le Pen (2 nov.).

## 5. Points à vérifier

- **Meeting de Marine Le Pen, Orléans, 25 octobre.** ChatGPT cite un article de Public Sénat et des titres de franceinfo et France 24 l'évoquent (gouvernement « d'union nationale », « pluraliste », dirigé par Jordan Bardella), mais aucun texte complet n'a pu être lu ici. Si l'article de Public Sénat se confirme, il peut remplacer le fait 4 pour l'équilibre du digest.
- **Notice Cluster17 de la Commission des sondages** (n° 10339 selon ChatGPT) : non consultable ici ; les scores des petits candidats et de l'hypothèse 3 reposent sur elle seule.
- **Zemmour (3.2)** : LCP titre « officialise sa candidature » (17 septembre) ; Toute l'Europe (14 octobre) attend encore une déclaration formelle.
- **Notice de la Commission des sondages pour l'enquête Ipsos-Le Parisien** : non trouvée.
- **Candidatures signalées par des agrégateurs** (Gilles Platret, Sylvain Durif) et **décision de Bruno Le Maire** annoncée pour octobre : rien de confirmé par un média de référence.

## 6. Arbitrages suggérés

- **Badge « Volet judiciaire » pour Édouard Philippe (bloc 10).** Aujourd'hui, seule Marine Le Pen le porte, après une condamnation. Le statut de témoin assisté est moins incriminant qu'une mise en examen. Recommandation : garder la note (bloc 9) et retirer le bloc 10, puis fixer une règle publique (badge à partir de la mise en examen ou d'une condamnation) appliquée à tous.
- **Ouvrir le comparateur complet.** Remplissent a priori le critère du groupe parlementaire : Le Pen, Mélenchon, Glucksmann, Attal, Philippe, Retailleau, Tondelier, Roussel. Le critère des 2 % demande d'abord une règle pour moyenner des enquêtes à plusieurs hypothèses (remarque de ChatGPT, retenue).
- **Prompt de veille.** Ajouter trois consignes tirées de cette comparaison : vérifier la date de publication d'une source officielle avant d'en faire un fait de la semaine ; signaler quand une annonce reprend une annonce antérieure ; livrer les fichiers SQL (deux des trois veilles ne l'ont pas fait).

## 7. Comparaison des trois veilles

| Critère | Claude | ChatGPT | Gemini |
| --- | --- | --- | --- |
| Faits de la semaine retenus et confirmés | 5 sur 5, mais trois de priorité faible | 5 sur 5 | 2 sur 5 |
| Faits majeurs manqués | Témoin assisté de Philippe, projet économique d'Attal, sondage Cluster17 | Aucun relevé | Philippe, projet d'Attal, rejet de la primaire |
| Erreurs factuelles relevées | Aucune | Aucune ; nouveauté du projet d'Attal à nuancer | Date Service-Public (2 juillet, pas 30 octobre) ; date Ipsos (24, pas 26 octobre) ; « ni Philippe ni Retailleau n'ont réagi » (faux : rejet le 29) |
| Respect du prompt | Période, 5 faits, sources datées, SQL testé | Période, 5 faits, sources datées par niveau, pas de SQL | Fait hors période (Ipsos) dans le digest, sources sans URL, pas de SQL |
| Apports propres | Notes Zemmour, Tondelier, Le Pen ; sondage de référence ; source Odile Jacob | Philippe ; projet d'Attal ; Cluster17 ; position sur le nucléaire ; prudence sur le critère des 2 % | Source officielle des dates (Service-Public.fr), après correction |
| Usage recommandé | Production du SQL et contrôle | Repérage des faits et des sources primaires | Contre-vérification seulement |

## 8. Sources (consultées le 3 novembre 2026)

- LCP, « Soupçons de détournement de fonds publics: Édouard Philippe placé sous le statut de témoin assisté, une "décision favorable" réagit son avocat », 30 octobre 2026. https://lcp.fr/actualites/soupcons-de-detournement-de-fonds-publics-edouard-philippe-place-sous-le-statut-de
- Le Club des juristes, « Placement d'Edouard Philippe sous le statut de témoin assisté dans une enquête pour détournement de fonds publics », 30 octobre 2026. https://www.leclubdesjuristes.com/en-bref/placement-dedouard-philippe-sous-le-statut-de-temoin-assiste-dans-une-enquete-pour-detournement-de-fonds-publics-18148/
- LCP, « Présidentielle 2027: pour le gouvernement, il n'y a "pas de raison de changer" les dates de l'élection », 28 octobre 2026. https://lcp.fr/actualites/presidentielle-2027-pour-le-gouvernement-il-n-y-a-pas-de-raison-de-changer-les-dates-de
- LCP, « Présidentielle 2027: Gabriel Attal veut une "grande primaire des démocrates" pour éviter un second tour RN-LFI », 28 octobre 2026. https://lcp.fr/actualites/presidentielle-2027-gabriel-attal-veut-une-grande-primaire-des-democrates-pour-eviter-un
- Public Sénat, « Après la proposition de primaire de Gabriel Attal, rejetée par le camp Philippe et Retailleau, le blocage perdure », 29 octobre 2026. https://www.publicsenat.fr/actualites/politique/apres-la-proposition-de-primaire-de-gabriel-attal-rejetee-par-le-camp-philippe-et-retailleau-le-blocage-perdure
- attalpresident.fr, « Gabriel Attal présente sa vision économique pour libérer, innover et renforcer l'indépendance de la France », 28 octobre 2026. https://attalpresident.fr/actualites/gabriel-attal-vision-economique-liberer-innover-independance-france
- attalpresident.fr, « Gabriel Attal présente un plan de désendettement et un « Messmer II » pour sortir des dépendances françaises », 23 septembre 2026 (contrôle de nouveauté). https://attalpresident.fr/actualites/gabriel-attal-presente-un-plan-de-desendettement-et-un-messmer-ii-pour-sortir-des-dependances-francaises
- Cluster17, « Présidentielle 2027 : Marine Le Pen conforte son avance, Jean-Luc Mélenchon devance désormais Edouard Philippe », 26 octobre 2026. https://cluster17.com/presidentielle-2027-marine-le-pen-conforte-son-avance-jean-luc-melenchon-devance-desormais-edouard-philippe-philippe/
- Ipsos bva, « Présidentielle 2027 : Mélenchon progresse, Le Pen reste en tête », 24 octobre 2026, et rapport complet. https://www.ipsos.com/fr-fr/presidentielle-2027-melenchon-progresse-le-pen-reste-en-tete ; https://www.cesi.fr/wp-content/uploads/2026/10/presidentielle-2027-intention-vote-octobre26-rapport-complet-web.pdf
- LCP, « Présidentielle 2027: Éric Zemmour officialise sa candidature », 17 septembre 2026. https://lcp.fr/actualites/presidentielle-2027-eric-zemmour-officialise-sa-candidature-441871
- LCP, « Présidentielle: une dynamique Mélenchon chez Les Écologistes au risque de fracturer le parti? », 23 octobre 2026. https://lcp.fr/actualites/presidentielle-une-dynamique-melenchon-chez-les-ecologistes-au-risque-de-fracturer-le
- Public Sénat, « Présidentielle 2027 : le débat sur l'inéligibilité de Marine Le Pen relancé », 2 novembre 2026. https://www.publicsenat.fr/actualites/politique/presidentielle-2027-le-debat-sur-lineligibilite-de-marine-le-pen-relance
- Odile Jacob, « Réussir à l'ère des crises. Un plan robuste pour l'économie française », paru le 14 octobre 2026. https://www.odilejacob.fr/catalogue/sciences-humaines/economie-et-finance/reussir-a-l-ere-des-crises_9782415016722.php
- Service-Public.fr, « Les dates de l'élection présidentielle de 2027 sont annoncées », 2 juillet 2026. https://www.service-public.gouv.fr/particuliers/actualites/A15053
- Consultées sans être retenues comme source : Infodujour, 27 octobre (Cluster17) ; Business AM, 26 octobre (meeting d'Orléans, article tronqué) ; LCP et Public Sénat (dossiers présidentielle) ; Toute l'Europe (14 octobre) ; LCP, Lisnard, Glucksmann, Braun-Pivet, Villepin, Philippe (1er novembre).

## Mode d'emploi

1. phpMyAdmin → base → onglet **Importer** → `saisie.sql`. Le contrôle final affiche 13 sources, 5 faits, 12 résultats de sondage et 1 position.
2. Relire ce rapport ; dans `validation.sql`, supprimer les blocs refusés (blocs 3 et 10 à arbitrer).
3. Onglet **SQL** → coller et exécuter `validation.sql`. Le contrôle final affiche « digest_publie 1 », « faits_valides 5 », « sondage valide ».
4. GitHub → Actions → **Publier les données** → Run workflow (ou attendre la régénération horaire).
