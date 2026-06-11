# semicollon-db

세미콜론 동아리 홈페이지의 Supabase 데이터베이스 저장소.
스키마 변경은 반드시 `supabase/migrations/`의 SQL 마이그레이션으로 관리한다.

## 설정

클론 후 최초 1회:

```
npm install
```

## 명령어

- `npx supabase migration new <name>` — 새 마이그레이션 파일 생성
- `npx supabase db push` — 원격 Supabase 프로젝트에 마이그레이션 적용
- `npx supabase migration list` — 로컬/원격 마이그레이션 상태 비교

## 테이블

| 테이블 | 용도 |
|---|---|
| `profiles` | 부원 프로필 (auth.users와 1:1, 역할: admin/member) |
| `posts` | 통합 게시판 (공지/블로그, 공개범위: public/member, 이미지 여러 장) |
| `comments` | 게시글 댓글 (작성자 탈퇴 시 댓글 보존 — author_id set null) |
| `activities` | 활동 아카이브 (프로젝트/스터디/행사, 썸네일 + 갤러리 image_urls) |
| `events` | 일정 (캘린더 — 제목/설명/장소/시작·종료 시각) |
| `applications` | 신입 지원서 |
| `settings` | 키-값 사이트 설정 (아래 표) |

### settings 키

| 키 | 값 형태 |
|---|---|
| `recruit_period` | `{"start": ISO\|null, "end": ISO\|null}` — null이면 모집 중 아님 |
| `invite_code` | 부원 가입 초대 코드 (문자열) |
| `about_history` | 연혁 `[{year, title}]` |
| `about_staff` | 운영진 `[{name, role, note?}]` |
| `about_faq` | FAQ `[{q, a}]` |

스토리지: `images` 버킷 (공개 읽기, 쓰기는 백엔드 service_role 전용, 5MB·이미지 MIME 제한)

## 보안 모델

모든 테이블은 RLS가 켜져 있고 정책이 없다 (deny-all).
데이터 접근은 전부 백엔드(NestJS, 직접 Postgres 연결)를 통해서만 이루어진다.
anon key로는 어떤 테이블도 읽을 수 없다.

## 최초 관리자 계정 만들기

1. Dashboard > Authentication > Users > **Add user** > 이메일/비밀번호 입력해 생성
2. 생성된 유저의 UUID를 복사
3. Dashboard > SQL Editor에서 실행:

```sql
insert into public.profiles (id, name, generation, role)
values ('<복사한 UUID>', '관리자이름', 1, 'admin');
```

## 초대 코드 변경

Dashboard > SQL Editor:

```sql
update public.settings set value = '"새코드"'::jsonb where key = 'invite_code';
```
