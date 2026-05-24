# Status: fahrzeugankauf-app

**Stand:** 2026-05-24
**Status:** 🟢 live (v4-Update ausstehend bei Strato)

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
1. **Migration in Supabase ausführen:** [`inzahlungnahme-app-v4-migration.sql`](inzahlungnahme-app-v4-migration.sql) im Supabase SQL-Editor laufen lassen (legt Spalten, Storage-Bucket + Policies an).
2. **Datei nach Strato hochladen:** [`inzahlungnahme-app-v3.html`](inzahlungnahme-app-v3.html) per WebFTP nach `/ankauf/`.
3. Auf Handy + Tablet testen (Kamera-Aufnahme, Foto-Upload, Speichern, Druck).

## Offene Fragen / Wartet auf
- Test auf realem Gerät (Handy + Tablet)
- Strato-Upload + Migration in Supabase

## Wichtige Dateien
- [inzahlungnahme-app-v3.html](inzahlungnahme-app-v3.html) — Aktuelle App (v4-Inhalt unter v3-Dateinamen)
- [inzahlungnahme-app-v4-migration.sql](inzahlungnahme-app-v4-migration.sql) — **Neu:** Spalten, Storage-Bucket, Policies für v4
- [inzahlungnahme-app-supabase-migration.sql](inzahlungnahme-app-supabase-migration.sql) — Ursprüngliche v3-Migration
- [README-v3.md](README-v3.md) — Übergabe-Doku v3
- [PROJEKT_KONTEXT.md](PROJEKT_KONTEXT.md) — Projekt-Hintergrund
- [cowork-paket/Strato-Paket/Strato_Anleitung.md](cowork-paket/Strato-Paket/Strato_Anleitung.md) — Deployment
