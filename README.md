# Claude Code Harness Recipes

실무에서 바로 쓸 수 있는 **Claude Code 하네스 레시피 모음**입니다. 각 레시피는 `.claude/` 디렉토리 전체를 복붙 가능한 상태로 제공하며, 한국어 블로그 [claudeheadlines.com](https://claudeheadlines.com)의 하네스 엔지니어링 시리즈와 연결됩니다.

## 레시피 목록

| # | 레시피 | 설명 | 블로그 글 |
|---|---|---|---|
| 01 | [intro-minimum-harness](recipes/01-intro-minimum-harness/) | 5분 최소 하네스 — 위험 명령 차단 + PR 리뷰 Slash | [하네스 설계 입문](https://claudeheadlines.com/claude-code-harness-design-intro-2026/) |
| 02 | [react-nextjs-team](recipes/02-react-nextjs-team/) | 팀 하네스 — Prettier·ESLint·tsc 커밋 게이트 + PR/테스트/리팩토링 Slash | [React·Next.js 팀 하네스](https://claudeheadlines.com/2026/04/21/claude-code-react-nextjs-team-harness-2026/) |
| 03 | [personal-security](recipes/03-personal-security/) | 개인 보안 하네스 — .env·SSH 키·AWS credentials 접근 3중 방어 | [개인 보안 하네스](https://claudeheadlines.com/2026/04/22/claude-code-personal-security-harness-2026/) |

> 시리즈 진행에 따라 추가됩니다 (React 팀·보안·비용·Skills·MCP·Subagents 등).

## 설치 방법

### 방법 1 — 특정 레시피만 가져오기

```bash
# 전체 리포 클론 후 원하는 레시피만 복사
git clone https://github.com/OWNER/claude-code-harness-recipes.git
cp -r claude-code-harness-recipes/recipes/01-intro-minimum-harness/.claude ./
chmod +x .claude/hooks/*.sh
```

### 방법 2 — ZIP 릴리스로 받기

각 레시피의 GitHub Release 페이지에서 `.zip` 에셋을 다운로드해 압축 해제 후 프로젝트 루트에 배치합니다.

### 방법 3 — 스파스 체크아웃

```bash
git clone --filter=blob:none --sparse https://github.com/OWNER/claude-code-harness-recipes.git
cd claude-code-harness-recipes
git sparse-checkout set recipes/01-intro-minimum-harness
```

## 구조 규칙

모든 레시피는 아래 규약을 따릅니다.

- `recipes/NN-slug/.claude/` — 복붙하면 즉시 동작하는 완성 하네스
- `recipes/NN-slug/README.md` — 해결하는 문제·설치·검증·커스터마이징 가이드
- 모든 훅 스크립트는 실패 시 stderr에 이유 출력 (가시성 원칙)
- 환경변수·경로는 플레이스홀더로 (이식성 원칙)

## 라이선스

[MIT](LICENSE) — 자유롭게 포크·수정·재배포 가능합니다. 개선안은 PR 환영합니다.
