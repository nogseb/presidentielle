<?php
/**
 * Repères 2027 · publication en ligne de commande.
 *
 * Usage :
 *   php app/bin/publier.php                 dossier de données lu dans la configuration (data_dir)
 *   php app/bin/publier.php --data=/chemin  dossier de données imposé
 *   php app/bin/publier.php --cron          trace la publication comme planifiée par l'hébergeur
 *
 * Sur OVHcloud, peut servir de tâche planifiée (« Cron ») à la place du
 * workflow GitHub « Publier les données ».
 */

declare(strict_types=1);

if (PHP_SAPI !== 'cli') {
    http_response_code(404);
    exit;
}

require dirname(__DIR__) . '/bootstrap.php';

$options = getopt('', ['data:', 'cron']);

try {
    $dataDir = isset($options['data']) ? rtrim((string) $options['data'], '/') : app_data_dir();
    $rapport = export_publier(app_db(), $dataDir, isset($options['cron']) ? 'cron' : 'manuel');
} catch (Throwable $e) {
    fwrite(STDERR, 'Échec de la publication : ' . $e->getMessage() . PHP_EOL);
    exit(1);
}

echo json_encode($rapport, JSON_UNESCAPED_UNICODE | JSON_UNESCAPED_SLASHES | JSON_PRETTY_PRINT) . PHP_EOL;
exit(0);
