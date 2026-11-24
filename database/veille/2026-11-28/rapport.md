# Veille Repères 2027 · S48 · du 22 au 28 novembre 2026 · provisoire au 24 novembre

Préparée le mardi 24 novembre 2026 selon `docs/prompt-veille.md`.

**Important :** la semaine n'est pas terminée. Cette version S48 est volontairement provisoire : elle ne retient que les faits déjà survenus et vérifiés au 24 novembre. Aucun événement du 25 au 28 novembre n'est anticipé.

État de départ : le `site.json` public n'a pas pu être lu directement depuis l'environnement de veille. Le snapshot du dépôt `public/data/site.json` est généré le **4 novembre 2026**, en phase `declares`, et son dernier digest publié couvre **du 25 au 31 octobre 2026**. Les semaines antérieures manquantes ne sont pas rattrapées ici.

## 1. Synthèse

- Génération.s annonce le 23 novembre soutenir Jean-Luc Mélenchon ; ses adhérents ont approuvé ce choix à 85 %.
- Toluna Harris Interactive publie le 23 novembre une nouvelle vague d'intentions de vote : Marine Le Pen est à 30-31 %, Jean-Luc Mélenchon à 18-19 % et David Lisnard à 11-12 % selon les hypothèses.
- Aucun nouveau changement de candidature propre à S48 n'est retenu à ce stade ; les annonces de Teddy Riner, Dominique de Villepin et le retrait de François Ruffin sont antérieurs au 22 novembre.
- Une seconde réunion des équipes de Gabriel Attal, Bruno Retailleau et David Lisnard est annoncée pour le 26 novembre sur les modalités d'une éventuelle primaire ; elle reste un événement futur au moment de cette veille.
- Aucun fait institutionnel nouveau ni publication du Shift Project directement liée à la présidentielle n'est retenu au 24 novembre.

## 2. Faits retenus pour le digest

Ordre d'affichage proposé : date décroissante. Deux faits seulement sont retenus à ce stade : le plafond est de cinq, pas un objectif à atteindre.

| Ordre | Date | Type | Axe | Portée | Fait | Candidats liés | Sources |
| --- | --- | --- | --- | --- | --- | --- | --- |
| 1 | 23 nov. | ralliement | 1 · Candidatures | course | Génération.s annonce soutenir Jean-Luc Mélenchon après un vote de ses adhérents approuvé à 85 %, et conclut un accord de majorité législative avec LFI. | melenchon | LCP, 23 nov. ; TF1 Info avec AFP, 23 nov. |
| 2 | 23 nov. | sondage | 4 · Opinion | signal | Toluna Harris Interactive publie une enquête de premier tour : Marine Le Pen 30-31 %, Jean-Luc Mélenchon 18-19 % et David Lisnard 11-12 % selon les trois hypothèses testées. | le-pen, melenchon, lisnard | Toluna Harris Interactive, 23 nov. ; Commission des sondages, notice 10393 |

### Justification du radar

- **Ralliement Génération.s** : classement par défaut `axe = 1`, `portee = 'course'`, car il modifie le champ des soutiens organisés autour d'une candidature.
- **Sondage Toluna Harris Interactive** : classement par défaut `axe = 4`, `portee = 'signal'`.

## 3. Autres mises à jour proposées

### 3.1 Candidatures : état du dépôt à ne pas confondre avec S48

Le snapshot du 4 novembre est antérieur à plusieurs changements déjà intervenus. Ils doivent être contrôlés dans la base de production, mais **ne doivent pas être rattrapés dans le digest S48** :

| Événement antérieur | Date réelle | Situation dans le snapshot du dépôt | Action |
| --- | --- | --- | --- |
| Teddy Riner annonce sa candidature | 9 nov. | absent | Vérifier s'il est déjà créé en production ; sinon à traiter dans la veille manquante correspondante, pas dans S48 |
| Dominique de Villepin officialise sa candidature | 20 nov. | absent | Même règle : vérifier la production, ne pas l'ajouter au digest S48 |
| François Ruffin retire sa candidature | 21 nov. | `declare` | Vérifier la production ; événement hors période S48, donc pas de rattrapage ici |

