---
name: policy-audit
description: 현재 하네스의 정책 준수 상태를 진단하고 보고서를 생성합니다
triggers:
  - "정책 감사"
  - "policy audit"
  - "보안 점검"
  - "하네스 점검"
---

# 정책 감사 스킬

현재 프로젝트의 `.claude/` 하네스가 회사 정책을 올바르게 준수하는지 점검합니다.

## 점검 항목

1. **settings.json 검증** — `permissions.deny`에 필수 차단 패턴 5개 포함 여부
2. **Hook 파일 검증** — 3개 훅 파일 존재 및 실행 권한 확인
3. **감사 로그 점검** — `.claude/audit.jsonl` 존재·최근 기록·차단 이력
4. **비용 카운터 점검** — `.claude/cost-counter.json` 사용량 대비 잔여분

## 실행 절차

1. 위 4개 항목을 순서대로 점검
2. 각 항목에 PASS / WARN / FAIL 등급 부여
3. 마크다운 테이블로 요약 보고서 출력
4. FAIL 항목이 있으면 즉시 수정 방안 제시
