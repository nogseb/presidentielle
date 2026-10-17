<?php
/**
 * Repères 2027 · mise en forme des dates et nombres en français.
 * Indépendant de l'extension intl, absente de certains hébergements.
 */

declare(strict_types=1);

const FR_MOIS = [
    1 => 'janvier', 'février', 'mars', 'avril', 'mai', 'juin',
    'juillet', 'août', 'septembre', 'octobre', 'novembre', 'décembre',
];

/** « 2026-09-03 » → « 3 septembre 2026 » (« 1er » pour le premier du mois). */
function fr_date(string $iso, bool $avecAnnee = true): string
{
    [$a, $m, $j] = array_map('intval', explode('-', substr($iso, 0, 10)));
    $jour = $j === 1 ? '1er' : (string) $j;
    return $jour . ' ' . FR_MOIS[$m] . ($avecAnnee ? ' ' . $a : '');
}

/** Période compacte : « du 3 au 9 septembre 2026 », « du 28 septembre au 4 octobre 2026 ». */
function fr_periode(string $debut, string $fin, bool $majuscule = false): string
{
    [$a1, $m1] = array_map('intval', explode('-', $debut));
    [$a2, $m2] = array_map('intval', explode('-', $fin));
    if ($a1 === $a2 && $m1 === $m2) {
        [, , $j1] = array_map('intval', explode('-', $debut));
        $texte = 'du ' . ($j1 === 1 ? '1er' : $j1) . ' au ' . fr_date($fin);
    } elseif ($a1 === $a2) {
        $texte = 'du ' . fr_date($debut, false) . ' au ' . fr_date($fin);
    } else {
        $texte = 'du ' . fr_date($debut) . ' au ' . fr_date($fin);
    }
    return $majuscule ? 'D' . substr($texte, 1) : $texte;
}

/** 13060 → « 13 060 » avec une espace fine insécable. */
function fr_nombre(int $n): string
{
    return number_format($n, 0, ',', "\u{202F}");
}
