-- Run Tracker — Supabase schema
--
-- Column names are camelCase and quoted, exactly as used by the Dart model.
-- Do not rename them: the app and this table share the same identifiers.

create extension if not exists "pgcrypto";

create table if not exists public.run_tb (
  id           uuid primary key default gen_random_uuid(),
  created_at   timestamptz not null default now(),
  "runWhere"    text,
  "runPerson"   text,
  "runDistance" integer,
  "runImageUrl" text
);

comment on table public.run_tb is
  'Run log rows for the Run Tracker app. One row per run, optional photo.';

-- ---------------------------------------------------------------------------
-- Row Level Security
-- ---------------------------------------------------------------------------
-- The app has no login screen, so it uses the anon key. The policies below
-- let anyone holding that key read and write the shared log. This is the
-- intended model for this single-user student project; the app never ships
-- a service role key.
alter table public.run_tb enable row level security;

create policy "run_tb read"   on public.run_tb for select to anon, authenticated using (true);
create policy "run_tb insert" on public.run_tb for insert to anon, authenticated with check (true);
create policy "run_tb update" on public.run_tb for update to anon, authenticated using (true) with check (true);
create policy "run_tb delete" on public.run_tb for delete to anon, authenticated using (true);

-- ---------------------------------------------------------------------------
-- Storage bucket "run_bk" — public bucket
-- ---------------------------------------------------------------------------
-- Public read lets Image.network render a stored photo without signing every
-- URL. Writes still go through the anon-key policies below.
-- Size and MIME limits match what the app uploads (image/jpeg, image/png,
-- image/webp) and keep the bucket from being used as generic file storage.
insert into storage.buckets (id, name, public, file_size_limit, allowed_mime_types)
values ('run_bk', 'run_bk', true, 10485760,
        array['image/jpeg', 'image/png', 'image/webp'])
on conflict (id) do update
  set public = excluded.public,
      file_size_limit = excluded.file_size_limit,
      allowed_mime_types = excluded.allowed_mime_types;

create policy "run_bk read"   on storage.objects for select to anon, authenticated
  using (bucket_id = 'run_bk');
create policy "run_bk insert" on storage.objects for insert to anon, authenticated
  with check (bucket_id = 'run_bk');
create policy "run_bk update" on storage.objects for update to anon, authenticated
  using (bucket_id = 'run_bk') with check (bucket_id = 'run_bk');
create policy "run_bk delete" on storage.objects for delete to anon, authenticated
  using (bucket_id = 'run_bk');

-- ---------------------------------------------------------------------------
-- Photo lifecycle used by the app
-- ---------------------------------------------------------------------------
-- insert with a photo  : upload to run_bk, store the object path in runImageUrl
-- update with new photo: upload new, delete the replaced object, update the column
-- delete a row         : remove the run_bk object when runImageUrl is set
