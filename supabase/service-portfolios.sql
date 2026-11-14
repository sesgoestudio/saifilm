-- SAI FILM: portafolios independientes por servicio
-- Ejecuta este archivo una sola vez en Supabase > SQL Editor.
create table if not exists public.service_portfolios (
 id uuid primary key default gen_random_uuid(), name text not null, slug text not null unique,
 description text not null default '', sort_order integer not null default 0,
 is_active boolean not null default true, created_at timestamptz not null default now()
);
create table if not exists public.service_portfolio_media (
 id uuid primary key default gen_random_uuid(),
 service_id uuid not null references public.service_portfolios(id) on delete cascade,
 storage_path text, external_url text, alt_text text not null default '',
 caption text not null default '', sort_order integer not null default 0,
 is_cover boolean not null default false, created_at timestamptz not null default now(),
 constraint service_portfolio_media_source check (storage_path is not null or external_url is not null)
);
create index if not exists service_portfolios_order_idx on public.service_portfolios(is_active,sort_order);
create index if not exists service_portfolio_media_service_idx on public.service_portfolio_media(service_id,sort_order);
alter table public.service_portfolios enable row level security;
alter table public.service_portfolio_media enable row level security;
drop policy if exists "Public can view active service portfolios" on public.service_portfolios;
create policy "Public can view active service portfolios" on public.service_portfolios for select using (is_active=true);
drop policy if exists "Admins manage service portfolios" on public.service_portfolios;
create policy "Admins manage service portfolios" on public.service_portfolios for all to authenticated using (exists(select 1 from public.admin_users a where a.user_id=auth.uid())) with check (exists(select 1 from public.admin_users a where a.user_id=auth.uid()));
drop policy if exists "Public can view active service portfolio media" on public.service_portfolio_media;
create policy "Public can view active service portfolio media" on public.service_portfolio_media for select using (exists(select 1 from public.service_portfolios s where s.id=service_id and s.is_active=true));
drop policy if exists "Admins manage service portfolio media" on public.service_portfolio_media;
create policy "Admins manage service portfolio media" on public.service_portfolio_media for all to authenticated using (exists(select 1 from public.admin_users a where a.user_id=auth.uid())) with check (exists(select 1 from public.admin_users a where a.user_id=auth.uid()));
drop policy if exists "Admins upload service portfolio files" on storage.objects;
create policy "Admins upload service portfolio files" on storage.objects for insert to authenticated with check (bucket_id='saifilm-media' and name like 'services/%' and exists(select 1 from public.admin_users a where a.user_id=auth.uid()));
drop policy if exists "Admins update service portfolio files" on storage.objects;
create policy "Admins update service portfolio files" on storage.objects for update to authenticated using (bucket_id='saifilm-media' and name like 'services/%' and exists(select 1 from public.admin_users a where a.user_id=auth.uid())) with check (bucket_id='saifilm-media' and name like 'services/%' and exists(select 1 from public.admin_users a where a.user_id=auth.uid()));
drop policy if exists "Admins delete service portfolio files" on storage.objects;
create policy "Admins delete service portfolio files" on storage.objects for delete to authenticated using (bucket_id='saifilm-media' and name like 'services/%' and exists(select 1 from public.admin_users a where a.user_id=auth.uid()));
