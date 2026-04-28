# Recipe 10 — Subagent 오케스트레이션 하네스

> Claude Code의 Agent 도구로 Explore·Plan·구현 3단계 서브에이전트 파이프라인을 구성하여, 복잡한 작업을 체계적으로 분할·병렬 처리하는 하네스입니다.

## 대상

- 복잡한 기능 구현 시 한 세션에서 탐색·설계·코딩을 반복하느라 컨텍스트가 오염되는 사용자
- 독립적인 파일 변경을 병렬로 처리하여 작업 시간을 단축하려는 팀

## 해결하는 문제

| 문제 | 이 레시피의 해법 |
|---|---|
| 탐색·설계·구현이 한 컨텍스트에 섞여 정확도 저하 | 3단계 에이전트로 관심사 분리 |
| 독립 변경을 순차 처리하여 시간 낭비 | /parallel로 병렬 에이전트 분배 |
| 서브에이전트 호출 시 prompt가 빈약하여 결과 품질 불안정 | PreToolUse 훅으로 description·prompt 길이·타입 검증 |
| 에이전트 사용 패턴을 추적할 수 없음 | PostToolUse 로그로 유형별 사용량 기록 |

## 구성

```
.claude/
├── settings.json                     # PreToolUse + PostToolUse Agent 훅 설정
├── hooks/
│   ├── validate-subagent.sh          # Agent 호출 품질 게이트 (PreToolUse)
│   └── log-subagent.sh               # Agent 사용 로그 기록 (PostToolUse)
├── skills/
│   └── orchestrator/
│       └── SKILL.md                  # 3단계 오케스트레이션 스킬
└── commands/
    ├── orchestrate.md                # /orchestrate — Explore→Plan→Implement
    ├── agents.md                     # /agents — 사용 현황 조회
    └── parallel.md                   # /parallel — 병렬 분배
```

## 설치

### 1줄 설치 (ZIP)

```bash
curl -sL https://github.com/haeineeeee/claude-code-harness-recipes/releases/download/v10-subagent-orchestration/harness-10-subagent-orchestration.zip -o h.zip && unzip h.zip && cp -r recipes/10-subagent-orchestration/.claude . && chmod +x .claude/hooks/*.sh && rm -rf h.zip recipes
```

### Git clone

```bash
git clone https://github.com/haeineeeee/claude-code-harness-recipes.git
cp -r claude-code-harness-recipes/recipes/10-subagent-orchestration/.claude .
chmod +x .claude/hooks/*.sh
```

## 검증

| 확인 항목 | 명령 | 기대 결과 |
|---|---|---|
| 설정 로드 | `cat .claude/settings.json \| jq .hooks` | PreToolUse·PostToolUse Agent 매처 확인 |
| 훅 실행권한 | `ls -la .claude/hooks/*.sh` | `-rwxr-xr-x` |
| description 검증 | Agent 호출 시 description 누락 | block + 안내 메시지 |
| prompt 길이 검증 | 30자 미만 prompt로 Agent 호출 | block + 안내 메시지 |
| 로그 기록 | Agent 정상 호출 후 | `.claude/logs/subagent-usage.log` 생성 |

## 커스터마이징

| 상황 | 변경 방법 |
|---|---|
| 허용 에이전트 타입 추가 | `validate-subagent.sh`의 `ALLOWED_TYPES` 수정 |
| prompt 최소 길이 변경 | `validate-subagent.sh`의 `30` 값 조정 |
| 로그 포맷 변경 | `log-subagent.sh`의 echo 라인 수정 |
| 특정 에이전트 타입에만 오케스트레이션 적용 | `SKILL.md`의 트리거 키워드 조정 |

## 관련 글

- [Claude Code 하네스 엔지니어링 시리즈](https://claudeheadlines.com/category/harness-engineering/)
- [Recipe 09 — Hooks vs Skills vs Slash](https://github.com/haeineeeee/claude-code-harness-recipes/tree/main/recipes/09-hooks-vs-skills-vs-slash)
