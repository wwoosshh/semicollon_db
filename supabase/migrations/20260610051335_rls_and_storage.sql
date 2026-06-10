-- 모든 테이블 RLS 활성화, 정책 없음 = anon/authenticated의 PostgREST 접근 전면 차단.
-- 데이터 접근은 백엔드(직접 Postgres 연결)로만 이루어진다.
alter table public.profiles enable row level security;
alter table public.posts enable row level security;
alter table public.activities enable row level security;
alter table public.applications enable row level security;
alter table public.settings enable row level security;

-- 이미지 버킷: 공개 읽기(URL로 이미지 표시), 쓰기는 service_role(백엔드)만 가능
-- storage.objects에 정책을 추가하지 않는 이유:
--   읽기는 public bucket CDN 경로(/storage/v1/object/public/...)가 RLS와 무관하게 동작하므로 불필요.
--   쓰기는 기본 deny-all RLS가 적용되어 anon 업로드가 차단된다. 절대 anon 쓰기 정책을 추가하지 말 것.
insert into storage.buckets (id, name, public)
values ('images', 'images', true)
on conflict (id) do nothing;
