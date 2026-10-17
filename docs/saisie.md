# Saisir et valider des données

La saisie se fait dans phpMyAdmin en attendant le back-office (V2). Règle unique : **rien n'est publié tant qu'une ligne n'est pas à l'état `valide`**, et l'export refuse toute ligne validée sans source.

## Le circuit

1. Ajouter la **source** (table `source`) : URL, titre, éditeur, libellé court du lien, niveau de 1 à 5.
2. Saisir l'information avec `etat = 'a_valider'`.
3. Relire sur la source primaire (et faire relire si la formulation peut être contestée), puis passer à `etat = 'valide'` en renseignant `verifie_le` et `verifie_par`.
4. Lancer **Actions → Publier les données**. Le rapport liste les alertes de la charte.

| État | Signification | Publié |
| --- | --- | --- |
| `brouillon` | en cours de rédaction | non |
| `a_valider` | prêt pour relecture | non |
| `valide` | relu et sourcé | oui |
| `retire` | retiré, conservé pour l'historique | non |

## Exemples prêts à copier (onglet SQL)

Les données d'exemple contiennent déjà deux propositions et une position de Bruno Retailleau à l'état `a_valider`.

### Valider une saisie relue

```sql
UPDATE proposition SET etat = 'valide', verifie_le = CURDATE(), verifie_par = 'SN'
WHERE code IN ('P-RET-001', 'P-RET-002');

UPDATE position_candidat p JOIN candidat c ON c.id = p.candidat_id
SET p.etat = 'valide', p.verifie_le = CURDATE(), p.verifie_par = 'SN'
WHERE c.slug = 'retailleau';
```

### Ouvrir la comparaison complète à un candidat (phase 1)

Le critère est publié dans la page Méthode : parti doté d'un groupe parlementaire, ou 2 % de moyenne dans les trois dernières enquêtes.

```sql
UPDATE candidat SET niveau = 'complet' WHERE slug IN ('retailleau', 'glucksmann');
```

### Ajouter une source puis une proposition

```sql
INSERT INTO source (cle, url, titre, editeur, libelle_court, date_publication, niveau, consultee_le)
VALUES ('programme-exemple-2027-01-15', 'https://exemple.fr/programme.pdf', 'Programme présidentiel', 'Équipe de campagne', 'Programme', '2027-01-15', 2, CURDATE());

INSERT INTO proposition (code, candidat_id, theme_id, intitule, type, chantier_id, statut_proposition, mesure_phare, source_id, source_page, etat)
VALUES ('P-XXX-001',
        (SELECT id FROM candidat WHERE slug = 'slug-du-candidat'),
        13,                                             -- thème Transports et mobilités
        'Doubler l''investissement public dans le ferroviaire',
        'chiffree',
        (SELECT id FROM chantier WHERE slug = 'train'), -- pastille The Shift Project
        'programme', 1,
        (SELECT id FROM source WHERE cle = 'programme-exemple-2027-01-15'), 'p. 42',
        'a_valider');
```

Intitulé : verbe à l'infinitif, 15 mots au plus, sans adjectif ni adverbe évaluatif. Trois mesures phares au plus par candidat et par thème.

### Placer un candidat sur une variable pivot

```sql
-- Valeur chiffrée
INSERT INTO position_candidat (candidat_id, variable_id, valeur_num, statut_position, source_id, extrait, etat)
VALUES ((SELECT id FROM candidat WHERE slug = 'slug-du-candidat'),
        (SELECT id FROM variable WHERE slug = 'age-legal'),
        62, 'programme', (SELECT id FROM source WHERE cle = 'programme-exemple-2027-01-15'),
        'Retour de l''âge légal à 62 ans', 'a_valider');

-- Choix entre options
INSERT INTO position_candidat (candidat_id, variable_id, modalite_id, statut_position, source_id, etat)
VALUES ((SELECT id FROM candidat WHERE slug = 'slug-du-candidat'),
        (SELECT id FROM variable WHERE slug = 'voitures-thermiques'),
        (SELECT m.id FROM modalite m JOIN variable v ON v.id = m.variable_id
          WHERE v.slug = 'voitures-thermiques' AND m.libelle = 'Maintenir l''échéance de 2035'),
        'programme', (SELECT id FROM source WHERE cle = 'programme-exemple-2027-01-15'), 'a_valider');

-- Absence de position, vérifiée
INSERT INTO position_candidat (candidat_id, variable_id, non_aborde, etat, verifie_le, verifie_par)
VALUES ((SELECT id FROM candidat WHERE slug = 'slug-du-candidat'),
        (SELECT id FROM variable WHERE slug = 'vote-16-ans'), 1, 'a_valider', CURDATE(), 'SN');
```

