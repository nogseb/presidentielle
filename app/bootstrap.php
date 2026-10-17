<?php
/**
 * Repères 2027 · amorçage de l'application privée.
 *
 * Ce dossier est déployé HORS du dossier public (par défaut
 * ~/presidentielle-app sur l'hébergement OVHcloud). Il contient la
 * configuration, l'accès à la base MySQL et la fabrication de
 * l'instantané public/data/site.json.
 *
 * Compatible PHP 7.4 à 8.3.
 */

declare(strict_types=1);

define('APP_DIR', __DIR__);

/**
 * Lit app/config.local.json (écrit par le workflow de déploiement à partir
 * des secrets GitHub, ou à la main en local ; voir config.sample.json).
 */
function app_config(): array
{
    static $config = null;
    if ($config === null) {
        $fichier = APP_DIR . '/config.local.json';
        if (!is_file($fichier)) {
            throw new RuntimeException('Configuration absente : ' . $fichier);
        }
        $config = json_decode((string) file_get_contents($fichier), true);
        if (!is_array($config)) {
            throw new RuntimeException('Configuration illisible : ' . $fichier);
        }
    }
    return $config;
}

function app_db(): PDO
{
    $c = app_config();
    foreach (['db_host', 'db_name', 'db_user', 'db_password'] as $cle) {
        if (!isset($c[$cle]) || $c[$cle] === '') {
            throw new RuntimeException('Paramètre de base de données manquant : ' . $cle);
        }
    }
    $dsn = sprintf(
        'mysql:host=%s;port=%d;dbname=%s;charset=utf8mb4',
        $c['db_host'],
        (int) ($c['db_port'] ?? 3306),
        $c['db_name']
    );
    return new PDO($dsn, $c['db_user'], $c['db_password'], [
        PDO::ATTR_ERRMODE            => PDO::ERRMODE_EXCEPTION,
        PDO::ATTR_DEFAULT_FETCH_MODE => PDO::FETCH_ASSOC,
        PDO::ATTR_EMULATE_PREPARES   => false,
    ]);
}

/**
 * Dossier public/data/ où écrire site.json. Chemin absolu, ou relatif au
 * dossier de l'application (clé data_dir de la configuration).
 */
function app_data_dir(?string $parDefaut = null): string
{
    $c = app_config();
    $dir = $c['data_dir'] ?? $parDefaut;
    if ($dir === null || $dir === '') {
        throw new RuntimeException('Dossier de données non défini (clé data_dir).');
    }
    if ($dir[0] !== '/') {
        $dir = APP_DIR . '/' . $dir;
    }
    return rtrim($dir, '/');
}

date_default_timezone_set('Europe/Paris');

require APP_DIR . '/lib/format.php';
require APP_DIR . '/lib/export.php';
