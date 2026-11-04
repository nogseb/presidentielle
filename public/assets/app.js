/* Repères 2027 · interface
 * Lit data/site.json (ou data/demo.json avec ?demo=1) et dessine les vues.
 * Le contrat des données est décrit dans docs/modele-de-donnees.md.
 */
"use strict";

(function () {
  const $ = s => document.querySelector(s);
  // Échappement HTML, plus espaces insécables de la typographie française (guillemets, : ; ! ?)
  const esc = s => String(s == null ? "" : s).replace(/[&<>"]/g, c => ({ "&": "&amp;", "<": "&lt;", ">": "&gt;", '"': "&quot;" }[c]))
    .replace(/« /g, "«\u00a0").replace(/ »/g, "\u00a0»").replace(/ ([:;!?])(?=\s|$)/g, "\u202f$1");
  const fr = n => Number(n).toLocaleString("fr-FR", { maximumFractionDigits: 1 });
  const dayNum = iso => { const [y, m, d] = iso.split("-").map(Number); return Date.UTC(y, m - 1, d) / 864e5; };
  const fmt = (iso, o) => new Date(iso + "T12:00:00Z").toLocaleDateString("fr-FR", Object.assign({ timeZone: "UTC" }, o));
  const norm = s => s.normalize("NFD").replace(/[̀-ͯ]/g, "").toLowerCase();
  const link = l => l ? `<a href="${esc(l[1])}" target="_blank" rel="noopener">${esc(l[0])}</a>` : "";
  const parisToday = () => { try { return new Intl.DateTimeFormat("en-CA", { timeZone: "Europe/Paris" }).format(new Date()); } catch (e) { return new Date().toISOString().slice(0, 10); } };
  const TODAY = parisToday();

  const DEMO = new URLSearchParams(location.search).has("demo");
  if (DEMO) {
    const m = document.createElement("meta"); m.name = "robots"; m.content = "noindex"; document.head.appendChild(m);
  }

  fetch(DEMO ? "data/demo.json" : "data/site.json", { cache: "no-cache" })
    .then(r => { if (!r.ok) throw new Error("HTTP " + r.status); return r.json(); })
    .then(init)
    .catch(err => {
      console.error(err);
      $("#chargement").hidden = true;
      $("#erreur").hidden = false;
    });

  function init(DATA) {
    $("#chargement").hidden = true;
    const META = DATA.meta || {};
    const CMP = (DATA.comparateur && DATA.comparateur.candidats) || [];
    const IDS = CMP.map(c => c.id);
    const NAME = {}; CMP.forEach(c => { NAME[c.id] = c.nom; });
    const nameOf = id => NAME[id] || id;
    const shortOf = id => { const c = CMP.find(x => x.id === id); return c ? c.court : id; };
    const themeById = id => DATA.themes.find(t => t.id === id);
    const SH = DATA.shift;

    if (META.demo) {
      $("#demo-banner").hidden = false;
      document.querySelectorAll("[data-demo]").forEach(el => { el.hidden = false; });
    }

    /* Grille The Shift Project : R repris, P en partie, O opposé, N non abordé, D à documenter */
    const ST = { R: "Repris", P: "En partie", O: "Opposé", N: "Non abordé", D: "À documenter" };
    const ST_ORDER = ["R", "P", "O", "N", "D"];
    const CH = {};
    if (SH) SH.chantiers.forEach((c, i) => { CH[c.id] = Object.assign({ i }, c); });
    const stateOf = (cand, ch) => (SH && SH.etats && SH.etats[cand] && SH.etats[cand][ch]) || "D";
    const shiftSrc = (cand, ch) => SH && SH.src && SH.src[cand] && SH.src[cand][ch];
    const sg = (s, tip) => `<span class="sg sg-${s}" role="img" aria-label="${ST[s]}"${tip ? ` tabindex="0" data-tip="${esc(tip)}"` : ""}></span>`;
    const PST = `<span class="pst-s" aria-hidden="true">S</span>`;
    const shiftChantiersOf = t => SH ? SH.chantiers.filter(c => c.th === t.id) : [];
    const hasShiftData = !!(SH && SH.etats && Object.keys(SH.etats).length);

    /* Compte à rebours */
    const j = Math.max(0, dayNum(META.premier_tour || "2027-04-18") - dayNum(TODAY));
    $("#jcount").textContent = j > 0 ? "J-" + j : "Jour J";

    /* Pied de page */
    if (META.genere_le) {
      const d = new Date(META.genere_le);
      $("#maj").textContent = "Données mises à jour le " + d.toLocaleDateString("fr-FR", { day: "numeric", month: "long", year: "numeric" }) + " à " + d.toLocaleTimeString("fr-FR", { hour: "2-digit", minute: "2-digit" }) + (META.demo ? " · démonstration" : "") + ".";
    }

    /* ---------------------------------------------------------------- La semaine
     * Radar : huit axes (domaines), trois anneaux (portée). Points pleins = faits du digest,
     * points creux = cinq prochaines échéances du calendrier. Règle publiée dans « Méthode ». */
    const RAD_AXES = [
      { l: "Candidatures", d: "Déclarations, retraits, ralliements, primaires" },
      { l: "Règles et calendrier", d: "Scrutin, parrainages, Conseil constitutionnel" },
      { l: "Programmes", d: "Mesures annoncées et chiffrées" },
      { l: "Opinion", d: "Enquêtes d'intentions de vote" },
      { l: "Débats de fond", d: "Les quinze thèmes du comparateur" },
      { l: "Justice et financement", d: "Procédures, comptes de campagne" },
      { l: "Médias et numérique", d: "Temps de parole, désinformation, IA" },
      { l: "Société civile", d: "Think tanks, ONG, syndicats" },
    ];
    const RAD_POR = { course: "Change la course", engagement: "Engage un candidat", signal: "À suivre" };
    const RAD_RING = { course: 0, engagement: 1, signal: 2 };
    const RAD_BANDS = [[24, 66], [76, 112], [124, 156]];
    // Repli si data/site.json ne porte pas encore l'axe (ancien export) : même règle que app/lib/export.php
    const RAD_TYPE = { candidature: [1, "course"], retrait: [1, "course"], ralliement: [1, "course"], primaire: [1, "signal"], decompte: [1, "signal"], institutions: [2, "signal"], calendrier: [2, "signal"], programme: [3, "engagement"], sondage: [4, "signal"], debat: [5, "engagement"], justice: [6, "signal"], societe_civile: [8, "signal"] };
    const NOMBRES = ["Aucun", "Un", "Deux", "Trois", "Quatre", "Cinq", "Six", "Sept", "Huit", "Neuf", "Dix", "Onze", "Douze"];
    const axeNum = a => String(a).padStart(2, "0");
    const axeNom = a => `${axeNum(a)} · ${RAD_AXES[a - 1].l}`;
    const radOf = (x, defaut) => {
      const ok = x.axe >= 1 && x.axe <= 8;
      return [ok ? x.axe : defaut[0], RAD_POR[x.por] ? x.por : defaut[1]];
    };
    const FAITS = (DATA.semaine && DATA.semaine.faits) || [];
    const NEXT = DATA.calendrier.filter(c => c.d >= TODAY).slice(0, 5);
    const SIG = FAITS.map((f, i) => {
      const [axe, por] = radOf(f, RAD_TYPE[f.ty] || [1, "signal"]);
      return { k: "f", id: "fait-" + i, axe, por, date: fmt(f.d, { day: "numeric", month: "short" }), t: f.t };
    }).concat(NEXT.map((c, i) => {
      const [axe, por] = radOf(c, c.soc ? [8, "signal"] : [2, "course"]);
      return { k: "e", id: "eche-" + i, axe, por, date: c.lc || fmt(c.d, { day: "numeric", month: "short" }), t: c.court || c.t };
    }));
    let radAxe = null;

    function renderSemaine() {
      const S = DATA.semaine;
      if (S && S.faits.length) {
        $("#periode").textContent = S.periode;
        $("#facts").innerHTML = S.faits.map((f, i) => {
          const s = SIG[i];
          return `
          <li class="fact" id="${s.id}" data-axe="${s.axe}" tabindex="-1">
            <time datetime="${f.d}">${esc(fmt(f.d, { day: "numeric", month: "short" }))}</time>
            <div class="txt">
              <p>${esc(f.t)}</p>
              <div class="meta"><span class="tag">${esc(axeNom(s.axe))}</span><span class="por por-${s.por}">${RAD_POR[s.por]}</span><span>Source : ${f.src.map(link).join(", ")}</span></div>
            </div>
          </li>`;
        }).join("") + `<li class="empty" id="facts-vide" hidden></li>`;
      } else {
        $("#periode").textContent = "Premier digest à paraître";
        $("#facts").innerHTML = `<li class="empty">Le premier digest sera publié un lundi, avec cinq faits sourcés.</li>`;
      }
      const officiels = META.phase && META.phase !== "declares";
      const n = DATA.candidats.length;
      const unite = officiels ? (n > 1 ? "candidats officiels" : "candidat officiel") : (n > 1 ? "candidatures déclarées" : "candidature déclarée");
      $("#nb-cand").textContent = n; $("#nb-cand-u").textContent = unite;
      $("#nb-cand-2").textContent = n; $("#nb-cand-2u").textContent = unite;
      $("#chiffre-note").textContent = META.chiffre_note || "";
      if (officiels) {
        $("#cand-eyebrow").textContent = "Phase 2 · candidats officiels";
        $("#cand-lede").textContent = "Liste publiée par le Conseil constitutionnel, dans l'ordre du tirage au sort.";
        $("#sort").closest(".field").hidden = true;
      }
      $("#next").innerHTML = NEXT.map((c, i) => { const s = SIG[FAITS.length + i]; return `<li class="next" id="${s.id}" data-axe="${s.axe}" tabindex="-1"><time datetime="${c.d}">${esc(s.date)}</time><span>${esc(c.court || c.t)}${c.soc ? '<span class="soc">Société civile</span>' : ""}</span></li>`; }).join("")
        + `<li><a href="#calendrier">Tout le calendrier</a></li>`;
      renderRadar();
      $("#phases").innerHTML = DATA.phases.map(p => {
        const on = TODAY >= p.from && TODAY < p.to;
        const past = TODAY >= p.to;
        const left = dayNum(p.to) - dayNum(TODAY);
        const st = on ? (p.n.indexOf("Phase 1") === 0 ? `En cours · J-${left} avant la liste officielle` : "En cours") : (past ? "Terminée" : "À venir");
        return `<div class="phase${on ? " on" : ""}"><b>${esc(p.n)}</b><span class="ph-st">${esc(st)}</span><span class="d">${esc(p.d)}</span></div>`;
      }).join("");
      $("#une").innerHTML = DATA.themes.filter(t => t.une).map(t => {
        const k = shiftChantiersOf(t).length;
        return `<a class="une-card" href="#themes" data-theme="${t.id}">
          <span class="eyebrow" style="margin:0">Thème ${t.id}</span>
          <b>${esc(t.n)}</b>
          <span class="small">${t.pivots.slice(0, 3).map(esc).join(" · ")}</span>
          ${k ? `<span class="pst">${PST}${k} chantier${k > 1 ? "s" : ""} du Shift Project</span>` : ""}
        </a>`;
      }).join("");
    }

    // Grand écran : disque élargi avec le nom des axes autour ; mobile : disque carré, numéros seuls
    const RAD_LARGE = window.matchMedia ? matchMedia("(min-width: 640px)") : { matches: false };
    const radPt = (r, deg) => { const a = deg * Math.PI / 180; return [r * Math.sin(a), -r * Math.cos(a)]; };
    let radXY = null;
    const RAD_TOUR = 2.2;                                   // durée d'un tour de faisceau (voir @keyframes rad-sonar)
    let radFige = false;

    function renderRadar() {
      if (!SIG.length) { $("#radar").hidden = true; return; }
      $("#radar").hidden = false;
      const n = SIG.length;
      $("#rad-n").textContent = (NOMBRES[n] || n) + (n > 1 ? " signaux." : " signal.");
      // Position : secteur de l'axe, bande de l'anneau. Plusieurs points d'une même case partent
      // en diagonale, puis s'écartent les uns des autres sans sortir de leur case.
      const P = [];
      for (let a = 1; a <= 8; a++) {
        [0, 1, 2].forEach(r => {
          const items = SIG.filter(s => s.axe === a && RAD_RING[s.por] === r);
          items.forEach((s, j) => {
            const t = items.length === 1 ? 0.5 : j / (items.length - 1);
            const [r0, r1] = RAD_BANDS[r], d0 = (a - 1) * 45;
            P.push({ id: s.id, r0, r1, d0, ra: r0 + (r1 - r0) * t, de: d0 + 9 + 27 * t });
          });
        });
      }
      const ECART = 26;
      for (let it = 0; it < 120; it++) {
        P.forEach(p => { [p.x, p.y] = radPt(p.ra, p.de); });
        for (let i = 0; i < P.length; i++) for (let j = i + 1; j < P.length; j++) {
          const p = P[i], q = P[j];
          let dx = q.x - p.x, dy = q.y - p.y, dd = Math.hypot(dx, dy);
          if (dd >= ECART) continue;
          if (dd < 0.01) { dx = 1; dy = 0; dd = 1; }
          const k = (ECART - dd) / 2 / dd;
          p.x -= dx * k; p.y -= dy * k; q.x += dx * k; q.y += dy * k;
        }
        P.forEach(p => {
          p.ra = Math.min(p.r1, Math.max(p.r0, Math.hypot(p.x, p.y)));
          let rel = ((Math.atan2(p.x, -p.y) * 180 / Math.PI - p.d0) % 360 + 360) % 360;
          if (rel > 202.5) rel -= 360;
          p.de = p.d0 + Math.min(40, Math.max(5, rel));
        });
      }
      radXY = {};
      P.forEach(p => { radXY[p.id] = radPt(p.ra, p.de); });
      $("#rad-axes").innerHTML = RAD_AXES.map((x, i) => {
        const c = SIG.filter(s => s.axe === i + 1).length;
        return `<button type="button" class="ax" data-axe="${i + 1}" aria-pressed="false"${c ? "" : " disabled"}><span class="ax-n">${axeNum(i + 1)}</span><span class="ax-l"><b>${esc(x.l)}</b><span class="ax-d">${esc(x.d)}</span></span><span class="ax-c">${c}<span class="vh"> ${c > 1 ? "signaux" : "signal"}</span></span></button>`;
      }).join("");
      dessinerRadar();
    }

    function dessinerRadar() {
      if (!radXY) return;
      const large = RAD_LARGE.matches;
      const X = large ? 260 : 200, W = 2 * X;               // viewBox : largeur 2X, hauteur 400
      const pc = (x, y) => [((x + X) / W * 100).toFixed(2), ((y + 200) / 4).toFixed(2)];
      const f2 = v => v.toFixed(2);
      const box = $("#rad-box");
      box.style.aspectRatio = `${W} / 400`;
      box.classList.toggle("large", large);
      let h = `<svg class="rad-svg" viewBox="${-X} -200 ${W} 400" aria-hidden="true"><circle class="rad-disc" r="162"/><circle class="rad-core" r="70"/>`
        + [70, 118, 162].map(r => `<circle class="rad-ring" r="${r}"/>`).join("");
      for (let k = 0; k < 8; k++) { const [x, y] = radPt(162, k * 45); h += `<line class="rad-ring" x1="0" y1="0" x2="${f2(x)}" y2="${f2(y)}"/>`; }
      h += `<path class="rad-voile" id="rad-voile" d=""/></svg>`;
      const cote = ["haut", "droite", "droite", "bas", "bas", "gauche", "gauche", "haut"];
      RAD_AXES.forEach((x, k) => {
        const [lx, ly] = radPt(large ? 170 : 180, k * 45 + 22.5), [l, t] = pc(lx, ly);
        const vide = !SIG.some(s => s.axe === k + 1);
        h += `<span class="rad-lab ${large ? cote[k] : "centre"}${vide ? " vide" : ""}" data-axe="${k + 1}" style="left:${l}%;top:${t}%" aria-hidden="true"><b>${axeNum(k + 1)}</b>${large ? esc(x.l) : ""}</span>`;
      });
      const [sl] = pc(-162, 0);
      h += `<div class="rad-sweep" aria-hidden="true" style="left:${sl}%;width:${f2(324 / W * 100)}%;top:9.5%;height:81%"></div><span class="rad-c" aria-hidden="true"></span>`;
      // Sonar : le faisceau fait un tour en RAD_TOUR secondes, toutes les 5 secondes ; chaque point
      // s'allume au passage du faisceau (délai proportionnel à son angle depuis midi).
      const angle = id => ((Math.atan2(radXY[id][0], -radXY[id][1]) * 180 / Math.PI) + 360) % 360;
      h += SIG.map(s => { const [l, t] = pc(radXY[s.id][0], radXY[s.id][1]); return `<button type="button" class="rad-dot ${s.k}" data-cible="${s.id}" data-axe="${s.axe}" style="left:${l}%;top:${t}%;--ping:${(angle(s.id) / 360 * RAD_TOUR).toFixed(2)}s" aria-label="${esc((s.k === "f" ? "Fait du " : "Échéance : ") + s.date + " · " + axeNom(s.axe) + " · " + RAD_POR[s.por] + " · " + s.t)}" data-tip="${esc(s.date + " · " + s.t)}"></button>`; }).join("");
      box.innerHTML = h;
      box.classList.toggle("fige", radFige);
      radarFiltre();
    }

    function radarFiltre() {
      const on = s => radAxe === null || Number(s) === radAxe;
      document.querySelectorAll("#rad-box .rad-dot").forEach(b => b.classList.toggle("off", !on(b.dataset.axe)));
      document.querySelectorAll("#rad-box .rad-lab").forEach(t => t.classList.toggle("on", radAxe !== null && on(t.dataset.axe)));
      document.querySelectorAll("#rad-axes .ax").forEach(b => b.setAttribute("aria-pressed", String(radAxe !== null && on(b.dataset.axe))));
      // Axe choisi : les sept autres secteurs passent sous un voile
      const voile = $("#rad-voile");
      if (voile) {
        if (radAxe === null) voile.setAttribute("d", "");
        else {
          const [x0, y0] = radPt(162, (radAxe - 1) * 45), [x1, y1] = radPt(162, radAxe * 45);
          voile.setAttribute("d", `M0 0L${x1.toFixed(2)} ${y1.toFixed(2)}A162 162 0 1 1 ${x0.toFixed(2)} ${y0.toFixed(2)}Z`);
        }
      }
      const actif = $("#rad-actif");
      actif.hidden = radAxe === null;
      if (radAxe !== null) actif.innerHTML = `<span>Axe ${esc(axeNom(radAxe))}</span><button type="button" id="rad-retirer" aria-label="Retirer le filtre : axe ${esc(axeNom(radAxe))}"><svg viewBox="0 0 12 12" width="12" height="12" aria-hidden="true"><path d="M2 2l8 8M10 2l-8 8" stroke="currentColor" stroke-width="2" stroke-linecap="round"/></svg></button>`;
      let vis = 0;
      document.querySelectorAll("#facts .fact").forEach(li => { li.hidden = !on(li.dataset.axe); if (!li.hidden) vis++; });
      document.querySelectorAll("#next .next").forEach(li => li.classList.toggle("off", !on(li.dataset.axe)));
      const total = FAITS.length;
      const vide = $("#facts-vide");
      if (vide) {
        vide.hidden = vis > 0;
        if (!vis) vide.textContent = `Aucun fait de la semaine sur l'axe ${axeNom(radAxe)}. Ses échéances restent signalées dans « Prochaines étapes ».`;
      }
      $("#facts-n").textContent = !total ? "" : radAxe === null
        ? `${total} fait${total > 1 ? "s" : ""}, du plus récent au plus ancien`
        : `${vis} fait${vis > 1 ? "s" : ""} sur ${total} · axe ${axeNom(radAxe)}`;
      $("#rad-tous").hidden = radAxe === null;
    }

    /* Menu « Filtrer par axe » : s'ouvre sous le bouton, se ferme au choix d'un axe, à Échap ou au clic ailleurs */
    const radBurger = $("#rad-burger"), radMenu = $("#rad-menu");
    function radMenuOuvrir(ouvrir, rendreFocus) {
      radMenu.hidden = !ouvrir;
      radBurger.setAttribute("aria-expanded", String(ouvrir));
      if (ouvrir) { const b = radMenu.querySelector('.ax[aria-pressed="true"]') || radMenu.querySelector(".ax:not(:disabled)"); if (b) b.focus(); }
      else if (rendreFocus) radBurger.focus();
    }
    radBurger.addEventListener("click", () => radMenuOuvrir(radMenu.hidden));
    document.addEventListener("click", e => { if (!radMenu.hidden && !e.target.closest("#rad-menu, #rad-burger")) radMenuOuvrir(false); });
    document.addEventListener("keydown", e => { if (e.key === "Escape" && !radMenu.hidden) radMenuOuvrir(false, true); });
    $("#rad-axes").addEventListener("click", e => {
      const b = e.target.closest("button[data-axe]");
      if (!b || b.disabled) return;
      const a = Number(b.dataset.axe);
      radAxe = radAxe === a ? null : a;
      radarFiltre();
      radMenuOuvrir(false, true);
    });
    $("#rad-tous").addEventListener("click", () => { radAxe = null; radarFiltre(); radMenuOuvrir(false, true); });
    $("#rad-actif").addEventListener("click", e => { if (e.target.closest("#rad-retirer")) { radAxe = null; radarFiltre(); radBurger.focus(); } });
    /* Animation sonar : bouton pause (critère WCAG 2.2.2), absente si l'utilisateur limite les animations */
    $("#rad-pause").addEventListener("click", () => {
      radFige = !radFige;
      $("#rad-box").classList.toggle("fige", radFige);
      const b = $("#rad-pause"), txt = radFige ? "Relancer l'animation" : "Mettre l'animation en pause";
      b.classList.toggle("fige", radFige);
      b.setAttribute("aria-label", txt); b.setAttribute("data-tip", txt);
      if (!tip.hidden) tip.textContent = txt;
    });
    if (RAD_LARGE.addEventListener) RAD_LARGE.addEventListener("change", dessinerRadar);
    else if (RAD_LARGE.addListener) RAD_LARGE.addListener(dessinerRadar);
    $("#rad-box").addEventListener("click", e => {
      const b = e.target.closest("button[data-cible]");
      if (!b) return;
      const el = document.getElementById(b.dataset.cible);
      if (!el) return;
      if (el.hidden || el.classList.contains("off")) { radAxe = null; radarFiltre(); }
      const calme = window.matchMedia && matchMedia("(prefers-reduced-motion: reduce)").matches;
      el.scrollIntoView({ block: "center", behavior: calme ? "auto" : "smooth" });
      el.focus({ preventScroll: true });
      el.classList.remove("flash"); void el.offsetWidth; el.classList.add("flash");
    });

    /* ---------------------------------------------------------------- Candidats */
    const OFFICIELS = !!(META.phase && META.phase !== "declares");
    const MOT_DATE = { declaration: "Déclaration", annonce: "Annonce", primaire: "Désignation", parti: "Désignation" };
    const dateTxt = c => c.dp === "mois" ? fmt(c.d, { month: "long", year: "numeric" }) : fmt(c.d, { day: "numeric", month: "long", year: "numeric" });
    const dateLabel = c => c.d ? `${MOT_DATE[c.dk] || "Déclaration"} · ${dateTxt(c)}` : "";
    const fullName = c => c.p + " " + c.n;
    const initials = c => (c.p.charAt(0) + c.n.charAt(0)).toUpperCase();
    const ageOf = iso => {
      if (!iso) return null;
      const [y, m, d] = iso.split("-").map(Number), [ty, tm, td] = TODAY.split("-").map(Number);
      return ty - y - ((tm < m || (tm === m && td < d)) ? 1 : 0);
    };

    /* Portraits : vignettes de Wikimedia Commons et leurs crédits (photos/credits.json, facultatif) */
    let PHOTOS = {};
    fetch("photos/credits.json", { cache: "no-cache" })
      .then(r => r.ok ? r.json() : null)
      .then(d => { if (d && d.photos) { PHOTOS = d.photos; renderCands(); } })
      .catch(() => {});
    const avatar = c => {
      const ph = PHOTOS[c.id];
      return ph ? `<img class="mono ph" src="${esc(ph.fichier)}" alt="" width="240" height="300" loading="lazy" decoding="async">`
        : `<span class="mono" aria-hidden="true">${esc(initials(c))}</span>`;
    };
    const creditPhoto = id => {
      const ph = PHOTOS[id];
      if (!ph) return "";
      const lic = ph.licence_url ? `<a href="${esc(ph.licence_url)}" target="_blank" rel="noopener license">${esc(ph.licence)}</a>` : esc(ph.licence);
      return `${esc(ph.auteur)}, ${lic}, <a href="${esc(ph.source)}" target="_blank" rel="noopener">Wikimedia Commons</a>`;
    };
    const investi = c => c.dk === "primaire" || c.dk === "parti";
    const aConfirmer = c => !OFFICIELS && (c.st === "a_confirmer" || c.dk === "annonce" || (!c.st && (c.f || []).indexOf("Candidature à confirmer") >= 0));
    const pl = (n, un, plusieurs) => n > 1 ? plusieurs : un;
    const FILTRES = [
      { k: "toutes", l: n => OFFICIELS ? pl(n, "candidat officiel", "candidats officiels") : pl(n, "candidature", "candidatures"), t: () => true },
      { k: "investies", l: n => pl(n, "investie par un parti ou une primaire", "investies par un parti ou une primaire"), t: investi },
      { k: "confirmer", l: () => "en attente de confirmation", t: aConfirmer, phase1: true },
      { k: "programme", l: n => pl(n, "programme publié", "programmes publiés"), t: c => !!c.prog },
    ];
    let filtre = "toutes";
    let vue = "fiches";

    function renderTiles() {
      $("#cand-tiles").innerHTML = FILTRES.filter(f => !(f.phase1 && OFFICIELS)).map(f => {
        const n = DATA.candidats.filter(f.t).length;
        const vide = n === 0 && f.k !== "toutes";
        return `<button type="button" class="tile" data-f="${f.k}" aria-pressed="${filtre === f.k}"${vide ? " disabled" : ""}><b>${n}</b><span>${esc(f.l(n))}</span></button>`;
      }).join("");
    }

    function candList() {
      const q = norm($("#q").value.trim());
      const f = FILTRES.find(x => x.k === filtre) || FILTRES[0];
      let list = DATA.candidats.filter(c => f.t(c) && (!q || norm(fullName(c) + " " + (c.parti || "")).indexOf(q) >= 0));
      const sort = $("#sort").value;
      if (sort === "date") list = list.slice().sort((a, b) => (b.d || "0000").localeCompare(a.d || "0000") || a.n.localeCompare(b.n, "fr"));
      else if (sort === "parti") list = list.slice().sort((a, b) => (a.parti ? 0 : 1) - (b.parti ? 0 : 1) || (a.parti || "").localeCompare(b.parti || "", "fr") || a.n.localeCompare(b.n, "fr"));
      return list;
    }

    function card(c) {
      const badges = (c.b || []).map(x => `<span class="badge">${esc(x)}</span>`).concat((c.f || []).map(x => `<span class="badge flag">${esc(x)}</span>`)).join("");
      const rows = [
        ["Date", c.d ? `${esc(dateTxt(c))} <span class="kv-n">(${esc((MOT_DATE[c.dk] || "Déclaration").toLowerCase())})</span>` : `<span class="todo">À sourcer</span>`],
        ["Programme", c.prog ? `<a href="${esc(c.prog.url)}" target="_blank" rel="noopener">consulter</a>${c.prog.date ? ` <span class="kv-n">(${esc(fmt(c.prog.date, { day: "numeric", month: "long", year: "numeric" }))})</span>` : ""}` : "non publié à ce jour"],
        ["Propositions", c.nb ? `${c.nb} ${pl(c.nb, "vérifiée", "vérifiées")}` : "aucune vérifiée pour l'instant"],
        ["Comparateur", c.cmp ? `<a href="#themes">comparaison complète</a>` : `fiche courte, selon le <a href="#methode">critère publié</a>`],
      ];
      if (SH && c.cmp) {
        const n = Object.keys((SH.etats && SH.etats[c.id]) || {}).length;
        rows.push([`${PST}Shift Project`, n ? `${n} chantier${n > 1 ? "s" : ""} sur ${SH.chantiers.length} documenté${n > 1 ? "s" : ""} · <a href="#shift">voir la grille</a>` : "correspondances à établir"]);
      }
      if (c.src) rows.push(["Candidature", link(c.src)]);
      rows.push(["Biographie", c.bio && c.bioSrc ? link(c.bioSrc) : `<span class="todo">À documenter</span>`]);
      if (PHOTOS[c.id]) rows.push(["Photo", creditPhoto(c.id)]);
      const age = ageOf(c.nai);
      return `<details class="cand" id="cand-${esc(c.id)}">
          <summary>
            ${avatar(c)}
            <span class="who"><span class="nm">${esc(c.p)} <span class="last">${esc(c.n)}</span></span><span class="pt"><span class="${c.parti ? "" : "sans"}">${esc(c.parti || "Sans parti indiqué")}</span>${age ? ` · ${age} ans` : ""}</span></span>
            ${c.d ? `<span class="cdate">${esc(dateLabel(c))}</span>` : ""}
            ${badges ? `<span class="badges">${badges}</span>` : ""}
            ${c.bio ? `<span class="bio">${esc(c.bio)}</span>` : ""}
          </summary>
          <div class="more">
            ${c.note ? `<p>${esc(c.note)}</p>` : ""}
            <dl class="kv">${rows.map(r => `<dt>${r[0]}</dt><dd>${r[1]}</dd>`).join("")}</dl>
          </div>
        </details>`;
    }

    /* Chronologie : un rang par mois, du plus récent au plus ancien, sur douze mois au plus */
    const ymOf = iso => iso.slice(0, 7);
    const ymMinus = (ym, k) => { let [y, m] = ym.split("-").map(Number); m -= k; while (m < 1) { m += 12; y--; } return y + "-" + String(m).padStart(2, "0"); };
    function chipCand(c, avecMois) {
      const jour = c.dp === "mois" ? "" : String(Number(c.d.slice(8, 10)));
      const suffixe = avecMois ? fmt(c.d, c.dp === "mois" ? { month: "short", year: "numeric" } : { day: "numeric", month: "short", year: "numeric" }) : jour;
      return `<button type="button" class="who-chip" data-cand="${esc(c.id)}" data-tip="${esc(fullName(c) + (c.parti ? " (" + c.parti + ")" : "") + " · " + dateLabel(c))}">${esc(fullName(c))}${suffixe ? `<span class="cm-d">${esc(suffixe)}</span>` : ""}</button>`;
    }
    function renderChrono(list) {
      if (!list.length) { $("#chrono").innerHTML = `<p class="empty">Aucune candidature ne correspond.</p>`; return; }
      const dated = list.filter(c => c.d).sort((a, b) => b.d.localeCompare(a.d) || a.n.localeCompare(b.n, "fr"));
      const sans = list.filter(c => !c.d);
      const fin = [ymOf(META.maj || TODAY)].concat(dated.map(c => ymOf(c.d))).sort().pop();
      const limite = ymMinus(fin, 11);
      const recents = dated.filter(c => ymOf(c.d) >= limite);
      const anciens = dated.filter(c => ymOf(c.d) < limite);
      const debut = recents.length ? ymOf(recents[recents.length - 1].d) : fin;
      const rows = [];
      for (let m = fin; m >= debut; m = ymMinus(m, 1)) {
        const ici = recents.filter(c => ymOf(c.d) === m);
        rows.push(`<div class="cm-row"><span class="cm-l">${esc(fmt(m + "-15", { month: "short", year: "numeric" }))}</span><span class="cm-n${ici.length ? "" : " zero"}">${ici.length}</span><span class="cm-c">${ici.map(c => chipCand(c, false)).join("")}</span></div>`);
      }
      if (anciens.length) rows.push(`<div class="cm-row"><span class="cm-l">Plus tôt</span><span class="cm-n">${anciens.length}</span><span class="cm-c">${anciens.map(c => chipCand(c, true)).join("")}</span></div>`);
      $("#chrono").innerHTML = `<p class="small">Du plus récent au plus ancien. Date retenue : déclaration publique, annonce, ou désignation par un parti ou une primaire. Un nom ouvre la fiche correspondante.</p>
        <div class="cm">${rows.join("")}</div>
        ${sans.length ? `<details class="cm-todo"><summary>${sans.length} ${pl(sans.length, "date", "dates")} de déclaration à sourcer</summary><div class="cm-c">${sans.map(c => `<button type="button" class="who-chip" data-cand="${esc(c.id)}">${esc(fullName(c))}</button>`).join("")}</div></details>` : ""}`;
    }

    /* Échiquier : hémicycle des candidatures, de gauche à droite selon l'ordre de la grille des nuances
     * du ministère de l'Intérieur (municipales 2026) ; ordre alphabétique au sein d'une nuance.
     * Divers et sans étiquette (DIV) restent hors de l'axe. L'hémicycle double la légende, seule
     * partie lue par les lecteurs d'écran et parcourue au clavier. */
    const NUANCES = [["EXG", "Extrême gauche"], ["FI", "La France insoumise"], ["COM", "Parti communiste français"], ["SOC", "Parti socialiste"],
      ["VEC", "Les Écologistes"], ["UG", "Union à gauche"], ["DVG", "Divers gauche"], ["ECO", "Écologiste"], ["REG", "Régionaliste"], ["DIV", "Divers"],
      ["REN", "Renaissance"], ["MDM", "Mouvement démocrate"], ["HOR", "Horizons"], ["UDI", "Union des démocrates et indépendants"], ["UC", "Union au centre"],
      ["DVC", "Divers centre"], ["LR", "Les Républicains"], ["UD", "Union à droite"], ["DVD", "Divers droite"], ["DSV", "Droite souverainiste"],
      ["UDR", "Union des droites pour la République"], ["RN", "Rassemblement national"], ["REC", "Reconquête !"], ["UXD", "Union à l'extrême droite"], ["EXD", "Extrême droite"]];
    const NU_ORDRE = {}, NU_LIB = {};
    NUANCES.forEach(([k, l], i) => { NU_ORDRE[k] = i; NU_LIB[k] = l; });
    const NU_SOURCE = "https://www.resultats-elections.interieur.gouv.fr/municipales2026/referentiel.html";
    const AVEC_NUANCES = DATA.candidats.some(c => c.nu);
    const placeOf = c => c.nu && c.nu !== "DIV" && NU_ORDRE[c.nu] !== undefined;
    const tipCand = c => fullName(c) + " · " + (c.parti || "sans parti indiqué") + (c.nu ? " · " + NU_LIB[c.nu] : "") + (c.nuM ? " (" + c.nuM + ")" : "");

    function renderEchiquier(list) {
      const box = $("#echiquier");
      if (!AVEC_NUANCES) { box.innerHTML = ""; return; }
      const vus = new Set(list.map(c => c.id));
      const places = DATA.candidats.filter(placeOf).sort((a, b) => NU_ORDRE[a.nu] - NU_ORDRE[b.nu] || a.n.localeCompare(b.n, "fr"));
      const hors = DATA.candidats.filter(c => !placeOf(c)).sort((a, b) => a.n.localeCompare(b.n, "fr"));
      const N = places.length;
      const groupes = [];
      places.forEach((c, i) => { let g = groupes[groupes.length - 1]; if (!g || g.nu !== c.nu) groupes.push(g = { nu: c.nu, c: [], i: [] }); g.c.push(c); g.i.push(i); });

      // Sièges : rangs concentriques, nombre de sièges proportionnel au rayon, puis tri par angle (gauche → droite)
      const nr = N <= 10 ? 2 : N <= 40 ? 3 : 4, R0 = 0.5, R1 = 0.92;
      const rayons = Array.from({ length: nr }, (_, i) => R0 + (R1 - R0) * i / (nr - 1));
      const somme = rayons.reduce((a, b) => a + b, 0);
      const parRang = rayons.map(r => Math.max(1, Math.round(N * r / somme)));
      for (let ecart = N - parRang.reduce((a, b) => a + b, 0), i = nr - 1; ecart !== 0; i = (i + nr - 1) % nr) {
        if (ecart > 0) { parRang[i]++; ecart--; } else if (parRang[i] > 1) { parRang[i]--; ecart++; }
      }
      const sieges = [];
      // Chaque siège au centre d'un créneau régulier de son rang : pas d'égalité d'angle entre rangs,
      // donc un ordre de lecture net de gauche à droite (à égalité, le plus à gauche d'abord).
      rayons.forEach((r, i) => { const n = parRang[i]; for (let j = 0; j < n; j++) sieges.push({ r, a: Math.PI - (j + 0.5) * Math.PI / n }); });
      sieges.sort((p, q) => q.a - p.a || p.r * Math.cos(p.a) - q.r * Math.cos(q.a));
      const pas = Math.min((R1 - R0) / (nr - 1), ...rayons.map((r, i) => r * Math.PI / parRang[i]));
      const D = pas * 0.9;                                   // diamètre d'un siège
      const RIN = R0 - D / 2 - 0.035, ROUT = R1 + D / 2 + 0.035;
      const XMIN = -(ROUT + 0.14), W = 2 * (ROUT + 0.14), YMIN = -(ROUT + 0.12), H = ROUT + 0.12 + 0.13;
      const pc = (x, y) => [((x - XMIN) / W * 100).toFixed(2), ((y - YMIN) / H * 100).toFixed(2)];
      const xy = (r, a) => [r * Math.cos(a), -r * Math.sin(a)];
      const u = v => (v * 100).toFixed(2);                    // unités du viewBox (×100)

      // Secteurs des nuances : limite à mi-angle entre deux nuances voisines
      groupes.forEach((g, k) => {
        g.a0 = k === 0 ? Math.PI : (Math.min(...groupes[k - 1].i.map(i => sieges[i].a)) + Math.max(...g.i.map(i => sieges[i].a))) / 2;
      });
      groupes.forEach((g, k) => { g.a1 = k === groupes.length - 1 ? 0 : groupes[k + 1].a0; });
      const secteur = g => {
        const [ox0, oy0] = xy(ROUT, g.a0), [ox1, oy1] = xy(ROUT, g.a1), [ix1, iy1] = xy(RIN, g.a1), [ix0, iy0] = xy(RIN, g.a0);
        return `M${u(ox0)} ${u(oy0)}A${u(ROUT)} ${u(ROUT)} 0 0 1 ${u(ox1)} ${u(oy1)}L${u(ix1)} ${u(iy1)}A${u(RIN)} ${u(RIN)} 0 0 0 ${u(ix0)} ${u(iy0)}Z`;
      };
      let h = `<svg class="hc-svg" viewBox="${u(XMIN)} ${u(YMIN)} ${u(W)} ${u(H)}" aria-hidden="true">`
        + groupes.map((g, k) => `<path class="hc-sect${k % 2 ? " alt" : ""}" data-nu="${g.nu}" d="${secteur(g)}"/>`).join("") + `</svg>`;
      // Pastilles numérotées sur le bord, au milieu de chaque secteur, écartées d'au moins ECART_NUM
      const ECART_NUM = Math.min(8.5 * Math.PI / 180, (Math.PI - 0.1) / Math.max(1, groupes.length));
      const mil = groupes.map(g => (g.a0 + g.a1) / 2);
      for (let it = 0; it < 80; it++) {
        for (let k = 0; k < mil.length - 1; k++) {
          const manque = ECART_NUM - (mil[k] - mil[k + 1]);
          if (manque > 0) { mil[k] += manque / 2; mil[k + 1] -= manque / 2; }
        }
        for (let k = 0; k < mil.length; k++) mil[k] = Math.min(Math.PI - 0.05, Math.max(0.05, mil[k]));
      }
      groupes.forEach((g, k) => {
        const [x, y] = xy(ROUT + 0.065, mil[k]), [l, t] = pc(x, y);
        h += `<span class="hc-num" data-nu="${g.nu}" style="left:${l}%;top:${t}%">${k + 1}</span>`;
      });
      places.forEach((c, i) => {
        const [x, y] = xy(sieges[i].r, sieges[i].a), [l, t] = pc(x, y);
        h += `<button type="button" class="seat${vus.has(c.id) ? "" : " off"}" tabindex="-1" data-cand="${esc(c.id)}" data-nu="${c.nu}" style="left:${l}%;top:${t}%;width:${(D / W * 100).toFixed(2)}%" data-tip="${esc(tipCand(c))}">${PHOTOS[c.id] ? `<img src="${esc(PHOTOS[c.id].fichier)}" alt="" loading="lazy" decoding="async">` : `<span>${esc(initials(c))}</span>`}</button>`;
      });
      const [cl, ct] = pc(0, -0.04), [gl, gt] = pc(-(R0 + R1) / 2, 0.065), [dl] = pc((R0 + R1) / 2, 0);
      const centre = `<b>${N}</b><span>${pl(N, "candidature placée", "candidatures placées")}<br>sur ${DATA.candidats.length}</span>`;
      echiquierCentre = nu => { const g = groupes.find(x => x.nu === nu); return g ? `<b>${g.c.length}</b><span>${esc(NU_LIB[nu])}</span>` : centre; };
      h += `<div class="hc-centre" id="hc-centre" style="left:${cl}%;top:${ct}%">${centre}</div>`
        + `<span class="hc-bout" style="left:${gl}%;top:${gt}%">Gauche</span><span class="hc-bout" style="left:${dl}%;top:${gt}%">Droite</span>`;
      const chip = c => `<button type="button" class="who-chip${vus.has(c.id) ? "" : " off"}" data-cand="${esc(c.id)}" data-tip="${esc(tipCand(c))}">${esc(fullName(c))}</button>`;
      box.innerHTML = `<p class="small">De gauche à droite, chaque candidature est placée selon la nuance politique de son parti, dans l'ordre de la <a href="${NU_SOURCE}" target="_blank" rel="noopener">grille des nuances du ministère de l'Intérieur</a> (municipales 2026) ; ordre alphabétique au sein d'une nuance. Ce placement ne mesure ni la radicalité ni la proximité des programmes. Un nom ou un portrait ouvre la fiche.</p>
        <div class="hc" style="aspect-ratio:${u(W)} / ${u(H)}" aria-hidden="true">${h}</div>
        <ol class="hc-leg">${groupes.map((g, k) => `<li data-nu="${g.nu}"><span class="hc-n" aria-hidden="true">${k + 1}</span><div><p class="hc-l"><b>${esc(NU_LIB[g.nu])}</b> <span class="small">· ${g.c.length}</span></p><div class="hc-noms">${g.c.map(chip).join("")}</div></div></li>`).join("")}</ol>
        ${hors.length ? `<div class="hc-hors"><p class="hc-l"><b>Hors de l'axe gauche-droite</b> <span class="small">· ${hors.length}</span></p><p class="small">Divers ou sans étiquette : parti hors de la grille sans rattachement établi, ou candidature sans parti indiqué.</p><div class="hc-noms">${hors.map(chip).join("")}</div></div>` : ""}`;
    }
    let echiquierCentre = () => "";
    function echiquierSurligner(nu) {
      const c = $("#hc-centre");
      if (c) c.innerHTML = echiquierCentre(nu);
      document.querySelectorAll("#echiquier [data-nu]").forEach(el => {
        const on = nu && el.dataset.nu === nu;
        el.classList.toggle("on", !!on);
        if (el.classList.contains("seat")) el.classList.toggle("dim", !!nu && !on);
      });
    }

    function renderCands() {
      const list = candList();
      const total = DATA.candidats.length;
      $("#cands-n").textContent = `${list.length} sur ${total} affichée${list.length > 1 ? "s" : ""}`;
      $("#cands-n").hidden = list.length === total;
      $("#cands").innerHTML = list.length ? list.map(card).join("")
        : `<p class="empty">Aucune candidature ne correspond${$("#q").value.trim() ? ` à « ${esc($("#q").value.trim())} »` : " à ce filtre"}.</p>`;
      renderChrono(list);
      renderEchiquier(list);
    }

    function setVue(v) {
      vue = v;
      $("#vue-fiches").setAttribute("aria-pressed", v === "fiches");
      $("#vue-chrono").setAttribute("aria-pressed", v === "chrono");
      $("#vue-echiquier").setAttribute("aria-pressed", v === "echiquier");
      $("#cands").hidden = v !== "fiches";
      $("#chrono").hidden = v !== "chrono";
      $("#echiquier").hidden = v !== "echiquier";
      $("#cands-note").hidden = v !== "fiches";
      if (!OFFICIELS) $("#sort").closest(".field").hidden = v !== "fiches";
    }

    /* ---------------------------------------------------------------- Graphiques */
    function axisRow(min, max, ticks, fmtTick) {
      return `<div class="dp-axis" aria-hidden="true"><span></span><span class="dp-ticks">${ticks.map(t => `<span style="left:${(t - min) / (max - min) * 100}%">${fmtTick(t)}</span>`).join("")}</span><span></span></div>`;
    }
    const gridLines = (min, max, ticks) => ticks.map(t => `<span class="dp-grid" style="left:${(t - min) / (max - min) * 100}%"></span>`).join("");
    const has = (o, k) => Object.prototype.hasOwnProperty.call(o, k);
    const numLabel = (v, x) => (v.unit === " 000" ? fr(x * 1000) : fr(x) + (v.unit || ""));

    function numVar(v) {
      const rows = IDS.map(id => {
        if (!has(v.v, id)) return `<div class="dp-row"><span class="dp-name">${esc(shortOf(id))}</span><span class="dp-track">${gridLines(v.min, v.max, v.ticks)}</span><span class="dp-val todo">À documenter</span></div>`;
        const x = v.v[id];
        if (x === null) return `<div class="dp-row"><span class="dp-name">${esc(shortOf(id))}</span><span class="dp-track">${gridLines(v.min, v.max, v.ticks)}</span><span class="dp-val na">Non abordé</span></div>`;
        const pct = Math.max(0, Math.min(100, (x - v.min) / (v.max - v.min) * 100));
        const lab = numLabel(v, x);
        const s = v.src && v.src[id];
        return `<div class="dp-row"><span class="dp-name">${esc(shortOf(id))}</span><span class="dp-track">${gridLines(v.min, v.max, v.ticks)}<span class="dp-dot" style="left:${pct}%" tabindex="0" data-tip="${esc(nameOf(id) + " · " + lab + (s ? " · source : " + s[0] : ""))}"></span></span><span class="dp-val">${esc(lab)}</span></div>`;
      }).join("");
      return `<div class="dp" role="img" aria-label="${esc(v.q)} : position de chaque candidat sur un axe">${rows}${axisRow(v.min, v.max, v.ticks, t => v.unit === " 000" ? fr(t * 1000) : fr(t))}</div>`;
    }
    function catVar(v) {
      const rows = v.mods.map(m => {
        const who = IDS.filter(id => v.v[id] === m);
        return `<div class="cat-row"><span class="cat-mod">${esc(m)}</span><span class="cat-cands">${who.length ? who.map(id => `<span class="pill" tabindex="0" data-tip="${esc(nameOf(id) + " · " + m + (v.src && v.src[id] ? " · source : " + v.src[id][0] : ""))}">${esc(shortOf(id))}</span>`).join("") : `<span class="none">Aucun</span>`}</span></div>`;
      });
      const na = IDS.filter(id => has(v.v, id) && v.v[id] === null);
      if (na.length) rows.push(`<div class="cat-row na"><span class="cat-mod">Non abordé</span><span class="cat-cands">${na.map(id => `<span class="pill">${esc(shortOf(id))}</span>`).join("")}</span></div>`);
      const todo = IDS.filter(id => !has(v.v, id));
      if (todo.length) rows.push(`<div class="cat-row todo"><span class="cat-mod todo">À documenter</span><span class="cat-cands">${todo.map(id => `<span class="pill">${esc(shortOf(id))}</span>`).join("")}</span></div>`);
      return `<div class="cat">${rows.join("")}</div>`;
    }
    function shiftStrip(chId) {
      const c = CH[chId];
      if (!c) return "";
      return `<div class="shift-strip">
        <span class="pst">${PST}Chantier du Shift Project : ${esc(c.l)}</span>
        <div class="ss">${IDS.map(id => { const s = stateOf(id, chId); return `<span class="ss-c">${sg(s, nameOf(id) + " · " + c.l + " : " + ST[s].toLowerCase())}<span>${esc(shortOf(id))}</span><span class="ss-l">${ST[s]}</span></span>`; }).join("")}</div>
        <a class="small" href="#shift">Voir toute la grille du Shift Project</a>
      </div>`;
    }
    function varTable(v) {
      return `<details class="data"><summary>Voir le tableau</summary><div class="tbl"><table><thead><tr><th>Candidat</th><th>Position</th>${v.shift ? "<th>Chantier Shift</th>" : ""}<th>Source</th></tr></thead><tbody>${
        IDS.map(id => {
          const val = !has(v.v, id) ? "À documenter" : (v.v[id] === null ? "Non abordé" : (v.type === "num" ? numLabel(v, v.v[id]) : v.v[id]));
          const s = v.src && v.src[id];
          return `<tr><td>${esc(nameOf(id))}</td><td class="num">${esc(val)}</td>${v.shift ? `<td>${ST[stateOf(id, v.shift)]}</td>` : ""}<td class="src-cell">${s ? link(s) : "—"}</td></tr>`;
        }).join("")
      }</tbody></table></div></details>`;
    }

    /* ---------------------------------------------------------------- Comparateur */
    let currentTheme = (DATA.themes.find(t => t.une) || DATA.themes[0]).id;
    const chip = t => `<button type="button" data-id="${t.id}" aria-pressed="${t.id === currentTheme}">${esc(t.c)}${shiftChantiersOf(t).length ? PST : ""}</button>`;
    function renderChips() {
      $("#chips-une").innerHTML = DATA.themes.filter(t => t.une).map(chip).join("");
      $("#chips").innerHTML = DATA.themes.filter(t => !t.une).map(chip).join("");
    }
    function mesureItem(id, x) {
      const src = x.src ? ` <span class="small">(${link(x.src)})</span>` : "";
      if (!x.s || !CH[x.s]) return `<li>${esc(x.t)}${src}</li>`;
      return `<li>${esc(x.t)}${src} <span class="pst">${PST}${esc(CH[x.s].l)} : ${ST[stateOf(id, x.s)].toLowerCase()}</span></li>`;
    }
    function renderTheme() {
      const t = themeById(currentTheme);
      const chs = shiftChantiersOf(t);
      let html = `<div><p class="eyebrow">Thème ${t.id} sur ${DATA.themes.length}${t.une ? " · à la une" : ""}</p><h2>${esc(t.n)}</h2></div>`;
      if (chs.length) html += `<div class="pst-line"><span class="pst">${PST}Sujet traité par The Shift Project</span><span class="small">${chs.map(c => esc(c.l)).join(" · ")}</span></div>`;
      const debs = debatsDuTheme(t.id);
      if (debs.length) html += `<p class="small">Pour et contre : ${debs.map(d => `<a href="#debats" data-debat="${esc(d.id)}">${esc(d.q)}</a>`).join(" · ")}.</p>`;
      if (!IDS.length || !t.vars || !t.vars.length) {
        html += `<div class="panel"><p><b>Aucune position publiée pour ce thème.</b> Les positions apparaissent à mesure que les programmes sont publiés et vérifiés.</p><p class="small">Variables pivots : ${t.pivots.map(esc).join(" · ")}.</p>${chs.length ? `<p class="small">Correspondances avec le Shift Project : <a href="#shift">voir la grille</a>.</p>` : ""}</div>`;
      } else {
        html += t.vars.map(v => `<div class="var"><div class="q"><h3>${esc(v.q)}</h3><span class="kind">${v.type === "num" ? "Valeur chiffrée" : "Choix entre options"}</span></div>${v.type === "num" ? numVar(v) : catVar(v)}${v.shift ? shiftStrip(v.shift) : ""}${varTable(v)}</div>`).join("");
        const autres = t.pivots.filter(q => !t.vars.some(v => v.q === q));
        if (autres.length) html += `<p class="small">Pas encore de position publiée sur : ${autres.map(esc).join(" · ")}.</p>`;
      }
      if (IDS.length && t.mesures) {
        html += `<div class="var"><div class="q"><h3>Trois mesures phares par candidat</h3><span class="kind">Texte</span></div><div class="mesures">${
          IDS.map(id => {
            const m = t.mesures[id] || [];
            const k = m.filter(x => x && x.s).length;
            return `<details><summary>${esc(nameOf(id))} <span>${m.length ? `${m.length} mesure${m.length > 1 ? "s" : ""}${k ? ` · ${k} liée${k > 1 ? "s" : ""} au Shift` : ""}` : "À documenter"}</span></summary>${m.length ? `<ul>${m.map(x => mesureItem(id, x)).join("")}</ul>` : ""}</details>`;
          }).join("")
        }</div></div>`;
      }
      $("#theme").innerHTML = html;
    }

    /* ---------------------------------------------------------------- Radars : un axe par thème, échelle commune 0-30 % */
    const RMAX = 30;
    const NT = DATA.themes.length;
    const EMP = DATA.empreinte || {};
    const EIDS = IDS.filter(id => EMP[id]);
    function radarFrame(n, cx, cy, r) {
      let s = "";
      [10, 20, 30].forEach(lv => {
        const pts = Array.from({ length: n }, (_, i) => { const a = -Math.PI / 2 + i * 2 * Math.PI / n; const k = lv / RMAX * r; return (cx + k * Math.cos(a)).toFixed(1) + "," + (cy + k * Math.sin(a)).toFixed(1); }).join(" ");
        s += `<polygon class="r-ring" points="${pts}"/>`;
      });
      for (let i = 0; i < n; i++) { const a = -Math.PI / 2 + i * 2 * Math.PI / n; s += `<line class="r-spoke" x1="${cx}" y1="${cy}" x2="${(cx + r * Math.cos(a)).toFixed(1)}" y2="${(cy + r * Math.sin(a)).toFixed(1)}"/>`; }
      return s;
    }
    function radarShape(vals, cx, cy, r, cls, who, dotR) {
      const pts = vals.map((v, i) => { const a = -Math.PI / 2 + i * 2 * Math.PI / vals.length; const k = Math.min(v, RMAX) / RMAX * r; return [cx + k * Math.cos(a), cy + k * Math.sin(a)]; });
      let s = `<polygon class="r-shape ${cls}" points="${pts.map(p => p[0].toFixed(1) + "," + p[1].toFixed(1)).join(" ")}"/>`;
      pts.forEach((p, i) => {
        s += `<g tabindex="0" data-tip="${esc(`${who} · ${DATA.themes[i].n} : ${vals[i]} % des propositions`)}"><circle class="r-hit" cx="${p[0].toFixed(1)}" cy="${p[1].toFixed(1)}" r="9"/>${(cls === "b" || !dotR) ? "" : `<circle class="r-dot" cx="${p[0].toFixed(1)}" cy="${p[1].toFixed(1)}" r="${dotR}"/>`}</g>`;
      });
      return s;
    }
    function renderRadars() {
      if (!EIDS.length) {
        $("#radars").hidden = true; $("#compare").hidden = true;
        $("#radars-vide").hidden = false;
        $("#radars-vide").textContent = `Les empreintes s'affichent quand un candidat compte au moins ${META.empreinte_min || 10} propositions vérifiées.`;
        return;
      }
      $("#radars").innerHTML = EIDS.map(id => {
        const vals = EMP[id];
        const top = vals.map((v, i) => [v, i]).sort((a, b) => b[0] - a[0]).slice(0, 2);
        return `<figure class="radar" style="margin:0">
          <svg viewBox="0 0 160 160" role="img" aria-label="Empreinte thématique de ${esc(nameOf(id))}">${radarFrame(NT, 80, 80, 66)}${radarShape(vals, 80, 80, 66, "a", nameOf(id), 0)}</svg>
          <figcaption><span class="rn">${esc(nameOf(id))}</span><br><span class="rt">Plus fortes parts : ${top.map(t => `${esc(DATA.themes[t[1]].c)} ${t[0]} %`).join(", ")}</span></figcaption>
        </figure>`;
      }).join("");
      const opts = EIDS.map(id => `<option value="${esc(id)}">${esc(nameOf(id))}</option>`).join("");
      $("#ca").innerHTML = opts; $("#cb").innerHTML = opts;
      $("#ca").value = EIDS[0]; $("#cb").value = EIDS[Math.min(2, EIDS.length - 1)];
      renderCompare();
    }
    function renderCompare() {
      const a = $("#ca").value, b = $("#cb").value;
      const cx = 210, cy = 150, r = 104;
      let labels = "";
      for (let i = 0; i < NT; i++) {
        const ang = -Math.PI / 2 + i * 2 * Math.PI / NT, c = Math.cos(ang), s = Math.sin(ang);
        const x = cx + (r + 14) * c, y = cy + (r + 14) * s + (s > 0.5 ? 10 : (s < -0.5 ? -2 : 4));
        const anchor = c > 0.2 ? "start" : (c < -0.2 ? "end" : "middle");
        const t = DATA.themes[i];
        labels += `<text class="r-label" x="${x.toFixed(1)}" y="${y.toFixed(1)}" text-anchor="${anchor}">${esc(t.r || t.c)}</text>`;
      }
      const ticks = [10, 20, 30].map(lv => `<text class="r-tick" x="${cx + 4}" y="${(cy - lv / RMAX * r + 11).toFixed(1)}">${lv} %</text>`).join("");
      $("#cmp").innerHTML = `<svg viewBox="0 0 420 300" role="img" aria-label="Empreintes superposées de ${esc(nameOf(a))} et ${esc(nameOf(b))}">${radarFrame(NT, cx, cy, r)}${ticks}${radarShape(EMP[a], cx, cy, r, "a", nameOf(a), 3.5)}${a !== b ? radarShape(EMP[b], cx, cy, r, "b", nameOf(b), 3.5) : ""}${labels}</svg>`;
      $("#cmp-legend").innerHTML = `<span><svg width="28" height="10" aria-hidden="true"><line class="lg-a" x1="0" y1="5" x2="28" y2="5"/></svg>${esc(nameOf(a))}</span>` + (a !== b ? `<span><svg width="28" height="10" aria-hidden="true"><line class="lg-b" x1="0" y1="5" x2="28" y2="5"/></svg>${esc(nameOf(b))}</span>` : "");
      $("#cmp-table").innerHTML = `<table><thead><tr><th>Thème</th><th>${esc(nameOf(a))}</th>${a !== b ? `<th>${esc(nameOf(b))}</th>` : ""}</tr></thead><tbody>${DATA.themes.map((t, i) => `<tr><td>${esc(t.n)}</td><td class="num">${EMP[a][i]} %</td>${a !== b ? `<td class="num">${EMP[b][i]} %</td>` : ""}</tr>`).join("")}</tbody></table>`;
    }

    /* ---------------------------------------------------------------- Débats : pour, contre, positions */
    const DEB = DATA.debats && DATA.debats.liste && DATA.debats.liste.length ? DATA.debats : null;
    const ECH = DEB ? DEB.echelle : [];
    const echLabel = v => (ECH.find(e => e.v === v) || {}).l || "";
    let currentDebat = DEB ? DEB.liste[0].id : null;
    const debatById = id => DEB && DEB.liste.find(d => d.id === id);
    const debatsDuTheme = th => DEB ? DEB.liste.filter(d => d.th === th) : [];
    const posOf = (d, id) => (d.pos && d.pos[id]) || null;

    function renderDebChips() {
      $("#deb-chips").innerHTML = DEB.liste.map(d => `<button type="button" data-deb="${esc(d.id)}" aria-pressed="${d.id === currentDebat}">${esc(d.c)}${d.shift && CH[d.shift] ? PST : ""}</button>`).join("");
    }
    function argList(liste) {
      return `<ol>${liste.map(a => `<li><p>${esc(a.t)}</p><p class="arg-who">${esc(a.qui)} · ${link(a.src)}</p></li>`).join("")}</ol>`;
    }
    function debScale(d) {
      if (!IDS.length) return `<p class="small">Les positions des candidats s'affichent après relecture, pour les candidatures ouvertes à la comparaison complète.</p>`;
      const pill = (id, p) => `<span class="pill" tabindex="0" data-tip="${esc(nameOf(id) + " · " + echLabel(p.e) + (p.cit ? " · « " + p.cit + " »" : "") + (p.src ? " · source : " + p.src[0] : ""))}">${esc(shortOf(id))}</span>`;
      const rows = ECH.map(e => {
        const who = IDS.filter(id => { const p = posOf(d, id); return p && !p.na && p.e === e.v; });
        return `<div class="cat-row"><span class="cat-mod">${esc(e.l)}</span><span class="cat-cands">${who.length ? who.map(id => pill(id, posOf(d, id))).join("") : `<span class="none">Aucun</span>`}</span></div>`;
      });
      const na = IDS.filter(id => { const p = posOf(d, id); return p && p.na; });
      if (na.length) rows.push(`<div class="cat-row na"><span class="cat-mod">Non abordé</span><span class="cat-cands">${na.map(id => `<span class="pill">${esc(shortOf(id))}</span>`).join("")}</span></div>`);
      const todo = IDS.filter(id => !posOf(d, id));
      if (todo.length) rows.push(`<div class="cat-row todo"><span class="cat-mod todo">À documenter</span><span class="cat-cands">${todo.map(id => `<span class="pill">${esc(shortOf(id))}</span>`).join("")}</span></div>`);
      return `<div class="cat">${rows.join("")}</div>`;
    }
    function renderDebat() {
      const d = debatById(currentDebat);
      if (!d) return;
      const t = themeById(d.th);
      const fig = d.chiffre ? `<div class="deb-fig"><span class="n">${esc(d.chiffre.v)}</span><span class="small">${esc(d.chiffre.l)}${d.chiffre.src ? ` (${link(d.chiffre.src)})` : ""}</span></div>` : "";
      const liens = [];
      if (d.var && t) liens.push(`<a href="#themes" data-theme="${t.id}">la variable pivot dans le thème ${esc(t.c)}</a>`);
      if (d.shift && CH[d.shift]) liens.push(`<a href="#shift">la grille du Shift Project</a>`);
      $("#debat").innerHTML = `
        <div class="deb-head">
          <p class="eyebrow">${t ? `Thème ${t.id} · ${esc(t.n)}` : "Débat"}</p>
          <h2 class="deb-q">${esc(d.q)}</h2>
          ${d.shift && CH[d.shift] ? `<p><span class="pst">${PST}Chantier du Shift Project : ${esc(CH[d.shift].l)}</span></p>` : ""}
        </div>
        <div class="deb-ctx">${fig}<p>${esc(d.ctx)} <span class="small">(${link(d.ctxSrc)})</span></p></div>
        <div class="balance">
          <section class="side" aria-label="Arguments pour"><h3><span class="sym" aria-hidden="true">+</span>Arguments pour</h3>${argList(d.pour)}</section>
          <section class="side" aria-label="Arguments contre"><h3><span class="sym" aria-hidden="true">−</span>Arguments contre</h3>${argList(d.contre)}</section>
        </div>
        <div class="var"><div class="q"><h3>Où se placent les candidats</h3><span class="kind">Échelle commune</span></div>${debScale(d)}</div>
        ${liens.length ? `<p class="small">Voir aussi ${liens.join(" et ")}.</p>` : ""}`;
    }
    function miniScale(p, who, d) {
      if (!p) return `<span class="t5-na" title="À documenter">?</span><span class="vh">${esc(who)} : à documenter</span>`;
      if (p.na) return `<span class="t5-na">n.a.</span><span class="vh">${esc(who)} : non abordé</span>`;
      const x = (p.e + 2) / 4 * 100;
      return `<span class="t5" tabindex="0" data-tip="${esc(who + " · " + d.q + " : " + echLabel(p.e) + (p.cit ? " · « " + p.cit + " »" : ""))}"><i style="left:${x}%"></i></span><span class="vh">${esc(who)} : ${esc(echLabel(p.e))}</span>`;
    }
    function renderDebMatrice() {
      $("#deb-vide").hidden = IDS.length > 0;
      $("#deb-matrice").hidden = !IDS.length;
      $("#deb-duel").hidden = IDS.length < 2;
      if (!IDS.length) return;
      $("#deb-matrice").innerHTML = `<table class="mxd"><thead><tr><th scope="col">Candidat</th>${DEB.liste.map(d => `<th scope="col"><a href="#debats" data-debat="${esc(d.id)}">${esc(d.c)}</a></th>`).join("")}</tr></thead><tbody>${
        IDS.map(id => `<tr><th scope="row">${esc(shortOf(id))}</th>${DEB.liste.map(d => `<td>${miniScale(posOf(d, id), nameOf(id), d)}</td>`).join("")}</tr>`).join("")
      }</tbody></table><p class="small mxd-key"><span class="t5" aria-hidden="true"><i style="left:0%"></i></span> contre · <span class="t5" aria-hidden="true"><i style="left:50%"></i></span> nuancé · <span class="t5" aria-hidden="true"><i style="left:100%"></i></span> pour · n.a. non abordé · ? à documenter</p>`;
      const opts = IDS.map(id => `<option value="${esc(id)}">${esc(nameOf(id))}</option>`).join("");
      $("#da").innerHTML = opts; $("#db").innerHTML = opts;
      $("#da").value = IDS[0]; $("#db").value = IDS[Math.min(1, IDS.length - 1)];
      renderDebRadar();
    }
    function renderDebRadar() {
      const a = $("#da").value, b = $("#db").value, L = DEB.liste, n = L.length;
      const cx = 280, cy = 150, r = 104;          // marge latérale pour les libellés longs
      const ang = i => -Math.PI / 2 + i * 2 * Math.PI / n;
      const rad = e => (e + 3) / 5 * r;              // contre = 1/5 du rayon, pour = rayon complet
      let s = "";
      [-2, -1, 0, 1, 2].forEach(e => {
        const pts = L.map((_, i) => (cx + rad(e) * Math.cos(ang(i))).toFixed(1) + "," + (cy + rad(e) * Math.sin(ang(i))).toFixed(1)).join(" ");
        s += `<polygon class="r-ring" points="${pts}"/>`;
      });
      L.forEach((_, i) => { s += `<line class="r-spoke" x1="${cx}" y1="${cy}" x2="${(cx + r * Math.cos(ang(i))).toFixed(1)}" y2="${(cy + r * Math.sin(ang(i))).toFixed(1)}"/>`; });
      const mid = -Math.PI / 2 + Math.PI / n;          // repères placés entre les deux premiers axes
      s += [[-2, "Contre"], [2, "Pour"]].map(([e, l]) => `<text class="r-tick" x="${(cx + rad(e) * Math.cos(mid) + 3).toFixed(1)}" y="${(cy + rad(e) * Math.sin(mid) + 3).toFixed(1)}">${l}</text>`).join("");
      const shape = (id, cls) => {
        const pts = L.map((d, i) => { const p = posOf(d, id); if (!p || p.na) return null; return [cx + rad(p.e) * Math.cos(ang(i)), cy + rad(p.e) * Math.sin(ang(i)), d, p]; });
        let out = "";
        if (pts.every(Boolean)) out += `<polygon class="r-shape ${cls}" points="${pts.map(p => p[0].toFixed(1) + "," + p[1].toFixed(1)).join(" ")}"/>`;
        else pts.forEach((p, i) => { const q = pts[(i + 1) % n]; if (p && q) out += `<line class="r-shape ${cls}" x1="${p[0].toFixed(1)}" y1="${p[1].toFixed(1)}" x2="${q[0].toFixed(1)}" y2="${q[1].toFixed(1)}"/>`; });
        pts.forEach(p => { if (p) out += `<g tabindex="0" data-tip="${esc(nameOf(id) + " · " + p[2].c + " : " + echLabel(p[3].e))}"><circle class="r-hit" cx="${p[0].toFixed(1)}" cy="${p[1].toFixed(1)}" r="9"/>${cls === "a" ? `<circle class="r-dot" cx="${p[0].toFixed(1)}" cy="${p[1].toFixed(1)}" r="3.5"/>` : `<circle class="r-dot b" cx="${p[0].toFixed(1)}" cy="${p[1].toFixed(1)}" r="3.5"/>`}</g>`; });
        return out;
      };
      let labels = "";
      L.forEach((d, i) => {
        const c = Math.cos(ang(i)), sn = Math.sin(ang(i));
        const x = cx + (r + 14) * c, y = cy + (r + 14) * sn + (sn > 0.5 ? 10 : (sn < -0.5 ? -2 : 4));
        labels += `<text class="r-label" x="${x.toFixed(1)}" y="${y.toFixed(1)}" text-anchor="${c > 0.2 ? "start" : (c < -0.2 ? "end" : "middle")}">${esc(d.c)}</text>`;
      });
      $("#deb-radar").innerHTML = `<svg viewBox="0 0 560 300" role="img" aria-label="Positions de ${esc(nameOf(a))}${a !== b ? " et de " + esc(nameOf(b)) : ""} sur ${n} débats">${s}${shape(a, "a")}${a !== b ? shape(b, "b") : ""}${labels}</svg>`;
      $("#deb-legend").innerHTML = `<span><svg width="28" height="10" aria-hidden="true"><line class="lg-a" x1="0" y1="5" x2="28" y2="5"/></svg>${esc(nameOf(a))}</span>` + (a !== b ? `<span><svg width="28" height="10" aria-hidden="true"><line class="lg-b" x1="0" y1="5" x2="28" y2="5"/></svg>${esc(nameOf(b))}</span>` : "");
      const cell = (d, id) => { const p = posOf(d, id); return !p ? "À documenter" : (p.na ? "Non abordé" : echLabel(p.e)); };
      $("#deb-table").innerHTML = `<table><thead><tr><th>Débat</th><th>${esc(nameOf(a))}</th>${a !== b ? `<th>${esc(nameOf(b))}</th>` : ""}</tr></thead><tbody>${L.map(d => `<tr><td>${esc(d.q)}</td><td>${esc(cell(d, a))}</td>${a !== b ? `<td>${esc(cell(d, b))}</td>` : ""}</tr>`).join("")}</tbody></table>`;
    }
    function renderDebats() {
      if (!DEB) { document.querySelector('nav.tabs a[href="#debats"]').hidden = true; return; }
      renderDebChips(); renderDebat(); renderDebMatrice();
    }

    /* ---------------------------------------------------------------- Sondage : fourchettes entre scénarios */
    function renderPoll() {
      const S = DATA.sondage;
      if (!S || !S.rows.length) {
        $("#poll-panel").hidden = true;
        $("#poll-lecture").textContent = "Aucune enquête publiée pour l'instant.";
        return;
      }
      const min = 0, max = Math.max(40, Math.ceil(Math.max.apply(null, S.rows.map(r => r.hi)) / 10) * 10);
      const ticks = []; for (let t = 0; t <= max; t += 10) ticks.push(t);
      $("#poll-lecture").textContent = (S.lecture || "") + " Candidats dans l'ordre alphabétique.";
      const short = n => n.indexOf("Le Pen") >= 0 ? "Le Pen" : n.split(" ").slice(-1)[0];
      $("#poll").innerHTML = S.rows.map(r => {
        const l = (r.lo - min) / (max - min) * 100, w = (r.hi - r.lo) / (max - min) * 100;
        const lab = r.lo === r.hi ? `${fr(r.lo)} %` : `${fr(r.lo)}–${fr(r.hi)} %`;
        return `<div class="dp-row"><span class="dp-name" title="${esc(r.n)}">${esc(short(r.n))}</span><span class="dp-track">${gridLines(min, max, ticks)}<span class="dp-bar" style="left:${l}%;width:${w}%" tabindex="0" data-tip="${esc(r.n + " · " + (r.lo === r.hi ? fr(r.lo) + " %" : "de " + fr(r.lo) + " à " + fr(r.hi) + " % selon les scénarios"))}"></span></span><span class="dp-val">${esc(lab)}</span></div>`;
      }).join("") + axisRow(min, max, ticks, t => t + " %");
      $("#poll-table").innerHTML = `<table><thead><tr><th>Candidat</th><th>Plus bas</th><th>Plus haut</th></tr></thead><tbody>${S.rows.map(r => `<tr><td>${esc(r.n)}</td><td class="num">${fr(r.lo)} %</td><td class="num">${fr(r.hi)} %</td></tr>`).join("")}</tbody></table>`;
      $("#poll-mentions").innerHTML = `${esc(S.mentions)}${S.url ? ` <a href="${esc(S.url)}" target="_blank" rel="noopener">Voir l'enquête</a>` : ""} · <a href="${esc(S.notice || "https://www.commission-des-sondages.fr/")}" target="_blank" rel="noopener">Commission des sondages</a>`;
    }

    /* ---------------------------------------------------------------- The Shift Project */
    function renderShift() {
      if (!SH) { document.querySelector('nav.tabs a[href="#shift"]').hidden = true; return; }
      $("#sh-count").textContent = SH.chantiers.length;
      $("#sh-vide").hidden = hasShiftData || !!META.demo;
      $("#sh-ensemble").hidden = !hasShiftData || !IDS.length;
      $("#sh-table-wrap").hidden = !hasShiftData || !IDS.length;
      $("#sh-legend").innerHTML = ST_ORDER.map(s => `<span class="key">${sg(s)}${ST[s]}</span>`).join("");
      $("#sh-summary").innerHTML = IDS.map(id => {
        const counts = ST_ORDER.map(s => SH.chantiers.filter(c => stateOf(id, c.id) === s).length);
        const glyphs = ST_ORDER.map((s, k) => Array.from({ length: counts[k] }, () => sg(s)).join("")).join("");
        const txt = ST_ORDER.map((s, k) => counts[k] ? `${counts[k]} ${ST[s].toLowerCase()}` : "").filter(Boolean).join(" · ");
        return `<div class="unit-row"><span class="unit-name">${esc(shortOf(id))}</span><span class="unit-g" role="img" aria-label="${esc(txt)}">${glyphs}</span><span class="unit-n">${esc(txt)}</span></div>`;
      }).join("");
      // Groupes : chapitres du livre si la base les fournit (migration 004), sinon domaines
      const CHAPS = SH.chapitres && SH.chapitres.length ? SH.chapitres : null;
      let groupes;
      if (CHAPS) {
        groupes = CHAPS.filter(ch => SH.chantiers.some(c => c.chap === ch.n)).map(ch => ({
          titre: `Chapitre ${ch.n} · ${ch.t}`, court: `Ch. ${ch.n}`, page: ch.p, th: ch.th, list: SH.chantiers.filter(c => c.chap === ch.n),
        }));
        const sans = SH.chantiers.filter(c => !CHAPS.some(ch => ch.n === c.chap));
        if (sans.length) groupes.push({ titre: "Autres chantiers", court: "", page: null, th: null, list: sans });
      } else {
        groupes = SH.chantiers.map(c => c.dom).filter((d, i, a) => a.indexOf(d) === i).map(d => {
          const list = SH.chantiers.filter(c => c.dom === d);
          return { titre: d, court: d, page: null, th: list[0].th, list };
        });
      }
      if (CHAPS && SH.livre) {
        const L = SH.livre;
        const annee = L.d ? fmt(L.d, { month: "long", year: "numeric" }) : "";
        $("#sh-lede").innerHTML = `The Shift Project, think tank présidé par Jean-Marc Jancovici, détaille son Plan robuste pour l'économie française dans un livre paru ${annee ? "en " + esc(annee) : "récemment"}, ${L.src ? `<a href="${esc(L.src[1])}" target="_blank" rel="noopener">«&nbsp;${esc(L.t.split(". ")[0])}&nbsp;»</a>` : `«&nbsp;${esc(L.t.split(". ")[0])}&nbsp;»`} (${esc(L.ed)}). Pour chacun des <span id="sh-count"></span> chantiers retenus ici, regroupés selon les chapitres du livre, la grille indique si le candidat le reprend, en partie, s'y oppose ou ne l'aborde pas.`;
        $("#sh-count").textContent = SH.chantiers.length;
      }
      $("#sh-mx-titre").textContent = CHAPS ? "Chantier par chantier, chapitre par chapitre" : "Chantier par chantier";
      $("#sh-mx-note").hidden = !CHAPS;
      if (CHAPS) $("#sh-mx-note").textContent = `${groupes.filter(g => g.court).length} chapitres du livre sur ${CHAPS.length} portent un chantier de la grille. Le rattachement d'un chantier à un chapitre est un choix du site.`;
      const cols = IDS.length ? IDS : [];
      const tpl = cols.length ? `grid-template-columns:minmax(9rem,1fr) repeat(${cols.length},30px);min-width:calc(9rem + ${cols.length * 34}px)` : "grid-template-columns:1fr";
      let mx = cols.length ? `<div class="mx-row mx-head" style="${tpl}" aria-hidden="true"><span></span>${cols.map(id => `<span title="${esc(nameOf(id))}">${esc(shortOf(id))}</span>`).join("")}</div>` : "";
      groupes.forEach(g => {
        const th = g.th ? themeById(g.th) : null;
        const infos = [g.page ? `p. ${g.page}` : "", th ? `<a href="#themes" data-theme="${th.id}">${CHAPS ? esc(th.n) : "Thème " + esc(th.c)}</a>` : ""].filter(Boolean).join(" · ");
        mx += `<div class="mx-dom" style="min-width:calc(9rem + ${cols.length * 34}px)"><b>${esc(g.titre)}</b>${infos ? `<span class="small">${infos}</span>` : ""}</div>`;
        g.list.forEach(c => {
          mx += `<div class="mx-row" style="${tpl}"><span class="mx-l">${esc(c.l)}</span>${cols.map(id => { const s = stateOf(id, c.id); const src = shiftSrc(id, c.id); return `<span class="mx-c">${sg(s, nameOf(id) + " · " + c.l + " : " + ST[s].toLowerCase() + (src ? " · source : " + src[0] : ""))}</span>`; }).join("")}</div>`;
        });
      });
      $("#sh-matrix").innerHTML = mx;
      $("#sh-table").innerHTML = cols.length ? `<table><thead><tr><th>${CHAPS ? "Chapitre" : "Domaine"}</th><th>Chantier</th>${cols.map(id => `<th>${esc(shortOf(id))}</th>`).join("")}</tr></thead><tbody>${groupes.map(g => g.list.map(c => `<tr><td>${esc(g.court)}</td><td>${esc(c.l)}</td>${cols.map(id => { const src = shiftSrc(id, c.id); return `<td>${ST[stateOf(id, c.id)]}${src ? ` (${link(src)})` : ""}</td>`; }).join("")}</tr>`).join("")).join("")}</tbody></table>` : "";
      const autres = CHAPS ? CHAPS.filter(ch => !SH.chantiers.some(c => c.chap === ch.n)) : [];
      $("#sh-chap-autres").hidden = !autres.length;
      if (autres.length) {
        $("#sh-chap-autres").innerHTML = `<h3>Les ${autres.length} autres chapitres du livre</h3><p class="small">Ils ne portent pas de chantier dans cette grille. Le thème indiqué renvoie au comparateur.</p>`
          + `<ul class="chap-list">${autres.map(ch => { const th = ch.th ? themeById(ch.th) : null; return `<li><span class="chap-n">${ch.n}</span><span class="chap-t"><span>${esc(ch.t)}${ch.p ? ` <span class="small">p.&nbsp;${ch.p}</span>` : ""}</span><span class="small">${th ? `Thème : <a href="#themes" data-theme="${th.id}">${esc(th.n)}</a>` : "Sans thème correspondant dans le comparateur"}</span></span></li>`; }).join("")}</ul>`;
      }
      $("#sh-org").innerHTML = `<dl class="facts-org">
          <dt>Qui</dt><dd>${esc(SH.qui)}</dd>
          <dt>Demande</dt><dd>${esc(SH.demande)}</dd>
          <dt>Financement</dt><dd>${esc(SH.finance)} ${link(SH.financeSrc)}</dd>
          ${SH.hatvp ? `<dt>HATVP</dt><dd><a href="${esc(SH.hatvp)}" target="_blank" rel="noopener">Fiche au répertoire des représentants d'intérêts</a></dd>` : ""}
        </dl>`;
      $("#sh-disp").innerHTML = SH.dispositifs.map(d => `<article><span class="when">${esc(d.when)}</span><h3>${esc(d.t)}</h3><p>${esc(d.d)}</p>${d.src.length ? `<p class="small">Source : ${d.src.map(link).join(", ")}</p>` : ""}</article>`).join("");
    }

    /* ---------------------------------------------------------------- Calendrier */
    function renderCal() {
      const lab = { officiel: "Officiel", fait: "Fait", annonce: "Annoncé", calcule: "Calculé" };
      $("#cal").innerHTML = DATA.calendrier.map(c => `<li class="${c.d < TODAY ? "past" : ""}"><span class="when">${esc(c.l)}</span><span class="what">${esc(c.t)}${c.soc ? '<span class="soc">Société civile</span>' : ""}${c.src ? ` <span class="small">(${link(c.src)})</span>` : ""}</span><span class="s"><span class="st st-${c.s}">${lab[c.s]}</span></span></li>`).join("");
    }

    /* ---------------------------------------------------------------- Quiz
     * Données : data/quiz-2022.json, chargé à la première ouverture de l'onglet.
     * Les réponses restent en mémoire, dans cette page : rien n'est enregistré ni envoyé. */
    const QZ = { D: null, promesse: null, version: "court", liste: [], i: 0, rep: {}, imp: {}, sel: [] };
    const QZ_MIN = 5;                                   // réponses minimales pour un résultat
    const qzEch = v => QZ.D.echelle.find(e => e.v === v) || {};
    const qzCand = id => QZ.D.candidats.find(c => c.id === id);
    const qzNom = c => c.p + " " + c.n;
    const qzSrc = k => { const s = QZ.D.sources[k]; return s ? [s.e + (s.d ? ", " + qzDate(s.d) : ""), s.u, s.t] : null; };
    const qzDate = d => d.length === 7 ? fmt(d + "-15", { month: "long", year: "numeric" }) : fmt(d, { day: "numeric", month: "long", year: "numeric" });
    const qzLien = k => { const s = qzSrc(k); return s ? `<a href="${esc(s[1])}" target="_blank" rel="noopener" title="${esc(s[2])}">${esc(s[0])}</a>` : ""; };
    const qzTheme = th => { const t = themeById(th); return t ? (t.r || t.c) : "Thème " + th; };
    const qzRepondues = () => QZ.liste.filter(q => QZ.rep[q.id] !== undefined && QZ.rep[q.id] !== null);

    function quizCharger() {
      if (QZ.promesse) return QZ.promesse;
      QZ.promesse = fetch("data/quiz-2022.json", { cache: "no-cache" })
        .then(r => { if (!r.ok) throw new Error("HTTP " + r.status); return r.json(); })
        .then(d => { QZ.D = d; $("#qz-chargement").hidden = true; renderQuizAccueil(); })
        .catch(err => { console.error(err); $("#qz-chargement").hidden = true; $("#qz-erreur").hidden = false; });
      return QZ.promesse;
    }
    function quizVue(v) {
      $("#qz-accueil").hidden = v !== "accueil";
      $("#qz-question").hidden = v !== "question";
      $("#qz-resultats").hidden = v !== "resultats";
      $("#v-quiz .lede").hidden = v !== "accueil";
    }
    function quizListe(version) {
      const qs = QZ.D.questions.filter(q => version === "complet" || q.court);
      return qs.slice().sort((a, b) => a.th - b.th || (b.court ? 1 : 0) - (a.court ? 1 : 0));
    }
    function renderQuizAccueil() {
      const D = QZ.D;
      $("#qz-eyebrow").textContent = "Quiz · " + D.titre.toLowerCase();
      $("#qz-ed-titre").textContent = D.titre + " · " + D.candidats.length + " candidats";
      $("#qz-ed-texte").textContent = D.presentation;
      const nC = D.questions.filter(q => q.court).length, nT = D.questions.length;
      $("#qz-start").innerHTML = `
        <button type="button" class="btn" data-qz="court">Version courte<span>${nC} affirmations, une par thème · 3 minutes environ</span></button>
        <button type="button" class="btn sec" data-qz="complet">Version complète<span>${nT} affirmations · 5 minutes environ</span></button>`;
      quizVue("accueil");
    }
    function quizDemarrer(version, garder) {
      QZ.version = version;
      QZ.liste = quizListe(version);
      if (!garder) { QZ.rep = {}; QZ.imp = {}; }
      const k = QZ.liste.findIndex(q => QZ.rep[q.id] === undefined);
      QZ.i = k >= 0 ? k : 0;
      renderQuizQuestion(true);
    }
    function renderQuizQuestion(focus) {
      const q = QZ.liste[QZ.i], n = QZ.liste.length;
      const r = QZ.rep[q.id], imp = QZ.imp[q.id] || "normal";
      const faites = QZ.liste.filter(x => QZ.rep[x.id] !== undefined).length;
      const pip = v => `<span class="pip" aria-hidden="true">${[-2, -1, 0, 1, 2].map(k => `<i class="${k === v ? "on" : ""}"></i>`).join("")}</span>`;
      const nb = qzRepondues().length;
      $("#qz-question").innerHTML = `
        <div class="qz-top">
          <p class="eyebrow">Affirmation ${QZ.i + 1} sur ${n} · ${esc(themeById(q.th) ? themeById(q.th).n : "")}</p>
          <div class="qz-prog" role="progressbar" aria-label="Progression" aria-valuemin="0" aria-valuemax="${n}" aria-valuenow="${faites}"><i style="width:${(faites / n * 100).toFixed(1)}%"></i></div>
        </div>
        <h2 class="qz-q" id="qz-q" tabindex="-1">${esc(q.q)}</h2>
        <div class="qz-imp"><span class="small" id="qz-imp-l">Importance pour vous</span>
          <div class="seg" role="group" aria-labelledby="qz-imp-l">${QZ.D.importance.map(x => `<button type="button" data-imp="${x.k}" aria-pressed="${x.k === imp}">${esc(x.l)}</button>`).join("")}</div>
        </div>
        <fieldset class="qz-rep"><legend class="vh">Votre avis sur : ${esc(q.q)}</legend>
          ${QZ.D.echelle.map(e => `<button type="button" data-rep="${e.v}" aria-pressed="${r === e.v}">${pip(e.v)}${esc(e.rep)}</button>`).join("")}
          <button type="button" class="btn lien qz-sans" data-rep="sans" aria-pressed="${r === null}">Sans avis, passer</button>
        </fieldset>
        <div class="qz-nav">
          <button type="button" class="btn sec" data-nav="prec"${QZ.i === 0 ? " disabled" : ""}>Précédente</button>
          ${QZ.i < n - 1 && r !== undefined ? `<button type="button" class="btn sec" data-nav="suiv">Suivante</button>` : ""}
          <button type="button" class="btn fin" data-nav="fin"${nb < QZ_MIN ? ` disabled title="Au moins ${QZ_MIN} réponses"` : ""}>Voir mes résultats</button>
        </div>
        <p class="small" aria-live="polite">${faites === n && nb < QZ_MIN ? `<b>Vous avez donné ${nb} avis sur ${n}.</b> Le résultat demande au moins ${QZ_MIN} réponses : revenez sur des affirmations passées avec « Précédente ».` : `Le résultat s'affiche à partir de ${QZ_MIN} réponses. Vous pouvez revenir sur chaque affirmation.`}</p>`;
      quizVue("question");
      if (focus) { const h = $("#qz-q"); if (h) h.focus({ preventScroll: true }); window.scrollTo(0, 0); }
    }
    // Pendant le remplissage, on passe à la prochaine affirmation sans réponse ;
    // en relecture (tout est déjà répondu), on avance une à une jusqu'aux résultats.
    function quizRepondre(v) {
      const q = QZ.liste[QZ.i], n = QZ.liste.length;
      const relecture = QZ.liste.every(x => QZ.rep[x.id] !== undefined);
      QZ.rep[q.id] = v;
      const libre = k => QZ.rep[QZ.liste[k].id] === undefined;
      let suite = -1;
      if (relecture) suite = QZ.i < n - 1 ? QZ.i + 1 : -1;
      else {
        for (let k = QZ.i + 1; k < n && suite < 0; k++) if (libre(k)) suite = k;
        for (let k = 0; k < QZ.i && suite < 0; k++) if (libre(k)) suite = k;
      }
      if (suite >= 0) { QZ.i = suite; renderQuizQuestion(true); }
      else if (qzRepondues().length >= QZ_MIN) renderQuizResultats();
      else renderQuizQuestion(false);
    }

    /* Calcul : accord = 1 − |réponse − position| / 4, moyenne pondérée par l'importance,
       sur les seules affirmations où la position du candidat est documentée. */
    function quizScores() {
      const W = {}; QZ.D.importance.forEach(x => { W[x.k] = x.w; });
      const reps = qzRepondues();
      const seuil = Math.max(QZ_MIN, Math.ceil(reps.length / 3));
      const res = QZ.D.candidats.map(c => {
        let sw = 0, sa = 0, n = 0; const th = {};
        reps.forEach(q => {
          const p = q.pos[c.id];
          if (!p || p.na) return;
          const w = W[QZ.imp[q.id] || "normal"], a = 1 - Math.abs(QZ.rep[q.id] - p.e) / 4;
          sw += w; sa += w * a; n++;
          const t = th[q.th] || (th[q.th] = { sw: 0, sa: 0, n: 0 });
          t.sw += w; t.sa += w * a; t.n++;
        });
        const parTheme = {}; Object.keys(th).forEach(k => { parTheme[k] = Math.round(th[k].sa / th[k].sw * 100); });
        return { c, n, score: sw ? Math.round(sa / sw * 100) : null, th: parTheme, ok: n >= seuil };
      });
      const classes = res.filter(r => r.ok).sort((a, b) => b.score - a.score || b.n - a.n || a.c.n.localeCompare(b.c.n, "fr"));
      const autres = res.filter(r => !r.ok).sort((a, b) => b.n - a.n || a.c.n.localeCompare(b.c.n, "fr"));
      return { reps, seuil, classes, autres };
    }
    const qzListeNoms = arr => arr.length < 2 ? arr.join("") : arr.slice(0, -1).join(", ") + " et " + arr[arr.length - 1];
    const qzListeCourte = arr => arr.length > 5 ? arr.slice(0, 4).join(", ") + " et " + (arr.length - 4) + " autres thèmes" : qzListeNoms(arr);
    function renderQuizResultats() {
      const S = quizScores();
      const R = S.classes;
      if (!QZ.sel.length || QZ.sel.some(id => !R.find(r => r.c.id === id))) QZ.sel = R.slice(0, 3).map(r => r.c.id);
      let synth;
      if (!R.length) {
        synth = `<p>Trop peu de positions documentées recoupent vos réponses pour conclure. Répondez à davantage d'affirmations, ou passez à la version complète.</p>`;
      } else {
        const top = R.slice(0, 3);
        const de = r => `${/^[aeiouyéèêâîh]/i.test(r.c.p) ? "d'" : "de "}<b>${esc(qzNom(r.c))}</b> (${r.score} %)`;
        synth = `<p>Parmi les ${QZ.D.candidats.length} candidats de 2022, vos réponses sont les plus proches des positions ${de(top[0])}${top.length > 1 ? `, puis ${qzListeNoms(top.slice(1).map(de))}` : ""}.</p>`;
        if (R.length > 1 && R[0].score - R[1].score < 5) synth += `<p class="small">L'écart entre les deux premiers est faible : une ou deux réponses suffisent à inverser l'ordre.</p>`;
        const t0 = top[0], accords = [], desaccords = [];
        Object.keys(t0.th).forEach(k => { if (t0.th[k] >= 75) accords.push(qzTheme(Number(k))); else if (t0.th[k] <= 25) desaccords.push(qzTheme(Number(k))); });
        if (accords.length || desaccords.length) synth += `<p class="small">Avec ${esc(qzNom(t0.c))} : ${accords.length ? `accord net sur ${esc(qzListeCourte(accords))}` : ""}${accords.length && desaccords.length ? " ; " : ""}${desaccords.length ? `désaccord sur ${esc(qzListeCourte(desaccords))}` : ""}. Calcul fait sur ${t0.n} de vos ${S.reps.length} réponses.</p>`;
      }
      const rank = R.map((r, k) => `<li><span class="rg">${k + 1}</span><span class="nm2">${esc(qzNom(r.c))} <span>· ${esc(r.c.parti)}</span></span><span class="pc">${r.score} %</span><span class="bar" aria-hidden="true"><i style="width:${r.score}%"></i></span><span class="cov">Sur ${r.n} affirmation${r.n > 1 ? "s" : ""} comparable${r.n > 1 ? "s" : ""}</span></li>`).join("");
      const autres = S.autres.length ? `<p class="small">Positions trop peu documentées sur vos réponses pour conclure (au moins ${S.seuil} affirmations comparables requises) : ${S.autres.map(r => `${esc(qzNom(r.c))} (${r.n})`).join(", ")}.</p>` : "";
      $("#qz-resultats").innerHTML = `
        <div class="qz-top"><p class="eyebrow">Vos résultats · ${S.reps.length} réponse${S.reps.length > 1 ? "s" : ""} · ${esc(QZ.D.titre.toLowerCase())}</p></div>
        <div class="panel qz-synth">${synth}</div>
        ${R.length ? `<div class="block"><h2>Accord avec chaque candidat</h2><ol class="qz-rank">${rank}</ol>${autres}</div>` : autres}
        ${R.length ? `<div class="block">
          <div><h2>Thème par thème</h2><p class="small" style="margin-top:6px">Chaque axe est un thème ; plus le point est loin du centre, plus vos réponses rejoignent celles du candidat. Un axe sans point : pas d'affirmation comparable sur ce thème. Trois candidats au plus.</p></div>
          <div class="qz-who" id="qz-who" role="group" aria-label="Candidats affichés sur le radar"></div>
          <figure id="qz-radar" style="margin:0"></figure>
          <div class="legend qz-legend" id="qz-legend"></div>
          <details class="data"><summary>Voir le tableau</summary><div class="tbl" id="qz-table"></div></details>
        </div>` : ""}
        <div class="block"><h2>Vos réponses et les positions relevées</h2><div class="qz-det">${quizDetail(S)}</div></div>
        <blockquote>Ce résultat n'est pas une consigne de vote. Il dépend des affirmations retenues, de leur formulation et des positions documentées pendant la campagne de 2022 ; il ne dit rien des candidatures de 2027. Méthode de calcul : voir la page <a href="#methode">Méthode</a>.</blockquote>
        <div class="qz-actions">
          <button type="button" class="btn sec" data-nav="revoir">Revoir mes réponses</button>
          ${QZ.version === "court" ? `<button type="button" class="btn sec" data-nav="complet">Continuer avec la version complète</button>` : ""}
          <button type="button" class="btn lien" data-nav="zero">Recommencer</button>
        </div>`;
      quizVue("resultats");
      if (R.length) renderQuizRadar(S);
      window.scrollTo(0, 0);
    }
    function quizDetail(S) {
      return S.reps.map(q => {
        const r = QZ.rep[q.id], imp = QZ.D.importance.find(x => x.k === (QZ.imp[q.id] || "normal"));
        const lignes = QZ.D.candidats.map(c => {
          const p = q.pos[c.id];
          const sel = QZ.sel.indexOf(c.id) >= 0 ? " sel" : "";
          if (!p) return `<tr class="na${sel}"><td>${esc(qzNom(c))}</td><td class="ec">—</td><td>Position non documentée</td><td></td></tr>`;
          if (p.na) return `<tr class="na${sel}"><td>${esc(qzNom(c))}</td><td class="ec">Non abordé</td><td>${esc(p.x)}</td><td class="src-cell">${qzLien(p.src)}</td></tr>`;
          return `<tr class="${sel.trim()}"><td>${esc(qzNom(c))}</td><td class="ec">${esc(qzEch(p.e).pos)}</td><td>${esc(p.x)}</td><td class="src-cell">${qzLien(p.src)}</td></tr>`;
        }).join("");
        return `<details><summary><b>${esc(q.q)}</b><span>${esc(qzTheme(q.th))} · votre réponse : ${esc(qzEch(r).rep)}${imp && imp.k !== "normal" ? ` · importance ${esc(imp.l.toLowerCase())}` : ""}</span></summary>
          <div class="tbl"><table><thead><tr><th>Candidat</th><th>Position</th><th>Relevé</th><th>Source</th></tr></thead><tbody>${lignes}</tbody></table></div></details>`;
      }).join("");
    }
    const QZ_STYLES = ["a", "b", "c"];
    function qzTrait(k) { return `<svg width="28" height="10" aria-hidden="true"><line class="lg-${QZ_STYLES[k]}" x1="0" y1="5" x2="28" y2="5"/></svg>`; }
    function renderQuizRadar(S) {
      const R = S.classes;
      $("#qz-who").innerHTML = R.map(r => { const k = QZ.sel.indexOf(r.c.id); return `<button type="button" data-qzc="${esc(r.c.id)}" aria-pressed="${k >= 0}">${k >= 0 ? qzTrait(k) : ""}${esc(r.c.n)}</button>`; }).join("");
      const T = DATA.themes, n = T.length;
      const cx = 220, cy = 172, r = 118;          // viewBox 440 × 340 : libellés lisibles sur mobile
      const ang = i => -Math.PI / 2 + i * 2 * Math.PI / n;
      const pt = (i, v) => [cx + v / 100 * r * Math.cos(ang(i)), cy + v / 100 * r * Math.sin(ang(i))];
      let s = "";
      [25, 50, 75, 100].forEach(lv => { s += `<polygon class="r-ring" points="${T.map((_, i) => pt(i, lv).map(x => x.toFixed(1)).join(",")).join(" ")}"/>`; });
      T.forEach((_, i) => { const p = pt(i, 100); s += `<line class="r-spoke" x1="${cx}" y1="${cy}" x2="${p[0].toFixed(1)}" y2="${p[1].toFixed(1)}"/>`; });
      const mid = -Math.PI / 2 + Math.PI / n;
      s += [50, 100].map(lv => `<text class="r-tick" x="${(cx + lv / 100 * r * Math.cos(mid) + 3).toFixed(1)}" y="${(cy + lv / 100 * r * Math.sin(mid) + 3).toFixed(1)}">${lv} %</text>`).join("");
      QZ.sel.forEach((id, k) => {
        const res = R.find(x => x.c.id === id);
        if (!res) return;
        const cls = QZ_STYLES[k];
        const pts = T.map((t, i) => res.th[t.id] === undefined ? null : pt(i, res.th[t.id]).concat([t, res.th[t.id]]));
        if (pts.every(Boolean)) s += `<polygon class="r-shape ${cls}" points="${pts.map(p => p[0].toFixed(1) + "," + p[1].toFixed(1)).join(" ")}"/>`;
        else pts.forEach((p, i) => { const q = pts[(i + 1) % n]; if (p && q) s += `<line class="r-shape ${cls}" x1="${p[0].toFixed(1)}" y1="${p[1].toFixed(1)}" x2="${q[0].toFixed(1)}" y2="${q[1].toFixed(1)}"/>`; });
        pts.forEach(p => { if (p) s += `<g tabindex="0" data-tip="${esc(qzNom(res.c) + " · " + p[2].n + " : " + p[3] + " % d'accord")}"><circle class="r-hit" cx="${p[0].toFixed(1)}" cy="${p[1].toFixed(1)}" r="9"/><circle class="r-dot ${cls === "a" ? "" : cls}" cx="${p[0].toFixed(1)}" cy="${p[1].toFixed(1)}" r="3.5"/></g>`; });
      });
      T.forEach((t, i) => {
        const c = Math.cos(ang(i)), sn = Math.sin(ang(i));
        const x = cx + (r + 14) * c, y = cy + (r + 14) * sn + (sn > 0.5 ? 10 : (sn < -0.5 ? -2 : 4));
        const vide = !S.reps.some(q => q.th === t.id);
        s += `<text class="r-label${vide ? " vide" : ""}" x="${x.toFixed(1)}" y="${y.toFixed(1)}" text-anchor="${c > 0.2 ? "start" : (c < -0.2 ? "end" : "middle")}">${esc(t.r || t.c)}</text>`;
      });
      const noms = QZ.sel.map(id => qzNom(qzCand(id)));
      $("#qz-radar").innerHTML = `<svg viewBox="0 0 440 340" role="img" aria-label="${esc("Accord par thème avec " + qzListeNoms(noms))}">${s}</svg>`;
      $("#qz-legend").innerHTML = QZ.sel.map((id, k) => `<span>${qzTrait(k)}${esc(qzNom(qzCand(id)))}</span>`).join("");
      const themesRep = T.filter(t => S.reps.some(q => q.th === t.id));
      $("#qz-table").innerHTML = `<table><thead><tr><th>Thème</th><th>Affirmations</th>${QZ.sel.map(id => `<th>${esc(qzCand(id).n)}</th>`).join("")}</tr></thead><tbody>${themesRep.map(t => `<tr><td>${esc(t.n)}</td><td class="num">${S.reps.filter(q => q.th === t.id).length}</td>${QZ.sel.map(id => { const v = R.find(x => x.c.id === id).th[t.id]; return `<td class="num">${v === undefined ? "—" : v + " %"}</td>`; }).join("")}</tr>`).join("")}</tbody></table>`;
    }

    $("#qz-start").addEventListener("click", e => { const b = e.target.closest("button[data-qz]"); if (b) quizDemarrer(b.dataset.qz, false); });
    $("#qz-question").addEventListener("click", e => {
      const b = e.target.closest("button");
      if (!b || b.disabled) return;
      const q = QZ.liste[QZ.i];
      if (b.dataset.imp) { QZ.imp[q.id] = b.dataset.imp; b.parentNode.querySelectorAll("button").forEach(x => x.setAttribute("aria-pressed", x === b)); return; }
      if (b.dataset.rep) { quizRepondre(b.dataset.rep === "sans" ? null : Number(b.dataset.rep)); return; }
      if (b.dataset.nav === "prec" && QZ.i > 0) { QZ.i--; renderQuizQuestion(true); }
      else if (b.dataset.nav === "suiv") { QZ.i++; renderQuizQuestion(true); }
      else if (b.dataset.nav === "fin") renderQuizResultats();
    });
    $("#qz-resultats").addEventListener("click", e => {
      const c = e.target.closest("button[data-qzc]");
      if (c) {
        const id = c.dataset.qzc, k = QZ.sel.indexOf(id);
        if (k >= 0) { if (QZ.sel.length > 1) QZ.sel.splice(k, 1); }
        else { QZ.sel.push(id); if (QZ.sel.length > 3) QZ.sel.shift(); }
        const S = quizScores();
        renderQuizRadar(S);
        $("#qz-resultats .qz-det").innerHTML = quizDetail(S);
        return;
      }
      const b = e.target.closest("button[data-nav]");
      if (!b) return;
      if (b.dataset.nav === "revoir") { QZ.i = 0; renderQuizQuestion(true); }
      else if (b.dataset.nav === "complet") quizDemarrer("complet", true);
      else if (b.dataset.nav === "zero") { QZ.rep = {}; QZ.imp = {}; QZ.sel = []; renderQuizAccueil(); window.scrollTo(0, 0); }
    });

    /* ---------------------------------------------------------------- Navigation par onglets */
    const VIEWS = ["semaine", "candidats", "themes", "debats", "quiz", "sondages", "shift", "calendrier", "methode"];
    function route() {
      const h = (location.hash || "").replace("#", "");
      const v = VIEWS.indexOf(h) >= 0 ? h : "semaine";
      VIEWS.forEach(id => { $("#v-" + id).hidden = id !== v; });
      if (v === "quiz") quizCharger();
      document.querySelectorAll("nav.tabs a").forEach(a => {
        if (a.getAttribute("href") === "#" + v) { a.setAttribute("aria-current", "page"); a.scrollIntoView({ block: "nearest", inline: "nearest" }); }
        else a.removeAttribute("aria-current");
      });
    }
    window.addEventListener("hashchange", () => { route(); window.scrollTo(0, 0); });

    document.addEventListener("click", e => {
      const a = e.target.closest("a[data-theme]");
      if (!a) return;
      currentTheme = Number(a.dataset.theme);
      renderChips(); renderTheme();
      if (location.hash === "#themes") { e.preventDefault(); route(); window.scrollTo(0, 0); }
    });

    /* ---------------------------------------------------------------- Infobulles */
    const tip = $("#tip");
    function placeTip(x, y) {
      const w = tip.offsetWidth, h = tip.offsetHeight;
      tip.style.left = Math.max(8, Math.min(x + 12, innerWidth - w - 8)) + "px";
      tip.style.top = Math.max(8, (y - h - 12 < 8 ? y + 16 : y - h - 12)) + "px";
    }
    function showTip(el, x, y) { tip.textContent = el.getAttribute("data-tip"); tip.hidden = false; placeTip(x, y); }
    document.addEventListener("pointerover", e => { const el = e.target.closest("[data-tip]"); if (el) showTip(el, e.clientX, e.clientY); else tip.hidden = true; });
    document.addEventListener("pointermove", e => { if (!tip.hidden && e.target.closest("[data-tip]")) placeTip(e.clientX, e.clientY); });
    document.addEventListener("focusin", e => { const el = e.target.closest("[data-tip]"); if (el) { const r = el.getBoundingClientRect(); showTip(el, r.left + r.width / 2, r.top); } else tip.hidden = true; });
    document.addEventListener("scroll", () => { tip.hidden = true; }, { passive: true });

    /* ---------------------------------------------------------------- Démarrage */
    ["#chips", "#chips-une"].forEach(sel => $(sel).addEventListener("click", e => { const b = e.target.closest("button[data-id]"); if (!b) return; currentTheme = Number(b.dataset.id); renderChips(); renderTheme(); }));
    $("#q").addEventListener("input", renderCands);
    $("#sort").addEventListener("change", renderCands);
    $("#cand-tiles").addEventListener("click", e => {
      const b = e.target.closest("button[data-f]");
      if (!b || b.disabled) return;
      filtre = b.dataset.f === filtre ? "toutes" : b.dataset.f;
      renderTiles(); renderCands();
    });
    $("#vue-fiches").addEventListener("click", () => setVue("fiches"));
    $("#vue-chrono").addEventListener("click", () => setVue("chrono"));
    $("#vue-echiquier").hidden = !AVEC_NUANCES;
    $("#vue-echiquier").addEventListener("click", () => setVue("echiquier"));
    $("#echiquier").addEventListener("mouseover", e => { const el = e.target.closest("[data-nu]"); echiquierSurligner(el ? el.dataset.nu : null); });
    $("#echiquier").addEventListener("mouseleave", () => echiquierSurligner(null));
    $("#echiquier").addEventListener("focusin", e => { const li = e.target.closest("li[data-nu]"); echiquierSurligner(li ? li.dataset.nu : null); });
    $("#echiquier").addEventListener("focusout", () => echiquierSurligner(null));
    ["#chrono", "#echiquier"].forEach(sel => $(sel).addEventListener("click", e => {
      const b = e.target.closest("[data-cand]");
      if (!b) return;
      setVue("fiches");
      const el = document.getElementById("cand-" + b.dataset.cand);
      if (el) { el.open = true; el.scrollIntoView({ block: "center" }); el.querySelector("summary").focus({ preventScroll: true }); }
    }));
    $("#ca").addEventListener("change", renderCompare);
    if (DEB) {
      $("#deb-chips").addEventListener("click", e => {
        const b = e.target.closest("button[data-deb]");
        if (!b) return;
        currentDebat = b.dataset.deb; renderDebChips(); renderDebat();
      });
      $("#da").addEventListener("change", renderDebRadar);
      $("#db").addEventListener("change", renderDebRadar);
    }
    document.addEventListener("click", e => {
      const a = e.target.closest("a[data-debat]");
      if (!a || !DEB) return;
      currentDebat = a.dataset.debat; renderDebChips(); renderDebat();
      if (location.hash === "#debats") { e.preventDefault(); $("#debat").scrollIntoView({ block: "start" }); }
    });
    $("#cb").addEventListener("change", renderCompare);
    $("#cmp-vide").hidden = IDS.length > 0;

    renderSemaine(); renderTiles(); renderCands(); renderChips(); renderTheme(); renderRadars(); renderDebats(); renderPoll(); renderShift(); renderCal(); route();
  }
})();
