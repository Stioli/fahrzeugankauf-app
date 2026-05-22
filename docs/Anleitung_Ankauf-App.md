# Anleitung — Fahrzeugankauf-App im OneDrive einrichten

**Autohaus Stieber GmbH**

Diese Anleitung zeigt dir Schritt für Schritt, wie du die `Ankauf.html`-App in dein bestehendes OneDrive einbindest und mit deinen Mitarbeitern teilst.

---

## ⏱️ Zeitaufwand

- **Einrichtung (einmalig, du):** ca. 10–15 Minuten
- **Einarbeitung pro Mitarbeiter:** ca. 5 Minuten

---

## 📋 Was du brauchst

✅ Microsoft 365 mit OneDrive (hast du bereits)
✅ Die Datei `Ankauf.html` (haben wir gerade erstellt)
✅ E-Mail-Adressen deiner Mitarbeiter (für die Freigabe)
✅ Tablet/PC mit Browser (Chrome, Edge oder Safari)

---

## 🔧 Schritt 1: App in den Akten-Ordner legen

1. Öffne den Windows Explorer
2. Navigiere zu:
   ```
   OneDrive - Autohaus Stieber\Autohaus Stieber\Fahrzeugverkauf\Fahrzeuge\Inzahlungnahme+Ankauf
   ```
3. **Lege die Datei `Ankauf.html` in diesen Ordner**
4. Warte bis OneDrive die Synchronisation abgeschlossen hat (kleines grünes Häkchen)

---

## 🔗 Schritt 2: Ordner mit Mitarbeitern teilen

1. **Rechtsklick** auf den Ordner `Inzahlungnahme+Ankauf`
2. Wähle **„OneDrive → Teilen"** (oder „Personen einladen")
3. Im Dialog:
   - **Berechtigung:** „Bearbeiten"
   - **E-Mail-Adressen** der Mitarbeiter eingeben:
     - z.B. `verkauf@stieber.de`, `werkstatt@stieber.de`, etc.
   - **Optional:** Häkchen bei „Anmeldung erforderlich" — sicherer
4. Klicke **„Senden"**

Die Mitarbeiter bekommen eine E-Mail mit einem Link zum Ordner.

---

## 📱 Schritt 3: App auf jedem Gerät einrichten

### Auf dem PC (Werkstatt + Büro)

1. Mitarbeiter öffnet die E-Mail mit der Freigabe und klickt den Link
2. OneDrive öffnet sich → der Ordner ist sichtbar
3. **Wichtig:** "Mit meinem OneDrive synchronisieren" klicken (oben in OneDrive)
4. Jetzt ist der Ordner auch im Windows Explorer verfügbar
5. **`Ankauf.html` doppelklicken** → öffnet sich im Browser

### Auf dem Tablet (Verkaufsberater)

**Option A: iPad/iPhone**
1. OneDrive-App aus dem App Store installieren
2. Mit Microsoft-Konto anmelden
3. Ordner `Inzahlungnahme+Ankauf` öffnen
4. `Ankauf.html` antippen → öffnet sich in Safari

**Option B: Android-Tablet**
1. OneDrive-App aus Google Play installieren
2. Anmelden + Ordner öffnen
3. `Ankauf.html` antippen → Browser öffnet die Datei

**Tipp:** Auf dem Tablet nach dem ersten Öffnen die Seite **„zum Home-Bildschirm hinzufügen"** — dann hast du sie als App-Icon!

---

## 🔄 Wie funktioniert die Datenspeicherung?

Wichtig zu wissen: Die App speichert die Daten **lokal im Browser** (LocalStorage). Das bedeutet:

✅ Daten gehen nie verloren — auch ohne Internet  
✅ Schnell und ohne Verzögerung  
⚠️ **Pro Gerät separater Datenstand** — Daten wandern nicht automatisch zwischen Geräten

### So tauschst du Akten zwischen Geräten:

1. Auf Gerät A: **Klick auf „⬇ Export"** (rechts oben in der App)
   → Datei `Stieber-Ankauf-Akten_2026-XX-XX.json` wird heruntergeladen
2. Datei in den OneDrive-Ordner legen
3. Auf Gerät B: **Klick auf „⬆ Import"**
4. Die JSON-Datei auswählen → Akten werden übernommen

