<?php
/**
 * Repères 2027 · fabrication de l'instantané public/data/site.json.
 *
 * Lit la base MySQL, ne retient que les lignes « valide », contrôle les
 * règles de la charte (source obligatoire, trois mesures phares au plus,
 * cinq faits par digest au plus) et produit le JSON lu par public/assets/app.js.
 *
 * Le contrat du JSON est décrit dans docs/modele-de-donnees.md.
 */

declare(strict_types=1);

const EXPORT_VERSION = 1;
const EXPORT_JSON = JSON_UNESCAPED_UNICODE | JSON_UNESCAPED_SLASHES;

const EXPORT_ETATS_CHANTIER = [
    'repris'     => 'R',
    'en_partie'  => 'P',
    'oppose'     => 'O',
    'non_aborde' => 'N',
];

const EXPORT_TYPES_EVENEMENT = [
    'candidature'    => 'Candidature',
    'retrait'        => 'Retrait',
    'ralliement'     => 'Ralliement',
    'primaire'       => 'Primaire',
    'programme'      => 'Programme',
    'debat'          => 'Débat',
    'sondage'        => 'Sondage',
    'justice'        => 'Justice',
    'institutions'   => 'Institutions',
    'calendrier'     => 'Calendrier',
    'decompte'       => 'Décompte',
    'societe_civile' => 'Société civile',
    'autre'          => 'Autre',
];

final class ExportSite
{
    /** @var PDO */
    private $db;
    /** @var array<int, array{0:string,1:string}> */
    private $sources = [];
    /** @var array<string, string> */
    private $params = [];
    /** @var string[] */
    private $alertes = [];
    /** @var array<string, int> */
    private $stats = [];

    public function __construct(PDO $db)
    {
        $this->db = $db;
    }

    /**
     * @return array{site: array, stats: array, alertes: string[]}
     */
    public function construire(): array
    {
        $this->params = $this->db->query('SELECT cle, valeur FROM parametre')->fetchAll(PDO::FETCH_KEY_PAIR);
        foreach ($this->db->query('SELECT id, libelle_court, url FROM source') as $s) {
            $this->sources[(int) $s['id']] = [$s['libelle_court'], $s['url']];
        }

        $phase = $this->param('phase', 'declares');
        if (!in_array($phase, ['declares', 'officiels', 'entre_deux_tours'], true)) {
            $this->alerte("Paramètre phase inconnu « {$phase} » : phase 1 appliquée.");
            $phase = 'declares';
        }

        [$candidats, $comparateur] = $this->candidats($phase);
        $ids = array_column($comparateur, 'id');

        $themes = $this->themes($ids);
        $site = [
            'meta' => [
                'version'          => EXPORT_VERSION,
                'genere_le'        => (new DateTimeImmutable('now'))->format(DATE_ATOM),
                'maj'              => (new DateTimeImmutable('now'))->format('Y-m-d'),
                'premier_tour'     => $this->param('premier_tour', '2027-04-18'),
                'second_tour'      => $this->param('second_tour', '2027-05-02'),
                'liste_officielle' => $this->param('liste_officielle', '2027-03-26'),
                'phase'            => $phase,
                'demo'             => false,
                'chiffre_note'     => $this->param('chiffre_note', ''),
                'empreinte_min'    => (int) $this->param('empreinte_min', '10'),
            ],
            'semaine'     => $this->semaine(),
            'phases'      => $this->phases(),
            'calendrier'  => $this->calendrier(),
            'candidats'   => $candidats,
            'comparateur' => ['candidats' => $comparateur],
            'themes'      => $themes,
            'empreinte'   => $this->empreinte($ids, count($themes)),
            'sondage'     => $this->sondage(),
            'shift'       => $this->shift($ids),
        ];

        $this->controlerFraicheur();
        $this->stats['nb_candidats'] = count($candidats);
        $this->stats['nb_comparateur'] = count($comparateur);

        return ['site' => $site, 'stats' => $this->stats, 'alertes' => $this->alertes];
    }

