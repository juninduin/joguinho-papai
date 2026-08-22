-- ============================================================
-- Diário do Dia a Dia — schema inicial do banco
-- Cole este script inteiro no SQL Editor do Supabase (painel do
-- projeto > SQL Editor > New query) e clique em "Run".
-- ============================================================

create table if not exists profiles (
  device_id uuid primary key default gen_random_uuid(),
  nome text,
  idade text,
  tema text default 'coral',
  bichinho text,
  bichinho_nome text,
  pai text,
  mae text,
  estrelas_total integer not null default 0,
  quebra_grid integer not null default 2,
  quebra_imagem text,
  quebra_resolvidos_total integer not null default 0,
  criado_em timestamptz not null default now(),
  atualizado_em timestamptz not null default now()
);

create table if not exists rotina_dias (
  id bigint generated always as identity primary key,
  device_id uuid not null references profiles(device_id) on delete cascade,
  data date not null,
  itens_concluidos jsonb not null default '{}'::jsonb,
  estrela_premiada boolean not null default false,
  atualizado_em timestamptz not null default now(),
  unique (device_id, data)
);

create table if not exists emocoes_diario (
  id bigint generated always as identity primary key,
  device_id uuid not null references profiles(device_id) on delete cascade,
  data date not null,
  criado_em timestamptz not null default now(),
  emocao_emoji text,
  emocao_label text,
  reacao text,
  solucao text
);

-- Row Level Security: cada aparelho só enxerga e só grava os próprios dados.
-- auth.uid() vem do login anônimo do Supabase (não é um dado que o
-- navegador possa forjar, então isso protege de verdade).
alter table profiles enable row level security;
alter table rotina_dias enable row level security;
alter table emocoes_diario enable row level security;

create policy "profiles: dono ve" on profiles
  for select using (auth.uid() = device_id);
create policy "profiles: dono cria" on profiles
  for insert with check (auth.uid() = device_id);
create policy "profiles: dono atualiza" on profiles
  for update using (auth.uid() = device_id);

create policy "rotina: dono ve" on rotina_dias
  for select using (auth.uid() = device_id);
create policy "rotina: dono cria" on rotina_dias
  for insert with check (auth.uid() = device_id);
create policy "rotina: dono atualiza" on rotina_dias
  for update using (auth.uid() = device_id);

create policy "emocoes: dono ve" on emocoes_diario
  for select using (auth.uid() = device_id);
create policy "emocoes: dono cria" on emocoes_diario
  for insert with check (auth.uid() = device_id);
