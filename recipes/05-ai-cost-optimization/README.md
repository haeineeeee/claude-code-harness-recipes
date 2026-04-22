# Recipe 05 — AI 비용 최적화 하네스

> PreToolUse·PostToolUse 훅으로 Claude Code 세션의 토큰·USD 비용을 자동 추적하고 한도를 초과하면 도구 실행을 차단하는 하네스.

## 대상

- Claude Code를 업무에 본격 도입했지만 비용이 예측 불가능한 팀
- 세션 단위 예산 한도를 걸어 과금 폭주를 방지하고 싶은 개인·프리랜서
- 도구별 비용 분포를 파악해 워크플로를 최적화하려는 엔지니어

## 해결하는 문제

| 문제 | 이 하네스의 해결 |
|---|---|
| 세션 비용을 모르고 지나감 | PostToolUse 훅이 매 호출마다 자동 기록 |
| 예산 초과 시 대응이 늦음 | PreToolUse 게이트가 한도 초과 시 즉시 차단 |
| 어떤 도구가 비용을 많이 쓰는지 모름 | 원장(cost-ledger.json)에 도구별 통계 누적 |
| 비용 리포트를 수동으로 만들어야 함 | /cost-report 명령으로 분석 마크다운 자동 생성 |

## 구성

```
.claude/
├── settings.json            # PreToolUse·PostToolUse 훅 등록
├── hooks/
│   ├── cost-gate.sh         # PreToolUse — 한도 초과 시 차단
│   └── token-tracker.sh     # PostToolUse — 비용 누적 기록
├── skills/
│   └── cost-dashboard/
│       └── SKILL.md         # "비용 현황" 트리거 → 대시보드 출력
└── commands/
    ├── cost-status.md       # /cost-status — 현황 조회
    ├── cost-reset.md        # /cost-reset — 카운터 초기화
    └── cost-report.md       # /cost-report — 분석 리포트 생성
```

## 설치

```bash
# 방법 1: ZIP 다운로드 → 복사
curl -sL https://github.com/haeineeeee/claude-code-harness-recipes/releases/download/v05-ai-cost-optimization/harness-05-ai-cost-optimization.zip -o h.zip \
  && unzip h.zip \
  && cp -r recipes/05-ai-cost-optimization/.claude . \
  && chmod +x .claude/hooks/*.sh \
  && rm -rf h.zip recipes

# 방법 2: Git clone
git clone https://github.com/haeineeeee/claude-code-harness-recipes.git
cp -r claude-code-harness-recipes/recipes/05-ai-cost-optimization/.claude .
chmod +x .claude/hooks/*.sh
```

## 환경변수

| 변수 | 기본값 | 설명 |
|---|---|---|
| `COST_LIMIT_USD` | `5.00` | 세션 비용 한도 (USD) |
| `COST_FILE` | `.claude/cost-ledger.json` | 원장 파일 경로 |
| `COST_LOG` | `.claude/cost-log.jsonl` | 호출 로그 파일 경로 |

## 검증

| 확인 | 명령 | 기대 |
|---|---|---|
| 훅 등록 | `cat .claude/settings.json \| jq '.hooks'` | PreToolUse·PostToolUse 각 1개 |
| 실행 권한 | `ls -la .claude/hooks/*.sh` | `-rwxr-xr-x` |
| 비용 추적 | 도구 1회 사용 후 `cat .claude/cost-ledger.json` | `total_usd > 0` |
| 차단 테스트 | `COST_LIMIT_USD=0.001` 설정 후 도구 실행 | block 메시지 출력 |

## 커스터마이징

| 상황 | 변경 |
|---|---|
| 한도를 $20로 올리기 | `COST_LIMIT_USD=20.00` 환경변수 설정 |
| Agent만 추적하기 | `settings.json`의 PostToolUse matcher를 `"Agent"`로 변경 |
| 경고 임계값 변경 | `cost-gate.sh`의 `0.8`을 원하는 비율로 수정 |
| Slack 알림 연동 | `cost-gate.sh` 차단 분기에 `curl` Slack webhook 추가 |
