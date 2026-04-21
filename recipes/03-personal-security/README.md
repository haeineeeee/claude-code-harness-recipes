# 03. 개인 보안 하네스 — 시크릿 접근 차단

**대상:** 개인 개발자 / 솔로 프로젝트 / 시크릿 관리 첫 단추가 필요한 팀
**해결하는 문제:**
- Claude Code가 실수로 `.env`·SSH 키·credentials 파일을 읽거나 출력
- 비밀 값이 외부 HTTP 요청에 포함되어 유출
- 환경변수 전체 덤프(`env`·`printenv`)로 의도치 않은 노출

**난이도:** ★★☆ (설치 10분, 검증 포함 20분)

## 3중 방어 구조

| 레이어 | 파일 | 역할 |
|---|---|---|
| 1. 선언적 차단 | `settings.json` `permissions.deny` | Claude가 요청 단계에서 즉시 거부 |
| 2. 동적 가드 | `hooks/guard-secrets.sh` | PreToolUse에서 명령·경로 패턴 정밀 검사 |
| 3. 감사 로그 | `hooks/audit-log.sh` | PostToolUse에서 접근 시도 기록 |
| 보조. 규약 주입 | `skills/secret-handling-patterns/SKILL.md` | "시크릿"·"token" 등 키워드 감지 시 안전 패턴 안내 |

## 구성

```
.claude/
├── settings.json                                    # permissions.deny + 훅 등록
├── hooks/
│   ├── guard-secrets.sh                             # PreToolUse 가드
│   └── audit-log.sh                                 # PostToolUse 로깅
├── skills/
│   └── secret-handling-patterns/SKILL.md            # 안전 패턴 규약
└── commands/
    ├── load-env.md                                  # /load-env <KEY> — 단일 키 마스킹 조회
    └── audit-secrets.md                             # /audit-secrets — 로그 요약
```

## 설치

```bash
cp -r recipes/03-personal-security/.claude /path/to/your-project/
chmod +x /path/to/your-project/.claude/hooks/*.sh
mkdir -p ~/.claude/logs   # 감사 로그 저장 경로 (없으면 훅이 자동 생성)
```

## 검증

| 확인 항목 | 명령·조작 | 기대 결과 |
|---|---|---|
| 설정 로드 | `claude` 기동 후 로그 | permissions·hooks 등록 표시 |
| 선언적 차단 | Claude에 "`.env` 파일 읽어줘" | "Read(.env)가 deny 목록에 있어 거부" |
| 훅 2차 차단 (Bash) | Claude에 "`cat .env` 실행해줘" | "민감 파일 내용 출력 차단" 사유 반환 |
| 예외 허용 | Claude에 "`.env.example` 읽어줘" | 정상 읽기 |
| 환경 덤프 차단 | Claude에 "`env` 실행해줘" | "전체 환경변수 덤프 차단" |
| Slash 명령 | `/load-env DATABASE_URL` | 마스킹된 값 출력 |
| 감사 로그 | `/audit-secrets` | 최근 시도 요약 표 |

## 커스터마이징

### 추가로 차단할 파일 유형
`settings.json` 의 `permissions.deny` 에 Glob 추가 + 훅 `is_sensitive_path()` 함수에 패턴 추가.

### 팀 공용 엔터프라이즈 설정
macOS: `/Library/Application Support/ClaudeCode/managed-settings.json` 에 배치하면 모든 사용자에 적용 (관리자 권한 필요).

### 회전 일정 자동화
`/audit-secrets` 명령에 "90일 이상 미회전 키 플래그" 로직 추가 (Slash command 파일 수정).

## 관련 블로그 글

- [하네스 설계 입문 — 레이어 구조와 선택 기준](https://claudeheadlines.com/2026/04/21/claude-code-harness-design-intro-2026/)
- [React·Next.js 팀 하네스](https://claudeheadlines.com/2026/04/21/claude-code-react-nextjs-team-harness-2026/)
- 개인 보안 하네스 (발행 후 업데이트)

## 라이선스

MIT — 자유 사용·수정·재배포.