    // -----------------------------------------------------------------
    // Candidatures
    // -----------------------------------------------------------------
    private function candidats(string $phase): array
    {
        if ($phase === 'declares') {
            $where = "statut IN ('declare','a_confirmer','officiel')";
            $order = 'nom, prenom';
        } else {
            $where = "statut IN ('officiel','qualifie_t2')";
            $order = 'ordre_officiel IS NULL, ordre_officiel, nom, prenom';
        }
        $rows = $this->db->query("SELECT * FROM candidat WHERE {$where} ORDER BY {$order}")->fetchAll();

        $nbProps = $this->db->query(
            "SELECT candidat_id, COUNT(*) FROM proposition WHERE etat = 'valide' GROUP BY candidat_id"
        )->fetchAll(PDO::FETCH_KEY_PAIR);

        $candidats = [];
        $comparateur = [];
        foreach ($rows as $c) {
            $dansComparateur = $phase === 'declares' ? $c['niveau'] === 'complet'
                : ($phase === 'officiels' ? true : $c['statut'] === 'qualifie_t2');

            $badges = [];
            if ($c['designation'] === 'primaire') {
                $badges[] = 'Primaire remportée';
            } elseif ($c['designation'] === 'parti') {
                $badges[] = 'Investiture du parti';
            }
            if ((int) $c['hors_primaire'] === 1) {
                $badges[] = 'Hors primaire';
            }
            if ($c['statut'] === 'officiel' && $phase === 'declares') {
                $badges[] = 'Candidature officielle';
            }
            $signales = [];
            if ($c['statut'] === 'a_confirmer') {
                $signales[] = 'Candidature à confirmer';
            }
            if ((int) $c['volet_judiciaire'] === 1) {
                $signales[] = 'Volet judiciaire';
            }
            if ($c['mention']) {
                $signales[] = $c['mention'];
            }

            $candidats[] = [
                'id'    => $c['slug'],
                'p'     => $c['prenom'],
                'n'     => $c['nom'],
                'parti' => $c['parti'],
                'st'    => $c['statut'],
                'd'     => $c['date_declaration'],
                'dp'    => $c['precision_date'],
                'dk'    => $c['designation'],
                'b'     => $badges,
                'f'     => $signales,
                'note'  => $c['note'],
                'prog'  => $c['programme_url'] ? ['url' => $c['programme_url'], 'date' => $c['programme_date']] : null,
                'nb'    => (int) ($nbProps[$c['id']] ?? 0),
                'cmp'   => $dansComparateur,
                'src'   => $this->src((int) $c['source_id']),
            ];
            if ($dansComparateur) {
                $comparateur[] = [
                    'id'    => $c['slug'],
                    'nom'   => $c['prenom'] . ' ' . $c['nom'],
                    'court' => $c['nom'],
                ];
            }
        }
        return [$candidats, $comparateur];
    }

