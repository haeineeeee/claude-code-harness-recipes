# /cost-report — 비용 분석 리포트 생성

세션 비용 분석 리포트를 마크다운 파일로 생성합니다.

1. `.claude/cost-log.jsonl` 전체를 분석
2. 아래 항목을 포함하는 cost-report-YYYY-MM-DD.md 생성:
   - 총 비용 요약
   - 시간대별 비용 추이 (시간 단위 그룹핑)
   - 도구별 비용 비중 (상위 5개)
   - 가장 비용이 높은 호출 TOP 10
   - 비용 절감 제안 (Agent 호출 빈도가 높으면 Explore/Plan 분리 제안 등)
3. 리포트 파일 경로를 안내
