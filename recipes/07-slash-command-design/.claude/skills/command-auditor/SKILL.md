---
name: command-auditor
description: Slash 명령 등록 현황 감사 및 최적화 제안
trigger: "명령 감사", "command audit", "slash audit"
---

# Command Auditor

프로젝트의 Slash 명령 등록 현황을 감사하고 최적화를 제안합니다.

## 절차

1. `.claude/commands/*.md` 의 모든 등록 명령을 목록화
2. `.claude/command-usage.jsonl` 에서 최근 30일 사용 빈도 분석
3. 미사용 명령(0회) 경고
4. 중복·유사 명령 탐지 (이름 유사도 기반)
5. 10개 초과 시 통합 제안, 5개 미만 시 추가 후보 제안

## 출력 형식

| 명령 | 설명 | 30일 사용 | 상태 |
|---|---|---|---|
| /cmd | ... | N회 | 활성/미사용/통합 후보 |

총 명령 수: X개 (권장 상한: 10개)
