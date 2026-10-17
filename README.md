# Repères 2027

Veille sobre et sourcée de l'élection présidentielle française de 2027 : l'actualité de la semaine en cinq faits, les candidatures, les positions comparées sur 14 thèmes communs et une lecture des programmes au regard des propositions de The Shift Project.

En ligne : https://nogues.app/presidentielle/ · données fictives de démonstration : https://nogues.app/presidentielle/?demo=1

## Principe

```
phpMyAdmin (saisie)  →  MySQL OVHcloud  →  api/publier.php  →  data/site.json  →  page statique
                         source de vérité    export validé       contrat public     HTML, CSS, JS
```

- La base n'est jamais interrogée par les visiteurs : le site est une page statique qui lit un JSON. Rapide, sans risque d'injection, et consultable même si la base est indisponible.
- Rien n'est publié sans validation ni source. L'export écarte les lignes non conformes et le signale.
- GitHub ne se connecte jamais à la base : le déploiement dépose la configuration sur le serveur, hors du dossier public, puis demande au serveur de régénérer les données.

## Arborescence

| Dossier | Contenu | Destination sur OVHcloud |
| --- | --- | --- |
| `public/` | le site : `index.html`, `assets/`, `data/`, `api/publier.php` | `www/presidentielle` |
| `app/` | code privé : connexion à la base, export, configuration | `presidentielle-app`, hors de `www` |
| `database/` | schéma MySQL, données de référence, actualité au 17 octobre 2026 | à importer dans phpMyAdmin |
| `outils/` | générateur des données de démonstration | non déployé |
| `docs/` | installation, saisie, modèle de données | non déployé |
| `.github/workflows/` | déploiement, publication des données, contrôle | GitHub Actions |

## Workflows

| Workflow | Déclenchement | Rôle |
| --- | --- | --- |
| Contrôler | chaque push et pull request | syntaxe PHP et JS, import du schéma dans un MySQL 8.0 vierge, export et vérification de `site.json` |
| Publier Repères 2027 sur OVHcloud | push sur `main` touchant `public/` ou `app/`, ou manuel | envoi SFTP, écriture de la configuration privée, régénération des données |
| Publier les données | manuel, et toutes les heures de 7 h à 23 h | régénère `site.json` après une saisie, sans redéployer le code |

## Documentation

- [Installation sur OVHcloud](docs/installation.md) : base, secrets GitHub, premier déploiement.
- [Saisir et valider des données](docs/saisie.md) : requêtes prêtes à copier dans phpMyAdmin.
- [Modèle de données](docs/modele-de-donnees.md) : tables et contrat JSON.

## Travailler en local

Prérequis : PHP 7.4 ou plus avec PDO MySQL, MySQL 8 ou MariaDB 10.6 ou plus, Node 18 ou plus pour la démonstration.

```bash
mysql -e "CREATE DATABASE presidentielle CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci"
for f in database/migrations/*.sql database/seed/*.sql; do mysql presidentielle < "$f"; done

cp app/config.sample.json app/config.local.json   # renseigner la base ; data_dir : "../public/data"
php app/bin/publier.php                           # écrit public/data/site.json
node outils/demo.mjs                              # écrit public/data/demo.json

php -S 127.0.0.1:8000 -t public                   # http://127.0.0.1:8000/  et  /?demo=1
```

## Charte éditoriale, en bref

- Une information = une source primaire, citée et datée.
- Formulations neutres : verbe à l'infinitif, sans adjectif évaluatif ; même traitement pour toutes les candidatures.
- « Non abordé » (vérifié) et « À documenter » (pas encore traité) ne se confondent jamais.
- La grille The Shift Project est présentée comme une grille de lecture parmi d'autres, sourcée, et non comme une note des candidats.

Les polices Archivo et Atkinson Hyperlegible sont distribuées sous licence SIL Open Font License (fichiers de licence dans `public/assets/fonts/`).
