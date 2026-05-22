# Code-Architektur — Ankauf.html

Diese Datei dokumentiert den technischen Aufbau der App, falls jemand (Cowork-Claude oder ein Entwickler) den Code anpassen muss.

---

## Übersicht

`Ankauf.html` ist eine **Single-File-Web-App** — alles (HTML, CSS, JavaScript, Logo) liegt in einer Datei. Keine Build-Tools, keine externen Abhängigkeiten, keine Frameworks.

**Größe:** ~200 KB (davon ~115 KB Stieber-Logo als Base64)

**Browser-Anforderungen:** Moderne Browser (Chrome/Edge/Safari/Firefox) der letzten 2-3 Jahre. Funktioniert auf Tablets und Smartphones.

---

## Struktur der Datei

Die `Ankauf.html` ist in 5 logische Blöcke gegliedert:

### 1. HTML-Header + CSS (Zeilen ~1 bis 320)

- DOCTYPE und Meta-Tags
- Stieber-Logo als Base64-eingebettetes Bild
- Komplettes CSS mit CSS-Variablen für die Stieber-Farben
- Tablet-optimiertes Layout (Mobile-First)
- Druck-Stylesheets für PDFs

### 2. Datenmodell + Speicher (Block 1 im JS)

```javascript
// Status-Konstanten
const STATUS = { NEU, DATENAUFNAHME, IN_WERKSTATT, ZUR_KALKULATION, ANGEKAUFT, UEBERNOMMEN };

// Extras-Liste in 7 Blöcken
const EXTRAS_BLOECKE = [...];

// LocalStorage-Layer
function alleAktenLaden() / akteSpeichern() / akteLaden() / akteLoeschen()

// Akte-Datenstruktur
function neueAkte() // gibt komplette leere Akte zurück
```

### 3. UI-Rendering + Routing (Block 2 im JS)

```javascript
const App = { view: 'liste'|'detail', aktiveAkteId, aktiverTab, filter };

function navigateZu(view, aktenId, tab)
function render() // Hauptrender-Funktion

function renderListe()      // Akten-Übersicht
function renderDetail(akte) // Einzelne Akte mit Tabs
function renderAkteCard(a)  // Eine einzelne Akten-Kachel
```

### 4. Die 5 Tabs (Block 3 im JS)

Jeder Tab eine eigene Render-Funktion:

```javascript
function renderTabKunde(akte)         // Halter + Fahrzeug + Foto-Upload
function renderTabExtras(akte)         // Checkliste
function renderTabWerkstatt(akte)      // Mängel + Zusicherungen
function renderTabKalkulation(akte)    // Einkaufspreis + PDF
function renderTabUebergabe(akte)      // Zustandsbericht
```

Hilfsfunktionen:
- `mangelHinzufuegen()`, `mangelLoeschen(idx)`
- `aktualisiereFeld(pfad, wert)` — generischer Feld-Updater
- `werkstattAbgeschlossen(akte)` — Tab-Sperre-Check

### 5. PDF-Generator (Block 4 im JS)

```javascript
function generierePdfBewertung()  // 2-seitiges PDF (Bewertung+Kaufvertrag)
function generierePdfUebergabe()  // 1-seitiges Übergabeprotokoll
function buildBewertungKaufvertragHtml(akte)  // HTML-Template
function buildUebergabeHtml(akte)              // HTML-Template
function oeffnePdfFenster(html, dateiname)    // Öffnet Fenster + window.print()
```

PDF-Generierung erfolgt über `window.print()` mit speziellen `@page`-CSS-Regeln. Kein PDF-Library — funktioniert komplett im Browser.

### 6. Foto-Upload (am Ende des JS, vor INIT)

```javascript
function zlbFotoUpload(inputEl)        // Liest Datei ein, ruft verkleinerFoto
function verkleinerFoto(dataUrl, ...)  // Canvas-basiertes Resizing
function zlbFotoLoeschen()
function zlbFotoVergroessern()         // Vollbild-Modal
```

Fotos werden auf max 1600px Kantenlänge verkleinert und als Base64 in die Akte gespeichert.

---

## Datenmodell — Akte

Eine Akte ist ein JavaScript-Objekt mit dieser Struktur:

