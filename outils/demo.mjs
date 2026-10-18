// Repères 2027 · fabrique public/data/demo.json
//
// Part de public/data/site.json (données réelles) et remplace le
// comparateur, les empreintes et la grille The Shift Project par six
// candidats fictifs (A à F). Sert à vérifier les formats graphiques en
// ligne avec ?demo=1, sans jamais mêler données fictives et réelles.
//
// Usage : node outils/demo.mjs

import { readFileSync, writeFileSync } from "node:fs";

const racine = new URL("../public/data/", import.meta.url);
const site = JSON.parse(readFileSync(new URL("site.json", racine), "utf8"));

const IDS = ["A", "B", "C", "D", "E", "F"];
const valeurs = o => Object.fromEntries(Object.entries(o).filter(([, v]) => v !== undefined));

const VARS = {
  3: [
    { slug: "age-legal", q: "Âge légal de départ à la retraite", type: "num", unit: " ans", min: 59, max: 66, ticks: [60, 62, 64, 66], v: { A: 60, B: 62, C: 64, D: 65, E: null }, shift: null },
    { slug: "duree-cotisation", q: "Durée de cotisation pour une pension à taux plein", type: "num", unit: " ans", min: 40, max: 44, ticks: [40, 41, 42, 43, 44], v: { A: 40, B: 42, C: 43, D: 43, F: 42 }, shift: null },
  ],
  6: [
    { slug: "reacteurs", q: "Nouveaux réacteurs nucléaires à lancer", type: "num", unit: "", min: 0, max: 15, ticks: [0, 5, 10, 15], v: { A: 0, B: 6, C: 14, D: 8, E: 0, F: null }, shift: "nucleaire" },
    { slug: "renouvelables", q: "Part des renouvelables visée dans l'électricité en 2035", type: "num", unit: " %", min: 20, max: 90, ticks: [20, 40, 60, 80], v: { A: 70, B: 50, C: 30, D: 25, E: 85, F: 55 }, shift: "enr" },
    { slug: "neutralite-carbone", q: "Année visée pour la neutralité carbone", type: "cat", mods: ["2040", "2045", "2050", "Année non précisée"], v: { A: "2040", B: "2050", C: "2050", D: "Année non précisée", E: "2045", F: "2050" }, shift: null },
  ],
  11: [
    { slug: "mode-scrutin", q: "Mode de scrutin aux élections législatives", type: "cat", mods: ["Scrutin majoritaire actuel", "Dose de proportionnelle", "Proportionnelle intégrale"], v: { A: "Proportionnelle intégrale", B: "Dose de proportionnelle", C: "Scrutin majoritaire actuel", D: "Proportionnelle intégrale", E: "Proportionnelle intégrale", F: "Dose de proportionnelle" }, shift: null },
    { slug: "vote-16-ans", q: "Droit de vote à 16 ans", type: "cat", mods: ["Pour", "Contre"], v: { A: "Pour", B: "Contre", C: "Contre", D: "Contre", E: "Pour", F: null }, shift: null },
  ],
  13: [
    { slug: "ferroviaire", q: "Investissement public annuel dans le ferroviaire", type: "num", unit: " Md€", min: 0, max: 12, ticks: [0, 4, 8, 12], v: { A: 8, B: 5, C: 3, D: 2, E: 10, F: null }, shift: "train" },
    { slug: "voitures-thermiques", q: "Fin de vente des voitures thermiques neuves", type: "cat", mods: ["Maintenir l'échéance de 2035", "Reporter après 2035", "Abandonner l'échéance"], v: { A: "Maintenir l'échéance de 2035", B: "Maintenir l'échéance de 2035", C: "Reporter après 2035", D: "Abandonner l'échéance", E: "Maintenir l'échéance de 2035", F: "Reporter après 2035" }, shift: "ve" },
  ],
  14: [
    { slug: "encadrement-ia", q: "Encadrement de l'intelligence artificielle", type: "cat", mods: ["Aller au-delà du règlement européen", "Appliquer le règlement européen", "Assouplir les règles européennes"], v: { A: "Aller au-delà du règlement européen", B: "Appliquer le règlement européen", C: "Assouplir les règles européennes", D: "Assouplir les règles européennes", E: "Aller au-delà du règlement européen", F: "Appliquer le règlement européen" }, shift: null },
    { slug: "centres-donnees", q: "Nouveaux centres de données", type: "cat", mods: ["Moratoire", "Encadrer leur consommation d'énergie et d'eau", "Aucune restriction"], v: { A: "Encadrer leur consommation d'énergie et d'eau", B: "Encadrer leur consommation d'énergie et d'eau", C: "Aucune restriction", D: "Aucune restriction", E: "Moratoire" }, shift: "datacenters" },
  ],
};