    // -----------------------------------------------------------------
    // Thèmes, variables pivots, positions, mesures phares
    // -----------------------------------------------------------------
    private function themes(array $ids): array
    {
        $dansComparateur = array_flip($ids);

        $modalites = [];
        foreach ($this->db->query('SELECT variable_id, libelle FROM modalite ORDER BY variable_id, ordre, id') as $m) {
            $modalites[(int) $m['variable_id']][] = $m['libelle'];
        }

        $variables = [];
        $sql = 'SELECT v.*, ch.slug AS chantier FROM variable v
                LEFT JOIN chantier ch ON ch.id = v.chantier_id
                WHERE v.actif = 1 ORDER BY v.theme_id, v.ordre, v.id';
        foreach ($this->db->query($sql) as $v) {
            $variables[(int) $v['theme_id']][(int) $v['id']] = $v;
        }

        // Positions validées des candidats du comparateur
        $positions = [];
        $nbPositions = 0;
        $sql = "SELECT p.*, c.slug AS cand, m.libelle AS modalite FROM position_candidat p
                JOIN candidat c ON c.id = p.candidat_id
                LEFT JOIN modalite m ON m.id = p.modalite_id
                WHERE p.etat = 'valide'";
        foreach ($this->db->query($sql) as $p) {
            if (!isset($dansComparateur[$p['cand']])) {
                continue;
            }
            $vid = (int) $p['variable_id'];
            $nonAborde = (int) $p['non_aborde'] === 1;
            if (!$nonAborde && !$p['source_id']) {
                $this->alerte("Position {$p['cand']} / variable {$vid} validée sans source : non publiée.");
                continue;
            }
            $positions[$vid][] = $p;
            $nbPositions++;
        }
        $this->stats['nb_positions'] = $nbPositions;

        // Mesures phares validées
        $mesures = [];
        $sql = "SELECT p.code, p.theme_id, p.intitule, p.source_id, c.slug AS cand, ch.slug AS chantier
                FROM proposition p
                JOIN candidat c ON c.id = p.candidat_id
                LEFT JOIN chantier ch ON ch.id = p.chantier_id
                WHERE p.etat = 'valide' AND p.mesure_phare = 1
                ORDER BY p.theme_id, c.nom, p.id";
        foreach ($this->db->query($sql) as $m) {
            if (!isset($dansComparateur[$m['cand']])) {
                continue;
            }
            $t = (int) $m['theme_id'];
            $liste = $mesures[$t][$m['cand']] ?? [];
            if (count($liste) >= 3) {
                $this->alerte("Plus de trois mesures phares pour {$m['cand']} sur le thème {$t} : {$m['code']} non publiée.");
                continue;
            }
            $item = ['t' => $m['intitule'], 'src' => $this->src((int) $m['source_id'])];
            if ($m['chantier']) {
                $item['s'] = $m['chantier'];
            }
            $mesures[$t][$m['cand']][] = $item;
        }
        $this->stats['nb_propositions'] = (int) $this->db->query(
            "SELECT COUNT(*) FROM proposition WHERE etat = 'valide'"
        )->fetchColumn();

        $themes = [];
        foreach ($this->db->query('SELECT * FROM theme ORDER BY ordre, id') as $t) {
            $tid = (int) $t['id'];
            $pivots = [];
            $vars = [];
            foreach ($variables[$tid] ?? [] as $vid => $v) {
                $pivots[] = $v['question'];
                if (empty($positions[$vid])) {
                    continue;
                }
                $vars[] = $this->variableJson($v, $positions[$vid], $modalites[$vid] ?? []);
            }
            $theme = [
                'id'     => $tid,
                'slug'   => $t['slug'],
                'n'      => $t['nom'],
                'c'      => $t['nom_court'],
                'une'    => (int) $t['a_la_une'] === 1,
                'pivots' => $pivots,
                'vars'   => $vars,
            ];
            if ($t['nom_radar']) {
                $theme['r'] = $t['nom_radar'];
            }
            if (!empty($mesures[$tid])) {
                $theme['mesures'] = $mesures[$tid];
            }
            $themes[] = $theme;
        }
        return $themes;
    }

    private function variableJson(array $v, array $positions, array $modalites): array
    {
        $num = $v['type'] === 'numerique';
        $valeurs = [];
        $sources = [];
        foreach ($positions as $p) {
            if ((int) $p['non_aborde'] === 1) {
                $valeurs[$p['cand']] = null;
            } elseif ($num) {
                if ($p['valeur_num'] === null) {
                    $this->alerte("Position {$p['cand']} / {$v['slug']} sans valeur chiffrée : non publiée.");
                    continue;
                }
                $valeurs[$p['cand']] = self::nombre($p['valeur_num']);
            } else {
                if ($p['modalite'] === null) {
                    $this->alerte("Position {$p['cand']} / {$v['slug']} sans modalité : non publiée.");
                    continue;
                }
                $valeurs[$p['cand']] = $p['modalite'];
            }
            if ($p['source_id']) {
                $sources[$p['cand']] = $this->src((int) $p['source_id']);
            }
        }

        $json = [
            'slug'  => $v['slug'],
            'q'     => $v['question'],
            'type'  => $num ? 'num' : 'cat',
            'v'     => (object) $valeurs,
            'src'   => (object) $sources,
            'shift' => $v['chantier'],
        ];
        if ($num) {
            $json['unit'] = $v['unite'] ?? '';
            $json['min'] = self::nombre($v['borne_min']);
            $json['max'] = self::nombre($v['borne_max']);
            $json['ticks'] = array_map([self::class, 'nombre'], array_filter(array_map('trim', explode(',', (string) $v['graduations'])), 'strlen'));
        } else {
            $json['mods'] = $modalites;
        }
        return $json;
    }

