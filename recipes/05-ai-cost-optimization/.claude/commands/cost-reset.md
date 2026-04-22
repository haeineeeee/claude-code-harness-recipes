# /cost-reset — 비용 카운터 초기화

비용 추적 카운터를 초기화합니다.

1. `.claude/cost-ledger.json`의 현재 값을 `.claude/cost-ledger.bak.json`에 백업
2. 원장을 초기 상태로 리셋
3. `.claude/cost-log.jsonl`은 유지 (이력 보존)
4. 리셋 완료 메시지와 함께 이전 누적 비용을 안내
