-- =====================================================================
-- Migration: Inzahlungnahme-App v2 -> v3
-- Datum: 2026-05-19
-- Tabelle: public.fahrzeugankauf
-- Ergaenzungen:
--   1. interne_nr  TEXT          (haendisch eingetragene interne Nummer)
--   2. erstellt_von UUID         (Supabase Auth User-ID des Bearbeiters)
--   3. RLS-Policies: jeder Mitarbeiter sieht/aendert seine eigenen
--      Ankaeufe + optional "alle" via Filter in der App.
-- =====================================================================

-- ---------------------------------------------------------------------
-- 1) Neue Spalten anlegen (idempotent)
-- ---------------------------------------------------------------------
ALTER TABLE public.fahrzeugankauf
    ADD COLUMN IF NOT EXISTS interne_nr   TEXT,
    ADD COLUMN IF NOT EXISTS erstellt_von UUID REFERENCES auth.users(id) ON DELETE SET NULL;

CREATE INDEX IF NOT EXISTS idx_fahrzeugankauf_interne_nr
    ON public.fahrzeugankauf (interne_nr);

CREATE INDEX IF NOT EXISTS idx_fahrzeugankauf_erstellt_von
    ON public.fahrzeugankauf (erstellt_von);

COMMENT ON COLUMN public.fahrzeugankauf.interne_nr   IS 'Haendisch vergebene interne Ankaufsnummer (Freitext)';
COMMENT ON COLUMN public.fahrzeugankauf.erstellt_von IS 'auth.users(id) des Mitarbeiters, der den Datensatz angelegt hat';

-- ---------------------------------------------------------------------
-- 2) Bestehende Datensaetze: erstellt_von leer lassen
--    (Alt-Datensaetze bleiben sichtbar fuer alle, weil erstellt_von NULL)
-- ---------------------------------------------------------------------
-- Kein Backfill noetig. Wer sie pflegt, kann sie spaeter zuordnen.

-- ---------------------------------------------------------------------
-- 3) RLS aktivieren + Policies
-- ---------------------------------------------------------------------
ALTER TABLE public.fahrzeugankauf ENABLE ROW LEVEL SECURITY;

-- Alte Policies (falls vorhanden) erstmal abraeumen
DROP POLICY IF EXISTS "ankauf_select_all"     ON public.fahrzeugankauf;
DROP POLICY IF EXISTS "ankauf_insert_self"    ON public.fahrzeugankauf;
DROP POLICY IF EXISTS "ankauf_update_self"    ON public.fahrzeugankauf;
DROP POLICY IF EXISTS "ankauf_delete_self"    ON public.fahrzeugankauf;

-- SELECT: jeder eingeloggte Mitarbeiter sieht alle Ankaeufe.
-- (Der "Meine / Alle"-Filter in der App ist UI-seitig.)
CREATE POLICY "ankauf_select_all"
    ON public.fahrzeugankauf
    FOR SELECT
    TO authenticated
    USING (true);

-- INSERT: nur eingeloggte User, und erstellt_von MUSS gleich auth.uid() sein.
CREATE POLICY "ankauf_insert_self"
    ON public.fahrzeugankauf
    FOR INSERT
    TO authenticated
    WITH CHECK (erstellt_von = auth.uid());

-- UPDATE: jeder eingeloggte Mitarbeiter darf ALLE Ankaeufe aendern
-- (Team-Modus). Falls du das auf "nur eigene" einschraenken willst,
-- ersetze "USING (true)" durch "USING (erstellt_von = auth.uid())".
CREATE POLICY "ankauf_update_self"
    ON public.fahrzeugankauf
    FOR UPDATE
    TO authenticated
    USING (true)
    WITH CHECK (true);

-- DELETE: nur eigene Datensaetze loeschen.
CREATE POLICY "ankauf_delete_self"
    ON public.fahrzeugankauf
    FOR DELETE
    TO authenticated
    USING (erstellt_von = auth.uid());

-- ---------------------------------------------------------------------
-- 4) Trigger: erstellt_von beim INSERT automatisch setzen,
--    falls App es vergisst (Defensive Default).
-- ---------------------------------------------------------------------
CREATE OR REPLACE FUNCTION public.fa_set_erstellt_von()
RETURNS TRIGGER AS $$
BEGIN
    IF NEW.erstellt_von IS NULL THEN
        NEW.erstellt_von := auth.uid();
    END IF;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

DROP TRIGGER IF EXISTS tg_fa_set_erstellt_von ON public.fahrzeugankauf;
CREATE TRIGGER tg_fa_set_erstellt_von
    BEFORE INSERT ON public.fahrzeugankauf
    FOR EACH ROW EXECUTE FUNCTION public.fa_set_erstellt_von();

-- ---------------------------------------------------------------------
-- 5) Pruefung am Ende
-- ---------------------------------------------------------------------
SELECT
    column_name,
    data_type,
    is_nullable
FROM information_schema.columns
WHERE table_schema = 'public'
  AND table_name   = 'fahrzeugankauf'
  AND column_name IN ('interne_nr', 'erstellt_von')
ORDER BY column_name;

SELECT policyname, cmd, qual, with_check
FROM pg_policies
WHERE schemaname = 'public' AND tablename = 'fahrzeugankauf'
ORDER BY policyname;
