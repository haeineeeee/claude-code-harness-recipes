# /cmd-new — 새 Slash 명령 등록

새로운 Slash 명령을 `.claude/commands/`에 등록합니다.

## 절차

1. 사용자에게 명령 이름(영문 kebab-case) 입력 요청
2. 명령 목적·트리거 상황 확인
3. 현재 등록 수 확인 — 10개 초과 시 경고 후 기존 명령 통합 제안
4. `.claude/commands/<name>.md` 생성:
   - `# /<name> — 한줄 설명`
   - 절차 섹션 (단계별)
   - 출력 형식 섹션
5. 등록 완료 메시지 출력

## 네이밍 규칙

- kebab-case (예: deploy-preview, test-api)
- 동사-목적어 패턴 우선 (예: run-tests, check-deps)
- 3단어 이하 권장
