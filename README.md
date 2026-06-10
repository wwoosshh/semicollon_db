# semicollon-db

세미콜론 동아리 홈페이지의 Supabase 데이터베이스 저장소.
스키마 변경은 반드시 `supabase/migrations/`의 SQL 마이그레이션으로 관리한다.

## 명령어

- `npx supabase migration new <name>` — 새 마이그레이션 파일 생성
- `npx supabase db push` — 원격 Supabase 프로젝트에 마이그레이션 적용
- `npx supabase migration list` — 로컬/원격 마이그레이션 상태 비교

## 테이블

| 테이블 | 용도 |
|---|---|
| `profiles` | 부원 프로필 (auth.users와 1:1, 역할: admin/member) |
| `posts` | 통합 게시판 (공지/블로그, 공개범위: public/member) |
| `activities` | 활동 아카이브 (프로젝트/스터디/행사) |
| `applications` | 신입 지원서 |
| `settings` | 사이트 설정 (모집 기간, 초대 코드) |

## 보안 모델

모든 테이블은 RLS가 켜져 있고 정책이 없다 (deny-all).
데이터 접근은 전부 백엔드(NestJS, 직접 Postgres 연결)를 통해서만 이루어진다.
anon key로는 어떤 테이블도 읽을 수 없다.
