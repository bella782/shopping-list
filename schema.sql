-- Run once in Supabase: SQL Editor > New query > paste > Run

create table if not exists public.shops (
  id uuid primary key default gen_random_uuid(),
  name text not null,
  position int not null default 0,
  created_at timestamptz not null default now()
);

create table if not exists public.items (
  id uuid primary key default gen_random_uuid(),
  shop_id uuid not null references public.shops(id) on delete cascade,
  text text not null,
  done boolean not null default false,
  added_by text,
  created_at timestamptz not null default now()
);

alter table public.shops enable row level security;
alter table public.items enable row level security;

-- Link-based access: anyone with the page + key can read/write.
create policy "shops open" on public.shops for all to anon using (true) with check (true);
create policy "items open" on public.items for all to anon using (true) with check (true);

-- Live updates between the two phones
alter publication supabase_realtime add table public.shops, public.items;

insert into public.shops (name, position) values
  ('Kosher', 0), ('Supermarket', 1), ('Paperware', 2);
