# Status: fahrzeugankauf-app

**Stand:** 2026-05-22
**Status:** 🟢 live

## Was zuletzt passiert ist
- **2026-05-22:** Konsolidierung — Stieber-Ankauf-Komplettpaket aus OneDrive ins Repo geholt (`cowork-paket/` mit Beispiel-Akten, Quellcode-Snapshot, Strato-Paket inkl. .htaccess). Zusätzlich Anleitung und Cowork-Briefing nach `docs/`.
- **2026-05-19:** **v3 abgeschlossen** ([README-v3.md](README-v3.md))
  - Stieber-CI komplett angewendet (Plus Jakarta Sans + DM Sans, #1a6dd4)
  - Neue Felder: Interne Nr., Fgst.-Nr. in der Tabelle
  - Spalten-Filter unter jedem Header
- **Live:** `inzahlungnahme-app-v3.html` (Strato), Supabase-Backend angebunden (`inzahlungnahme-app-supabase-migration.sql`)

## Nächster Schritt
App ist live. Nächste Schritte ergeben sich aus dem Betrieb:
- Mitarbeiter-Feedback einsammeln, ggf. v4 planen
- Beispiel-Akten in `cowork-paket/Beispiel-Akten/` als Referenz pflegen, wenn neue Anlässe kommen
- Strato-Paket aktualisieren, wenn die HTML-Version sich ändert

## Offene Fragen / Wartet auf
- Nutzungs-Feedback der Mitarbeiter

## Wichtige Dateien
- [README-v3.md](README-v3.md) — Übergabe-Doku v3 (was neu, was anders)
- [PROJEKT_KONTEXT.md](PROJEKT_KONTEXT.md) — Projekt-Hintergrund
- [inzahlungnahme-app-v3.html](inzahlungnahme-app-v3.html) — Aktuelle App-Version
- [inzahlungnahme-app-supabase-migration.sql](inzahlungnahme-app-supabase-migration.sql) — Datenbank-Schema
- [cowork-paket/README.md](cowork-paket/README.md) — Cowork-Komplettpaket
- [cowork-paket/Strato-Paket/Strato_Anleitung.md](cowork-paket/Strato-Paket/Strato_Anleitung.md) — Deployment-Anleitung
- [docs/Anleitung_Ankauf-App.md](docs/Anleitung_Ankauf-App.md) — Einrichtungs-Anleitung für Mitarbeiter
