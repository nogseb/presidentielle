<?php
/**
 * Repères 2027 · import d'un fichier de veille dans la base MySQL.
 *
 * Exécute app/veille/<semaine>/<etape>.sql (saisie ou validation), fichier
 * déposé par le workflow « Importer une veille » à partir du dépôt GitHub.
 * Rien d'autre n'est exécutable : pas de SQL reçu par HTTP, pas d'autre dossier.
 *
 * Garanties :
 * - une seule transaction : en cas d'erreur, aucune ligne n'est modifiée ;
 * - instructions de structure refusées (CREATE, ALTER, DROP, TRUNCATE…) ;
 * - chaque tentative est consignée dans app/journal/imports.log.
 */

declare(strict_types=1);

const IMPORT_ETAPES = ['saisie', 'validation'];

/**
 * @return array{statut:string, semaine:string, etape:string, empreinte:string, instructions:int, controle:array, duree_ms:int}
 */
function import_veille(string $semaine, string $etape): array
{
    if (!preg_match('/^\d{4}-\d{2}-\d{2}$/', $semaine) || !in_array($etape, IMPORT_ETAPES, true)) {
        throw new InvalidArgumentException('Semaine ou étape invalide.');
    }
    $fichier = APP_DIR . '/veille/' . $semaine . '/' . $etape . '.sql';
    if (!is_file($fichier)) {
        throw new InvalidArgumentException('Fichier de veille absent du serveur : veille/' . $semaine . '/' . $etape . '.sql');
    }
    $sql = (string) file_get_contents($fichier);
    $empreinte = hash('sha256', $sql);

    // Seules les instructions de données sont admises (une instruction par début de ligne).
    if (preg_match('/^\s*(CREATE|ALTER|DROP|TRUNCATE|RENAME|GRANT|REVOKE|LOAD|HANDLER|CALL|PREPARE|EXECUTE|LOCK|UNLOCK|USE)\b/im', $sql, $m)) {
        throw new InvalidArgumentException('Instruction refusée dans le fichier : ' . strtoupper($m[1]) . '.');
    }

    if (!class_exists('mysqli')) {
        throw new RuntimeException('Extension mysqli indisponible.');
    }
    $c = app_config();
    mysqli_report(MYSQLI_REPORT_ERROR | MYSQLI_REPORT_STRICT);
    $debut = microtime(true);
    $db = new mysqli((string) $c['db_host'], (string) $c['db_user'], (string) $c['db_password'], (string) $c['db_name'], (int) ($c['db_port'] ?? 3306));
    $db->set_charset('utf8mb4');

    $resultats = [];
    $n = 0;
    try {
        $db->begin_transaction();
        $db->multi_query($sql);
        do {
            $n++;
            $res = $db->store_result();
            if ($res instanceof mysqli_result) {
                $lignes = $res->fetch_all(MYSQLI_ASSOC);
                $res->free();
                if ($lignes) {
                    $resultats = $lignes;          // on garde le dernier jeu : le contrôle final
                }
            }
            if (!$db->more_results()) {
                break;
            }
            $db->next_result();
        } while (true);
        $db->commit();
    } catch (Throwable $e) {
        try {
            // Vider les résultats en attente avant d'annuler.
            while ($db->more_results() && $db->next_result()) {
            }
        } catch (Throwable $ignore) {
        }
        $db->rollback();
        $db->close();
        import_journal($semaine, $etape, $empreinte, 'annule', $n, [], $e->getMessage());
        throw new RuntimeException('Import annulé, aucune modification, erreur à l\'instruction ' . ($n + 1) . ' : ' . $e->getMessage(), 0, $e);
    }
    $db->close();

    $rapport = [
        'statut'       => 'importe',
        'semaine'      => $semaine,
        'etape'        => $etape,
        'empreinte'    => $empreinte,
        'instructions' => $n,
        'controle'     => $resultats,
        'duree_ms'     => (int) round((microtime(true) - $debut) * 1000),
    ];
    import_journal($semaine, $etape, $empreinte, 'importe', $n, $resultats, null);
    return $rapport;
}

function import_journal(string $semaine, string $etape, string $empreinte, string $statut, int $n, array $controle, ?string $erreur): void
{
    $dir = APP_DIR . '/journal';
    if (!is_dir($dir)) {
        @mkdir($dir, 0700, true);
    }
    $ligne = json_encode([
        'date'         => date('c'),
        'semaine'      => $semaine,
        'etape'        => $etape,
        'statut'       => $statut,
        'instructions' => $n,
        'empreinte'    => $empreinte,
        'controle'     => $controle,
        'erreur'       => $erreur,
    ], JSON_UNESCAPED_UNICODE | JSON_UNESCAPED_SLASHES);
    @file_put_contents($dir . '/imports.log', $ligne . "\n", FILE_APPEND | LOCK_EX);
}
