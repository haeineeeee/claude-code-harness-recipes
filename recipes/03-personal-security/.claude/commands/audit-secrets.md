---
description: 최근 secrets-audit.log 기록을 요약해 시크릿 접근 시도 패턴을 분석합니다
---

다음을 수행하세요:

1. `~/.claude/logs/secrets-audit.log` 파일 존재 확인 (없으면 "아직 기록 없음" 안내)
2. 마지막 50줄 추출 (`tail -50`)
3. 다음 4개 카테고리로 분류해 카운트:
   - Bash (출력 명령)
   - Bash (전송 명령)
   - Read/Edit (파일 접근)
   - Write (파일 쓰기)
4. 시간대별 분포도 표로:
   - 오늘
   - 어제
   - 지난 7일
5. 주의 필요 패턴 감지:
   - 같은 경로에 반복 시도 ≥ 3회 → 경보
   - .pem / id_rsa / credentials 시도 한 번이라도 있으면 경보
6. 결과를 마크다운 표로 출력