    /** Part des propositions validées par thème, en %, arrondie au plus fort reste. */
    private function empreinte(array $ids, int $nbThemes): object
    {
        $minimum = (int) $this->param('empreinte_min', '10');
        $comptes = [];
        $sql = "SELECT c.slug, p.theme_id, COUNT(*) AS n FROM proposition p
                JOIN candidat c ON c.id = p.candidat_id
                WHERE p.etat = 'valide' GROUP BY c.slug, p.theme_id";
        foreach ($this->db->query($sql) as $r) {
            $comptes[$r['slug']][(int) $r['theme_id']] = (int) $r['n'];
        }
        $themes = array_map('intval', $this->db->query('SELECT id FROM theme ORDER BY ordre, id')->fetchAll(PDO::FETCH_COLUMN));

        $empreinte = [];
        foreach ($ids as $id) {
            $parTheme = [];
            foreach ($themes as $t) {
                $parTheme[] = $comptes[$id][$t] ?? 0;
            }
            if (array_sum($parTheme) >= $minimum) {
                $empreinte[$id] = self::pourcentages($parTheme);
            }
        }
        return (object) $empreinte;
    }

    // -----------------------------------------------------------------
    // Sondage de référence
    // -----------------------------------------------------------------
    private function sondage(): ?array
    {
        $s = $this->db->query(
            "SELECT * FROM sondage WHERE etat = 'valide' AND tour = 1 ORDER BY terrain_fin DESC, id DESC LIMIT 1"
        )->fetch();
        if (!$s) {
            return null;
        }
        $stmt = $this->db->prepare(
            'SELECT c.prenom, c.nom, r.valeur_min, r.valeur_max FROM sondage_resultat r
             JOIN candidat c ON c.id = r.candidat_id WHERE r.sondage_id = ? ORDER BY c.nom, c.prenom'
        );
        $stmt->execute([$s['id']]);
        $rows = [];
        foreach ($stmt as $r) {
            $rows[] = [
                'n'  => $r['prenom'] . ' ' . $r['nom'],
                'lo' => self::nombre($r['valeur_min']),
                'hi' => self::nombre($r['valeur_max']),
            ];
        }
        $mentions = sprintf(
            '%s pour %s, réalisée %s auprès de %s %s. %s.',
            $s['institut'],
            $s['commanditaires'],
            fr_periode($s['terrain_debut'], $s['terrain_fin']),
            fr_nombre((int) $s['echantillon']),
            $s['population'],
            $s['unite']
        );
        if ($s['note']) {
            $mentions .= ' ' . $s['note'];
        }
        $source = $this->src((int) $s['source_id']);
        return [
            'rows'     => $rows,
            'mentions' => $mentions,
            'lecture'  => $s['lecture'],
            'url'      => $source ? $source[1] : null,
            'notice'   => $s['url_notice'],
        ];
    }

