# Veille Repères 2027 · semaine du 1er au 7 novembre 2026

Préparée le mardi 10 novembre 2026 par Claude avec le prompt `docs/prompt-veille.md`, à la demande de Sébastien Noguès (« prépare et publie »). Chaque élément retenu a été lu sur sa source le 10 novembre ; ce qui n'a pas pu l'être figure en section 5.

Digest : du dimanche 1er au samedi 7 novembre 2026. Autres mises à jour : tout ce qui est paru depuis la veille du 25 au 31 octobre.

État de départ : le `site.json` de production n'est pas lisible depuis l'environnement de la veille. L'état de référence est celui du dépôt (`database/seed/` jusqu'à 080, puis `database/veille/2026-10-31/`), qui correspond à la base importée le 4 novembre.

## 1. Synthèse

- La France insoumise publie le 6 novembre « L'Avenir en commun », programme de Jean-Luc Mélenchon, présenté le 7 au Bourget.
- Neuf députés du groupe GDR, dont quatre communistes, soutiennent Jean-Luc Mélenchon plutôt que Fabien Roussel ; le PCF les considère « en dehors du parti ».
- La primaire de la droite et du centre reste en débat : refus d'Édouard Philippe, maintien de Gabriel Attal, soutien de Bruno Retailleau à une primaire « en début d'année ».
- Sondage Ifop pour LCI (terrain du 27 au 29 octobre) : Marine Le Pen en tête, Jean-Luc Mélenchon deuxième dans toutes les hypothèses.
- Aucune déclaration ni aucun retrait de candidature relevé dans la semaine.

## 2. Faits retenus pour le digest (4)

Ordre d'affichage du site : date décroissante. Axe et portée : règle par défaut du type pour les quatre faits (aucun écart à justifier).

| Ordre | Date | Type | Radar | Fait | Candidats liés | Sources |
| --- | --- | --- | --- | --- | --- | --- |
| 1 | 6 nov. | programme | 3 · engagement | La France insoumise publie « L'Avenir en commun », programme de Jean-Luc Mélenchon (1 069 mesures selon le mouvement, dont 238 nouvelles), présenté le lendemain lors d'un meeting au Bourget ; son financement doit être présenté début 2027. | melenchon | AFP, 6 nov. ; LCP, 6 nov. ; LCP, 7 nov. ; melenchon2027.fr |
| 2 | 5 nov. | ralliement | 1 · course | Neuf députés du groupe GDR, dont son président Stéphane Peu (quatre communistes et cinq ultramarins), annoncent soutenir Jean-Luc Mélenchon plutôt que Fabien Roussel ; le 7, le Conseil national du PCF estime que les adhérents soutenant un autre candidat se placent « en dehors du parti ». | melenchon, roussel | LCP, 5 nov. ; AFP, 7 nov. |
| 3 | 3 nov. | sondage | 4 · signal | Sondage Ifop pour LCI (terrain du 27 au 29 octobre) : Marine Le Pen de 35 à 37 % selon les hypothèses, Jean-Luc Mélenchon de 17,5 à 18 %, Édouard Philippe 15 % comme seul candidat du bloc central, Raphaël Glucksmann de 10 à 13 %. | le-pen, melenchon, philippe, glucksmann | Commission des sondages (notice) ; Public Sénat, 4 nov. |
| 4 | 1er nov. | primaire | 1 · signal | Sur TF1, Édouard Philippe refuse le 1er novembre la « grande primaire des démocrates » proposée par Gabriel Attal et renvoie les choix à février ; le 2, Gabriel Attal juge cette primaire « inéluctable » ; le 3, Bruno Retailleau estime qu'« il faudra une primaire sans doute en début d'année ». | philippe, attal, retailleau | LCP, 1er nov. ; LCP, 2 nov. ; AFP, 4 nov. |

Choix éditoriaux :

- Quatre faits plutôt que cinq : aucun cinquième fait ne disposait d'une source de référence lue en entier (section 4).
- Ordre de priorité du prompt : désignation et soutiens des candidats, programmes, sondages. Les faits 1 et 2 concernent tous deux Jean-Luc Mélenchon : ils relèvent de deux priorités distinctes (programme, ralliement) et sont les plus marquants de la semaine. L'équilibre entre familles politiques s'apprécie sur plusieurs semaines.
- Fait 3 : chiffres lus sur la notice de la Commission des sondages, seule source complète trouvée. La date retenue (3 novembre) est celle de la publication par LCI, rapportée par Public Sénat et LCP.
- Fait 4 : trois réactions successives sur un même sujet, regroupées en un fait daté du premier jour ; citations reprises à l'identique.

## 3. Autres mises à jour proposées

