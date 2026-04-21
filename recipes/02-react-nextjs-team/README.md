# 02. React/Next.js 팀 하네스

**대상:** React 또는 Next.js 팀 프로젝트 (TypeScript 권장)
**해결하는 문제:**
- 포맷·린트·타입 에러가 PR 단계에 몰려 리뷰 지연
- 팀원마다 다른 설정으로 인한 코드 스타일 편차
- PR 작성·테스트·리팩토링 반복 작업의 수동 부담

**난이도:** ★★☆ (설치 15~20분, Prettier/ESLint/tsconfig 이미 설정된 프로젝트 전제)

## 구성

```
.claude/
├── settings.json                                # 팀 공통 모델·권한·훅 등록
├── hooks/
│   ├── pre-commit-check.sh                      # git commit 전 prettier+eslint+tsc
│   └── log-build-time.sh                        # next build 소요시간 로그
├── skills/
│   └── nextjs-conventions/
│       └── SKILL.md                             # Next.js App Router 규약 자동 주입
└── commands/
    ├── pr.md                                    # /pr <title> — Draft PR 생성
    ├── test-watch.md                            # /test-watch — 변경 파일 테스트만
    └── refactor-component.md                    # /refactor-component <path>
```

## 의존성 체크리스트

이 하네스는 아래 도구가 프로젝트에 설치되어 있다고 가정합니다 (없어도 훅은 해당 단계를 건너뜁니다).

| 도구 | 용도 | 감지 기준 |
|---|---|---|
| Prettier | 포맷 검증 | `npx prettier` 실행 가능 |
| ESLint | 린트 검증 | `.eslintrc.*` 또는 `eslint.config.*` 존재 |
| TypeScript | 타입 검증 | `tsconfig.json` 존재 |
| gh CLI | `/pr` 명령 | `gh auth status` 통과 상태 |

## 설치

```bash
# 1) 프로젝트 루트로 이동
cd /path/to/your-project

# 2) 전체 .claude 복사
cp -r /path/to/harness-recipes/recipes/02-react-nextjs-team/.claude .

# 3) 훅 실행 권한
chmod +x .claude/hooks/*.sh

# 4) (선택) 팀과 공유 — .gitignore 에서 .claude 제외
echo ".claude/local/" >> .gitignore    # 개인 설정만 gitignore
git add .claude
git commit -m "chore: add Claude Code team harness"
```

## 검증

| 확인 항목 | 명령·조작 | 기대 결과 |
|---|---|---|
| 훅 등록 | Claude 기동 후 settings 로드 확인 | 로그에 PreToolUse 등록 표시 |
| 포맷 게이트 | 일부러 포맷 깨뜨린 파일 커밋 시도 | "Prettier 포맷 불일치" 차단 |
| 린트 게이트 | `any` 또는 미사용 변수 커밋 시도 | "ESLint 에러" 차단 |
| 타입 게이트 | 타입 오류 커밋 시도 | "TypeScript 타입 에러" 차단 |
| Skill 자동 주입 | Claude에게 "App Router 규약대로 컴포넌트 만들어줘" 요청 | 서버 컴포넌트 기본 준수 |
| /pr 명령 | `/pr feat: add search` 입력 | Draft PR URL 반환 |
| /test-watch | `/test-watch` 입력 | 변경 파일 테스트만 watch 실행 |

## 커스터마이징

### 포맷 검증 제외 파일

훅 내부의 STAGED 필터링 부분에 `grep -v` 추가:

```bash
STAGED=$(git diff --cached --name-only --diff-filter=ACM \
  | grep -E '\.(ts|tsx|js|jsx|mjs|cjs)$' \
  | grep -v '^generated/' || true)
```

### 베이스 브랜치 변경 (`/pr`)

`commands/pr.md` 의 "베이스 브랜치(main 또는 develop)" 문장을 고정값으로.

### 모델 교체

더 빠른 응답이 필요하면 `settings.json` 의 `model` 을 `claude-haiku-4-5-20251001` 로.
더 정교한 리팩토링이 필요하면 `claude-opus-4-6`.

## 관련 블로그 글

- [하네스 설계 입문 — 레이어 구조와 선택 기준](https://claudeheadlines.com/2026/04/21/claude-code-harness-design-intro-2026/)
- [React/Next.js 팀 하네스 — 포맷·린트·PR 자동화 실전 설계](https://claudeheadlines.com/claude-code-react-nextjs-team-harness-2026/) (발행 후 링크 업데이트)

## 라이선스

MIT — 자유 사용·수정·재배포.
