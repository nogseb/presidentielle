"""Photos des candidats depuis Wikimedia Commons, et fiches de travail pour les biographies.

Lancé par le workflow « Photos des candidats » (GitHub Actions), jamais sur le serveur.

Pour chaque candidat de outils/photos/candidats.json :
  1. lit l'article de Wikipédia en français : image de l'infobox, élément Wikidata, introduction ;
  2. lit Wikidata : nature (être humain), date et lieu de naissance, image de repli ;
  3. lit la description du fichier sur Wikimedia Commons : auteur, licence, page source ;
  4. télécharge une vignette, la recadre au format 4:5 et l'enregistre en WebP 240 × 300
     dans public/photos/<identifiant>.webp ;
  5. écrit public/photos/credits.json, lu par le site pour afficher les crédits.

Les fiches de travail (naissance, introduction de l'article, date de révision) sont écrites
dans le journal d'exécution et dans $RUNNER_TEMP/fiches.json : elles servent à rédiger et
vérifier les biographies, qui sont ensuite saisies dans la base.
"""

import html
import io
import json
import os
import re
import sys
import time
import urllib.parse
import urllib.request
from datetime import datetime, timezone

from PIL import Image

RACINE = os.path.dirname(os.path.dirname(os.path.dirname(os.path.abspath(__file__))))
MANIFESTE = os.path.join(RACINE, "outils", "photos", "candidats.json")
DOSSIER = os.path.join(RACINE, "public", "photos")
CREDITS = os.path.join(DOSSIER, "credits.json")
LARGEUR, HAUTEUR = 240, 300
AGENT = "Reperes2027-photos/1.0 (https://nogues.app/presidentielle/; veille presidentielle)"

WP = "https://fr.wikipedia.org/w/api.php"
WD = "https://www.wikidata.org/w/api.php"
COMMONS = "https://commons.wikimedia.org/w/api.php"


def appel(url, params=None, binaire=False, essais=3):
    if params:
        url = url + "?" + urllib.parse.urlencode(params)
    for i in range(essais):
        try:
            req = urllib.request.Request(url, headers={"User-Agent": AGENT})
            with urllib.request.urlopen(req, timeout=30) as r:
                data = r.read()
            time.sleep(0.3)
            return data if binaire else json.loads(data.decode("utf-8"))
        except Exception as e:  # réseau ou limitation de débit : on réessaie
            if i == essais - 1:
                raise
            time.sleep(2 * (i + 1))


def texte(valeur):
    """Champ extmetadata de Commons (souvent du HTML) vers texte simple."""
    if not valeur:
        return ""
    v = re.sub(r"<[^>]+>", " ", str(valeur))
    return re.sub(r"\s+", " ", html.unescape(v)).strip()


def article(titre):
    d = appel(WP, {
        "action": "query", "format": "json", "formatversion": 2, "redirects": 1,
        "titles": titre, "prop": "pageimages|pageprops|extracts|revisions|info",
        "piprop": "name", "exintro": 1, "explaintext": 1, "rvprop": "timestamp", "inprop": "url",
    })
    page = d["query"]["pages"][0]
    if page.get("missing"):
        return None
    props = page.get("pageprops", {})
    return {
        "titre": page["title"],
        "url": page.get("fullurl"),
        "qid": props.get("wikibase_item"),
        "homonymie": "disambiguation" in props,
        "image": page.get("pageimage"),
        "intro": (page.get("extract") or "")[:2500],
        "revision": (page.get("revisions") or [{}])[0].get("timestamp"),
    }


def wikidata(qid):
    d = appel(WD, {"action": "wbgetentities", "ids": qid, "props": "claims|descriptions",
                   "languages": "fr", "format": "json"})
    e = d["entities"][qid]
    claims = e.get("claims", {})

    def valeur(p):
        try:
            return claims[p][0]["mainsnak"]["datavalue"]["value"]
        except (KeyError, IndexError):
            return None

    humain = any(c["mainsnak"].get("datavalue", {}).get("value", {}).get("id") == "Q5"
                 for c in claims.get("P31", []))
    naissance = valeur("P569")
    lieu = valeur("P19")
    lieu_nom = None
    if lieu:
        l = appel(WD, {"action": "wbgetentities", "ids": lieu["id"], "props": "labels",
                       "languages": "fr", "format": "json"})
        lieu_nom = l["entities"][lieu["id"]].get("labels", {}).get("fr", {}).get("value")
    return {
        "humain": humain,
        "description": e.get("descriptions", {}).get("fr", {}).get("value"),
        "naissance": naissance["time"][1:11] if naissance else None,
        "naissance_precision": naissance.get("precision") if naissance else None,
        "lieu_naissance": lieu_nom,
        "image": valeur("P18"),
    }


def commons(fichier):
    d = appel(COMMONS, {
        "action": "query", "format": "json", "formatversion": 2, "titles": "File:" + fichier,
        "prop": "imageinfo", "iiprop": "url|extmetadata|size|mime", "iiurlwidth": 480,
    })
    page = d["query"]["pages"][0]
    if page.get("missing") or not page.get("imageinfo"):
        return None
    ii = page["imageinfo"][0]
    m = ii.get("extmetadata", {})
    g = lambda k: (m.get(k) or {}).get("value")
    return {
        "vignette": ii.get("thumburl") or ii.get("url"),
        "source": ii.get("descriptionurl"),
        "auteur": texte(g("Artist")) or texte(g("Credit")) or "Auteur non indiqué",
        "licence": texte(g("LicenseShortName")) or "Licence non indiquée",
        "licence_url": g("LicenseUrl"),
        "date": texte(g("DateTimeOriginal"))[:10] or None,
        "mime": ii.get("mime"),
    }


