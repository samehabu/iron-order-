-- Supabase setup for the rebar ordering app
-- Run this once in the Supabase SQL Editor of your project.

create table if not exists orders (
  id text primary key,
  user_id uuid references auth.users not null,
  data jsonb not null,
  created_at timestamptz default now()
);

create table if not exists projects (
  id text primary key,
  user_id uuid references auth.users not null,
  name text not null,
  location text default '',
  created_at timestamptz default now()
);

alter table orders enable row level security;
alter table projects enable row level security;

create policy "users manage their own orders" on orders
  for all using (auth.uid() = user_id) with check (auth.uid() = user_id);

create policy "users manage their own projects" on projects
  for all using (auth.uid() = user_id) with check (auth.uid() = user_id);

-- Recommended: in Authentication > Sign In / Providers, disable "Confirm email"
-- so engineers can log in immediately after registering.
