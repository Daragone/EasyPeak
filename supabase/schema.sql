-- Enable UUID extension
create extension if not exists "uuid-ossp";

-- 1. Tabela de Níveis (Pré-A1 a C2)
create table public.levels (
    id integer primary key,
    name text not null,
    description text
);

-- Popula os níveis iniciais
insert into public.levels (id, name, description) values
(1, 'Pré-A1 - Básico', 'Primeiro contato com o idioma'),
(2, 'A1.1 - Iniciante', 'Início da jornada'),
(3, 'A1.2 - Iniciante II', 'Consolidando a base'),
(4, 'A2.1 - Elementar', 'Começando a se expressar'),
(5, 'A2.2 - Elementar II', 'Conversações simples'),
(6, 'B1.1 - Intermediário', 'Maior independência'),
(7, 'B1.2 - Intermediário II', 'Fluência em situações cotidianas'),
(8, 'B2.1 - Intermediário Superior', 'Comunicação confiante'),
(9, 'B2.2 - Superior II', 'Linguagem mais complexa'),
(10, 'C1.1 - Avançado', 'Proficiência quase nativa'),
(11, 'C1.2 - Avançado II', 'Domínio acadêmico e profissional'),
(12, 'C2 - Proficiente', 'Maestria no idioma');

-- 2. Tabela pública de Usuários (Extensão de auth.users)
create table public.users (
    id uuid primary key references auth.users(id) on delete cascade,
    name text,
    email text unique not null,
    role text default 'student' check (role in ('student', 'teacher', 'admin')),
    created_at timestamp with time zone default now()
);

-- 3. Tabela de Perfil do Estudante (Gamificação)
create table public.student_profiles (
    user_id uuid primary key references public.users(id) on delete cascade,
    xp integer default 0,
    streak_days integer default 0,
    last_login_date timestamp with time zone default now(),
    current_level_id integer references public.levels(id) default 1
);

-- 4. Tabela de Lições
create table public.lessons (
    id uuid primary key default uuid_generate_v4(),
    level_id integer references public.levels(id) on delete cascade,
    title text not null,
    order_index integer not null,
    xp_reward integer default 10
);

-- 5. Progresso do Estudante (Quais lições já completou)
create table public.student_progress (
    id uuid primary key default uuid_generate_v4(),
    user_id uuid references public.users(id) on delete cascade,
    lesson_id uuid references public.lessons(id) on delete cascade,
    score integer default 0,
    completed_at timestamp with time zone default now(),
    unique(user_id, lesson_id)
);

-- =========================================================================
-- FUNÇÕES E TRIGGERS PARA AUTOMAÇÃO DE CADASTRO
-- =========================================================================

-- Função para criar os perfis automaticamente quando usuário nascer no Auth
create or replace function public.handle_new_user()
returns trigger as $$
begin
  -- Insere na tabela public.users
  insert into public.users (id, email, name, role)
  values (new.id, new.email, new.raw_user_meta_data->>'name', 'student');

  -- Insere na tabela student_profiles o perfil vazio de gamificação
  insert into public.student_profiles (user_id, xp, streak_days, current_level_id)
  values (new.id, 0, 0, 1);

  return new;
end;
$$ language plpgsql security definer;

-- Trigger atrelada à tabela auth.users secreta do supabase
create trigger on_auth_user_created
  after insert on auth.users
  for each row execute procedure public.handle_new_user();

-- =========================================================================
-- CONFIGURAÇÕES DE RLS (Row Level Security)
-- =========================================================================

alter table public.levels enable row level security;
alter table public.users enable row level security;
alter table public.student_profiles enable row level security;
alter table public.lessons enable row level security;
alter table public.student_progress enable row level security;

-- Níveis são lidos por todos
create policy "Levels are visible to everyone" on public.levels for select using (true);

-- Lições são lidas por todos
create policy "Lessons are visible to everyone" on public.lessons for select using (true);

-- Usuários leem seus próprios dados
create policy "Users can view own data" on public.users for select using (auth.uid() = id);

-- Perfil de estudante: visível apenas pro dono
create policy "Students can view own profile" on public.student_profiles for select using (auth.uid() = user_id);
create policy "Students can update own profile" on public.student_profiles for update using (auth.uid() = user_id);

-- Progresso do estudante: visível pro dono
create policy "Students can view own progress" on public.student_progress for select using (auth.uid() = user_id);
create policy "Students can update own progress" on public.student_progress for all using (auth.uid() = user_id);
