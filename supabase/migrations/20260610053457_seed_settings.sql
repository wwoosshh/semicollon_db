-- 모집 기간: null이면 모집 중 아님. 백엔드가 이 값으로 지원서 제출을 거부한다.
insert into public.settings (key, value) values
  ('recruit_period', '{"start": null, "end": null}'::jsonb),
  ('invite_code', '"CHANGE-ME-INVITE-CODE"'::jsonb)
on conflict (key) do nothing;
