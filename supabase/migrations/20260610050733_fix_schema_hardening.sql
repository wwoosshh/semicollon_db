-- 트리거 함수 search_path 고정 (search_path injection 방지)
create or replace function public.set_updated_at()
returns trigger
language plpgsql
set search_path = ''
as $$
begin
  new.updated_at = now();
  return new;
end;
$$;

-- 부원 탈퇴 시 게시글은 보존하고 작성자만 비운다
alter table public.posts alter column author_id drop not null;
alter table public.posts drop constraint posts_author_id_fkey;
alter table public.posts
  add constraint posts_author_id_fkey
  foreign key (author_id) references public.profiles(id) on delete set null;