| N° | Objet | En ligne aujourd'hui | Proposition | Source | Bloc de `validation.sql` |
| --- | --- | --- | --- | --- | --- |
| 3.1 | Sondage de référence | Ipsos bva-CESI pour Le Parisien (21-22 octobre) | Ifop pour LCI (27-29 octobre, 1 501 inscrits, quatre hypothèses, 12 candidats en fourchette) | Commission des sondages, notice n° 122887 | 2 |
| 3.2 | Jean-Luc Mélenchon | Programme « non publié à ce jour » | Lien vers « L'Avenir en commun » (lecture en ligne), daté du 6 novembre 2026 | melenchon2027.fr | 3 |
| 3.3 | Débats suivis | Aucune position de Jean-Luc Mélenchon | Sept positions tirées du programme, saisies à l'état « à valider », **non validées** | melenchon2027.fr, quatre chapitres | 4, vide |

Fourchettes du sondage 3.1 : Le Pen 35-37 ; Mélenchon 17,5-18 ; Philippe 9,5-15 ; Glucksmann 10-13 ; Attal 5-9 ; Lisnard 7-9 ; Retailleau 4-7 ; Zemmour 4-4,5 ; Tondelier 3-3,5 ; Roussel 1,5-2 ; Dupont-Aignan 1,5-2 ; Arthaud 0,5-1. Tous les candidats testés existent dans la base.

Pourquoi Ifop plutôt que Toluna Harris Interactive : l'enquête Toluna Harris Interactive pour M6 et RTL (terrain du 3 au 5 novembre) est plus récente, mais publiée le 9 novembre, donc hors période ; elle teste aussi Dominique de Villepin, absent de la base. À examiner dans la veille du 8 au 14 novembre.

Positions 3.3 (détail dans `database/seed/090_programme_lfi_2026-11-10.sql`) : nouveaux réacteurs −2 ; moratoire sur les centres de données +1 ; encadrement de l'IA +2 ; hébergeur européen +2 ; budget de la culture +2 ; revenu des artistes-auteurs +2 ; enseignement supérieur privé +1. Le débat « thermiques 2035 » reste à documenter. Elles ne s'afficheront qu'avec l'ouverture du comparateur (section 6).

## 4. Faits écartés