    // -----------------------------------------------------------------
    // The Shift Project (organisation à grille dédiée)
    // -----------------------------------------------------------------
    private function shift(array $ids): ?array
    {
        $org = $this->db->query('SELECT * FROM organisation WHERE grille_dediee = 1 ORDER BY id LIMIT 1')->fetch();
        if (!$org) {
            return null;
        }
        $oid = (int) $org['id'];

        $dispositifs = [];
        $stmt = $this->db->prepare('SELECT * FROM organisation_dispositif WHERE organisation_id = ? ORDER BY ordre, id');
        $stmt->execute([$oid]);
        $srcStmt = $this->db->prepare('SELECT source_id FROM dispositif_source WHERE dispositif_id = ? ORDER BY ordre');
        foreach ($stmt->fetchAll() as $d) {
            $srcStmt->execute([$d['id']]);
            $liens = [];
            foreach ($srcStmt->fetchAll(PDO::FETCH_COLUMN) as $sid) {
                if ($l = $this->src((int) $sid)) {
                    $liens[] = $l;
                }
            }
            $dispositifs[] = ['when' => $d['periode'], 't' => $d['titre'], 'd' => $d['description'], 'src' => $liens];
        }

        $chantiers = [];
        $stmt = $this->db->prepare('SELECT * FROM chantier WHERE organisation_id = ? ORDER BY ordre, id');
        $stmt->execute([$oid]);
        foreach ($stmt as $c) {
            $chantiers[] = ['id' => $c['slug'], 'l' => $c['libelle'], 'dom' => $c['domaine'], 'th' => (int) $c['theme_id']];
        }

        $dansComparateur = array_flip($ids);
        $etats = [];
        $sources = [];
        $stmt = $this->db->prepare(
            "SELECT co.*, c.slug AS cand, ch.slug AS chantier FROM correspondance co
             JOIN candidat c ON c.id = co.candidat_id
             JOIN chantier ch ON ch.id = co.chantier_id
             WHERE co.etat = 'valide' AND ch.organisation_id = ?"
        );
        $stmt->execute([$oid]);
        $nb = 0;
        foreach ($stmt as $r) {
            if (!isset($dansComparateur[$r['cand']])) {
                continue;
            }
            if ($r['etat_chantier'] !== 'non_aborde' && !$r['source_id']) {
                $this->alerte("Correspondance {$r['cand']} / {$r['chantier']} validée sans source : non publiée.");
                continue;
            }
            $etats[$r['cand']][$r['chantier']] = EXPORT_ETATS_CHANTIER[$r['etat_chantier']];
            if ($r['source_id']) {
                $sources[$r['cand']][$r['chantier']] = $this->src((int) $r['source_id']);
            }
            $nb++;
        }
        $this->stats['nb_correspondances'] = $nb;

        $financement = $org['financement_source_id'] ? $this->src((int) $org['financement_source_id']) : null;
        return [
            'nom'         => $org['nom'],
            'qui'         => $org['presentation'],
            'demande'     => $org['demande'],
            'finance'     => $org['financement'],
            'financeSrc'  => $financement,
            'hatvp'       => $org['hatvp_url'],
            'dispositifs' => $dispositifs,
            'chantiers'   => $chantiers,
            'etats'       => (object) array_map(function ($e) { return (object) $e; }, $etats),
            'src'         => (object) array_map(function ($e) { return (object) $e; }, $sources),
        ];
    }

    // -----------------------------------------------------------------
    // Digest, calendrier, phases
    // -----------------------------------------------------------------
    private function semaine(): ?array
    {
        $dg = $this->db->query('SELECT * FROM digest WHERE publie = 1 ORDER BY debut DESC LIMIT 1')->fetch();
        if (!$dg) {
            $this->stats['nb_evenements'] = 0;
            return null;
        }
        $stmt = $this->db->prepare(
            "SELECT * FROM evenement WHERE digest_id = ? AND etat = 'valide' ORDER BY date_evenement DESC, id DESC"
        );
        $stmt->execute([$dg['id']]);
        $srcStmt = $this->db->prepare('SELECT source_id FROM evenement_source WHERE evenement_id = ? ORDER BY ordre');
        $faits = [];
        foreach ($stmt->fetchAll() as $e) {
            $srcStmt->execute([$e['id']]);
            $liens = [];
            foreach ($srcStmt->fetchAll(PDO::FETCH_COLUMN) as $sid) {
                if ($l = $this->src((int) $sid)) {
                    $liens[] = $l;
                }
            }
            if (!$liens) {
                $this->alerte("Fait du {$e['date_evenement']} sans source : non publié.");
                continue;
            }
            if (count($faits) >= 5) {
                $this->alerte("Plus de cinq faits dans le digest du {$dg['debut']} : fait du {$e['date_evenement']} non publié.");
                continue;
            }
            $faits[] = [
                'd'   => $e['date_evenement'],
                'tag' => EXPORT_TYPES_EVENEMENT[$e['type']] ?? 'Autre',
                't'   => $e['titre'],
                'src' => $liens,
            ];
        }
        $this->stats['nb_evenements'] = count($faits);
        return ['periode' => fr_periode($dg['debut'], $dg['fin'], true), 'faits' => $faits];
    }

