# Recipe 04 — 회사 정책 준수 하네스

> Bash 허용 리스트 · 비용 한도 · 감사 로그 중앙화 설계

## 대상

- Claude Code를 팀 단위로 도입하면서 보안·비용 정책을 하네스 레벨에서 강제하고 싶은 팀 리드
- AI 에이전트의 터미널 명령을 통제하고 감사 추적이 필요한 조직

## 해결하는 문제

| 문제 | 하네스 해결 |
|------|-------------|
| 위험한 Bash 명령 실행 | PreToolUse 훅이 차단 패턴 매칭으로 사전 차단 |
| 누가 뭘 실행했는지 모름 | PostToolUse 훅이 모든 도구 호출을 JSONL 감사 로그에 기록 |
| 과도한 API 비용 | PostToolUse 훅이 Bash 호출 횟수를 카운트하고 한도 초과 시 경고 |
| 정책 준수 상태 파악 어려움 | `/policy-check` 슬래시 명령으로 즉시 점검 |

## 구성

```
.claude/
├── settings.json              # 권한 deny 리스트 + 훅 연결
├── hooks/
│   ├── bash-allowlist.sh      # PreToolUse — Bash 차단 패턴 검증
│   ├── audit-log.sh           # PostToolUse — 감사 로그 기록
│   └── cost-guard.sh          # PostToolUse — 비용 카운터
├── skills/
│   └── policy-audit/SKILL.md  # "정책 감사" 트리거 스킬
└── commands/
    ├── policy-check.md        # /policy-check 슬래시 명령
    ├── audit-report.md        # /audit-report 슬래시 명령
    └── reset-counter.md       # /reset-counter 슬래시 명령
```

## 설치

```bash
# 1줄 설치
curl -sL https://github.com/haeineeeee/claude-code-harness-recipes/releases/download/v04-company-policy-harness/harness-04-company-policy-harness.zip -o h.zip && unzip h.zip && cp -r recipes/04-company-policy-harness/.claude . && chmod +x .claude/hooks/*.sh && rm -rf h.zip recipes

# 또는 Git clone
git clone https://github.com/haeineeeee/claude-code-harness-recipes.git
cp -r claude-code-harness-recipes/recipes/04-company-policy-harness/.claude .
chmod +x .claude/hooks/*.sh
```

## 검증

| 확인 항목 | 명령 | 기대 결과 |
|-----------|------|-----------|
| 차단 패턴 작동 | Claude에게 `sudo rm -rf /` 실행 요청 | "Policy violation" 차단 메시지 |
| 감사 로그 기록 | `cat .claude/audit.jsonl` | JSONL 형식 기록 확인 |
| 비용 카운터 | `cat .claude/cost-counter.json` | `bash_calls` 숫자 증가 확인 |
| 정책 점검 | `/policy-check` 실행 | PASS/WARN/FAIL 테이블 출력 |

## 커스터마이징

| 설정 | 환경변수 | 기본값 | 설명 |
|------|----------|--------|------|
| 화이트리스트 모드 | `ALLOWLIST_MODE=strict` | `open` | 허용 명령만 통과 |
| 최대 Bash 호출 | `MAX_BASH_CALLS` | `200` | 세션당 Bash 한도 |
| 경고 임계값 | `WARN_BASH_CALLS` | `150` | 경고 시작 횟수 |
| 로그 디렉터리 | `AUDIT_LOG_DIR` | `.claude` | 감사 로그 위치 |
| 카운터 파일 | `COST_COUNTER_FILE` | `.claude/cost-counter.json` | 카운터 위치 |

## 관련 글

- [Claude Code 하네스 엔지니어링 시리즈](https://claudeheadlines.com/category/harness-engineering/)
