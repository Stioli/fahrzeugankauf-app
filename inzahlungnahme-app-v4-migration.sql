-- =====================================================================
-- Migration: Inzahlungnahme-App v3 -> v4
-- Datum: 2026-05-24
-- Tabelle: public.fahrzeugankauf
--
-- Ergaenzungen v4:
--   1. fz_sitzplaetze                       (Anzahl Sitzplätze, 1-9, "mehr als 9")
--   2. reifen_sommer_profil_vorne/hinten    (getrennte Profiltiefe vorne/hinten)
--   3. reifen_winter_profil_vorne/hinten
--   4. reifen_ganzjahres + Profiltiefen     (NEU: Ganzjahresreifen)
--   5. vk_bekannte_maengel                  (Pflichtfeld: Verkäufer kennt diese Mängel)
--   6. mn_bemerkungen                       (Bemerkungen im Mängel-Block)
--   7. fotos                                (JSONB: Array von Storage-Pfaden)
--   8. Storage-Bucket "ankauf-fotos" + Policies fuer authenticated upload/read
--
-- ALTE Spalten reifen_sommer_profil / reifen_winter_profil bleiben bestehen
-- (Backward-Compatibility fuer existierende Datensaetze) und werden von der
-- App v4 nicht mehr beschrieben.
-- =====================================================================

-- ---------------------------------------------------------------------
-- 1) Neue Spalten anlegen (idempotent)
-- ---------------------------------------------------------------------
ALTER TABLE public.fahrzeugankauf
    ADD COLUMN IF NOT EXISTS fz_sitzplaetze              TEXT,
    ADD COLUMN IF NOT EXISTS reifen_sommer_profil_vorne  NUMERIC,
    ADD COLUMN IF NOT EXISTS reifen_sommer_profil_hinten NUMERIC,
    ADD COLUMN IF NOT EXISTS reifen_winter_profil_vorne  NUMERIC,
    ADD COLUMN IF NOT EXISTS reifen_winter_profil_hinten NUMERIC,
    ADD COLUMN IF NOT EXISTS reifen_ganzjahres           BOOLEAN DEFAULT FALSE,
    ADD COLUMN IF NOT EXISTS reifen_ganzjahres_profil_vorne  NUMERIC,
    ADD COLUMN IF NOT EXISTS reifen_ganzjahres_profil_hinten NUMERIC,
    ADD COLUMN IF NOT EXISTS vk_bekannte_maengel         TEXT,
    ADD COLUMN IF NOT EXISTS mn_bemerkungen              TEXT,
    ADD COLUMN IF NOT EXISTS fotos                       JSONB DEFAULT '[]'::jsonb;

COMMENT ON COLUMN public.fahrzeugankauf.fz_sitzplaetze              IS 'Anzahl Sitzplaetze (1-9 oder "mehr als 9")';
COMMENT ON COLUMN public.fahrzeugankauf.reifen_ganzjahres           IS 'Ganzjahresreifen vorhanden';
COMMENT ON COLUMN public.fahrzeugankauf.vk_bekannte_maengel         IS 'PFLICHTFELD: Vom Verkaeufer angegebene bekannte Maengel (rechtl. relevant)';
COMMENT ON COLUMN public.fahrzeugankauf.mn_bemerkungen              IS 'Freie Bemerkungen zur Maengel-Bewertung (interne Notizen)';
COMMENT ON COLUMN public.fahrzeugankauf.fotos                       IS 'Array von Supabase-Storage-Pfaden (Bucket "ankauf-fotos"), z.B. ["ankauf_xyz/foto_uuid.jpg"]';

-- ---------------------------------------------------------------------
-- 2) Storage-Bucket "ankauf-fotos" anlegen (idempotent)
-- ---------------------------------------------------------------------
INSERT INTO storage.buckets (id, name, public, file_size_limit, allowed_mime_types)
VALUES (
    'ankauf-fotos',
    'ankauf-fotos',
    TRUE,                                                       -- public: URL ohne Auth-Token lesbar (vereinfacht Druck)
    10485760,                                                    -- 10 MB pro Datei
    ARRAY['image/jpeg','image/png','image/webp','image/heic']
)
ON CONFLICT (id) DO UPDATE SET
    public = EXCLUDED.public,
    file_size_limit = EXCLUDED.file_size_limit,
    allowed_mime_types = EXCLUDED.allowed_mime_types;

-- ---------------------------------------------------------------------
-- 3) Storage-Policies fuer Bucket "ankauf-fotos"
--    - SELECT: oeffentlich lesbar (Bucket ist public)
--    - INSERT/UPDATE/DELETE: nur authenticated User
-- ---------------------------------------------------------------------
DROP POLICY IF EXISTS "ankauf_fotos_public_read"   ON storage.objects;
DROP POLICY IF EXISTS "ankauf_fotos_auth_insert"   ON storage.objects;
DROP POLICY IF EXISTS "ankauf_fotos_auth_update"   ON storage.objects;
DROP POLICY IF EXISTS "ankauf_fotos_auth_delete"   ON storage.objects;

CREATE POLICY "ankauf_fotos_public_read"
    ON storage.objects FOR SELECT
    TO public
    USING (bucket_id = 'ankauf-fotos');

CREATE POLICY "ankauf_fotos_auth_insert"
    ON storage.objects FOR INSERT
    TO authenticated
    WITH CHECK (bucket_id = 'ankauf-fotos');

CREATE POLICY "ankauf_fotos_auth_update"
    ON storage.objects FOR UPDATE
    TO authenticated
    USING (bucket_id = 'ankauf-fotos')
    WITH CHECK (bucket_id = 'ankauf-fotos');

CREATE POLICY "ankauf_fotos_auth_delete"
    ON storage.objects FOR DELETE
    TO authenticated
    USING (bucket_id = 'ankauf-fotos');

-- ---------------------------------------------------------------------
-- 4) Pruefung
-- ---------------------------------------------------------------------
SELECT
    column_name,
    data_type,
    column_default
FROM information_schema.columns
WHERE table_schema = 'public'
  AND table_name   = 'fahrzeugankauf'
  AND column_name IN (
      'fz_sitzplaetze',
      'reifen_sommer_profil_vorne','reifen_sommer_profil_hinten',
      'reifen_winter_profil_vorne','reifen_winter_profil_hinten',
      'reifen_ganzjahres','reifen_ganzjahres_profil_vorne','reifen_ganzjahres_profil_hinten',
      'vk_bekannte_maengel','mn_bemerkungen','fotos'
  )
ORDER BY column_name;

SELECT id, name, public, file_size_limit
FROM storage.buckets
WHERE id = 'ankauf-fotos';

SELECT policyname, cmd
FROM pg_policies
WHERE schemaname = 'storage' AND tablename = 'objects'
  AND policyname LIKE 'ankauf_fotos_%'
ORDER BY policyname;
