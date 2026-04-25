# /mcp-rotate — MCP 크리덴셜 교체 가이드

MCP 서버 토큰을 안전하게 교체하는 절차를 안내합니다.

## 수행 절차

1. 사용자에게 교체할 서버를 질문 (slack / notion / github / all)
2. 선택된 서버별로 토큰 재발급 절차 안내
3. 교체 후 /mcp-test 실행을 권장
4. .claude/mcp-audit.jsonl에 교체 이벤트 기록

## 주의사항
- 이전 토큰은 즉시 revoke할 것
- 토큰을 코드나 settings.json에 하드코딩하지 않는다
- 환경변수 또는 .env 파일(gitignore 등록)로만 관리
