-- 부원 프로필: auth.users와 1:1
create table public.profiles (
  id uuid primary key references auth.users(id) on delete cascade,
  name text not null,
  generation int not null,
  role text not null default 'member' check (role in ('admin', 'member')),
  created_at timestamptz not null default now()
);

-- 통합 게시판: 공지/블로그, 공개범위 public/member
create table public.posts (
  id bigint generated always as identity primary key,
  title text not null,
  content text not null,
  category text not null check (category in ('notice', 'blog')),
  visibility text not null default 'public' check (visibility in ('public', 'member')),
  author_id uuid not null references public.profiles(id) on delete cascade,
  image_urls text[] not null default '{}',
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);

-- 활동 아카이브
create table public.activities (
  id bigint generated always as identity primary key,
  title text not null,
  description text not null,
  type text not null check (type in ('project', 'study', 'event')),
  year int not null,
  thumbnail_url text,
  tags text[] not null default '{}',
  created_at timestamptz not null default now()
);

-- 신입 지원서
create table public.applications (
  id bigint generated always as identity primary key,
  name text not null,
  contact text not null,
  answers jsonb not null,
  status text not null default 'pending' check (status in ('pending', 'accepted', 'rejected')),
  created_at timestamptz not null default now()
);

-- 사이트 설정 (키-값)
create table public.settings (
  key text primary key,
  value jsonb not null
);

-- posts.updated_at 자동 갱신
create or replace function public.set_updated_at()
returns trigger
language plpgsql
as $$
begin
  new.updated_at = now();
  return new;
end;
$$;

create trigger posts_set_updated_at
  before update on public.posts
  for each row execute function public.set_updated_at();

-- 목록 조회용 인덱스
create index posts_category_created_idx on public.posts (category, created_at desc);
create index activities_year_idx on public.activities (year desc);
create index applications_status_idx on public.applications (status);
