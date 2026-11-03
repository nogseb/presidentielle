# Veille Repères 2027 · semaine du 25 au 31 octobre 2026

Préparée le mardi 3 novembre 2026. Digest : du dimanche 25 au samedi 31 octobre 2026. Autres mises à jour (candidatures, sondage, calendrier) : tout ce qui est paru depuis les données du 17 octobre.

État de départ : le fichier `data/site.json` en ligne n'était pas consultable depuis l'environnement de veille. L'état de référence est celui du dépôt (`database/seed/`), qui correspond à la base importée le 18 octobre. Toute saisie faite depuis dans phpMyAdmin n'a pas été prise en compte.

## 1. Synthèse

- Le bloc central cherche un mode de désignation : Gabriel Attal propose une « grande primaire des démocrates », rejetée par les équipes d'Édouard Philippe et de Bruno Retailleau ; Yaël Braun-Pivet plaide pour un candidat unique.
- Le gouvernement maintient les dates du scrutin (18 avril et 2 mai 2027).
- Raphaël Glucksmann installe son équipe de campagne ; David Lisnard brigue aussi sa réélection à la tête de l'AMF.
- Nouvelle enquête de référence : Ipsos bva-CESI pour Le Parisien (21-22 octobre), première mesure après la primaire de la gauche sociale-démocrate.
- The Shift Project a publié le 14 octobre son livre « Réussir à l'ère des crises » (Odile Jacob).

## 2. Faits retenus pour le digest (5)

| Ordre | Date | Type | Fait | Candidats liés | Sources |
| --- | --- | --- | --- | --- | --- |
| 1 | 28 oct. | calendrier | Le gouvernement exclut de modifier les dates du scrutin, fixées aux 18 avril et 2 mai 2027, après des demandes en ce sens, dont celle de Bruno Retailleau. | retailleau | LCP, 28 oct. |
| 2 | 28 oct. | primaire | Gabriel Attal propose sur TF1 une « grande primaire des démocrates », qu'il présente comme un moyen d'éviter un second tour RN-LFI ; les équipes d'Édouard Philippe et de Bruno Retailleau la rejettent le lendemain. | attal, philippe, retailleau | LCP, 28 oct. ; Public Sénat, 29 oct. |
| 3 | 28 oct. | autre | David Lisnard brigue sa réélection à la présidence de l'Association des maires de France, prévue fin novembre ; Marc Fesneau dénonce un « mélange des genres » avec sa candidature à la présidentielle. | lisnard | Public Sénat, 28 oct. |
| 4 | 27 oct. | autre | Raphaël Glucksmann compose son équipe de campagne : la sénatrice Laurence Rossignol préside son association de financement et le sénateur Alexandre Ouizille doit en devenir le directeur. | glucksmann | Public Sénat, 27 oct. |
| 5 | 27 oct. | autre | Dans Le Figaro, Yaël Braun-Pivet plaide pour un candidat unique du centre et de la droite et cite Gérard Larcher parmi ceux qui pourraient incarner ce rassemblement. | aucun | LCP, 27 oct. |

Ordre retenu : règles du scrutin, puis désignation des candidats, puis organisation des campagnes. Familles politiques : gouvernement, bloc central, droite, gauche sociale-démocrate. La semaine précédente portait sur Polony, Glucksmann, Retailleau et des parlementaires RN et UDR.

## 3. Autres mises à jour proposées