def recadrer(donnees, haut):
    im = Image.open(io.BytesIO(donnees))
    im = im.convert("RGB")
    w, h = im.size
    cible = LARGEUR / HAUTEUR
    if w / h > cible:                       # trop large : on garde le centre
        nw = round(h * cible)
        x0 = (w - nw) // 2
        im = im.crop((x0, 0, x0 + nw, h))
    elif w / h < cible:                     # trop haute : on garde surtout le haut (le visage)
        nh = round(w / cible)
        y0 = round((h - nh) * haut)
        im = im.crop((0, y0, w, y0 + nh))
    im = im.resize((LARGEUR, HAUTEUR), Image.LANCZOS)
    sortie = io.BytesIO()
    im.save(sortie, "WEBP", quality=80, method=6)
    return sortie.getvalue()


def main():
    manifeste = json.load(open(MANIFESTE, encoding="utf-8"))["candidats"]
    os.makedirs(DOSSIER, exist_ok=True)
    anciens = {}
    if os.path.exists(CREDITS):
        anciens = json.load(open(CREDITS, encoding="utf-8")).get("photos", {})

    photos, fiches, bilan = {}, {}, []
    for slug, conf in manifeste.items():
        ligne = {"id": slug, "photo": "non", "licence": "", "auteur": "", "remarque": ""}
        try:
            a = article(conf["article"])
            if not a:
                ligne["remarque"] = "article introuvable"
                bilan.append(ligne)
                continue
            w = wikidata(a["qid"]) if a["qid"] else {}
            fiches[slug] = {"article": a["titre"], "url": a["url"], "qid": a["qid"],
                            "description": w.get("description"), "naissance": w.get("naissance"),
                            "naissance_precision": w.get("naissance_precision"),
                            "lieu_naissance": w.get("lieu_naissance"),
                            "revision": a["revision"], "intro": a["intro"]}
            if a["homonymie"] or not w.get("humain"):
                ligne["remarque"] = "page d'homonymie ou pas une personne : à vérifier"
                bilan.append(ligne)
                continue
            if conf.get("sans_photo"):
                ligne["remarque"] = "photo désactivée dans le manifeste"
                bilan.append(ligne)
                continue
            fichier = conf.get("photo") or a["image"] or w.get("image")
            if not fichier:
                ligne["remarque"] = "aucune image dans l'article"
                bilan.append(ligne)
                continue
            c = commons(fichier.replace("File:", "").replace("Fichier:", ""))
            if not c or not (c["mime"] or "").startswith("image/"):
                ligne["remarque"] = "image absente de Wikimedia Commons"
                bilan.append(ligne)
                continue
            webp = recadrer(appel(c["vignette"], binaire=True), float(conf.get("haut", 0.15)))
            open(os.path.join(DOSSIER, slug + ".webp"), "wb").write(webp)
            photos[slug] = {"fichier": "photos/" + slug + ".webp", "auteur": c["auteur"],
                            "licence": c["licence"], "licence_url": c["licence_url"],
                            "source": c["source"], "date": c["date"]}
            ligne.update(photo="oui", licence=c["licence"], auteur=c["auteur"][:60])
        except Exception as e:
            ligne["remarque"] = "erreur : " + str(e)[:120]
            if slug in anciens:                 # incident passager : on garde la photo existante
                photos[slug] = anciens[slug]
                ligne["photo"] = "conservée"
        bilan.append(ligne)

    for nom in os.listdir(DOSSIER):            # photos devenues sans objet
        if nom.endswith(".webp") and nom[:-5] not in photos:
            os.remove(os.path.join(DOSSIER, nom))

    sortie = {
        "regle": "Photo de l'infobox de l'article de Wikipédia en français, hébergée sur Wikimedia Commons, recadrée au format 4:5.",
        "photos": dict(sorted(photos.items())),
    }
    # La date ne change que si les crédits changent, pour éviter des commits inutiles
    if not os.path.exists(CREDITS) or anciens != sortie["photos"]:
        sortie["mis_a_jour_le"] = datetime.now(timezone.utc).strftime("%Y-%m-%d")
    else:
        sortie["mis_a_jour_le"] = json.load(open(CREDITS, encoding="utf-8")).get("mis_a_jour_le")
    json.dump(sortie, open(CREDITS, "w", encoding="utf-8"), ensure_ascii=False, indent=1)

    temp = os.environ.get("RUNNER_TEMP", "/tmp")
    json.dump(fiches, open(os.path.join(temp, "fiches.json"), "w", encoding="utf-8"), ensure_ascii=False, indent=1)
    for slug, f in fiches.items():
        print("FICHE\t" + json.dumps(dict(id=slug, **f), ensure_ascii=False))

    resume = os.environ.get("GITHUB_STEP_SUMMARY")
    lignes = ["### Photos des candidats", "", "| Candidat | Photo | Licence | Auteur | Remarque |", "| --- | --- | --- | --- | --- |"]
    lignes += [f"| {b['id']} | {b['photo']} | {b['licence']} | {b['auteur']} | {b['remarque']} |" for b in bilan]
    texte_resume = "\n".join(lignes)
    print(texte_resume)
    if resume:
        open(resume, "a", encoding="utf-8").write(texte_resume + "\n")
    print(f"{len(photos)} photos sur {len(manifeste)} candidats.")


if __name__ == "__main__":
    sys.exit(main())