**💡 Empfehlung:** Macht **einmal pro Tag einen Export** als Backup in den OneDrive-Ordner.

---

## 🖨️ PDF-Export

Wenn du in der App auf **„📄 Bewertung & Kaufvertrag (PDF)"** klickst:

1. Es öffnet sich ein neues Browserfenster
2. Der **Druckdialog** erscheint automatisch
3. Wähle als „Drucker" → **„Als PDF speichern"** (Microsoft Print to PDF / Save as PDF)
4. Speichere das PDF in den Akten-Ordner mit dem Namen, der dir vorgeschlagen wird

**Wichtig:** Im Druckdialog folgende Einstellungen prüfen:
- **Format:** A4
- **Ränder:** Standard
- **Hintergrundgrafiken:** ✅ EIN (sonst fehlt das blaue Banner)

---

## 📁 Akten-Ablage in OneDrive

So sieht die ideale Ordner-Struktur aus:

```
OneDrive\Autohaus Stieber\Fahrzeugverkauf\Fahrzeuge\Inzahlungnahme+Ankauf\
│
├── Ankauf.html                              ← Die App selbst
├── Stieber-Ankauf-Akten_2026-XX-XX.json     ← Tägliches Backup
│
├── Csontos_Tucson_011029\                   ← Pro Akte ein Ordner
│   ├── Csontos_Tucson_011029_Bewertung.pdf
│   ├── Csontos_Tucson_011029_Kaufvertrag.pdf
│   ├── Csontos_Tucson_011029_Uebergabe.pdf
│   ├── ZLB_Foto.jpg
│   └── Direktannahme.pdf
│
├── Doell_Tucson_133631\
│   └── ...
│
└── Rist_208_214689\
    └── ...
```

---

## ⚠️ Wichtige Hinweise

### Datenschutz / DSGVO

✅ Alle Daten bleiben in **eurem Microsoft 365** — kein externer Anbieter  
✅ Pro-Gerät-Speicherung im Browser ist **nur lokal** auf dem Gerät  
✅ PDFs liegen im OneDrive — DSGVO-konform durch Microsoft 365 Business

### Was die App **nicht** automatisch macht

❌ Daten zwischen Geräten synchronisieren (manuell per Export/Import)
❌ PDF automatisch im OneDrive ablegen (manuell speichern)
❌ Mitarbeiter-Login (jeder mit Ordner-Zugriff kann alles sehen)

### Was die App **gut** macht

✅ Alle 4 Stufen sauber strukturiert (Datenaufnahme → Werkstatt → Kalkulation → Übergabe)  
✅ Tablet-optimiert mit großen Buttons  
✅ Auto-Save bei jeder Eingabe  
✅ Professionelles PDF im Stieber-Design  
✅ Funktioniert offline  
✅ Status-Übersicht aller Akten

---

## 🆘 Häufige Probleme

**Die App öffnet sich nicht / nur Code wird angezeigt**  
→ Im Explorer rechtsklick auf `Ankauf.html` → „Öffnen mit" → Browser auswählen

**PDF sieht falsch aus (kein Logo, falsche Farben)**  
→ Im Druckdialog: „Hintergrundgrafiken" / „Background graphics" einschalten

**Daten weg nach Browser-Update**  
→ Sehr selten, aber möglich. Deshalb täglich Export machen!

**Andere Mitarbeiter sehen meine Akten nicht**  
→ Das ist normal — Daten sind pro Gerät getrennt. Export/Import nutzen.

---

## 🚀 Nächste Ausbaustufen (später, wenn gewünscht)

Wenn ihr merkt: „Wir brauchen wirklich gemeinsam-synchrone Daten von überall", dann gibt es diese Wege:

1. **Power Apps** — Microsoft-eigene App-Plattform mit zentraler Datenbank
2. **Eigene Web-App** mit Vercel + Supabase (~10 €/Monat)
3. **SharePoint-Liste mit angepasstem Frontend**

Aber das machen wir später, wenn der Bedarf wirklich da ist! Erstmal mit dieser einfachen Lösung Erfahrungen sammeln.

---

## 📞 Bei Fragen

Wende dich an Oliver Stieber oder schreibe deine Verbesserungswünsche auf — wir können die App jederzeit anpassen.

**Viel Erfolg mit der App!** 🚗
