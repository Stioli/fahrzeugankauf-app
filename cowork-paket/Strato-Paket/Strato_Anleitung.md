# Strato-Anleitung — App online stellen

**Autohaus Stieber GmbH · Fahrzeugankauf-App**

Diese Anleitung führt dich Schritt für Schritt durch die Einrichtung der App auf deinem Strato-Webhosting. Du brauchst kein extra Programm — alles geht direkt im Browser über deinen Strato-Account.

⏱️ **Zeitaufwand:** ca. 20–30 Minuten beim ersten Mal

---

## 📦 Was im ZIP-Paket drin ist

| Datei | Wofür |
|-------|-------|
| `Ankauf.html` | Die App selbst |
| `.htaccess` | Konfiguration für den Passwortschutz |
| `.htpasswd` | Verschlüsseltes Passwort |
| `Strato_Anleitung.md` | Diese Anleitung |

---

## 🔐 Zugangsdaten — bitte sofort merken!

**Die App ist passwortgeschützt:**

```
Benutzername:  stieber
Passwort:      Ankauf2026!
```

⚠️ **Dieses Passwort solltest du später ändern** — siehe Abschnitt „Passwort ändern" am Ende dieser Anleitung.

---

## 🚀 Schritt 1: Bei Strato einloggen

1. Öffne im Browser: **https://www.strato.de/apps/CustomerService**
2. Melde dich mit deinen Strato-Zugangsdaten an
3. Du landest im **Strato Kundenservice-Bereich**

---

## 🌐 Schritt 2: Webseiten-Verwaltung öffnen

1. Im linken Menü auf **„Hosting"** klicken
2. Wähle deine Domain **autohaus-stieber.de** (falls mehrere)
3. Klicke auf **„Datei-Manager"** oder **„Web-FTP"**

> Falls du den Datei-Manager nicht findest:
> - Suche nach „**Datei-Manager**", „**Web-FTP**" oder „**File-Browser**"
> - Bei Strato heißt das je nach Tarif unterschiedlich

---

## 📁 Schritt 3: Ordner für die App anlegen

Du solltest jetzt eine Datei-Übersicht sehen — ähnlich dem Windows-Explorer.

1. Du befindest dich im Hauptverzeichnis deiner Domain (oft `/htdocs` oder `/`)
2. **Wichtig:** Lege keine Datei direkt im Hauptverzeichnis ab — das würde die Stieber-Webseite überschreiben!
3. **Neuen Ordner erstellen:** Klick auf **„Neuer Ordner"** oder **„Verzeichnis erstellen"**
4. Gib als Namen ein: **`ankauf`** (klein geschrieben, ohne Umlaute)
5. **Bestätigen** — der neue Ordner erscheint in der Liste
6. Klick auf den neuen Ordner `ankauf` — er sollte leer sein

---

## ⬆️ Schritt 4: Dateien hochladen

Im Ordner `ankauf` lädst du nun die 3 Dateien hoch:

1. Klick auf **„Datei hochladen"** oder **„Upload"** (oft ein Symbol mit Pfeil nach oben ⬆️)
2. **Wähle alle 3 Dateien aus** dem entpackten ZIP:
   - `Ankauf.html`
   - `.htaccess`
   - `.htpasswd`

> ⚠️ **Hinweis zu versteckten Dateien:**  
> Die Dateien `.htaccess` und `.htpasswd` beginnen mit einem Punkt — das macht sie unter Windows zu „versteckten Dateien".  
> 
> Falls du die Dateien im Datei-Auswahldialog **nicht siehst**:
> - **Windows Explorer:** Im Menü **„Ansicht"** → **„Ausgeblendete Elemente"** Häkchen setzen
> - **macOS Finder:** Mit `Cmd + Shift + .` einblenden

3. **Hochladen bestätigen**
4. Warten bis alle 3 Dateien hochgeladen sind (sollte sehr schnell gehen — sind alle klein)

✅ Im Ordner `ankauf` sollten jetzt 3 Dateien liegen.

---

