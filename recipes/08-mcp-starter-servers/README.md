# Recipe 08 — MCP 서버 하네스

> Slack·Notion·GitHub 3개 MCP 서버를 최소 설정으로 연동하고, PreToolUse 헬스체크 + PostToolUse 감사 로그로 안전하게 운영하는 하네스.

## 대상

- Claude Code에서 외부 서비스(Slack·Notion·GitHub)를 직접 다루고 싶은 개발자
- MCP 서버 설정을 처음 시도하는 팀
- 여러 MCP 서버의 인증·사용 현황을 중앙에서 관리하려는 리드

## 해결하는 문제

| 문제 | 이 하네스의 해결 |
|---|---|
| MCP 설정 파일을 어디에 어떻게 쓰는지 모름 | settings.json에 3개 서버 최소 설정 완성본 제공 |
| 토큰 미설정 상태로 도구 호출 → 에러 | PreToolUse 훅이 환경변수 누락 시 즉시 차단 |
| 어떤 MCP 도구가 언제 호출됐는지 모름 | PostToolUse 훅이 JSONL 감사 로그 자동 기록 |
| 토큰 교체 절차가 불명확 | /mcp-rotate 명령으로 서버별 교체 가이드 제공 |

## 구성

```
.claude/
├── settings.json              # 3개 MCP 서버 + PreToolUse·PostToolUse 훅
├── hooks/
│   ├── mcp-health-check.sh    # PreToolUse — 환경변수 헬스체크
│   └── mcp-audit-log.sh       # PostToolUse — 사용 감사 JSONL 로그
├── skills/
│   └── mcp-doctor/
│       └── SKILL.md           # MCP 연동 진단 스킬
└── commands/
    ├── mcp-status.md          # /mcp-status — 서버 상태 요약
    ├── mcp-test.md            # /mcp-test — 연결 테스트
    └── mcp-rotate.md          # /mcp-rotate — 크리덴셜 교체 가이드
```

## 설치

```bash
# 방법 1: ZIP 다운로드
curl -sL https://github.com/haeineeeee/claude-code-harness-recipes/releases/download/v08-mcp-starter-servers/harness-08-mcp-starter-servers.zip -o h.zip \
  && unzip h.zip \
  && cp -r recipes/08-mcp-starter-servers/.claude . \
  && chmod +x .claude/hooks/*.sh \
  && rm -rf h.zip recipes

# 방법 2: Git clone
git clone https://github.com/haeineeeee/claude-code-harness-recipes.git
cp -r claude-code-harness-recipes/recipes/08-mcp-starter-servers/.claude .
chmod +x .claude/hooks/*.sh
```

## 환경변수 설정

```bash
# Slack
export SLACK_BOT_TOKEN=xoxb-your-token
export SLACK_TEAM_ID=T0123456789

# Notion
export NOTION_API_KEY=ntn_your-token

# GitHub
export GITHUB_TOKEN=github_pat_your-token
```

## 검증

```bash
# 1. 설정 파일 확인
cat .claude/settings.json | python3 -c "import sys,json; d=json.load(sys.stdin); print(list(d['mcpServers'].keys()))"

# 2. 훅 실행 권한 확인
ls -la .claude/hooks/*.sh

# 3. MCP 연결 테스트
# Claude Code에서 /mcp-test 실행

# 4. 감사 로그 확인
cat .claude/mcp-audit.jsonl
```

## 커스터마이징

| 시나리오 | 변경 방법 |
|---|---|
| 서버 추가 (e.g. Jira) | settings.json의 mcpServers에 새 서버 블록 추가 |
| 특정 서버만 사용 | settings.json에서 불필요한 서버 블록 삭제 |
| 감사 로그 위치 변경 | mcp-audit-log.sh의 LOG_FILE 경로 수정 |
| 헬스체크 조건 추가 | mcp-health-check.sh의 case문에 조건 추가 |

## 관련 글

- [Recipe 07 — Slash 명령 설계 공식](https://github.com/haeineeeee/claude-code-harness-recipes/tree/main/recipes/07-slash-command-design)
- [Recipe 09 — Hooks vs Skills vs Slash](https://github.com/haeineeeee/claude-code-harness-recipes/tree/main/recipes/09-hooks-vs-skills-vs-slash) *(예정)*
