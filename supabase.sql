-- Ayuu's Piggi Bank cloud storage
-- Run this once in Supabase SQL Editor.

create table if not exists public.piggi_bank_data (
  user_id uuid primary key references auth.users(id) on delete cascade,
  entries jsonb not null default '[]'::jsonb,
  expenses jsonb not null default '[]'::jsonb,
  goals jsonb not null default '{"monthly":0,"yearly":0}'::jsonb,
  updated_at timestamptz not null default now()
);

alter table public.piggi_bank_data enable row level security;

drop policy if exists "Users can read their own Piggi Bank data" on public.piggi_bank_data;
create policy "Users can read their own Piggi Bank data"
on public.piggi_bank_data for select
to authenticated
using (auth.uid() = user_id);

drop policy if exists "Users can insert their own Piggi Bank data" on public.piggi_bank_data;
create policy "Users can insert their own Piggi Bank data"
on public.piggi_bank_data for insert
to authenticated
with check (auth.uid() = user_id);

drop policy if exists "Users can update their own Piggi Bank data" on public.piggi_bank_data;
create policy "Users can update their own Piggi Bank data"
on public.piggi_bank_data for update
to authenticated
using (auth.uid() = user_id)
with check (auth.uid() = user_id);

grant select, insert, update on public.piggi_bank_data to authenticated;
