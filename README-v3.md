# Inzahlungnahme-App v3 – Übergabe

**Datum:** 2026-05-19
**Datei:** `inzahlungnahme-app-v3.html`
**SQL:** `inzahlungnahme-app-supabase-migration.sql`

---

## Was ist neu gegenüber v2?

### 1. Stieber-CI komplett angewendet
Identisches Design wie [autohaus-stieber.de](https://www.autohaus-stieber.de) (Stand 13.05.2026):
- Schriften: **Plus Jakarta Sans** (Headlines/Zahlen) + **DM Sans** (Body)
- Akzent-Farbe: **#1a6dd4** (Stieber-Blau, ersetzt das alte Navy/Gold)
- Hero-Gradient `#f8fbff → #eef4fd`, weiche 12–20px Border-Radius
- `<em>Stieber</em>` italic+blau im Branding (wie auf der Website)

### 2. Zwei neue Felder
| Feld | Wo? | Logik |
|---|---|---|
| **Interne Nr.** | Formular Sektion 2, oben links + 1. Tabellen-Spalte | Händisch eingetragen (z.B. `A-2026-0234`) |
| **Fgst.-Nr.** | War schon im Formular, jetzt **auch in der Tabelle** sichtbar (Monospace-Font) | Bestehendes Feld `fz_fahrgestellnr` |

### 3. Spalten-Filter unter jedem Header
Zusätzlich zur globalen Volltextsuche (durchsucht jetzt auch Interne Nr. + FIN + alle Verkäufer-Felder + Notizen) gibt es **pro Spalte ein Eingabefeld** – live filter beim Tippen:

`Interne Nr. | Datum | Fahrzeug | Fgst.-Nr. | Kennzeichen | Verkäufer | KM | Preis | Status | Aktion`

Status hat eine Dropdown, die anderen sind Freitext-Inputs.

### 4. Mitarbeiter-Auth (Supabase Auth)
- `currentUserId` wird beim Login gemerkt
- Beim **Insert** wird `erstellt_von = auth.uid()` automatisch mitgespeichert
- **Update** überschreibt `erstellt_von` nicht (bleibt beim Original-Mitarbeiter)
- Neuer Filter `Alle Mitarbeiter / Nur meine Ankäufe` oben rechts

---

## Schritte zum Live-Gehen

### Schritt 1 – Supabase-SQL ausführen
**Pflicht – sonst geht nichts.**

1. Supabase-Dashboard öffnen → SQL Editor
2. Inhalt von `inzahlungnahme-app-supabase-migration.sql` einfügen
3. **Run** klicken
4. Erwartete Ausgabe am Ende:
   - 2 Zeilen aus `information_schema.columns` (`interne_nr` + `erstellt_von`)
   - 4 Policy-Zeilen (`ankauf_select_all`, `ankauf_insert_self`, `ankauf_update_self`, `ankauf_delete_self`)

### Schritt 2 – Mitarbeiter-Accounts anlegen
Im Supabase-Dashboard → **Authentication → Users**:

| Mitarbeiter | E-Mail | Passwort |
|---|---|---|
| Oliver Stieber | oliver.stieber@autohaus-stieber.de | (vergeben) |
| (weitere) | name@autohaus-stieber.de | … |

→ "Add user" → "Create new user" → E-Mail + temporäres Passwort
→ Häkchen bei "Auto Confirm User" setzen (sonst muss Mitarbeiter erst Bestätigungs-Mail anklicken)

### Schritt 3 – App testen
1. Datei `inzahlungnahme-app-v3.html` öffnen
2. Login mit einem der angelegten Accounts
3. Neuen Ankauf erfassen → speichern
4. In Supabase prüfen: `SELECT id, interne_nr, erstellt_von FROM fahrzeugankauf ORDER BY erstellt_am DESC LIMIT 1;`
   → `erstellt_von` muss die UUID des eingeloggten Mitarbeiters sein
5. Mit zweitem Account einloggen → Filter "Nur meine Ankäufe" testen

---

## RLS-Verhalten (was sehen Mitarbeiter?)

| Aktion | Wer darf? |
|---|---|
| **Lesen** (SELECT) | Alle angemeldeten Mitarbeiter sehen alle Ankäufe |
| **Anlegen** (INSERT) | Nur eingeloggte User; `erstellt_von` MUSS auf `auth.uid()` gesetzt sein (Trigger setzt automatisch) |
| **Ändern** (UPDATE) | Alle eingeloggten Mitarbeiter (Team-Modus) |
| **Löschen** (DELETE) | Nur den eigenen Datensatz (`erstellt_von = auth.uid()`) |

**Falls "nur eigene ändern" gewünscht:**
In der SQL-Migration in der `ankauf_update_self`-Policy `USING (true)` durch `USING (erstellt_von = auth.uid())` ersetzen.

---

## Rollback

Falls etwas schiefgeht:

1. App: einfach wieder `inzahlungnahme-app-v2.html` öffnen (in Downloads steht beides parallel)
2. SQL-Rollback:
```sql
DROP TRIGGER IF EXISTS tg_fa_set_erstellt_von ON public.fahrzeugankauf;
DROP FUNCTION IF EXISTS public.fa_set_erstellt_von();
DROP POLICY IF EXISTS "ankauf_select_all"  ON public.fahrzeugankauf;
DROP POLICY IF EXISTS "ankauf_insert_self" ON public.fahrzeugankauf;
DROP POLICY IF EXISTS "ankauf_update_self" ON public.fahrzeugankauf;
DROP POLICY IF EXISTS "ankauf_delete_self" ON public.fahrzeugankauf;
ALTER TABLE public.fahrzeugankauf DISABLE ROW LEVEL SECURITY;
-- Spalten BEHALTEN (interne_nr, erstellt_von) – v2 ignoriert sie einfach.
```

---

## Bekannte Punkte / nächste Schritte

- **Excel-Übersicht** (`Website-Uebersicht-Autohaus-Stieber.xlsx`) noch aktualisieren mit Eintrag „2026-05-19: Inzahlungnahme-App v3 – Stieber-CI + Interne Nr. + Auth pro Mitarbeiter"
- **Backup** der v2-Datei ist bereits im Downloads-Ordner als `inzahlungnahme-app-v2.html` vorhanden
- **Tablet-Test:** Die App sollte auch auf einem iPad gut nutzbar sein (Body-Mindestgröße 16px wurde Mobile-Regel-konform gesetzt)
