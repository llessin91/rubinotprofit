-- Gold Ledger: execute este script no SQL Editor do Supabase.
-- Cada linha pertence ao usuário autenticado. RLS impede acesso cruzado entre contas.
create table if not exists public.gold_entries (
  id uuid primary key default gen_random_uuid(),
  user_id uuid not null references auth.users(id) on delete cascade,
  amount_gp bigint not null check (amount_gp >= 0),
  entry_date date not null,
  created_at timestamptz not null default now(),
  unique (user_id, entry_date)
);

create table if not exists public.gold_goals (
  id uuid primary key default gen_random_uuid(),
  user_id uuid not null references auth.users(id) on delete cascade,
  name text,
  target_gp bigint not null check (target_gp > 0),
  status text not null default 'active' check (status in ('active','completed')),
  created_at timestamptz not null default now(),
  completed_at timestamptz
);

create unique index if not exists gold_goals_one_active_per_user
  on public.gold_goals(user_id) where status = 'active';

alter table public.gold_entries enable row level security;
alter table public.gold_goals enable row level security;

drop policy if exists "Read own gold entries" on public.gold_entries;
create policy "Read own gold entries" on public.gold_entries
  for select to authenticated using (auth.uid() = user_id);
drop policy if exists "Insert own gold entries" on public.gold_entries;
create policy "Insert own gold entries" on public.gold_entries
  for insert to authenticated with check (auth.uid() = user_id);
drop policy if exists "Update own gold entries" on public.gold_entries;
create policy "Update own gold entries" on public.gold_entries
  for update to authenticated using (auth.uid() = user_id) with check (auth.uid() = user_id);
drop policy if exists "Delete own gold entries" on public.gold_entries;
create policy "Delete own gold entries" on public.gold_entries
  for delete to authenticated using (auth.uid() = user_id);

drop policy if exists "Read own gold goals" on public.gold_goals;
create policy "Read own gold goals" on public.gold_goals
  for select to authenticated using (auth.uid() = user_id);
drop policy if exists "Insert own gold goals" on public.gold_goals;
create policy "Insert own gold goals" on public.gold_goals
  for insert to authenticated with check (auth.uid() = user_id);
drop policy if exists "Update own gold goals" on public.gold_goals;
create policy "Update own gold goals" on public.gold_goals
  for update to authenticated using (auth.uid() = user_id) with check (auth.uid() = user_id);
drop policy if exists "Delete own gold goals" on public.gold_goals;
create policy "Delete own gold goals" on public.gold_goals
  for delete to authenticated using (auth.uid() = user_id);

grant select, insert, update, delete on public.gold_entries to authenticated;
grant select, insert, update, delete on public.gold_goals to authenticated;
