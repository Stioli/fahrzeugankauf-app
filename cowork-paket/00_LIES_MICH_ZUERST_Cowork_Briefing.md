# Übergabe-Briefing für Claude Cowork

**Wichtig: Bitte lies dieses Dokument zuerst, bevor du mit der Arbeit beginnst.**

---

## Wer bin ich?

**Oliver Stieber**, Geschäftsführer der **Autohaus Stieber GmbH** in Stuttgart. Ich nutze Claude.ai schon länger und habe in den letzten Tagen mit der Web-Version von Claude eine Web-App für unseren Fahrzeugankauf-Prozess entwickelt.

---

## Was ist die Aufgabe jetzt?

Ich möchte die fertige Web-App auf meinem **Strato-Webhosting** unter `https://www.autohaus-stieber.de/ankauf/` bereitstellen, damit alle Mitarbeiter (3-5 Personen) zentral darauf zugreifen können.

Ich habe Strato-Zugang aber noch nie etwas hochgeladen. **Bitte hilf mir Schritt für Schritt** durch den Strato-Datei-Manager und richte folgendes ein:

1. Ordner `/ankauf/` im Webspace anlegen
2. Drei Dateien dorthin hochladen: `Ankauf.html`, `.htaccess`, `.htpasswd`
3. In der `.htaccess` den absoluten Pfad zur `.htpasswd` korrigieren (Strato-spezifisch)
4. Im Browser testen ob es funktioniert

---

## Was wir bisher gemacht haben (Hintergrund)

### Die Geschäftslogik

Der Fahrzeugankauf läuft bei uns in 4 Stufen:

1. **Datenaufnahme** (Verkaufsberater am Tablet) — Halter, Fahrzeug, Extras-Checkliste
2. **Werkstatt-Durchsicht** (Meister) — Mängel, KD/HU-Termine, technischer Zustand
3. **Kalkulation** (Geschäftsführer) — Aufwendungen, Händler-Einkaufspreis, Bewertungs- und Kaufvertrags-PDF
4. **Übergabe** (bei Anlieferung) — Zustandsbericht, KM-Stand, Schlüssel, Schäden

Bewertung und Kaufvertrag sollen **erst nach abgeschlossener Werkstatt-Durchsicht** möglich sein.

### Die App

Eine **HTML-Single-File-App** namens `Ankauf.html` (ca. 200 KB) mit:
- Akten-Verwaltung mit Status-Tracking (5 Stati von "Datenaufnahme" bis "Übernommen")
- Tablet-optimierter Bedienung
- 5 Tabs (Kunde & Fahrzeug, Extras, Werkstatt, Kalkulation, Übergabe)
- Foto-Upload für den Fahrzeugschein (Kamera oder Mediathek)
- 30+ Standard-Extras als Checkliste
- PDF-Generierung (Bewertung+Kaufvertrag und Übergabeprotokoll) im Stieber-Corporate-Design
- Daten-Export/Import als JSON (für Backup zwischen Geräten)
- Stieber-Logo eingebettet, Farben Blau/Weiß
- Speichert lokal im Browser (LocalStorage) — pro Gerät getrennt

### Akten-Daten-Struktur

Pro Fahrzeug eine Akte mit dieser ID-Konvention: `<Nachname>_<Modell>_<Letzte6FIN>` (z.B. `Csontos_Tucson_011029`).

### Geplante Strato-Setup

- **Schutzart:** HTTP-Basic-Auth über `.htaccess` + `.htpasswd`
- **Benutzer:** `stieber`
- **Passwort:** `Ankauf2026!` (temporär — soll ich später ändern)
- **HTTPS** wird per Rewrite-Rule erzwungen (Strato unterstützt das standardmäßig)

---

## Die 4 Dateien, die zu Strato hochgeladen werden müssen

Ich habe alle 4 Dateien aus dem ursprünglichen Chat heruntergeladen und sollten lokal verfügbar sein.