```javascript
{
  akten_id: "Csontos_Tucson_011029",  // <Nachname>_<Modell>_<Letzte6FIN>
  status: "ANGEKAUFT",
  erstellt_am: "2026-05-08T...",
  geaendert_am: "2026-05-09T...",

  verkaeufer: {
    name, strasse, plz_ort, telefon, email, kunden_nr
  },

  fahrzeug: {
    hersteller, modell, variante, aufbau, farbe,
    fin, kennzeichen, erstzulassung, km_stand,
    hubraum_ccm, leistung_kw, leistung_ps, kraftstoff,
    getriebe, antrieb, halteranzahl, schadstoffklasse
  },

  fotos: {
    zlb: "data:image/jpeg;base64,...",  // Fahrzeugschein
    kaufvertrag: "",
    uebergabe: []
  },

  extras: {
    // 30+ Felder, siehe EXTRAS_BLOECKE im Code
    panoramadach: false,
    lederausstattung: "Stoff" | "Teil" | "Voll",
    klimaautomatik: "Manuell" | "1" | "2" | "3" | "4",
    licht_typ: "Halogen" | "LED" | "Matrix-LED" | "Laser" | "Xenon",
    ahk: "Nein" | "Fest" | "Abnehmbar" | "Elektrisch",
    // ...
    extras_freitext: ""
  },

  werkstatt: {
    durchgesehen_von, durchgesehen_am, hu_faellig, kd_faellig,
    alle_kd_durchgefuehrt, unfallfrei, hagelschaden,
    nachlackiert, ex_mietwagen, eu_fahrzeug, gebrauchsspuren
  },

  maengel: [
    { pos: 1, baugruppe: "HU/TÜV", beschreibung: "..." },
    // ...
  ],

  positive_notizen: "",

  kalkulation: {
    kalkuliert_von, kalkuliert_am,
    aufwendungen_gesamt: 0,
    haendlereinkaufspreis: 16500,
    vertrags_nr, bewertungs_nr
  },

  uebergabe: {
    uebergabe_am, uebergabe_durch,
    km_stand_uebergabe, tankstand, anzahl_schluessel,
    bordmappe_vorhanden, serviceheft_vorhanden,
    kfz_schein_vorhanden, kfz_brief_vorhanden,
    winterreifen_mitgebracht, winterreifen_zustand,
    neue_schaeden, allgemeiner_zustand, bemerkungen
  }
}
```

---

## Speicherung

**Aktuell (Stufe 1):** Browser-LocalStorage unter Schlüssel `stieber_ankauf_akten_v1`. Inhalt ist ein Objekt `{ aktenId: akteObjekt }`.

**Geplant (Stufe 2):** REST-API gegen MySQL-Datenbank auf Strato.  
Endpunkte würden so aussehen:
- `GET /api/akten` — alle Akten holen
- `GET /api/akten/{id}` — einzelne Akte
- `POST /api/akten` — neue Akte anlegen
- `PUT /api/akten/{id}` — Akte aktualisieren
- `DELETE /api/akten/{id}` — Akte löschen

---

## Wichtige Konstanten

```javascript
// Akten-ID-Schema
makeAktenId(name, modell, fin) → "<Nachname>_<Modell>_<Letzte6FIN>"

// Stieber-Farben (CSS-Variablen)
--blau: #1a6dd4         // Primärfarbe
--blau-dunkel: #1a4e99  // Buttons hover, Akzente
--blau-hell: #eef5fc    // Hintergründe Hinweise
--gruen: #2c7a3d        // Erfolg, abgeschlossen
--rot: #b03030          // Löschen, Fehler
--orange: #d49a1a       // Warnung, Sperre
```

---

## Beispiele für Anpassungen

### Neues Feld in der Akte hinzufügen
1. In `neueAkte()` das Feld mit Default-Wert ergänzen
2. In passender `renderTab*()` Funktion das Eingabefeld einfügen
3. Im PDF-Template (`buildBewertungKaufvertragHtml`) einbauen, falls auf PDF gewünscht

### Neuen Mängel-Kategorie hinzufügen
- In Konstante `MAENGEL_KATEGORIEN` ergänzen

### Stieber-Farben anpassen
- CSS-Variablen am Anfang im `<style>`-Block ändern

### Logo austauschen
- Base64-String suchen (beginnt mit `data:image/jpeg;base64,/9j/`)
- Neues Logo Base64-encoden und ersetzen

---

## Deployment

### Aktuell (Stufe 1)
- Single-File hochladen ins Strato-Webhosting
- Mit `.htaccess` per Basic-Auth schützen
- Fertig

### Stufe 2 (geplant)
- PHP-Backend hinzufügen (3-4 PHP-Dateien)
- MySQL-Datenbank in Strato anlegen
- App-JavaScript um `fetch()`-Aufrufe erweitern
- Login-System (Sessions oder JWT)

---

## Kontakt für Anpassungen

Für Code-Änderungen am besten **bei Claude.ai zurückkommen** — dort liegt der gesamte Konversations-Kontext der bisherigen Entwicklung.
