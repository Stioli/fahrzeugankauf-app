# Status: fahrzeugankauf-app

**Stand:** 2026-05-24
**Status:** 🟢 live (v4 deployed via GitHub Pages, Supabase-Migration aktiv)

## Deployment
- **Live-URLs** (GitHub Pages – auto-deploy bei jedem `git push` auf `main`):
  - `https://stioli.github.io/fahrzeugankauf-app/` (= `index.html`, identisch mit v3-Datei)
  - `https://stioli.github.io/fahrzeugankauf-app/inzahlungnahme-app-v3.html` (Direkt-URL)
- **Strato ist NICHT mehr aktiv** für diese App – GitHub Pages hat das ersetzt seit v3 (Commit `cc23bf4` vom 2026-05-19).
- **Supabase:** Projekt `mnglpqeqmoxccqnztqez` (eu-central-1), v4-Migration angewendet 2026-05-24.

## Was zuletzt passiert ist
- **2026-05-24:** **v4-Update an `inzahlungnahme-app-v3.html`** — Datei behält ihren Namen, ist aber inhaltlich v4. Änderungen:
  - **Responsive komplett überarbeitet** für Handy + Tablet (Schriftgrößen ≥16 px → kein iOS-Auto-Zoom, Touch-Targets 48 px, Mängel-Tabelle wird auf Mobile zu Karten-Layout).
  - **Sitzplätze** als Dropdown (1–9 + „mehr als 9") in Fahrzeugdaten.
  - **Bereifung** aus „Ausstattung" raus, nach „Fahrzeugdaten" verschoben. **Sommer + Winter + Ganzjahres**, Profiltiefe **vorne und hinten getrennt**.
  - **Pflichtfeld** „Dem Verkäufer sind folgende Mängel bekannt" (Textarea, mit Validierung, erscheint in § 5 des Kaufvertrags).
  - **Foto-Upload** in Sektion 5 — direkt aus Handy-Kamera oder Galerie, client-seitig auf 1600 px verkleinert, Speicher in Supabase Storage Bucket `ankauf-fotos`, im Druck-Bericht + Modal angezeigt.
  - **Bemerkungsfeld** in Sektion 5 für interne Notizen zur Bewertung.
  - **SQL-Migration v4** unter `inzahlungnahme-app-v4-migration.sql` (neue Spalten + Storage-Bucket + RLS-Policies).
- **2026-05-22:** Konsolidierung — Stieber-Ankauf-Komplettpaket aus OneDrive ins Repo geholt (`cowork-paket/`).
- **2026-05-19:** v3 ([README-v3.md](README-v3.md)) — Stieber-CI, Interne Nr., Spalten-Filter.

## Nächster Schritt
- Auf realem Handy + Tablet testen: Kamera-Aufnahme, Foto-Upload, Speichern, Druck (Zustandsbericht + Kaufvertrag).

## Offene Fragen / Wartet auf
- Praxistest durch Mitarbeiter (Handy + Tablet)

## Wichtige Dateien
- [inzahlungnahme-app-v3.html](inzahlungnahme-app-v3.html) — Aktuelle App (v4-Inhalt unter v3-Dateinamen)
- [inzahlungnahme-app-v4-migration.sql](inzahlungnahme-app-v4-migration.sql) — **Neu:** Spalten, Storage-Bucket, Policies für v4
- [inzahlungnahme-app-supabase-migration.sql](inzahlungnahme-app-supabase-migration.sql) — Ursprüngliche v3-Migration
- [README-v3.md](README-v3.md) — Übergabe-Doku v3
- [PROJEKT_KONTEXT.md](PROJEKT_KONTEXT.md) — Projekt-Hintergrund
- [cowork-paket/Strato-Paket/Strato_Anleitung.md](cowork-paket/Strato-Paket/Strato_Anleitung.md) — Deployment