| N° | Objet | En ligne aujourd'hui | Proposition | Source | Bloc de `validation.sql` |
| --- | --- | --- | --- | --- | --- |
| 3.1 | Sondage de référence | Enquête électorale Ipsos bva (terrain du 3 au 9 septembre, 13 060 inscrits) | Ipsos bva-CESI pour Le Parisien, terrain du 21 au 22 octobre, 1 500 inscrits, quatre hypothèses, 12 candidats en fourchette | Ipsos, 24 oct. ; rapport complet (cesi.fr) | 2 |
| 3.2 | Éric Zemmour | « Annonce », badge « Déclaration formelle attendue » (Toute l'Europe, 14 oct.) | « Déclaration », badge retiré, note « Candidature officialisée sur BFMTV le 17 septembre 2026 » | LCP, 17 sept. : « Éric Zemmour officialise sa candidature » | 3 (à arbitrer, voir 5) |
| 3.3 | Marine Tondelier | Note : vote des militants le 13 décembre | Note et calendrier précisés : les adhérents choisiront entre sa candidature et le soutien à un candidat extérieur au parti | LCP, 23 oct. | 4 |
| 3.4 | Marine Le Pen | Note : condamnée en appel le 7 juillet 2026, pourvoi en cours, éligible à ce stade | Note complétée : 45 mois d'inéligibilité dont 30 avec sursis, sans exécution provisoire ; décision de cassation possible avant début 2027 ; éligibilité discutée entre juristes | Public Sénat, 2 nov. | 5 |
| 3.5 | The Shift Project | Calendrier : livre « annoncé », octobre 2026 | Calendrier : « fait », 14 octobre 2026 ; dispositif « Plan robuste » mis à jour, source Odile Jacob ajoutée | Odile Jacob (fiche de l'ouvrage) | 6 |

Fourchettes du sondage 3.1 (score le plus bas et le plus haut selon les hypothèses) : Le Pen 32-33,5 ; Mélenchon 17 ; Glucksmann 13-15,5 ; Philippe 13-15 ; Retailleau 5,5-11,5 ; Attal 4-9,5 ; Lisnard 6,5 ; Zemmour 4-4,5 ; Tondelier 3,5 ; Roussel 2-2,5 ; Dupont-Aignan 1,5-2 ; Arthaud 0,5. Attal, Lisnard et Retailleau ne sont pas testés dans toutes les hypothèses (précisé dans la note du sondage).

Positions dans les débats suivis : aucune déclaration nouvelle relevée sur les huit débats.

## 4. Faits écartés

| Date | Fait | Raison |
| --- | --- | --- |
| 27 oct. | Baromètre Odoxa-Mascaret pour Public Sénat : cotes d'adhésion de Glucksmann (+4) et Lisnard (+8) en hausse | Popularité, pas intention de vote ; dates de terrain et échantillon absents de l'article |
| 28 oct. | Entretien de Didier Guérin (Le Monde) estimant Marine Le Pen inéligible jusqu'à la décision de cassation | Opinion d'un juriste, pas un acte de procédure ; reprise dans la note 3.4 comme « débat entre juristes » |
| 26 oct. | Raphaël Glucksmann dénonce une « campagne de harcèlement » de LFI | Échange de déclarations, sans effet sur la course |
| 26 oct. | LCP : comparatif des propositions des candidats sur Parcoursup | Article de synthèse, pas un fait ; utile pour le quiz 2027 (section 6) |

Hors période du digest, à signaler :

- Semaine du 18 au 24 octobre, sans digest : enquête Ipsos-Le Parisien (reprise en 3.1) ; Dominique de Villepin dit avoir « dépassé la barre des 300 signatures » d'élus et annonce une décision « au cours des prochaines semaines » (LCP, 23 oct.) ; Michel Barnier plaide pour une primaire de la droite et du centre (Public Sénat, 22 oct.) ; un député écologiste se dit proche du projet de LFI et huit députés écologistes contestent une candidature autonome (LCP, 23 oct.).
- À reprendre dans le digest du 1er au 7 novembre : Édouard Philippe écarte sur TF1 la primaire proposée par Gabriel Attal (1er nov.) ; Gabriel Attal maintient sa proposition (2 nov.) ; débat sur l'éligibilité de Marine Le Pen (Public Sénat, 2 nov.).

## 5. Points à vérifier

- **Zemmour (3.2)** : LCP titre le 17 septembre « Éric Zemmour officialise sa candidature », tandis que Toute l'Europe (14 octobre) attend encore une déclaration formelle. Garder le bloc 3 si l'on retient la formule « je serai candidat » comme déclaration ; le supprimer sinon.
- **Notice de la Commission des sondages** pour l'enquête Ipsos-Le Parisien : non trouvée ; le site renverra à la page d'accueil de la Commission tant que `url_notice` est vide.
- **Candidatures signalées par des agrégateurs, non confirmées par un média de référence** : Gilles Platret, Sylvain Durif. Non saisies.
- **Bruno Le Maire** avait annoncé une décision « en octobre » (LCP, 23 juin) : aucune annonce trouvée au 3 novembre.
- **Dominique de Villepin** : pas de déclaration formelle ; à surveiller.

## 6. Arbitrages suggérés

- **Ouvrir le comparateur complet.** Aucun candidat n'y figure encore. Selon le critère publié (parti doté d'un groupe parlementaire, ou 2 % de moyenne dans les trois dernières enquêtes), remplissent a priori le premier critère : Marine Le Pen, Jean-Luc Mélenchon, Raphaël Glucksmann, Gabriel Attal, Édouard Philippe, Bruno Retailleau, Marine Tondelier, Fabien Roussel. À vérifier sur les trois dernières enquêtes : Éric Zemmour et David Lisnard.
- **Quiz, édition 2027** : le comparatif LCP sur Parcoursup (26 oct.) peut servir de base à une affirmation « Supprimer Parcoursup » pour les candidats de 2027, après vérification sur leurs sources.
- **Grille The Shift Project** : la parution du livre (14 octobre) permet l'étape 1 prévue, le regroupement des mesures par chapitre du livre, avec l'intégration du radar.

## 7. Sources consultées (le 3 novembre 2026)

- LCP, « Présidentielle 2027: pour le gouvernement, il n'y a "pas de raison de changer" les dates de l'élection », 28 octobre 2026. https://lcp.fr/actualites/presidentielle-2027-pour-le-gouvernement-il-n-y-a-pas-de-raison-de-changer-les-dates-de
- LCP, « Présidentielle 2027: Gabriel Attal veut une "grande primaire des démocrates" pour éviter un second tour RN-LFI », 28 octobre 2026. https://lcp.fr/actualites/presidentielle-2027-gabriel-attal-veut-une-grande-primaire-des-democrates-pour-eviter-un
- Public Sénat, « Après la proposition de primaire de Gabriel Attal, rejetée par le camp Philippe et Retailleau, le blocage perdure », 29 octobre 2026. https://www.publicsenat.fr/actualites/politique/apres-la-proposition-de-primaire-de-gabriel-attal-rejetee-par-le-camp-philippe-et-retailleau-le-blocage-perdure
- Public Sénat, « Candidat à la présidentielle et à la présidence de l'AMF : Marc Fesneau dénonce le « mélange des genres » de David Lisnard », 28 octobre 2026. https://www.publicsenat.fr/actualites/politique/candidat-a-la-presidentielle-et-a-la-presidence-de-lamf-marc-fesneau-denonce-le-melange-des-genres-de-david-lisnard
- Public Sénat, « Présidentielle : la sénatrice PS Laurence Rossignol va gérer les finances de la campagne de Raphaël Glucksmann », 27 octobre 2026. https://www.publicsenat.fr/actualites/politique/presidentielle-la-senatrice-ps-laurence-rossignol-va-gerer-les-finances-de-la-campagne-de-raphael-glucksmann
- LCP, « Présidentielle: Yaël Braun-Pivet plaide pour un "candidat unique" du centre et de la droite, mentionnant Gérard Larcher comme recours possible », 27 octobre 2026. https://lcp.fr/actualites/presidentielle-yael-braun-pivet-plaide-pour-un-candidat-unique-du-centre-et-de-la-droite
- Ipsos bva, « Présidentielle 2027 : Mélenchon progresse, Le Pen reste en tête », 24 octobre 2026, et rapport complet. https://www.ipsos.com/fr-fr/presidentielle-2027-melenchon-progresse-le-pen-reste-en-tete ; https://www.cesi.fr/wp-content/uploads/2026/10/presidentielle-2027-intention-vote-octobre26-rapport-complet-web.pdf
- LCP, « Présidentielle 2027: Éric Zemmour officialise sa candidature », 17 septembre 2026. https://lcp.fr/actualites/presidentielle-2027-eric-zemmour-officialise-sa-candidature-441871
- LCP, « Présidentielle: une dynamique Mélenchon chez Les Écologistes au risque de fracturer le parti? », 23 octobre 2026. https://lcp.fr/actualites/presidentielle-une-dynamique-melenchon-chez-les-ecologistes-au-risque-de-fracturer-le
- Public Sénat, « Présidentielle 2027 : le débat sur l'inéligibilité de Marine Le Pen relancé », 2 novembre 2026. https://www.publicsenat.fr/actualites/politique/presidentielle-2027-le-debat-sur-lineligibilite-de-marine-le-pen-relance
- Odile Jacob, « Réussir à l'ère des crises. Un plan robuste pour l'économie française », paru le 14 octobre 2026. https://www.odilejacob.fr/catalogue/sciences-humaines/economie-et-finance/reussir-a-l-ere-des-crises_9782415016722.php
- Consultées sans être retenues comme source : LCP, dossier « Présidentielle 2027 » ; Public Sénat, dossier « Élection présidentielle 2027 » ; Toute l'Europe (mise à jour du 14 octobre) ; LCP, Villepin, 23 octobre ; LCP, Philippe, 1er novembre ; Public Sénat, baromètre Odoxa, 27 octobre ; Tecsol Quotidien, 19 octobre (livre du Shift Project).

## Mode d'emploi

1. phpMyAdmin → base → onglet **Importer** → `saisie.sql`. Le contrôle final affiche 11 sources, 5 faits et 12 résultats de sondage.
2. Relire ce rapport ; dans `validation.sql`, supprimer les blocs refusés (le bloc 3 est à arbitrer).
3. Onglet **SQL** → coller et exécuter `validation.sql`. Le contrôle final affiche « digest_publie 1 », « faits_valides 5 », « sondage valide ».
4. GitHub → Actions → **Publier les données** → Run workflow (ou attendre la régénération horaire).
