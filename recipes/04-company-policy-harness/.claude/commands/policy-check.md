---
description: 정책 준수 상태를 빠르게 확인하는 요약 보고
---

현재 프로젝트의 `.claude/` 하네스 정책 준수 상태를 점검하세요.

1. `permissions.deny`에 필수 차단 패턴 5개 포함 확인
2. `.claude/hooks/` 내 3개 훅 파일 존재·실행 권한 확인
3. `.claude/audit.jsonl` 최근 10개 항목 요약
4. `.claude/cost-counter.json` 현재 사용량 보고

결과를 마크다운 테이블로 정리해서 보여주세요.