    private function calendrier(): array
    {
        $etapes = [];
        foreach ($this->db->query('SELECT * FROM calendrier_etape ORDER BY date_cle, id') as $c) {
            $etape = [
                'd' => $c['date_cle'],
                'l' => $c['libelle_date'],
                't' => $c['intitule'],
                's' => $c['statut'],
            ];
            if ($c['libelle_court']) {
                $etape['lc'] = $c['libelle_court'];
            }
            if ($c['intitule_court']) {
                $etape['court'] = $c['intitule_court'];
            }
            if ((int) $c['societe_civile'] === 1) {
                $etape['soc'] = true;
            }
            if ($c['source_id'] && ($s = $this->src((int) $c['source_id']))) {
                $etape['src'] = $s;
            }
            $etapes[] = $etape;
        }
        return $etapes;
    }

    private function phases(): array
    {
        $liste = $this->param('liste_officielle', '2027-03-26');
        $t1 = $this->param('premier_tour', '2027-04-18');
        return [
            ['n' => 'Phase 1 · Candidats déclarés', 'from' => $this->param('debut_suivi', '2026-07-01'), 'to' => $liste,
             'd' => 'Toutes les candidatures publiquement déclarées, ajoutées au fil des annonces.'],
            ['n' => 'Phase 2 · Candidats officiels', 'from' => $liste, 'to' => $t1,
             'd' => 'Les seuls candidats de la liste du Conseil constitutionnel, dans l’ordre du tirage au sort.'],
            ['n' => 'Entre-deux-tours', 'from' => $t1, 'to' => $this->param('second_tour', '2027-05-02'),
             'd' => 'Les deux qualifiés, comparés thème par thème.'],
        ];
    }

    // -----------------------------------------------------------------
    // Contrôles et outils
    // -----------------------------------------------------------------
    private function controlerFraicheur(): void
    {
        $sql = "SELECT 'positions' AS t, COUNT(*) AS n FROM position_candidat
                  WHERE etat = 'valide' AND (verifie_le IS NULL OR verifie_le < CURDATE() - INTERVAL 30 DAY)
                UNION ALL SELECT 'propositions', COUNT(*) FROM proposition
                  WHERE etat = 'valide' AND (verifie_le IS NULL OR verifie_le < CURDATE() - INTERVAL 30 DAY)
                UNION ALL SELECT 'correspondances', COUNT(*) FROM correspondance
                  WHERE etat = 'valide' AND (verifie_le IS NULL OR verifie_le < CURDATE() - INTERVAL 30 DAY)";
        foreach ($this->db->query($sql) as $r) {
            if ((int) $r['n'] > 0) {
                $this->alerte("{$r['n']} {$r['t']} validées sans vérification depuis plus de 30 jours.");
            }
        }
        $sql = "SELECT (SELECT COUNT(*) FROM position_candidat WHERE etat = 'a_valider')
                     + (SELECT COUNT(*) FROM proposition WHERE etat = 'a_valider')
                     + (SELECT COUNT(*) FROM correspondance WHERE etat = 'a_valider')
                     + (SELECT COUNT(*) FROM evenement WHERE etat = 'a_valider')";
        $this->stats['a_valider'] = (int) $this->db->query($sql)->fetchColumn();
    }

    private function param(string $cle, string $defaut): string
    {
        return isset($this->params[$cle]) && $this->params[$cle] !== '' ? $this->params[$cle] : $defaut;
    }

