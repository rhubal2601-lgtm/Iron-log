-- logbook Supabase setup (run once in SQL Editor)
create extension if not exists pgcrypto;

create table if not exists public.workspaces (
  id uuid primary key default gen_random_uuid(),
  owner_id uuid not null unique references auth.users(id) on delete cascade,
  name text not null default 'Mein logbook',
  created_at timestamptz not null default now()
);
create table if not exists public.profiles (
  id uuid primary key default gen_random_uuid(),
  workspace_id uuid not null references public.workspaces(id) on delete cascade,
  name text not null,
  start_weight numeric,
  goal_weight numeric,
  calories integer,
  protein integer,
  plan text not null default 'PPL' check (plan in ('PPL','TL')),
  created_at timestamptz not null default now()
);
create table if not exists public.workouts (
  id uuid primary key default gen_random_uuid(),
  workspace_id uuid not null references public.workspaces(id) on delete cascade,
  profile_id uuid not null references public.profiles(id) on delete cascade,
  day text not null,
  entries jsonb not null default '[]'::jsonb,
  created_at timestamptz not null default now()
);
create table if not exists public.app_settings (
  workspace_id uuid primary key references public.workspaces(id) on delete cascade,
  settings jsonb not null default '{}'::jsonb,
  updated_at timestamptz not null default now()
);

alter table public.workspaces enable row level security;
alter table public.profiles enable row level security;
alter table public.workouts enable row level security;
alter table public.app_settings enable row level security;

drop policy if exists "workspace owner access" on public.workspaces;
create policy "workspace owner access" on public.workspaces
for all using (owner_id = auth.uid()) with check (owner_id = auth.uid());

create or replace function public.owns_workspace(wid uuid)
returns boolean language sql security definer stable set search_path = public
as $$ select exists(select 1 from public.workspaces w where w.id = wid and w.owner_id = auth.uid()); $$;
revoke all on function public.owns_workspace(uuid) from public;
grant execute on function public.owns_workspace(uuid) to authenticated;

drop policy if exists "profiles owner access" on public.profiles;
create policy "profiles owner access" on public.profiles
for all using (public.owns_workspace(workspace_id)) with check (public.owns_workspace(workspace_id));

drop policy if exists "workouts owner access" on public.workouts;
create policy "workouts owner access" on public.workouts
for all using (public.owns_workspace(workspace_id)) with check (public.owns_workspace(workspace_id));

drop policy if exists "settings owner access" on public.app_settings;
create policy "settings owner access" on public.app_settings
for all using (public.owns_workspace(workspace_id)) with check (public.owns_workspace(workspace_id));

grant usage on schema public to authenticated;
grant select, insert, update, delete on public.workspaces, public.profiles, public.workouts, public.app_settings to authenticated;