### 1. `Ankauf.html`
Die App selbst. Ca. 200 KB.  
**Geht direkt in den Strato-Ordner `/ankauf/`** — keine Anpassung nötig.

### 2. `.htaccess`
Konfiguriert den Passwortschutz und HTTPS-Redirect. Inhalt:

```apache
AuthType Basic
AuthName "Autohaus Stieber - Fahrzeugankauf (Bitte einloggen)"
AuthUserFile /HIER_ABSOLUTER_PFAD_EINSETZEN/.htpasswd
Require valid-user

<Files ".ht*">
  Require all denied
</Files>

Options -Indexes
DirectoryIndex Ankauf.html index.html

<IfModule mod_headers.c>
  <FilesMatch "\.(html|css|js)$">
    Header set Cache-Control "public, max-age=300, must-revalidate"
  </FilesMatch>
</IfModule>

<IfModule mod_rewrite.c>
  RewriteEngine On
  RewriteCond %{HTTPS} off
  RewriteRule ^ https://%{HTTP_HOST}%{REQUEST_URI} [L,R=301]
</IfModule>
```

⚠️ **WICHTIG:** Der Platzhalter `/HIER_ABSOLUTER_PFAD_EINSETZEN/` muss durch den echten Pfad zur `.htpasswd` auf dem Strato-Server ersetzt werden — z.B. `/mnt/web001/abc/de/12345678/htdocs/ankauf`. **Das ist der häufigste Fehlerpunkt** — bitte unbedingt prüfen.

So findet man den Pfad auf Strato:
- Im Datei-Manager rechtsklick auf `.htpasswd`
- "Eigenschaften" oder "Details"
- Den dort angezeigten kompletten Server-Pfad nehmen (ohne den Dateinamen `.htpasswd`)

### 3. `.htpasswd`
Inhalt (bcrypt-gehashtes Passwort für Benutzer `stieber` mit Passwort `Ankauf2026!`):

```
stieber:$2b$10$<HASH>
```

⚠️ Dieser Hash wurde im ursprünglichen Chat generiert — sollte in der heruntergeladenen Datei vorhanden sein. Falls er fehlt oder neu erstellt werden muss: bcrypt mit 10 Rounds verwenden.

### 4. `Strato_Anleitung.md`
Schritt-für-Schritt-Anleitung — hilfreich als Referenz, aber nicht zum Hochladen gedacht.

---

## Was ich von dir (Cowork-Claude) brauche

1. **Frag mich** wo die heruntergeladenen Dateien lokal liegen (z.B. `Downloads/Strato-Paket/` oder ähnlich)
2. **Zeige mir Schritt für Schritt** wie ich im Strato-Browser navigiere — ich habe Strato schon offen
3. **Hilf mir** den Ordner anzulegen und die Dateien hochzuladen
4. **Hilf mir** den `.htaccess`-Pfad korrekt anzupassen (kritischer Schritt!)
5. **Teste mit mir gemeinsam** ob die App über `https://www.autohaus-stieber.de/ankauf/` erreichbar ist

---

## Verhaltensregeln

- **Auf Deutsch**, informell ("du")
- Ich bin **kein IT-Profi** — bitte einfache Erklärungen, keine Fachbegriffe ohne Erklärung
- **Bevor du etwas Kritisches machst** (Datei überschreiben, Berechtigungen ändern), kurz fragen
- **Bei Unsicherheit nachfragen** statt raten
- **Sei pragmatisch** — wir wollen das heute zum Laufen bringen, perfekt wird es später

---

## Wenn das Setup steht

Ich plane danach noch zwei Erweiterungen, aber erst nach erfolgreichem Test:

1. **Stufe 2 — Datenbank-Anbindung:** MySQL bei Strato (im Tarif inklusive) als zentrale Datenhaltung — dann sehen alle Mitarbeiter die gleichen Akten von überall
2. **Foto-Auto-Auslese (OCR):** Fahrzeugschein fotografieren → Daten werden automatisch in die Felder übernommen

Aber erst: **App auf Strato zum Laufen bringen.** 🚗

---

**Los geht's!**