Sources de contrôle :
- TF1 Info, « Le judoka et champion olympique Teddy Riner est candidat à l'élection présidentielle 2027 », 9 novembre 2026.
- TF1 Info, « "Je suis candidat à l'élection présidentielle de 2027" : Dominique de Villepin se lance officiellement dans la course à l'Élysée », 20 novembre 2026.
- LCP, « François Ruffin se retire de la présidentielle 2027 sans soutenir aucun des candidats de gauche encore en lice », 21 novembre 2026.

### 3.2 Primaire droite-centre : échéance annoncée au 26 novembre

Une seconde réunion des directeurs de campagne de **Gabriel Attal**, **Bruno Retailleau** et **David Lisnard** est annoncée pour le **jeudi 26 novembre en fin d'après-midi**. Édouard Philippe refuse toujours le principe de la primaire.

**Proposition :** ne pas en faire un fait du digest avant sa tenue. Si la réunion débouche sur un accord formel (dates, périmètre, règles, engagement de retrait ou soutien au vainqueur), réévaluer en priorité 1 avant la clôture de S48.

Source : Le Figaro, direct du 22 novembre 2026, « Présidentielle 2027 : David Lisnard assure qu’il ne gouvernera pas avec le RN et qu’il n’a pas "voulu devenir ministre macroniste" ».

### 3.3 Sondage de référence : Toluna Harris Interactive, vague 10

Le sondage actuellement visible dans le snapshot du dépôt est l'enquête Ipsos bva-CESI pour Le Parisien des 21-22 octobre 2026.

La vague 10 Toluna Harris Interactive publiée le 23 novembre est plus récente.

**Méthodologie vérifiée sur la notice de la Commission des sondages :**
- commanditaires : M6, RTL et L'Express ;
- terrain : **18-19 novembre 2026** ;
- échantillon : **2 088 personnes inscrites sur les listes électorales**, issu d'un échantillon de 2 378 personnes représentatif de la population française âgée de 18 ans et plus ;
- enquête en ligne, méthode des quotas et redressement ;
- marge d'erreur annoncée : environ ±1,4 à ±3,0 points selon le score ;
- trois hypothèses de premier tour.

**Fourchettes publiées sur les trois hypothèses :**

| Candidat | Fourchette |
| --- | ---: |
| Nathalie Arthaud | 1 % |
| Jean-Luc Mélenchon | 18-19 % |
| Fabien Roussel | 1 % |
| Marine Tondelier | 1-2 % |
| Raphaël Glucksmann | 11 % |
| Gabriel Attal | 4-7 % |
| Édouard Philippe | 9-10 % |
| Dominique de Villepin | 1-2 % |
| David Lisnard | 11-12 % |
| Bruno Retailleau | 4-5 % |
| Nicolas Dupont-Aignan | 1 % |
| Marine Le Pen | 30-31 % |
| Éric Zemmour | 3-4 % |
| Teddy Riner | 4-5 % |

**Point bloquant avant toute saisie SQL :** le snapshot du dépôt ne contient ni `riner` ni `villepin`. Vérifier d'abord le `site.json` de production. Si ces candidatures n'existent pas encore dans la base, le sondage ne doit pas être importé partiellement en inventant des slugs ou en supprimant leurs résultats.

### 3.4 Programmes

Aucune publication de programme entièrement nouvelle et datée du 22 au 24 novembre n'est retenue à ce stade.

La presse du 22 novembre rapporte des ajustements du « pacte pour la jeunesse » de Gabriel Attal après une convention tenue le **21 novembre**. L'événement source étant hors période S48, il n'est pas retenu comme fait du digest. Les éventuelles modifications précises du programme pourront être intégrées lorsqu'une source de campagne datée et stabilisée les publiera.

### 3.5 Positions dans les débats suivis

Aucune nouvelle déclaration vérifiée du 22 au 24 novembre ne permet, sans interprétation, de placer un candidat sur l'un des huit débats présents dans le snapshot du dépôt.

### 3.6 The Shift Project

Aucune publication, consultation ou interpellation de candidat datée du 22 au 24 novembre et explicitement rattachée à la présidentielle n'a été identifiée.

### 3.7 Biographies

