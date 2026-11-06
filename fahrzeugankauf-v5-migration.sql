-- Fahrzeugankauf-App v5 (06.11.2026): nur NEUE Spalten, bestehende Daten bleiben unverändert
alter table public.fahrzeugankauf
  add column if not exists vk_schaeden        text,
  add column if not exists fz_geprueft        boolean,
  add column if not exists fz_geprueft_datum  date,
  add column if not exists fz_pruefer_name    text,
  add column if not exists zus_ja_nein        boolean;
