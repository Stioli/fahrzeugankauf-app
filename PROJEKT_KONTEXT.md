# Fahrzeugankauf-App – Projektkontext für Claude

> Diese Datei am Anfang eines neuen Chats einfach hochladen oder den Inhalt einfügen.
> Dann weiß Claude sofort alles über das Projekt und kann direkt weiterarbeiten.

---

## Projektübersicht

**Projekt:** Digitale Fahrzeugankauf-App für Autohaus Stieber GmbH  
**Zweck:** Erfassung von Gebrauchtfahrzeugankäufen (Privat → Gewerbe), Zustandsbewertung, Kaufvertrag-Druck  
**Erstellt mit:** Claude Cowork (Einzelne HTML-Datei, kein Framework)  
**Stand:** Mai 2026

---

## Live-URL

```
http://ankauf.autohaus-stieber.de/inzahlungnahme-app-v2.html
```
> SSL-Zertifikat (Let's Encrypt über Strato) ist beantragt – sobald aktiv läuft es auf HTTPS.

---

## Hosting – Strato

| | |
|---|---|
| **Anbieter** | Strato Hosting Plus |
| **WebFTP-Pfad** | `/ankauf/inzahlungnahme-app-v2.html` |
| **Domain** | ankauf.autohaus-stieber.de |

**Datei hochladen (WebFTP):**
1. strato.de → Mein Konto → Alle Pakete
2. STRATO Hosting Plus → Webspace → Verwalten
3. Ordner `/ankauf/` öffnen
4. „Hochladen" → Datei auswählen → alte überschreiben

---

## Datenbank – Supabase

| | |
|---|---|
| **URL** | `https://mnglpqeqmoxccqnztqez.supabase.co` |
| **Publishable Key** | `sb_publishable_CDpY6_W07WdHFKYv0cx59g_GDm7UlZF` |
| **Tabelle** | `fahrzeugankauf` |
| **Auth** | Supabase Auth (E-Mail + Passwort) |

**Neue Benutzer anlegen:**  
Supabase Dashboard → Authentication → Users → Invite User

**SQL-Befehle ausführen:**  
Supabase Dashboard → SQL Editor → New Query → Run

---

## Technologie

- **Einzelne HTML-Datei** – kein Build-Prozess, kein Framework
- **Supabase JS v2** (CDN: `cdn.jsdelivr.net`)
- **Google Fonts:** Inter (Fließtext) + Playfair Display (Überschriften)
- **Druck:** `window.open('', '_blank')` → HTML-Seite generieren → `window.print()`
- **Farben:** Navy `#003366`, Gold `#c8982a`

---

## App-Funktionen

### Übersicht
- Tabelle aller Ankäufe mit Filter (Suche + Status) und Sortierung (alle Spalten)
- Statistik-Karten: Gesamt / Diesen Monat / In Bearbeitung / Abgeschlossen

### Formular – Neuer Ankauf (6 Abschnitte)
1. **Verkäufer** – Name, Adresse, Telefon, E-Mail
2. **Fahrzeugdaten** – Hersteller, Modell, Typ, Kennzeichen, FIN, Erstzulassung (TT.MM.JJJJ), KM, Kraftstoff, Getriebe, **Antrieb** (2WD/4WD/Allrad), PS, Farbe, Vorbesitzer, HU, Schlüssel
3. **Ausstattung** – Navigation, CarPlay/Android Auto, Klimaautomatik, Sitzheizung v/h, Leder, Panorama, AHK, Standheizung, **Lenkradheizung**, **EPH vorne**, **EPH hinten**, **Rückfahrkamera**, **360°-Kamera**, **Sommerreifen + Profiltiefe**, **Winterreifen + Profiltiefe**
4. **Zusicherungen** – Unfallfrei, kein Hagel, nicht nachlackiert, kein Mietwagen, kein EU-Import + **KD-Historie** (fällig bei km / am Datum / alle lückenlos)
5. **Mängel & Bewertung** – Strukturierte Tabelle mit 16 Baugruppen + Auto-Summe → Ankaufspreis
6. **Status & Notizen** – Status-Dropdown, Bearbeiter, interne Notizen

### Mängel-Tabelle (16 Zeilen)
HU · Kundendienst · Vorderachse · Hinterachse · Unterboden · Motor · Getriebe · Reifen · Bremsen · Karosserie/Lack 1–5 · Aufbereitung · Garantierückstellung

### Druckfunktionen
| Button | Inhalt |
|---|---|
| 📋 Zustandsbericht | Fahrzeugdaten + Ausstattung + Mängel-Tabelle + Ankaufspreis |
| 🖨️ Kaufvertrag | Seite 1: Kaufvertrag (§1–§7 inkl. Unbekannte-Mängel-Klausel) + Seite 2: Übergabe-Protokoll |

---

## Datenbank-Spalten (vollständige Liste)

### Verkäufer
`vk_vorname` · `vk_nachname` · `vk_strasse` · `vk_plz` · `vk_ort` · `vk_telefon` · `vk_email`

### Fahrzeugdaten
`fz_hersteller` · `fz_modell` · `fz_typ` · `fz_kennzeichen` · `fz_fahrgestellnr` · `fz_erstzulassung` · `fz_km_stand` · `fz_kraftstoff` · `fz_getriebe` · `fz_antrieb` · `fz_leistung_kw` · `fz_farbe` · `fz_halteranzahl` · `fz_hu_datum` · `fz_anzahl_schluessel`

### Ausstattung
`ausstattung_navi` · `ausstattung_soundsystem` · `ausstattung_klimaautomatik` · `ausstattung_sitzheizung` · `ausstattung_shz_hinten` · `ausstattung_leder` · `ausstattung_panorama` · `ausstattung_ahk` · `ausstattung_standhz` · `ausstattung_lenkradheizung` · `ausstattung_eph_vorne` · `ausstattung_eph_hinten` · `ausstattung_kamera_hinten` · `ausstattung_kamera_360`

### Reifen
`reifen_sommer` · `reifen_sommer_profil` · `reifen_winter` · `reifen_winter_profil`

### Zusicherungen
`zusicherung_unfallfrei` · `zusicherung_kein_hagel` · `zusicherung_kein_nachlack` · `zusicherung_kein_mietwagen` · `zusicherung_kein_eu_import`

### Kundendienst
`kd_km_faellig` · `kd_datum_faellig` · `kd_alle_durchgefuehrt`

### Mängel (je Baugruppe: text + numeric)
`mn_hu` / `mn_hu_kosten` · `mn_kd` / `mn_kd_kosten` · `mn_vorderachse` / `mn_vorderachse_kosten` · `mn_hinterachse` / `mn_hinterachse_kosten` · `mn_unterboden` / `mn_unterboden_kosten` · `mn_motor` / `mn_motor_kosten` · `mn_getriebe` / `mn_getriebe_kosten` · `mn_reifen` / `mn_reifen_kosten` · `mn_bremsen` / `mn_bremsen_kosten` · `mn_karosserie1–5` / `mn_karosserie1–5_kosten` · `mn_aufbereitung` / `mn_aufbereitung_kosten` · `mn_garantie` / `mn_garantie_kosten`

### Sonstiges
`aufwendungen_gesamt` · `ankaufspreis` · `status` · `bearbeiter_name` · `notizen` · `erstellt_am`

---

## SQL – Neue Spalten hinzufügen (Referenz)

```sql
-- Einmalig ausgeführt nach letzter Erweiterung (Mai 2026):
ALTER TABLE fahrzeugankauf
  ADD COLUMN IF NOT EXISTS fz_antrieb text,
  ADD COLUMN IF NOT EXISTS ausstattung_lenkradheizung boolean DEFAULT false,
  ADD COLUMN IF NOT EXISTS ausstattung_eph_vorne boolean DEFAULT false,
  ADD COLUMN IF NOT EXISTS ausstattung_eph_hinten boolean DEFAULT false,
  ADD COLUMN IF NOT EXISTS ausstattung_kamera_hinten boolean DEFAULT false,
  ADD COLUMN IF NOT EXISTS ausstattung_kamera_360 boolean DEFAULT false,
  ADD COLUMN IF NOT EXISTS reifen_sommer boolean DEFAULT false,
  ADD COLUMN IF NOT EXISTS reifen_sommer_profil numeric,
  ADD COLUMN IF NOT EXISTS reifen_winter boolean DEFAULT false,
  ADD COLUMN IF NOT EXISTS reifen_winter_profil numeric,
  ADD COLUMN IF NOT EXISTS kd_km_faellig integer,
  ADD COLUMN IF NOT EXISTS kd_datum_faellig date,
  ADD COLUMN IF NOT EXISTS kd_alle_durchgefuehrt boolean DEFAULT false,
  ADD COLUMN IF NOT EXISTS mn_hu text, ADD COLUMN IF NOT EXISTS mn_hu_kosten numeric,
  ADD COLUMN IF NOT EXISTS mn_kd text, ADD COLUMN IF NOT EXISTS mn_kd_kosten numeric,
  ADD COLUMN IF NOT EXISTS mn_vorderachse text, ADD COLUMN IF NOT EXISTS mn_vorderachse_kosten numeric,
  ADD COLUMN IF NOT EXISTS mn_hinterachse text, ADD COLUMN IF NOT EXISTS mn_hinterachse_kosten numeric,
  ADD COLUMN IF NOT EXISTS mn_unterboden text, ADD COLUMN IF NOT EXISTS mn_unterboden_kosten numeric,
  ADD COLUMN IF NOT EXISTS mn_motor text, ADD COLUMN IF NOT EXISTS mn_motor_kosten numeric,
  ADD COLUMN IF NOT EXISTS mn_getriebe text, ADD COLUMN IF NOT EXISTS mn_getriebe_kosten numeric,
  ADD COLUMN IF NOT EXISTS mn_reifen text, ADD COLUMN IF NOT EXISTS mn_reifen_kosten numeric,
  ADD COLUMN IF NOT EXISTS mn_bremsen text, ADD COLUMN IF NOT EXISTS mn_bremsen_kosten numeric,
  ADD COLUMN IF NOT EXISTS mn_karosserie1 text, ADD COLUMN IF NOT EXISTS mn_karosserie1_kosten numeric,
  ADD COLUMN IF NOT EXISTS mn_karosserie2 text, ADD COLUMN IF NOT EXISTS mn_karosserie2_kosten numeric,
  ADD COLUMN IF NOT EXISTS mn_karosserie3 text, ADD COLUMN IF NOT EXISTS mn_karosserie3_kosten numeric,
  ADD COLUMN IF NOT EXISTS mn_karosserie4 text, ADD COLUMN IF NOT EXISTS mn_karosserie4_kosten numeric,
  ADD COLUMN IF NOT EXISTS mn_karosserie5 text, ADD COLUMN IF NOT EXISTS mn_karosserie5_kosten numeric,
  ADD COLUMN IF NOT EXISTS mn_aufbereitung text, ADD COLUMN IF NOT EXISTS mn_aufbereitung_kosten numeric,
  ADD COLUMN IF NOT EXISTS mn_garantie text, ADD COLUMN IF NOT EXISTS mn_garantie_kosten numeric;
```

---

## Autohaus Stieber – Firmendaten

| | |
|---|---|
| **Firma** | Autohaus Stieber GmbH |
| **Adresse** | Emerholzweg 5, 70439 Stuttgart-Stammheim |
| **Tel.** | 0711 80 60 94 - 0 |
| **E-Mail** | service@autohaus-stieber.de |
| **Web** | www.autohaus-stieber.de |
| **GF** | Oliver Stieber |
| **Betrieb** | Mehrmarken-Center & Bosch Car Service |

---

## Dateien

| Datei | Beschreibung |
|---|---|
| `inzahlungnahme-app-v2.html` | Die komplette App (live + lokal) |
| `PROJEKT_KONTEXT.md` | Diese Datei – für neue Claude-Sessions |
| `Fahrzeugankauf_App_Übersicht.pdf` | Einseitige Kurzübersicht zum Nachschlagen |

---

## Nächste mögliche Erweiterungen (Ideen)

- [ ] Foto-Upload für Fahrzeug (Supabase Storage)
- [ ] E-Mail-Versand des Kaufvertrags direkt aus der App
- [ ] PDF-Export direkt im Browser (ohne Popup)
- [ ] Benutzerrechte (Nur-Lesen vs. Bearbeiten)
- [ ] HTTPS aktivieren sobald Strato SSL-Zertifikat greift
- [ ] Mobile-App-Version (PWA)

---

## Wie man weitermacht

1. Diese Datei (`PROJEKT_KONTEXT.md`) in einen neuen Claude-Chat hochladen
2. Änderungswunsch beschreiben
3. Claude erstellt die aktualisierte `inzahlungnahme-app-v2.html`
4. Datei per Strato WebFTP hochladen
5. Bei neuen DB-Feldern: SQL im Supabase SQL Editor ausführen