## 🔧 Schritt 5: Pfad in der `.htaccess` anpassen (WICHTIG!)

Das ist der kritischste Schritt. Strato braucht einen **absoluten Pfad** zur `.htpasswd`-Datei.

### 5a. Pfad herausfinden

1. Im Datei-Manager **rechtsklick** auf die Datei `.htpasswd`
2. Wähle **„Eigenschaften"** oder **„Details"**
3. Schaue nach **„Pfad"**, **„Dateipfad"** oder **„Server-Pfad"**
4. Du siehst etwas wie:
   ```
   /mnt/web001/abc/de/12345678/htdocs/ankauf/.htpasswd
   ```
5. **Kopiere den ganzen Pfad** (Strg+C) — den brauchst du gleich

### 5b. .htaccess bearbeiten

1. Im Datei-Manager **rechtsklick** auf `.htaccess`
2. Wähle **„Bearbeiten"**, **„Öffnen"** oder **„Editieren"**
3. Im Editor findest du diese Zeile:
   ```
   AuthUserFile /HIER_ABSOLUTER_PFAD_EINSETZEN/.htpasswd
   ```
4. **Ersetze den Platzhalter** durch den Pfad, den du grade kopiert hast — Beispiel:
   ```
   AuthUserFile /mnt/web001/abc/de/12345678/htdocs/ankauf/.htpasswd
   ```
5. **Speichern**