| Date | Fait | Raison |
| --- | --- | --- |
| 3 nov. | Dominique de Villepin, sur France Inter, dit ne pas avoir de doute sur sa candidature mais que « ce n'est pas le moment » de l'annoncer | Non déclaré ; source de référence non lue en entier (franceinfo inaccessible, reprise L'Express par 6Médias seulement) |
| 3 nov. | François Hollande se prononcera en décembre sur une candidature | Mention secondaire dans un article sur Villepin ; à suivre |
| 6 nov. | Le FLNKS soutient Jean-Luc Mélenchon, après l'Union calédonienne | Moins prioritaire que les quatre faits retenus ; source non lue (franceinfo inaccessible) |
| 6 nov. | Marine Le Pen dénonce un « démantèlement » du pays à propos du programme de LFI | Réaction, pas un fait de campagne nouveau |
| 3 nov. | Bruno Retailleau propose trois débats thématiques (pouvoir d'achat, régalien, écologie) avant une éventuelle primaire | Repris dans le fait 4 pour la primaire seulement |
| 9 nov. | Sondage Toluna Harris Interactive pour M6 et RTL | Hors période (section 3.1) |

Hors période : sondage Ifop-Fiducial pour LCI, Le Figaro et Sud Radio (vague 7, terrain du 17 au 19 octobre, publié le 20 octobre), jamais repris dans un digest ; départ anticipé de Christine Lagarde de la BCE (29 octobre), sans lien établi avec une candidature.

## 5. Points à vérifier

- **Date de publication du sondage Ifop pour LCI** : la notice indique « novembre 2026 » sans jour ; le nom du fichier, Public Sénat et LCP désignent le mardi 3 novembre.
- **Citations du programme de LFI (3.3)** : relevées chapitre par chapitre avec un outil de lecture qui restitue le texte par fragments, puis réassemblées ; à contrôler sur les pages avant validation.
- **Fonction de Stéphane Peu** : président du groupe GDR selon L'Express et l'AFP ; LCP ne la rappelle pas.

## 6. Arbitrages suggérés

- **Ouvrir le comparateur complet** (inchangé depuis la veille précédente) : sans cette décision, les positions tirées des programmes restent invisibles. Ouvrir le seul Jean-Luc Mélenchon romprait l'égalité de traitement ; huit candidatures remplissent le critère du groupe parlementaire.
- **Dominique de Villepin** : testé par Ifop et Toluna Harris Interactive, il n'est pas dans la base. Règle à fixer : création de la fiche à la déclaration formelle seulement (règle actuelle) ou dès qu'il annonce qu'il sera candidat.
- **Accroche de la page « La semaine »** : le texte fixe « Cinq faits datés et sourcés » ne correspond pas à un digest de quatre faits ; proposer « Les faits datés et sourcés de la semaine ».

## 7. Sources (consultées le 10 novembre 2026)

- AFP (Bourse Direct), « Pour 2027, LFI présente un programme fidèle à sa volonté de rupture », 6 novembre 2026. https://www.boursedirect.fr/fr/actualites/categorie/politique/pour-2027-lfi-presente-un-programme-fidele-a-sa-volonte-de-rupture-afp-756b72dfa87a534448dbb17b657b6ba86a839fda
- LCP, « Présidentielle 2027: ce qui change dans le nouveau programme de Jean-Luc Mélenchon », 6 novembre 2026. https://lcp.fr/actualites/presidentielle-2027-ce-qui-change-dans-le-nouveau-programme-de-jean-luc-melenchon-444841
- LCP, « "Je vais l'offrir à mes grands-parents": au meeting de Mélenchon, les militants repartent avec le programme et une mission », 7 novembre 2026. https://lcp.fr/actualites/je-vais-l-offrir-a-mes-grands-parents-au-meeting-de-melenchon-les-militants-repartent
- Mélenchon 2027, « L'Avenir en commun », lecture en ligne. https://melenchon2027.fr/programme/livre/
- LCP, « Présidentielle: la moitié des députés communistes choisit Jean-Luc Mélenchon plutôt que Fabien Roussel », 5 novembre 2026. https://lcp.fr/actualites/presidentielle-la-moitie-des-deputes-communistes-choisit-jean-luc-melenchon-plutot-que
- AFP (Bourse Direct), « Présidentielle : les députés qui soutiennent LFI se sont mis "en dehors du parti", dit le PCF », 7 novembre 2026. https://www.boursedirect.fr/fr/actualites/categorie/politique/presidentielle-les-deputes-qui-soutiennent-lfi-se-sont-mis-en-dehors-du-parti-dit-le-pcf-afp-eeb8ae489c8da81969b8b85542078098bbcdf11a
- Commission des sondages, notice « Les intentions de vote au 1er tour de l'élection présidentielle 2027 » (Ifop pour LCI), novembre 2026. https://www.commission-des-sondages.fr/notices/files/notices/2026/novembre/10352-pres-iv-ifop-lci-3-novembre.pdf
- Public Sénat, « Sondage présidentielle 2027 : un second tour Le Pen - Mélenchon assuré, la droite et le bloc central peinent à remonter, Lisnard confirme sa percée », 4 novembre 2026. https://www.publicsenat.fr/actualites/politique/sondage-presidentielle-2027-un-second-tour-le-pen-melenchon-assure-la-droite-et-le-bloc-central-peine-a-remonter-lisnard-confirme-sa-percee
- LCP, « Présidentielle 2027: Edouard Philippe ne veut pas de la primaire de Gabriel Attal », 1er novembre 2026. https://lcp.fr/actualites/presidentielle-2027-edouard-philippe-ne-veut-pas-de-la-primaire-de-gabriel-attal-444599
- LCP, « "C'est inéluctable": Gabriel Attal s'accroche à sa primaire, malgré le refus d'Édouard Philippe », 2 novembre 2026. https://lcp.fr/actualites/c-est-ineluctable-gabriel-attal-s-accroche-a-sa-primaire-malgre-le-refus-d-edouard
- AFP (La DH), « Primaire à droite et au centre : Retailleau remet la pression sur Philippe », 4 novembre 2026. https://www.dhnet.be/dernieres-depeches/2026/11/04/primaire-a-droite-et-au-centre-retailleau-remet-la-pression-sur-philippe-C25CTRDLU5AMRJLJ2B5SM5QT6Q/
- Consultées sans être retenues comme source : LCP, « Présidentielle 2027: quels scénarios pour le bloc central et la droite? », 5 novembre ; Toluna, rapport de la vague 9 du baromètre M6-RTL, 9 novembre ; Ifop, baromètre vague 7, 20 octobre ; L'Express via 6Médias (Villepin, 3 novembre ; députés GDR, 5 novembre) ; Wikipédia (élection présidentielle de 2027), comme détecteur.

## Mode d'emploi

1. GitHub → Actions → **Importer une veille** → Run workflow : semaine `2026-11-07`, étape `saisie`. La trace `import-saisie.json` affiche 15 sources, 4 faits, 12 résultats de sondage et 7 positions.
2. Relire ce rapport ; retirer de `validation.sql` les blocs refusés.
3. Même workflow, étape `validation` : les lignes passent à l'état validé et le site est régénéré.

Sans le workflow : importer `saisie.sql` puis exécuter `validation.sql` dans phpMyAdmin, et lancer « Publier les données ».

Publication du 10 novembre 2026 : étapes 1 et 3 lancées par Claude à la demande de Sébastien Noguès ; positions 3.3 laissées à l'état « à valider ».
