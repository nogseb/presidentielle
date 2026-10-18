# Installation sur nogues.app (OVHcloud)

Compter 20 minutes. Quatre étapes : créer la base, la remplir, déclarer les secrets GitHub, lancer le premier déploiement.

## 1. Créer la base MySQL chez OVHcloud

Espace client OVHcloud → **Web Cloud** → **Hébergements** → l'hébergement de nogues.app → onglet **Bases de données** → **Créer une base de données**.

| Réglage | Valeur conseillée |
| --- | --- |
| Moteur | MySQL |
| Version | 8.0 (la plus récente proposée) |
| Nom d'utilisateur | par exemple `presid` (OVHcloud ajoute un préfixe) |
| Mot de passe | long et aléatoire, conservé dans un gestionnaire de mots de passe |

Une fois la base créée (quelques minutes), noter dans l'onglet Bases de données :

- l'**adresse du serveur**, de la forme `xxxxxxxx.mysql.db` ;
- le **nom de la base** et le **nom d'utilisateur** ;
- le mot de passe choisi.

La base d'un hébergement mutualisé n'est joignable que depuis cet hébergement : c'est voulu, et c'est pourquoi GitHub ne s'y connecte jamais.

## 2. Remplir la base avec phpMyAdmin

Depuis l'onglet Bases de données, ouvrir phpMyAdmin pour la nouvelle base, puis onglet **Importer**, dans cet ordre, un fichier à la fois :

1. `database/migrations/001_schema.sql` : les tables ;
2. `database/seed/010_referentiels.sql` : paramètres, 14 thèmes, variables pivots, The Shift Project et ses chantiers ;
3. `database/seed/020_actualite_2026-10-17.sql` : candidatures, calendrier, digest, sondage, sources ;
4. `database/migrations/002_biographies.sql` puis `database/seed/030_biographies_2026-10-17.sql` : âge et biographie des candidats ;
5. `database/migrations/003_debats.sql` puis `database/seed/040_debats_2026-10-18.sql` `database/seed/050_culture_education_2026-10-18.sql` et `database/seed/060_debat_superieur_prive_2026-10-18.sql` : les débats pour et contre et le 15e thème, Culture et soutien aux artistes ;
6. facultatif : `database/optionnel/journal_triggers.sql`, le journal automatique des modifications. Si phpMyAdmin refuse ce fichier (droit `TRIGGER` absent), ce n'est pas bloquant.

Contrôle rapide dans l'onglet SQL :

```sql
SELECT (SELECT COUNT(*) FROM theme) AS themes, (SELECT COUNT(*) FROM candidat) AS candidats;
-- attendu : 15 thèmes, 30 candidats
```

## 3. Déclarer les secrets dans GitHub

Dépôt `nogseb/presidentielle` → **Settings** → **Secrets and variables** → **Actions**.

Les secrets d'un dépôt ne sont pas visibles depuis un autre : ceux de `nogues.app` sont à recopier ici.

| Nom | Type | Valeur |
| --- | --- | --- |
| `OVH_SFTP_HOST` | secret | serveur SFTP, comme pour nogues.app |
| `OVH_SFTP_USER` | secret | login FTP, comme pour nogues.app |
| `OVH_SFTP_PASSWORD` | secret | mot de passe FTP, comme pour nogues.app |
| `OVH_DB_HOST` | secret | adresse du serveur MySQL (`xxxxxxxx.mysql.db`) |
| `OVH_DB_NAME` | secret | nom de la base |
| `OVH_DB_USER` | secret | utilisateur de la base |
| `OVH_DB_PASSWORD` | secret | mot de passe de la base |
| `PUBLIER_JETON` | secret | 32 caractères aléatoires au moins (générateur de mots de passe, ou `openssl rand -hex 24`) |
| `OVH_TARGET_DIR` | variable, facultative | `www/presidentielle` par défaut |
| `OVH_APP_DIR` | variable, facultative | `presidentielle-app` par défaut, toujours hors de `www` |
| `SITE_URL` | variable, facultative | `https://nogues.app/presidentielle` par défaut |

À quoi servent les secrets de base : le workflow de déploiement les écrit dans `presidentielle-app/config.local.json`, sur le serveur, hors du dossier public, avec des droits restreints. Ils ne sont jamais versionnés ni affichés dans les journaux d'exécution.

Le jeton protège `https://nogues.app/presidentielle/api/publier.php` : sans lui, personne ne peut déclencher une régénération des données.

## 4. Premier déploiement

Onglet **Actions** → **Publier Repères 2027 sur OVHcloud** → **Run workflow**.

Le résumé de l'exécution indique le nombre de fichiers envoyés et le rapport de publication des données (`"statut": "publie"`). Le site est alors en ligne sur https://nogues.app/presidentielle/.

Vérifications :

- https://nogues.app/presidentielle/ affiche la semaine et les 30 candidatures ;
- https://nogues.app/presidentielle/?demo=1 affiche le comparateur et la grille The Shift Project avec des données fictives ;
- https://nogues.app/presidentielle/data/site.json renvoie le JSON public.

## Mises à jour du schéma

Chaque évolution de la base arrive sous forme d'une migration numérotée (`database/migrations/00N_*.sql`), à importer une seule fois dans phpMyAdmin, dans l'ordre, suivie le cas échéant du fichier de données qui l'accompagne. La table `schema_version` indique les migrations déjà appliquées :

```sql
SELECT * FROM schema_version ORDER BY version;
```

## Ensuite

- **Après chaque saisie** dans phpMyAdmin : onglet Actions → **Publier les données** → Run workflow. Ce workflow tourne aussi toutes les heures de 7 h à 23 h.
- **Version de PHP** : 7.4 au minimum, 8.2 ou plus recommandé (espace client → hébergement → Informations générales → Configuration globale).
- **Alternative au workflow planifié** : une tâche planifiée OVHcloud (onglet Plus → Cron) qui exécute `presidentielle-app/bin/publier.php --cron`.
- **Lien depuis l'accueil de nogues.app** : ajouter une carte dans `site/index.html` du dépôt `nogues.app`.

## Dépannage

| Symptôme | Cause probable | Solution |
| --- | --- | --- |
| Le workflow s'arrête avec un avertissement « Secrets … absents » | secrets SFTP non créés dans ce dépôt | les ajouter (étape 3) |
| Rapport HTTP 503 « Publication non configurée » | `PUBLIER_JETON` absent ou trop court, ou secrets OVH_DB_* incomplets | compléter les secrets puis relancer le déploiement |
| Rapport HTTP 500 | base injoignable ou schéma non importé | vérifier l'étape 2 ; détail dans les journaux d'erreurs PHP de l'hébergement (onglet Statistiques et logs) |
| Le site affiche « Les données n'ont pas pu être chargées » | `data/site.json` absent | relancer « Publier les données » |
