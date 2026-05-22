# 📦 Stieber-Ankauf — Komplettpaket

**Stand:** Mai 2026  
**Empfänger:** Oliver Stieber, Geschäftsführer Autohaus Stieber GmbH

Dieses Paket enthält alles, was für die Cowork-Übergabe und den Strato-Upload gebraucht wird.

---

## 📁 Inhalt

```
Stieber-Ankauf-Komplettpaket/
│
├── 00_LIES_MICH_ZUERST_Cowork_Briefing.md  ← In Cowork als ersten Prompt einfügen!
│
├── Strato-Paket/                            ← Diese 4 Dateien zu Strato hochladen
│   ├── Ankauf.html                          (die Web-App, ~200 KB)
│   ├── .htaccess                            (Passwortschutz-Konfiguration)
│   ├── .htpasswd                            (verschlüsseltes Passwort)
│   └── Strato_Anleitung.md                  (detaillierte Schritt-für-Schritt-Anleitung)
│
├── Beispiel-Akten/                          ← Zur Referenz / Test-Daten
│   ├── Csontos_Tucson_011029.json
│   ├── Csontos_Tucson_011029_Bewertung_Kaufvertrag.pdf
│   ├── Csontos_Tucson_011029_Uebergabe.pdf
│   ├── Rist_208_214689.json
│   ├── Rist_208_214689_Bewertung_Kaufvertrag.pdf
│   └── Rist_208_214689_Uebergabe.pdf
│
└── fahrzeugankauf-akte_Skill.zip            ← Claude.ai Skill-Definition (für Power-User)
```

---

## 🚀 Empfohlene Reihenfolge

### 1. In Cowork starten
1. Cowork-App öffnen
2. Neuen Chat starten
3. **`00_LIES_MICH_ZUERST_Cowork_Briefing.md`** öffnen
4. Inhalt komplett kopieren und als ersten Prompt in Cowork einfügen
5. Cowork-Claude weiß dann den ganzen Kontext und kann beim Strato-Setup helfen

### 2. Strato-Setup (mit Cowork-Hilfe)
- Ordner `/ankauf/` im Webspace anlegen
- Die 4 Dateien aus `Strato-Paket/` hochladen
- In `.htaccess` den Pfad anpassen (siehe `Strato_Anleitung.md` Schritt 5)
- Über `https://www.autohaus-stieber.de/ankauf/` testen
- Login: `stieber` / `Ankauf2026!`

### 3. Im Alltag nutzen
- App auf Tablet/PC im Browser öffnen
- Erste Akten anlegen
- Bei Bedarf zurück zu Claude.ai für App-Anpassungen

---

## 🔐 Zugangsdaten

```
URL:           https://www.autohaus-stieber.de/ankauf/
Benutzer:      stieber
Passwort:      Ankauf2026!  (sollte bald geändert werden)
```

---

## 📊 Was die App kann (Stand Mai 2026)

### ✅ Bereits implementiert
- 4-Stufen-Workflow: Datenaufnahme → Werkstatt → Kalkulation → Übergabe
- Akten-Verwaltung mit Status-Tracking (5 Stati)
- 30+ Standard-Extras als Checkliste
- Foto-Upload für Fahrzeugschein (Kamera + Mediathek)
- PDF-Generierung im Stieber-Corporate-Design
- Tablet-optimierte Bedienung
- Tab-Sperre: Kaufvertrag erst nach Werkstatt-Durchsicht
- Daten-Export/Import als JSON
- Funktioniert offline

### 🔜 Geplant (in Claude.ai zu beauftragen)
- **Stufe 2 — Datenbank-Anbindung:** Akten zentral in MySQL bei Strato (alle Mitarbeiter sehen gleiche Daten)
- **OCR-Funktion:** Fahrzeugschein fotografieren → Daten automatisch ausgelesen
- **Mehrere Mitarbeiter-Logins:** Eigener Benutzer pro Person mit Rollen

---

## 💡 Wichtige Hinweise

### Datenspeicherung (Stufe 1)
Die App speichert die Akten aktuell im **Browser-Speicher (LocalStorage)** — also **pro Gerät**. Das bedeutet:
- ✅ Daten gehen nie verloren — auch ohne Internet
- ⚠️ Daten **nicht automatisch zwischen Geräten synchron** — täglich Export/Import nötig
- 🔄 In Stufe 2 (Datenbank) wird das gelöst

### Updates
Wenn Anpassungen an der App nötig sind:
1. **Bei Claude.ai zurück** — ich kenne den vollständigen Code
2. Dort die Änderungen besprechen
3. Neue `Ankauf.html` herunterladen
4. **Im Strato-Datei-Manager hochladen** und alte Datei überschreiben
5. **Fertig!** Alle Mitarbeiter sehen die neue Version sofort

### Was Cowork-Claude besser kann
- Direkt im Strato-Browser navigieren (mit Mausklicks)
- Dateien lokal verwalten
- Browser-Aktionen ausführen

### Was Claude.ai (web) besser kann
- Komplexe Code-Änderungen an der App
- Den Code-Stand nachvollziehen (volle Chat-Historie)
- Neue Features designen und entwickeln

---

## 🆘 Bei Problemen

### Strato-Setup schlägt fehl
→ Cowork-Claude um Hilfe bitten oder bei Claude.ai zurückkommen

### App funktioniert nicht wie gewollt
→ Bei **Claude.ai** zurückkommen — dort den vollständigen Code-Stand und alle Anpassungswünsche besprechen

### Allgemeine Fragen zum Workflow
→ Oliver Stieber kontaktieren oder bei Claude.ai die ursprüngliche Konversation fortsetzen

---

## 🎯 Mein Tipp

**Mach erstmal nur das Strato-Setup mit Cowork** und teste die App ein paar Tage im Alltag. Wenn dann konkrete Verbesserungswünsche da sind oder die Datenbank-Anbindung gewünscht ist, **komm zu Claude.ai zurück** — die App-Architektur und der ganze Kontext sind dort.

**Viel Erfolg!** 🚗