Sur le site, une position absente de la base s'affiche « À documenter » ; une position `non_aborde = 1` s'affiche « Non abordé ».

### Rapprocher un candidat d'un chantier du Shift Project

```sql
INSERT INTO correspondance (candidat_id, chantier_id, etat_chantier, source_id, commentaire, etat)
VALUES ((SELECT id FROM candidat WHERE slug = 'slug-du-candidat'),
        (SELECT id FROM chantier WHERE slug = 'nucleaire'),
        'repris',                                       -- repris · en_partie · oppose · non_aborde
        (SELECT id FROM source WHERE cle = 'programme-exemple-2027-01-15'),
        'Six EPR2 et prolongation du parc existant', 'a_valider');
```

### Publier le digest de la semaine

```sql
INSERT INTO digest (debut, fin, publie) VALUES ('2026-10-18', '2026-10-24', 0);

INSERT INTO evenement (date_evenement, type, titre, digest_id, etat)
VALUES ('2026-10-20', 'candidature', 'Une phrase factuelle, sans adjectif.',
        (SELECT id FROM digest WHERE debut = '2026-10-18'), 'a_valider');

INSERT INTO evenement_source (evenement_id, source_id)
VALUES (LAST_INSERT_ID(), (SELECT id FROM source WHERE cle = 'cle-de-la-source'));

-- Le lundi, après relecture des cinq faits :
UPDATE evenement SET etat = 'valide', verifie_le = CURDATE(), verifie_par = 'SN'
WHERE digest_id = (SELECT id FROM digest WHERE debut = '2026-10-18');
UPDATE digest SET publie = 1 WHERE debut = '2026-10-18';
```

### Rédiger la biographie et l'âge d'un candidat

Gabarit : deux phrases, la fonction actuelle puis un ou deux jalons du parcours ; ni adjectif ni appréciation ; 250 caractères environ. La biographie n'est publiée qu'avec sa source.

```sql
INSERT INTO source (cle, url, titre, editeur, libelle_court, date_publication, niveau, consultee_le)
VALUES ('wikipedia-slug-du-candidat-2026-11-02', 'https://fr.wikipedia.org/wiki/…', 'Prénom Nom — Wikipédia', 'Wikipédia', 'Wikipédia', '2026-11-02', 4, CURDATE());

UPDATE candidat SET
  bio = 'Fonction actuelle depuis 2020. Ancien …, candidat à l''élection présidentielle de 2022.',
  date_naissance = '1970-01-31',
  bio_source_id = (SELECT id FROM source WHERE cle = 'wikipedia-slug-du-candidat-2026-11-02'),
  bio_verifie_le = CURDATE()
WHERE slug = 'slug-du-candidat';
```

### Ajouter ou changer une photo

Les photos ne sont pas dans la base. Dans le dépôt GitHub, modifier `outils/photos/candidats.json` (article Wikipédia du candidat, ou fichier Commons imposé, et réglages de recadrage) : le workflow « Photos des candidats » télécharge la vignette, enregistre le crédit et redéploie le site. Pour un nouveau candidat, ajouter une ligne `"slug-du-candidat": {"article": "Prénom Nom"}`.

### Passer en phase 2 (liste officielle)

```sql
UPDATE candidat SET statut = 'officiel', ordre_officiel = 1 WHERE slug = '…';  -- une ligne par candidat, ordre du tirage au sort
UPDATE candidat SET statut = 'non_retenu', date_sortie = '2027-03-26' WHERE statut IN ('declare', 'a_confirmer');
UPDATE parametre SET valeur = 'officiels' WHERE cle = 'phase';
UPDATE parametre SET valeur = '2027-03-26' WHERE cle = 'liste_officielle';      -- date réelle de publication
```

Entre les deux tours : `statut = 'qualifie_t2'` pour les deux qualifiés, puis `phase = 'entre_deux_tours'`.

## Alertes du rapport de publication

| Alerte | Action |
| --- | --- |
| « … validée sans source : non publiée » | ajouter la source, ou repasser la ligne en `a_valider` |
| « … sans valeur chiffrée » ou « … sans modalité : non publiée » | compléter `valeur_num` ou `modalite_id`, ou passer `non_aborde = 1` |
| « Plus de trois mesures phares … non publiée » | la quatrième est écartée d'office : choisir les trois à garder et retirer `mesure_phare` sur les autres |
| « Plus de cinq faits dans le digest … non publié » | le sixième est écarté d'office : repasser un fait en `a_valider` pour choisir lequel |
| « … sans vérification depuis plus de 30 jours » | revérifier la source, puis mettre à jour `verifie_le` |
