# Recipe 06 — 개인 Skills 라이브러리 구축

> 자주 쓰는 작업을 SKILL.md로 체계화하고, PreToolUse 훅으로 검증하고, PostToolUse 훅으로 사용 통계를 자동 수집하는 하네스.

## 대상

- 반복 작업을 Claude Code 스킬로 표준화하고 싶은 개인 개발자
- 팀에서 공통 스킬 라이브러리를 구축·공유하려는 리드 엔지니어
- 스킬 사용 패턴을 데이터로 파악해 워크플로를 최적화하려는 팀

## 해결하는 문제

| 문제 | 이 하네스의 해결 |
|---|---|
| 같은 작업을 매번 프롬프트로 설명 | SKILL.md에 한 번 정의하면 트리거 키워드로 자동 활성화 |
| 등록되지 않은 스킬 호출 시 혼란 | PreToolUse 훅이 SKILL.md 존재·필수 섹션 자동 검증 |
| 어떤 스킬을 얼마나 쓰는지 모름 | PostToolUse 훅이 호출마다 JSONL 로그 누적 |
| 스킬 관리가 수동·산발적 | /skill-list, /skill-new, /skill-stats 명령으로 체계화 |

## 구성

```
.claude/
├── settings.json              # PreToolUse·PostToolUse 훅 등록
├── hooks/
│   ├── skill-validator.sh     # PreToolUse — SKILL.md 존재·섹션 검증
│   └── skill-logger.sh        # PostToolUse — 호출 기록 JSONL 누적
├── skills/
│   └── skill-manager/
│       └── SKILL.md           # 스킬 라이브러리 관리 메타 스킬
└── commands/
    ├── skill-list.md          # /skill-list — 등록 스킬 목록
    ├── skill-new.md           # /skill-new — 새 스킬 등록 위자드
    └── skill-stats.md         # /skill-stats — 사용 통계 리포트
```

## 설치

```bash
# 방법 1: ZIP 다운로드
curl -sL https://github.com/haeineeeee/claude-code-harness-recipes/releases/download/v06-skills-library/harness-06-skills-library.zip -o h.zip \
  && unzip h.zip \
  && cp -r recipes/06-skills-library/.claude . \
  && chmod +x .claude/hooks/*.sh \
  && rm -rf h.zip recipes

# 방법 2: Git clone
git clone https://github.com/haeineeeee/claude-code-harness-recipes.git
cp -r claude-code-harness-recipes/recipes/06-skills-library/.claude .
chmod +x .claude/hooks/*.sh
```

## 검증

| 확인 | 명령 | 기대 |
|---|---|---|
| 훅 등록 | `cat .claude/settings.json | jq '.hooks'` | PreToolUse·PostToolUse 각 1개 |
| 실행 권한 | `ls -la .claude/hooks/*.sh` | `-rwxr-xr-x` |
| 스킬 목록 | `/skill-list` 실행 | skill-manager 1개 표시 |
| 검증 훅 | 미등록 스킬 호출 시도 | block 메시지 출력 |
| 로깅 | 스킬 1회 사용 후 `cat .claude/skill-usage.jsonl` | 1행 JSON 기록 |

## 커스터마이징

| 상황 | 변경 |
|---|---|
| 검증 없이 모든 스킬 허용 | settings.json에서 PreToolUse 훅 제거 |
| 로그를 외부 저장소로 전송 | skill-logger.sh에 curl 전송 로직 추가 |
| 팀 공유 스킬 동기화 | .claude/skills/를 Git 서브모듈로 관리 |
| 특정 스킬만 추적 | skill-logger.sh에 스킬 이름 필터 조건 추가 |