Aucune biographie nouvelle n'est préparée dans cette veille provisoire. Les candidatures de Teddy Riner et Dominique de Villepin sont antérieures à S48 et doivent d'abord être contrôlées dans la base de production.

## 4. Faits écartés

| Date | Fait | Raison |
| --- | --- | --- |
| 22 nov. | David Lisnard présente la primaire comme un « pré-premier tour » et réaffirme vouloir y associer Édouard Philippe ; il juge Reconquête admissible sous conditions. | Position déjà exprimée les jours précédents ; pas de décision nouvelle sur l'organisation de la primaire. |
| 22 nov. | Marine Le Pen indique ne pas prévoir de déplacement à l'étranger pendant la campagne, y compris à Kiev. | Choix d'organisation de campagne, sans effet sur la liste des candidatures, les règles, le programme ou un débat suivi. |
| 22 nov. | Gabriel Attal fait évoluer certains éléments de son « pacte pour la jeunesse » après une convention avec 150 jeunes. | La convention a eu lieu le 21 novembre, hors S48 ; attendre une publication primaire stabilisée des mesures modifiées. |
| 24 nov. | Ouverture du 108e Congrès des maires, où plusieurs candidats sont attendus pour rechercher des promesses de parrainage. | Événement de contexte ; aucun nouveau nombre de parrainages officiel ou changement de règle constaté à ce stade. |
| 24 nov. | Baromètre Odoxa-Mascaret : David Lisnard dépasse Édouard Philippe en popularité. | Baromètre de popularité, pas une intention de vote au premier tour ; hors catégorie « sondages » du digest. |

## 5. Points à vérifier avant clôture de S48

1. **État réel de production.** Relire `https://nogues.app/presidentielle/data/site.json` et contrôler `meta.genere_le`, `semaine.periode`, les candidatures Riner / de Villepin / Ruffin et le sondage courant.
2. **Réunion du 26 novembre.** Vérifier après sa tenue s'il existe un accord formel sur la primaire droite-centre. Ne rien anticiper.
3. **Conseil fédéral des Écologistes du 26 novembre.** Une réunion interne est annoncée pour fixer les scénarios soumis au vote du 13 décembre. Vérifier si elle modifie le statut de Marine Tondelier ou formalise une option de ralliement.
4. **Sondage Toluna.** Ne pas importer tant que les slugs des candidats testés ne sont pas tous confirmés dans la base.
5. **Parrainages au Congrès des maires.** Une promesse de soutien politique ne doit pas être confondue avec un parrainage officiel transmis au Conseil constitutionnel.
6. **Fin de semaine.** Refaire la recherche du 25 au 28 novembre avant de considérer cette veille comme consolidée.

Rien de cette section ne doit entrer dans un SQL tant que le point n'est pas vérifié.

## 6. Arbitrages suggérés

### Comparateur

Aucun changement automatique n'est proposé dans cette version provisoire. Le critère « groupe parlementaire ou 2 % de moyenne dans les trois dernières enquêtes » nécessite l'état de production et les trois enquêtes réellement retenues par le site.

### Sondage de référence

La vague 10 Toluna Harris Interactive est un bon candidat pour remplacer l'enquête Ipsos d'octobre, car elle est plus récente et sa notice Commission des sondages est disponible. Décision à prendre après contrôle des candidatures manquantes dans le snapshot.

### Nouveau débat

Aucun nouveau débat n'est proposé au 24 novembre.

### Erratum

Aucun erratum nouveau n'est identifié dans S48 à ce stade.

## 7. Sources consultées

Consultation : **24 novembre 2026**.

### Niveau 1 — officielle

- Commission des sondages, **« 10393 Pres IV Vague 10 TOLUNA HARRIS INTERACTIVE 23 novembre »**, novembre 2026.  
  https://www.commission-des-sondages.fr/notices/medias/fichiers/add/2417

### Niveau 3 — médias de référence

- LCP, **« Présidentielle: Génération.s officialise son soutien à Jean-Luc Mélenchon »**, 23 novembre 2026.  
  https://lcp.fr/actualites/presidentielle-generations-officialise-son-soutien-a-jean-luc-melenchon-445502
