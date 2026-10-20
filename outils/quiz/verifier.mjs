// Repères 2027 · contrôle des données du quiz
// Usage : node outils/quiz/verifier.mjs [public/data/quiz-2022.json]
// Vérifie la structure, les sources et la couverture, puis affiche le nombre de positions
// documentées par candidat. Code de sortie 1 en cas d'erreur (utilisé par le workflow Contrôler).

import { readFileSync } from "node:fs";

const fichier = process.argv[2] || "public/data/quiz-2022.json";
const Q = JSON.parse(readFileSync(fichier, "utf8"));
const erreurs = [];
const err = m => erreurs.push(m);
const NB_THEMES = 15;

if (Q.version !== 1) err("version : 1 attendu");
if (!Q.edition || !Q.titre || !Q.presentation) err("edition, titre et presentation sont obligatoires");
const crans = (Q.echelle || []).map(e => e.v).join(",");
if (crans !== "-2,-1,0,1,2") err("echelle : cinq crans de -2 à 2 attendus");
if (!(Q.importance || []).length || Q.importance.some(i => !(i.w > 0))) err("importance : poids positifs attendus");

const ids = new Set();
for (const c of Q.candidats || []) {
  if (!c.id || !c.p || !c.n) err(`candidat incomplet : ${JSON.stringify(c)}`);
  if (ids.has(c.id)) err(`candidat en double : ${c.id}`);
  ids.add(c.id);
}

const sources = Q.sources || {};
for (const [k, s] of Object.entries(sources)) {
  if (!s.e || !s.t || !/^https:\/\//.test(s.u || "")) err(`source ${k} : éditeur, titre et URL https obligatoires`);
  if (s.d && !/^\d{4}-\d{2}(-\d{2})?$/.test(s.d)) err(`source ${k} : date AAAA-MM ou AAAA-MM-JJ attendue`);
}

const utilisees = new Set();
const qids = new Set();
const parTheme = {}, courtesParTheme = {};
const couverture = Object.fromEntries([...ids].map(id => [id, 0]));
for (const q of Q.questions || []) {
  if (qids.has(q.id)) err(`question en double : ${q.id}`);
  qids.add(q.id);
  if (!Number.isInteger(q.th) || q.th < 1 || q.th > NB_THEMES) err(`${q.id} : thème hors de 1-${NB_THEMES}`);
  if (!q.q || !/\.$/.test(q.q)) err(`${q.id} : affirmation absente ou sans point final`);
  if (q.q && q.q.length > 140) err(`${q.id} : affirmation de plus de 140 caractères`);
  parTheme[q.th] = (parTheme[q.th] || 0) + 1;
  if (q.court) courtesParTheme[q.th] = (courtesParTheme[q.th] || 0) + 1;
  let documentees = 0;
  const sens = new Set();
  for (const [cid, p] of Object.entries(q.pos || {})) {
    if (!ids.has(cid)) err(`${q.id} : candidat inconnu ${cid}`);
    if (!p.src || !sources[p.src]) err(`${q.id} / ${cid} : source absente ou inconnue (${p.src})`);
    else utilisees.add(p.src);
    if (!p.x) err(`${q.id} / ${cid} : position relevée (x) absente`);
    if (p.na) { if ("e" in p) err(`${q.id} / ${cid} : na et e sont exclusifs`); continue; }
    if (!Number.isInteger(p.e) || p.e < -2 || p.e > 2) err(`${q.id} / ${cid} : échelle hors de -2..2`);
    documentees++;
    couverture[cid]++;
    sens.add(Math.sign(p.e));
  }
  if (documentees < 3) err(`${q.id} : au moins trois positions documentées attendues (${documentees})`);
  if (sens.size < 2) console.log(`Note : ${q.id} ne compte que des positions de même sens.`);
}
for (let t = 1; t <= NB_THEMES; t++) {
  if (!parTheme[t]) err(`thème ${t} sans question`);
  if (courtesParTheme[t] !== 1) err(`thème ${t} : une et une seule question de la version courte attendue (${courtesParTheme[t] || 0})`);
}
for (const k of Object.keys(sources)) if (!utilisees.has(k)) err(`source inutilisée : ${k}`);

const n = (Q.questions || []).length;
console.log(`${fichier} : ${n} affirmations, ${Object.values(courtesParTheme).length} en version courte, ${ids.size} candidats, ${Object.keys(sources).length} sources.`);
console.log("Positions documentées par candidat :");
for (const [id, k] of Object.entries(couverture)) console.log(`  ${id.padEnd(14)} ${String(k).padStart(2)} / ${n}`);

if (erreurs.length) {
  console.error(`\n${erreurs.length} erreur(s) :\n- ` + erreurs.join("\n- "));
  process.exit(1);
}
console.log("Quiz conforme.");
