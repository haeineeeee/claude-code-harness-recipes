# /cost-status — 현재 비용 현황 확인

현재 세션의 AI 비용 현황을 보여주세요.

1. `.claude/cost-ledger.json`을 읽어 총 비용, 호출 횟수, 도구별 분포를 표로 정리
2. `COST_LIMIT_USD` 대비 사용률(%)을 계산
3. 80% 초과 시 경고, 100% 초과 시 차단 상태임을 안내
4. `.claude/cost-log.jsonl`에서 최근 5건의 호출 로그를 시간순으로 표시
