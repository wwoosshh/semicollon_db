-- 일정 (캘린더): 공개 조회, 관리자 작성
create table public.events (
  id bigint generated always as identity primary key,
  title text not null,
  description text,
  location text,
  starts_at timestamptz not null,
  ends_at timestamptz,
  created_at timestamptz not null default now()
);

create index events_starts_at_idx on public.events (starts_at);

-- 게시글 댓글: 부원 작성, 작성자 탈퇴 시 댓글은 보존
create table public.comments (
  id bigint generated always as identity primary key,
  post_id bigint not null references public.posts(id) on delete cascade,
  author_id uuid references public.profiles(id) on delete set null,
  content text not null,
  created_at timestamptz not null default now()
);

create index comments_post_id_idx on public.comments (post_id, created_at);

-- 활동에 사진 여러 장
alter table public.activities
  add column image_urls text[] not null default '{}';

-- 새 테이블도 deny-all RLS (접근은 백엔드 직접 연결로만)
alter table public.events enable row level security;
alter table public.comments enable row level security;