- TF1 Info avec AFP, **« Un ralliement de plus à la candidature de Jean-Luc Mélenchon : Génération.s conclut un accord législatif avec LFI »**, 23 novembre 2026.  
  https://www.tf1info.fr/politique/elections/presidentielle/un-ralliement-de-plus-a-la-candidature-de-jean-luc-melenchon-generation-s-conclut-un-accord-legislatif-avec-lfi-2477637.html
- TF1 Info, **« Le judoka et champion olympique Teddy Riner est candidat à l'élection présidentielle 2027 »**, 9 novembre 2026.  
  https://www.tf1info.fr/politique/elections/presidentielle/le-judoka-et-champion-olympique-teddy-riner-est-candidat-a-l-election-presidentielle-2027-2474763.html
- TF1 Info, **« "Je suis candidat à l'élection présidentielle de 2027" : Dominique de Villepin se lance officiellement dans la course à l'Élysée »**, 20 novembre 2026.  
  https://www.tf1info.fr/politique/elections/presidentielle/je-suis-candidat-a-l-election-presidentielle-de-2027-dominique-de-villepin-se-lance-officiellement-dans-la-course-a-l-elysee-2477099.html
- LCP, **« François Ruffin se retire de la présidentielle 2027 sans soutenir aucun des candidats de gauche encore en lice »**, 21 novembre 2026.  
  https://lcp.fr/actualites/francois-ruffin-se-retire-de-la-presidentielle-2027-sans-soutenir-aucun-des-candidats-de
- Le Parisien avec AFP, **« Présidentielle 2027 : David Lisnard voit une primaire comme "le pré-premier tour" et "un moyen d'exclure les macronistes" »**, 22 novembre 2026.  
  https://www.leparisien.fr/elections/presidentielle/presidentielle-2027-david-lisnard-voit-une-primaire-comme-le-pre-premier-tour-et-un-moyen-dexclure-les-macronistes-22-11-2026-NV73BW4JAJAO5IYVOPOYOCXCUI.php
- Le Parisien avec AFP, **« Présidentielle 2027 : contrôle continu, horaires… Gabriel Attal veut modifier son "pacte jeunesse" pour mieux refléter les préoccupations »**, 22 novembre 2026.  
  https://www.leparisien.fr/elections/presidentielle/presidentielle-2027-controle-continu-horaires-gabriel-attal-veut-modifier-son-pacte-jeunesse-pour-mieux-refleter-les-preoccupations-22-11-2026-37NQJ22MMRGXVHJSVNHGV4T2SY.php
- TF1 Info, dossier présidentielle, **« Présidentielle 2027 : le congrès des maires, passage obligé pour candidats en quête de parrainages ? »**, 24 novembre 2026.  
  https://www.tf1info.fr/politique/elections/presidentielle/

### Niveau 4 — institut

- Toluna Harris Interactive, **« Intentions de vote à l’élection présidentielle 2027 – Vague 10 »**, 23 novembre 2026.  
  https://tolunacorporate.com/fr/intentions-de-vote-a-lelection-presidentielle-2027-vague-10/

### Projet Repères 2027

- `public/data/site.json`, généré le 4 novembre 2026.
- `docs/prompt-veille.md`.
- `docs/saisie.md`.
- `docs/modele-de-donnees.md`.

## 8. Contrôle avant remise

- [x] Période S48 selon la convention du site : dimanche 22 au samedi 28 novembre 2026.
- [x] Version explicitement provisoire au 24 novembre ; aucun fait futur inventé.
- [x] Deux faits retenus seulement, chacun daté et sourcé.
- [x] Axe et portée renseignés.
- [x] Sondage vérifié sur la publication de l'institut et la notice de la Commission des sondages.
- [x] Fourchettes reprises sans extrapolation.
- [x] Semaines antérieures non rattrapées.
- [x] Faits incertains ou futurs exclus du digest.
- [ ] Anti-doublon définitif avec le `site.json` de production à refaire avant import.
- [ ] Recherche complémentaire du 25 au 28 novembre nécessaire pour une version consolidée.
- [ ] Aucun `saisie.sql` ni `validation.sql` généré dans cette version, l'utilisateur ayant demandé la publication du **.MD** seulement.

