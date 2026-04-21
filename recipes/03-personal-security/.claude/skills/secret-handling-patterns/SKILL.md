---
name: secret-handling-patterns
description: 비밀 값(환경변수·API 키·토큰·프라이빗 키)을 다룰 때 따라야 할 안전 패턴. 유출 사고 방지·감지·회전까지 커버
trigger:
  - "환경변수"
  - ".env"
  - "API 키"
  - "API key"
  - "시크릿"
  - "secret"
  - "token"
  - "토큰"
  - "credentials"
  - "OAuth"
  - "프라이빗 키"
  - "private key"
---

# 시크릿 안전 처리 규약

## 절대 금지 (하드 룰)

- 비밀 값을 소스 코드나 문자열 리터럴로 하드코딩
- `.env` 전체 내용을 출력·전송·로그
- 비밀 값을 Git 커밋에 포함 (pre-commit hook으로도 2중 방어)
- `console.log` / `print` / `debug` 로 비밀 값 찍기
- 에러 메시지에 비밀 값 노출 (`throw new Error(token + ' invalid')` 금지)

## 권장 패턴

| 언어·런타임 | 참조 방법 |
|---|---|
| Node.js | `process.env.VAR_NAME` 또는 `zod` 기반 env 스키마 검증 |
| Next.js | 서버 전용 변수는 prefix 없이, 클라이언트는 `NEXT_PUBLIC_*` 접두사 |
| Python | `os.environ["VAR"]` 또는 `pydantic-settings.BaseSettings` |
| Go | `os.Getenv("VAR")` + 시작 시 검증 함수 |
| Shell | 값 참조는 `"$VAR"` (큰따옴표로 word splitting 방지) |

## 템플릿 파일 규칙

- 실제 값: `.env` (gitignore 필수)
- 템플릿: `.env.example` — 모든 키를 빈 값 또는 placeholder로 나열
- 커밋 대상: `.env.example` 만

## 자동 유출 감지 정규식 (커밋 전 gitleaks 대체)

| 유형 | 패턴 |
|---|---|
| AWS Access Key | `AKIA[0-9A-Z]{16}` |
| GitHub PAT | `ghp_[A-Za-z0-9]{36}` |
| GitHub OAuth | `gho_[A-Za-z0-9]{36}` |
| Anthropic API | `sk-ant-api03-[A-Za-z0-9_-]{90,}` |
| OpenAI API | `sk-[A-Za-z0-9]{48}` |
| Stripe | `sk_(test|live)_[A-Za-z0-9]{24}` |
| Private Key | `-----BEGIN (RSA|EC|OPENSSH|PGP) PRIVATE KEY-----` |
| Generic Token | `(?i)(api[_-]?key|secret|token|password)[[:space:]]*[=:][[:space:]]*['"][A-Za-z0-9_-]{16,}['"]` |

## 유출 시 대응 플로

1. **즉시 회전** — 해당 키·토큰을 발급처(AWS IAM·GitHub·Stripe 등)에서 revoke + 재발급
2. **커밋 제거** — `git filter-repo` 또는 `BFG` 로 히스토리에서 삭제 (단순 `git push --force` 는 시리즈 1편 훅으로 차단됨 — 우회 금지)
3. **감사 로그 확인** — `~/.claude/logs/secrets-audit.log` 최근 항목 검토
4. **관련자 통지** — 팀 슬랙·보안 담당자에 사고 보고
5. **사후 점검** — 어떤 경로로 유입됐는지 분석, pre-commit 훅·git hook·CI 파이프라인 보완

## 이 레시피(시리즈 3편) 하네스가 막아주는 것

- Read/Edit/Write 도구로 `.env`, `~/.ssh/`, `*.pem`, credentials 파일 접근 시도 자동 차단
- Bash 로 위 파일 내용 출력·전송 시도 차단
- `env` / `printenv` 로 전체 환경변수 덤프 차단
- 비밀 값이 포함된 외부 HTTP 요청 차단
- 접근 시도·차단 이력 `secrets-audit.log` 에 타임스탬프 기록