    /** @return array{0:string,1:string}|null */
    private function src(?int $id): ?array
    {
        return ($id && isset($this->sources[$id])) ? $this->sources[$id] : null;
    }

    private function alerte(string $message): void
    {
        $this->alertes[] = $message;
    }

    /** « 2031.00 » → 2031 ; « 15.50 » → 15.5 */
    public static function nombre($valeur)
    {
        if ($valeur === null || $valeur === '') {
            return null;
        }
        $f = (float) $valeur;
        return floor($f) === $f ? (int) $f : $f;
    }

    /** Pourcentages entiers dont la somme fait 100 (méthode du plus fort reste). */
    public static function pourcentages(array $comptes): array
    {
        $total = array_sum($comptes);
        if ($total === 0) {
            return array_fill(0, count($comptes), 0);
        }
        $bruts = array_map(function ($n) use ($total) { return $n * 100 / $total; }, $comptes);
        $entiers = array_map('floor', $bruts);
        $reste = 100 - (int) array_sum($entiers);
        $fractions = [];
        foreach ($bruts as $i => $b) {
            $fractions[$i] = $b - $entiers[$i];
        }
        arsort($fractions);
        foreach (array_slice(array_keys($fractions), 0, $reste) as $i) {
            $entiers[$i]++;
        }
        return array_map('intval', $entiers);
    }
}

/**
 * Construit le site, compare son empreinte à celle du fichier en ligne et
 * n'écrit site.json que si le contenu a changé (écriture atomique).
 *
 * @param string $declencheur manuel · planifie · deploiement · cron
 */
function export_publier(PDO $db, string $dataDir, string $declencheur): array
{
    if (!in_array($declencheur, ['manuel', 'planifie', 'deploiement', 'cron'], true)) {
        $declencheur = 'manuel';
    }
    $resultat = (new ExportSite($db))->construire();
    $site = $resultat['site'];

    $comparable = $site;
    unset($comparable['meta']['genere_le'], $comparable['meta']['maj']);
    $empreinte = hash('sha256', (string) json_encode($comparable, EXPORT_JSON));
    $site['meta']['empreinte'] = $empreinte;

    $fichier = $dataDir . '/site.json';
    $precedente = null;
    if (is_file($fichier)) {
        $ancien = json_decode((string) file_get_contents($fichier), true);
        $precedente = $ancien['meta']['empreinte'] ?? null;
    }

    $rapport = [
        'statut'    => 'inchange',
        'empreinte' => $empreinte,
        'stats'     => $resultat['stats'],
        'alertes'   => $resultat['alertes'],
    ];
    if ($precedente === $empreinte) {
        return $rapport;
    }

    if (!is_dir($dataDir) && !mkdir($dataDir, 0755, true) && !is_dir($dataDir)) {
        throw new RuntimeException('Impossible de créer le dossier ' . $dataDir);
    }
    $json = json_encode($site, EXPORT_JSON | JSON_PRETTY_PRINT);
    if ($json === false) {
        throw new RuntimeException('Encodage JSON impossible : ' . json_last_error_msg());
    }
    $temporaire = $fichier . '.' . bin2hex(random_bytes(4)) . '.tmp';
    if (file_put_contents($temporaire, $json . "\n", LOCK_EX) === false || !rename($temporaire, $fichier)) {
        @unlink($temporaire);
        throw new RuntimeException('Écriture impossible : ' . $fichier);
    }

    $s = $resultat['stats'];
    $stmt = $db->prepare(
        'INSERT INTO publication (empreinte_sha256, declencheur, nb_candidats, nb_positions, nb_propositions, nb_evenements, nb_alertes)
         VALUES (?, ?, ?, ?, ?, ?, ?)'
    );
    $stmt->execute([
        $empreinte, $declencheur, $s['nb_candidats'] ?? 0, $s['nb_positions'] ?? 0,
        $s['nb_propositions'] ?? 0, $s['nb_evenements'] ?? 0, count($resultat['alertes']),
    ]);

    $rapport['statut'] = 'publie';
    return $rapport;
}
