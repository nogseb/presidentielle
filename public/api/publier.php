<?php
/**
 * Repères 2027 · régénère data/site.json à partir de la base MySQL.
 *
 * Appel : POST, en-tête « X-Publication-Jeton » égal au jeton de la
 * configuration (secret GitHub PUBLIER_JETON). Appelé par les workflows
 * « Publier Repères 2027 sur OVHcloud » et « Publier les données ».
 *
 * Répond un rapport JSON : statut (publie ou inchange), compteurs, alertes.
 * Les erreurs techniques détaillées vont dans le journal d'erreurs PHP.
 */

declare(strict_types=1);

header('Content-Type: application/json; charset=utf-8');
header('Cache-Control: no-store');
header('X-Robots-Tag: noindex');

function repondre(int $code, array $corps): void
{
    http_response_code($code);
    echo json_encode($corps, JSON_UNESCAPED_UNICODE | JSON_UNESCAPED_SLASHES);
    exit;
}

if (($_SERVER['REQUEST_METHOD'] ?? '') !== 'POST') {
    header('Allow: POST');
    repondre(405, ['erreur' => 'Méthode non autorisée.']);
}

// Chemin du dossier privé de l'application (réécrit par le déploiement).
$appDir = require __DIR__ . '/chemin-app.php';
if (!is_file($appDir . '/bootstrap.php')) {
    error_log('Repères 2027 : dossier applicatif introuvable : ' . $appDir);
    repondre(503, ['erreur' => 'Application non installée.']);
}
require $appDir . '/bootstrap.php';

try {
    $jeton = (string) (app_config()['publier_jeton'] ?? '');
} catch (Throwable $e) {
    error_log('Repères 2027 : ' . $e->getMessage());
    repondre(503, ['erreur' => 'Publication non configurée.']);
}
if (strlen($jeton) < 32) {
    repondre(503, ['erreur' => 'Publication non configurée.']);
}

$recu = (string) ($_SERVER['HTTP_X_PUBLICATION_JETON'] ?? '');
if ($recu === '' || !hash_equals($jeton, $recu)) {
    repondre(403, ['erreur' => 'Jeton invalide.']);
}

$declencheur = (string) ($_SERVER['HTTP_X_DECLENCHEUR'] ?? 'manuel');

try {
    $rapport = export_publier(app_db(), app_data_dir(dirname(__DIR__) . '/data'), $declencheur);
} catch (Throwable $e) {
    error_log('Repères 2027 : publication impossible : ' . $e->getMessage());
    repondre(500, ['erreur' => 'Publication impossible. Voir le journal d’erreurs PHP de l’hébergement.']);
}

repondre(200, $rapport);