const FICTIVE = ["Source fictive", "./?demo=1"];
const MESURES = {
  3: {
    A: ["Ramener l'âge légal de départ à 60 ans", "Porter le minimum de pension au niveau du SMIC net", "Financer la réforme par une hausse des cotisations employeurs"],
    B: ["Fixer l'âge légal de départ à 62 ans", "Indexer toutes les pensions sur l'inflation", "Élargir le compte de prévention de la pénibilité"],
    C: ["Maintenir l'âge légal de départ à 64 ans", "Introduire une part de retraite par capitalisation", "Aligner les derniers régimes spéciaux sur le régime général"],
    D: ["Relever l'âge légal de départ à 65 ans d'ici 2032", "Indexer les pensions sur l'inflation", "Ouvrir un départ anticipé pour les carrières longues"],
    E: ["Créer une pension minimale pour les retraités agricoles"],
    F: ["Fixer l'âge légal de départ à 62 ans", "Compter les congés parentaux dans la durée de cotisation", "Créer un fonds de réserve pour les retraites"],
  },
  6: {
    A: [["Sortir du nucléaire d'ici 2045", "nucleaire"], ["Porter à 70 % la part des renouvelables dans l'électricité en 2035", "enr"], "Créer un fonds de 10 milliards d'euros pour l'adaptation des territoires"],
    B: [["Lancer six nouveaux réacteurs EPR2", "nucleaire"], ["Doubler le rythme d'installation du solaire", "enr"], "Instaurer un chèque énergie pour les ménages modestes"],
    C: [["Lancer quatorze nouveaux réacteurs", "nucleaire"], ["Suspendre les nouveaux projets éoliens terrestres", "enr"], "Supprimer les zones à faibles émissions"],
    D: [["Lancer huit nouveaux réacteurs", "nucleaire"], ["Instaurer un moratoire sur l'éolien", "enr"], "Baisser la TVA sur l'énergie à 5,5 %"],
    E: [["Fermer les réacteurs les plus anciens d'ici 2035", "nucleaire"], ["Atteindre 100 % d'électricité renouvelable en 2045", "enr"], "Inscrire la sobriété énergétique dans la loi"],
    F: [["Accélérer l'éolien en mer", "enr"], ["Planter un milliard d'arbres d'ici 2035", "puits"], "Renforcer la taxe carbone aux frontières de l'Union européenne"],
  },
};

// Un caractère par chantier, dans l'ordre de site.shift.chantiers
const ETATS = {
  A: "RRRRPRNRPRPPORRRORP",
  B: "PRRRRPPRRRRRRNPRRRN",
  C: "NPPPNNNPNORRRONPRON",
  D: "NNOPONNPNOPNNONNROR",
  E: "RRRRRRRRRRPPORRRORP",
  F: "PPPNNRNRPNNRNNPRNRN",
};

const EMPREINTE = {
  A: [14, 6, 20, 8, 10, 10, 3, 5, 2, 6, 6, 2, 5, 3],
  B: [8, 14, 10, 6, 7, 6, 4, 12, 8, 10, 5, 5, 2, 3],
  C: [6, 16, 8, 4, 5, 4, 5, 13, 10, 11, 2, 7, 3, 6],
  D: [10, 6, 6, 6, 5, 5, 8, 16, 21, 8, 4, 2, 2, 1],
  E: [8, 4, 6, 9, 9, 20, 10, 2, 2, 5, 9, 3, 9, 4],
  F: [11, 9, 9, 11, 11, 8, 4, 7, 5, 7, 4, 5, 4, 5],
};

const demo = structuredClone(site);
demo.meta.demo = true;
delete demo.meta.empreinte;
demo.comparateur = { candidats: IDS.map(id => ({ id, nom: "Candidat " + id, court: "Candidat " + id })) };
demo.candidats = demo.candidats.map(c => ({ ...c, cmp: false }));

for (const t of demo.themes) {
  const vars = VARS[t.id];
  t.vars = vars ? vars.map(v => ({ ...v, v: valeurs(v.v), src: Object.fromEntries(Object.keys(valeurs(v.v)).filter(k => v.v[k] !== null).map(k => [k, FICTIVE])) })) : [];
  const mes = MESURES[t.id];
  if (mes) {
    t.mesures = Object.fromEntries(Object.entries(mes).map(([id, liste]) => [id, liste.map(x => Array.isArray(x) ? { t: x[0], s: x[1], src: FICTIVE } : { t: x, src: FICTIVE })]));
  } else {
    delete t.mesures;
  }
}

demo.empreinte = EMPREINTE;

if (demo.shift) {
  const ch = demo.shift.chantiers.map(c => c.id);
  demo.shift.etats = Object.fromEntries(Object.entries(ETATS).map(([id, s]) => [id, Object.fromEntries(ch.map((c, i) => [c, s.charAt(i)]))]));
  demo.shift.src = {};
}

// Débats : contexte et arguments réels, positions fictives (na = non abordé, absent = à documenter)
const DEBATS = {
  "nouveaux-reacteurs": { A: -2, B: 2, C: 2, D: 1, E: -1, F: 0 },
  "thermiques-2035": { A: 2, B: 1, C: -1, D: -2, E: 2, F: -1 },
  "moratoire-centres-donnees": { A: 1, B: -1, C: -2, D: -2, E: 2 },
  "encadrement-ia": { A: 2, B: 0, C: -1, D: -2, E: 1, F: 0 },
  "hebergement-souverain": { A: 2, B: 1, C: 0, D: 1, E: 2, F: "na" },
};
if (demo.debats) {
  for (const d of demo.debats.liste) {
    d.pos = Object.fromEntries(Object.entries(DEBATS[d.id] || {}).map(([id, e]) => [id, e === "na" ? { na: true } : { e, cit: "Citation fictive.", src: FICTIVE }]));
  }
}

writeFileSync(new URL("demo.json", racine), JSON.stringify(demo, null, 2) + "\n");
console.log("demo.json écrit :", IDS.length, "candidats fictifs,", Object.keys(VARS).length, "thèmes de démonstration");