> 💡 **Tipp:** Wenn der Datei-Manager keinen Bearbeiten-Knopf hat:
> 1. `.htaccess` herunterladen (Rechtsklick → „Herunterladen")
> 2. Mit **Editor** (Windows) oder **TextEdit** (Mac) öffnen
> 3. Bearbeiten und speichern
> 4. Wieder hochladen (überschreibt die alte Version)

---

## 🌍 Schritt 6: Testen!

Jetzt der spannende Moment:

1. Öffne im Browser ein **neues Fenster** (am besten **inkognito/privat**)
2. Gib ein:
   ```
   https://www.autohaus-stieber.de/ankauf/
   ```
3. Es sollte sich ein **Passwort-Dialog** öffnen 🔒
4. Eingabe:
   - Benutzername: `stieber`
   - Passwort: `Ankauf2026!`
5. **Anmelden klicken**

🎉 **Wenn alles geklappt hat, siehst du jetzt die App!**

---

## 🆘 Wenn etwas nicht klappt

### „Internal Server Error" / Seite lädt nicht
**Ursache:** Pfad in der `.htaccess` ist falsch.

**Lösung:**
1. Geh nochmal zu Schritt 5
2. Prüfe den Pfad ganz genau — Strato ist sehr empfindlich bei Tippfehlern
3. Stelle sicher, dass kein Leerzeichen am Anfang oder Ende ist

### „403 Forbidden"
**Ursache:** Passwortschutz lädt nicht richtig.

**Lösung:**
1. Prüfe, ob `.htaccess` und `.htpasswd` im selben Ordner liegen
2. Prüfe Datei-Berechtigungen: Beide sollten **644** sein (im Datei-Manager rechtsklick → Eigenschaften → Rechte)

### „404 Not Found"
**Ursache:** Datei am falschen Ort hochgeladen.

**Lösung:**
1. Kontrolliere im Datei-Manager: Sind die Dateien wirklich im Ordner `/ankauf/`?
2. Achte auf Groß-/Kleinschreibung — `Ankauf.html` ist nicht das gleiche wie `ankauf.html`

### Passwort wird nicht akzeptiert
**Ursache:** Schreibfehler oder Pfad-Problem.

**Lösung:**
1. Achte auf Groß-/Kleinschreibung — `Ankauf2026!` ist exakt so einzutippen
2. Versuche aus einem **frischen Browserfenster** (Cache leeren)

---

## 📱 Schritt 7: Auf Tablet & Handy einrichten

Sobald die App online funktioniert, geht es auf den Geräten der Mitarbeiter so:

### iPad/iPhone (Safari):
1. Safari öffnen
2. URL eingeben: `https://www.autohaus-stieber.de/ankauf/`
3. Login: `stieber` / `Ankauf2026!`
4. Safari merkt sich Login (anhaken: „Passwort sichern")
5. **Zum Home-Bildschirm hinzufügen:**
   - Teilen-Symbol antippen ↗
   - „Zum Home-Bildschirm" wählen
   - Name: „Ankauf"
   - „Hinzufügen"

🎉 Jetzt erscheint auf dem Home-Bildschirm ein **Stieber-Ankauf-Icon** wie bei einer echten App!

### PC (Chrome/Edge):
1. URL aufrufen
2. Login eingeben — Browser fragt nach Speichern (anhaken)
3. **Lesezeichen anlegen:** Strg+D
4. Optional: **Als Web-App installieren:**
   - Chrome: Drei-Punkte-Menü → „App installieren"
   - Edge: Drei-Punkte-Menü → „Apps" → „Diese Site als App installieren"

### Android-Tablet:
1. Chrome öffnen, URL eingeben
2. Login
3. Drei-Punkte-Menü → „Zum Startbildschirm hinzufügen"

---

## 🔄 Schritt 8: App-Updates später hochspielen

**Das ist jetzt das Beste:** Wenn ich dir eine neue Version der App schicke (z.B. mit Verbesserungen), brauchst du **nicht mehr 5 Geräte einzeln zu aktualisieren** — du machst einfach:

1. Strato-Datei-Manager öffnen
2. In den Ordner `ankauf` gehen
3. Neue `Ankauf.html` hochladen → **„Vorhandene Datei überschreiben"** bestätigen
4. **Fertig!** Alle Mitarbeiter sehen beim nächsten Aufruf automatisch die neue Version (max. 5 Minuten Verzögerung wegen Cache)

> 💡 **Tipp:** Sag den Mitarbeitern, dass sie den Browser einmal aktualisieren (F5 oder „Neu laden") — dann ist die neue Version sofort da.

---

## 🔒 Passwort ändern (empfohlen!)

Das voreingestellte Passwort `Ankauf2026!` solltest du sobald wie möglich ändern.

### Wie es geht:

**Option A — über mich (Claude):**
Sag mir einfach: _„Bitte erstelle eine neue .htpasswd mit Passwort XYZ"_, und ich schicke dir die fertige Datei zum Hochladen.

**Option B — selbst machen:**
1. Geh auf https://hostingcanada.org/htpasswd-generator/
2. Wähle „bcrypt" als Verschlüsselung
3. Trage Benutzername und neues Passwort ein
4. Klicke „Create"
5. Kopiere die ausgegebene Zeile (sieht so aus: `stieber:$2y$...`)
6. Im Strato-Datei-Manager `.htpasswd` öffnen, **Inhalt komplett ersetzen**
7. Speichern → fertig

---

## 📊 Was du jetzt hast

✅ **Eine zentrale Web-App** unter `https://www.autohaus-stieber.de/ankauf/`  
✅ **Passwortschutz** — nur Mitarbeiter mit Login kommen rein  
✅ **HTTPS** — verschlüsselte Übertragung  
✅ **Updates** in Zukunft mit einer einzigen Datei machbar  
✅ **Funktioniert** auf allen Geräten ohne Installation

---

## 🚀 Was als Nächstes geht (später)

Wenn ihr ein paar Wochen Erfahrung gesammelt habt, können wir den nächsten Schritt machen:

🔧 **Stufe 2: Daten-Synchronisation**  
Die Akten landen dann nicht mehr im Browser-Speicher, sondern in einer **MySQL-Datenbank** auf Strato (ist in deinem Tarif inklusive!) — dann sehen alle Mitarbeiter die gleichen Daten von überall.

Aber erst mal: **Stufe 1 zum Laufen bringen und im Alltag testen.** Wenn was hakt, melde dich!

---

## 📞 Bei Problemen

Sag mir was nicht funktioniert — ich helfe dir Schritt für Schritt durch.

**Viel Erfolg!** 🚗
