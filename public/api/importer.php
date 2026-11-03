<?php
/**
 * Repères 2027 · importe un fichier de veille dans la base MySQL.
 *
 * Appel : POST, en-tête « X-Publication-Jeton » (secret GitHub PUBLIER_JETON),
 * champs « semaine » (AAAA-MM-JJ) et « etape » (saisie ou validation).
 * Appelé uniquement par le workflow « Importer une veille », qui dépose au
 * préalable database/veille/<semaine>/<etape>.sql dans le dossier privé.
 * Aucune requête SQL n'est reçue par HTTP : seul ce fichier est exécuté.
 *
 * Répond un rapport JSON : statut, empreinte du fichier, résultat du contrôle final.
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

$appDir = require __DIR__ . '/chemin-app.php';
if (!is_file($appDir . '/bootstrap.php') || !is_file($appDir . '/lib/import.php')) {
    error_log('Repères 2027 : dossier applicatif incomplet : ' . $appDir);
    repondre(503, ['erreur' => 'Application non installée.']);
}
require $appDir . '/bootstrap.php';
require $appDir . '/lib/import.php';

try {
    $jeton = (string) (app_config()['publier_jeton'] ?? '');
} catch (Throwable $e) {
    error_log('Repères 2027 : ' . $e->getMessage());
    repondre(503, ['erreur' => 'Import non configuré.']);
}
if (strlen($jeton) < 32) {
    repondre(503, ['erreur' => 'Import non configuré.']);
}

$recu = (string) ($_SERVER['HTTP_X_PUBLICATION_JETON'] ?? '');
if ($recu === '' || !hash_equals($jeton, $recu)) {
    repondre(403, ['erreur' => 'Jeton invalide.']);
}

$semaine = (string) ($_POST['semaine'] ?? '');
$etape = (string) ($_POST['etape'] ?? '');

try {
    repondre(200, import_veille($semaine, $etape));
} catch (InvalidArgumentException $e) {
    repondre(400, ['statut' => 'refuse', 'erreur' => $e->getMessage()]);
} catch (Throwable $e) {
    error_log('Repères 2027 : import de veille annulé : ' . $e->getMessage());
    repondre(500, ['statut' => 'annule', 'erreur' => $e->getMessage()]);
}
