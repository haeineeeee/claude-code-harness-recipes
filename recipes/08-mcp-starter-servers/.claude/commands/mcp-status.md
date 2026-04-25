# /mcp-status — MCP 서버 상태 요약

등록된 MCP 서버 3개(Slack, Notion, GitHub)의 현재 상태를 한눈에 보여줍니다.

## 수행 절차

1. `.claude/settings.json`의 `mcpServers` 키를 읽어 등록된 서버 목록 확인
2. 각 서버의 환경변수 설정 여부 확인 (값은 출력하지 않음)
3. `.claude/mcp-audit.jsonl`에서 최근 24시간 호출 통계 집계
4. 결과를 표 형식으로 출력

## 주의사항
- 토큰 값은 절대 노출하지 않는다
- 감사 로그가 없으면 "로그 없음"으로 표시
