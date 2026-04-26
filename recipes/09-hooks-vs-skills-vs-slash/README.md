# Recipe 09 — Hooks vs Skills vs Slash: 의사결정 플로

> Claude Code의 세 가지 자동화 메커니즘(Hooks, Skills, Slash Commands)을 **언제, 왜, 어떻게** 선택하는지 체계적으로 정리한 하네스입니다.

## 대상

- Claude Code에서 자동화를 구축하려는데 Hook·Skill·Slash 중 무엇을 써야 할지 매번 고민하는 사용자
- 팀 하네스를 설계할 때 메커니즘 간 경계를 명확히 정하고 싶은 리드

## 해결하는 문제

| 문제 | 이 레시피의 해법 |
|---|---|
| Hook으로 만들어야 할 것을 Slash로 만들어 매번 수동 실행 | 의사결정 플로우로 자동 분류 |
| Skill이 너무 많아져 트리거 충돌 | 용도별 명확한 기준 제시 |
| 어떤 자동화가 실제로 사용되는지 모름 | PostToolUse 로그로 사용량 추적 |
| 메커니즘 간 마이그레이션 방법을 모름 | /migrate 명령으로 변환 자동화 |

## 구성

```
.claude/
├── settings.json                     # PreToolUse + PostToolUse 훅 설정
├── hooks/
│   ├── classify-intent.sh            # Bash 호출 의도 분류 (PreToolUse)
│   └── log-tool-usage.sh             # 전체 도구 사용 추적 (PostToolUse)
├── skills/
│   └── decision-helper/
│       └── SKILL.md                  # 메커니즘 추천 스킬
└── commands/
    ├── decide.md                     # /decide — 메커니즘 결정
    ├── audit.md                      # /audit — 사용 현황 분석
    └── migrate.md                    # /migrate — 메커니즘 전환
```

## 설치

### 1줄 설치 (ZIP)

```bash
curl -sL https://github.com/haeineeeee/claude-code-harness-recipes/releases/download/v09-hooks-vs-skills-vs-slash/harness-09-hooks-vs-skills-vs-slash.zip -o h.zip && unzip h.zip && cp -r recipes/09-hooks-vs-skills-vs-slash/.claude . && chmod +x .claude/hooks/*.sh && rm -rf h.zip recipes
```

### Git clone

```bash
git clone https://github.com/haeineeeee/claude-code-harness-recipes.git
cp -r claude-code-harness-recipes/recipes/09-hooks-vs-skills-vs-slash/.claude .
chmod +x .claude/hooks/*.sh
```

## 검증

| 확인 항목 | 명령 | 기대 결과 |
|---|---|---|
| settings.json 로드 | `cat .claude/settings.json \| python3 -m json.tool` | JSON 파싱 성공 |
| Hook 실행 권한 | `ls -la .claude/hooks/*.sh` | `-rwx` 권한 확인 |
| /decide 작동 | Claude Code에서 `/decide "PR 리뷰 자동화"` 실행 | Hook/Skill/Slash 추천 출력 |
| /audit 작동 | 10회 이상 도구 사용 후 `/audit` 실행 | 사용량 표 출력 |
| 로그 생성 | `cat .claude/logs/intent-classification.log` | 분류 로그 확인 |

## 커스터마이징

| 상황 | 변경 포인트 |
|---|---|
| 특정 도구만 추적 | `settings.json`의 PostToolUse matcher를 `"Bash"` 등으로 한정 |
| 의도 분류 카테고리 추가 | `classify-intent.sh`의 grep 패턴에 새 카테고리 추가 |
| Skill 추천 임계값 변경 | `log-tool-usage.sh`의 `count > 20` 값 조정 |
| 팀 공유 로그 | LOG_DIR을 공유 디렉토리로 변경 |

## 관련 글

- [Claude Code 하네스 엔지니어링 시리즈](https://claudeheadlines.com/category/harness-engineering/)
- [Recipe 08 — MCP 서버 하네스](https://github.com/haeineeeee/claude-code-harness-recipes/tree/main/recipes/08-mcp-starter-servers)
