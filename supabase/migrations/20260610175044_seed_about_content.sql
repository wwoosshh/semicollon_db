-- 소개 페이지 콘텐츠(연혁/운영진/FAQ)를 settings에 시드한다.
-- 이후 갱신은 관리자 페이지(PATCH /admin/settings/about)에서 이루어진다.
insert into public.settings (key, value) values
  (
    'about_history',
    '[
      {"year": "2026.06", "title": "동아리 창립"},
      {"year": "2026.06", "title": "1기 부원 모집"}
    ]'::jsonb
  ),
  ('about_staff', '[]'::jsonb),
  (
    'about_faq',
    '[
      {"q": "비전공자도 지원할 수 있나요?", "a": "네. 전공과 무관하게 코드를 배우고 싶은 분이라면 누구나 환영합니다."},
      {"q": "활동은 언제, 얼마나 자주 하나요?", "a": "정기 모임은 주 1회이며, 스터디와 프로젝트 일정은 팀별로 조율합니다."},
      {"q": "회비가 있나요?", "a": "운영에 필요한 최소한의 회비를 학기 초에 안내합니다."},
      {"q": "무엇을 준비해야 하나요?", "a": "노트북 한 대면 충분합니다. 나머지는 함께 채워 갑니다."}
    ]'::jsonb
  )
on conflict (key) do nothing;
