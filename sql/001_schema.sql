-- SAI FILM — initial database schema
-- Apply this file in Supabase SQL Editor.
-- Admin membership is bootstrapped manually after the administrator signs up.
-- Never place service_role / sb_secret keys in the frontend.

create extension if not exists pgcrypto;

create table if not exists public.admin_users (
  user_id uuid primary key references auth.users(id) on delete cascade,
  created_at timestamptz not null default now()
);

create table if not exists public.categories (
  id uuid primary key default gen_random_uuid(),
  name text not null,
  slug text not null unique,
  description text,
  sort_order integer not null default 0,
  is_active boolean not null default true,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);

create table if not exists public.projects (
  id uuid primary key default gen_random_uuid(),
  category_id uuid references public.categories(id) on delete set null,
  title text not null,
  slug text not null unique,
  summary text,
  description text,
  cover_media_id uuid,
  is_featured boolean not null default false,
  status text not null default 'draft' check (status in ('draft', 'published')),
  sort_order integer not null default 0,
  published_at timestamptz,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);

create table if not exists public.project_media (
  id uuid primary key default gen_random_uuid(),
  project_id uuid not null references public.projects(id) on delete cascade,
  media_type text not null check (media_type in ('image', 'video')),
  storage_path text,
  external_url text,
  alt_text text,
  caption text,
  is_cover boolean not null default false,
  sort_order integer not null default 0,
  created_at timestamptz not null default now(),
  constraint project_media_source_check check (
    (storage_path is not null and external_url is null)
    or (storage_path is null and external_url is not null)
  )
);

alter table public.projects
  drop constraint if exists projects_cover_media_id_fkey;
alter table public.projects
  add constraint projects_cover_media_id_fkey
  foreign key (cover_media_id) references public.project_media(id) on delete set null;

create table if not exists public.site_settings (
  key text primary key,
  value jsonb not null default '{}'::jsonb,
  updated_at timestamptz not null default now()
);

create index if not exists projects_publication_idx
  on public.projects(status, is_featured, sort_order);
create index if not exists projects_category_idx
  on public.projects(category_id);
create index if not exists project_media_project_idx
  on public.project_media(project_id, sort_order);

create or replace function public.set_updated_at()
returns trigger
language plpgsql
as $$
begin
  new.updated_at = now();
  return new;
end;
$$;

drop trigger if exists categories_set_updated_at on public.categories;
create trigger categories_set_updated_at
before update on public.categories
for each row execute function public.set_updated_at();

drop trigger if exists projects_set_updated_at on public.projects;
create trigger projects_set_updated_at
before update on public.projects
for each row execute function public.set_updated_at();

drop trigger if exists site_settings_set_updated_at on public.site_settings;
create trigger site_settings_set_updated_at
before update on public.site_settings
for each row execute function public.set_updated_at();

alter table public.admin_users enable row level security;
alter table public.categories enable row level security;
alter table public.projects enable row level security;
alter table public.project_media enable row level security;
alter table public.site_settings enable row level security;

-- A signed-in user can only see their own admin membership.
-- Membership creation is intentionally reserved for the Supabase SQL Editor.
drop policy if exists "Admins can read own membership" on public.admin_users;
create policy "Admins can read own membership"
on public.admin_users for select
to authenticated
using (user_id = (select auth.uid()));

-- Public visitors can read active categories used by published projects.
drop policy if exists "Public can read active categories" on public.categories;
create policy "Public can read active categories"
on public.categories for select
to anon, authenticated
using (
  is_active = true
  and exists (
    select 1 from public.projects p
    where p.category_id = categories.id and p.status = 'published'
  )
);

-- Administrators can manage categories.
drop policy if exists "Admins manage categories" on public.categories;
create policy "Admins manage categories"
on public.categories for all
to authenticated
using (exists (select 1 from public.admin_users a where a.user_id = (select auth.uid())))
with check (exists (select 1 from public.admin_users a where a.user_id = (select auth.uid())));

-- Public visitors can read published projects only.
drop policy if exists "Public can read published projects" on public.projects;
create policy "Public can read published projects"
on public.projects for select
to anon, authenticated
using (status = 'published');

drop policy if exists "Admins manage projects" on public.projects;
create policy "Admins manage projects"
on public.projects for all
to authenticated
using (exists (select 1 from public.admin_users a where a.user_id = (select auth.uid())))
with check (exists (select 1 from public.admin_users a where a.user_id = (select auth.uid())));

-- Media is public only when its parent project is published.
drop policy if exists "Public can read media of published projects" on public.project_media;
create policy "Public can read media of published projects"
on public.project_media for select
to anon, authenticated
using (
  exists (
    select 1 from public.projects p
    where p.id = project_media.project_id and p.status = 'published'
  )
);

drop policy if exists "Admins manage project media" on public.project_media;
create policy "Admins manage project media"
on public.project_media for all
to authenticated
using (exists (select 1 from public.admin_users a where a.user_id = (select auth.uid())))
with check (exists (select 1 from public.admin_users a where a.user_id = (select auth.uid())));

-- Site settings are public-readable; writes require an administrator.
drop policy if exists "Public can read site settings" on public.site_settings;
create policy "Public can read site settings"
on public.site_settings for select
to anon, authenticated
using (true);

drop policy if exists "Admins manage site settings" on public.site_settings;
create policy "Admins manage site settings"
on public.site_settings for all
to authenticated
using (exists (select 1 from public.admin_users a where a.user_id = (select auth.uid())))
with check (exists (select 1 from public.admin_users a where a.user_id = (select auth.uid())));

-- Starter categories; safe to run more than once.
insert into public.categories (name, slug, sort_order)
values
  ('Photography', 'photography', 1),
  ('Film & Video', 'film-video', 2),
  ('Podcast', 'podcast', 3),
  ('Video Editing', 'video-editing', 4),
  ('Videobooks', 'videobooks', 5)
on conflict (slug) do nothing;
