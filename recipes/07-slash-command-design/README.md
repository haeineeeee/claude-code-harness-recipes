# Recipe 07 — Slash 명령 설계 공식

> 10개 이하의 Slash 명령으로 팀 전체 하네스를 통일하고, PreToolUse 훅으로 미등록 명령을 차단하고, PostToolUse 훅으로 사용 로그를 자동 수집하는 하네스.

## 대상

- Slash 명령이 늘어나 관리가 안 되는 팀
- 팀원마다 다른 명령 세트를 쓰고 있어 혼란을 겪는 조직
- 명령 사용 패턴을 데이터로 파악해 최적화하려는 리드 엔지니어

## 해결하는 문제

| 문제 | 이 하네스의 해결 |
|---|---|
| 명령이 20개 넘게 쌓여 아무도 전체를 모름 | 10개 상한 원칙 + /cmd-list로 전수 조회 |
| 미등록·오타 명령 실행 시 혼란 | PreToolUse 훅이 화이트리스트 밖 명령 즉시 차단 |
| 어떤 명령이 실제로 쓰이는지 모름 | PostToolUse 훅이 JSONL 로그 자동 누적 |
| 새 명령 등록이 일관되지 않음 | /cmd-new 위자드로 네이밍·구조 표준화 |

## 구성

```
.claude/
├── settings.json              # PreToolUse·PostToolUse 훅 등록
├── hooks/
│   ├── command-gate.sh        # PreToolUse — 화이트리스트 게이트
│   └── command-usage-log.sh   # PostToolUse — 사용 로그 JSONL 누적
├── skills/
│   └── command-auditor/
│       └── SKILL.md           # 명령 감사 및 최적화 제안 스킬
└── commands/
    ├── cmd-list.md            # /cmd-list — 등록 명령 목록
    ├── cmd-new.md             # /cmd-new — 새 명령 등록 위자드
    └── cmd-stats.md           # /cmd-stats — 사용 통계 리포트
```

## 설치

```bash
# 방법 1: ZIP 다운로드
curl -sL https://github.com/haeineeeee/claude-code-harness-recipes/releases/download/v07-slash-command-design/harness-07-slash-command-design.zip -o h.zip \
  && unzip h.zip \
  && cp -r recipes/07-slash-command-design/.claude . \
  && chmod +x .claude/hooks/*.sh \
  && rm -rf h.zip recipes

# 방법 2: Git clone
git clone https://github.com/haeineeeee/claude-code-harness-recipes.git
cp -r claude-code-harness-recipes/recipes/07-slash-command-design/.claude .
chmod +x .claude/hooks/*.sh
```

## 검증

```bash
# 1. 등록 명령 목록 확인
ls .claude/commands/*.md

# 2. 미등록 명령 차단 테스트
# Claude Code에서 등록되지 않은 /fake-cmd 실행 → BLOCKED 메시지 확인

# 3. 사용 로그 확인
cat .claude/command-usage.jsonl

# 4. 명령 감사 스킬 실행
# Claude Code에서 "명령 감사" 또는 "slash audit" 입력
```

## 커스터마이징

| 시나리오 | 변경 방법 |
|---|---|
| 명령 상한을 10 → 15로 | cmd-new.md의 "10개 초과" → "15개 초과" |
| 로그 포맷 변경 | command-usage-log.sh의 JSON 필드 수정 |
| 특정 명령 차단 제외 | command-gate.sh에 예외 배열 추가 |
| 팀 공유 | .claude/ 폴더를 프로젝트 루트에 커밋 |

## 관련 글

- [Recipe 06 — 개인 Skills 라이브러리 구축](https://github.com/haeineeeee/claude-code-harness-recipes/tree/main/recipes/06-skills-library)
- [Recipe 08 — MCP 서버 하네스](https://github.com/haeineeeee/claude-code-harness-recipes/tree/main/recipes/08-mcp-starter-servers) *(예정)*
