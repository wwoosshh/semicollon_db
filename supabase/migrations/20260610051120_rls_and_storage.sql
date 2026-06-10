-- 모든 테이블 RLS 활성화, 정책 없음 = anon/authenticated의 PostgREST 접근 전면 차단.
-- 데이터 접근은 백엔드(직접 Postgres 연결)로만 이루어진다.
alter table public.profiles enable row level security;
alter table public.posts enable row level security;
alter table public.activities enable row level security;
alter table public.applications enable row level security;
alter table public.settings enable row level security;

-- 이미지 버킷: 공개 읽기(URL로 이미지 표시), 쓰기는 service_role(백엔드)만 가능
insert into storage.buckets (id, name, public)
values ('images', 'images', true)
on conflict (id) do nothing;
