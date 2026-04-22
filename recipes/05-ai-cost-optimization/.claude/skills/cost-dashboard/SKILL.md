---
name: cost-dashboard
description: 현재 세션의 AI 비용 현황을 대시보드 형태로 보여줍니다.
triggers:
  - "비용 현황"
  - "cost dashboard"
  - "얼마나 썼"
  - "cost status"
---

# 비용 대시보드

## 실행 절차

1. `.claude/cost-ledger.json` 파일을 읽는다
2. 대시보드 형식으로 총 비용, 호출 횟수, 도구별 분포, 잔여 예산을 출력한다
3. 80% 초과 시 경고 메시지를 추가한다
4. `.claude/cost-log.jsonl`에서 최근 10건의 호출 내역을 테이블로 보여준다

## 파일이 없을 때

원장 파일이 없으면 "아직 비용 추적 데이터가 없습니다. 도구를 사용하면 자동으로 기록이 시작됩니다."라고 안내한다.
