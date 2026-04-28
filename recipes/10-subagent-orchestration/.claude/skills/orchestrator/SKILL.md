# Subagent Orchestrator

서브에이전트 오케스트레이션을 자동으로 구성하고 실행하는 스킬입니다.

## 트리거

다음 키워드가 포함된 요청 시 자동 활성화:
- "서브에이전트", "subagent", "에이전트 분배", "병렬 에이전트"
- "탐색하고 계획해서 구현해", "explore then plan then implement"
- "3단계 에이전트", "멀티 에이전트"

## 동작 규칙

### 1단계: Explore 에이전트 (탐색)
- `subagent_type: "Explore"` 사용
- 코드베이스 구조, 관련 파일, 패턴 파악
- 결과를 200자 이내 요약으로 수집

### 2단계: Plan 에이전트 (설계)
- `subagent_type: "Plan"` 사용
- Explore 결과를 기반으로 구현 계획 수립
- 변경 대상 파일, 순서, 위험 요소 식별

### 3단계: 구현 에이전트 (실행)
- `subagent_type: "general-purpose"` 사용
- Plan 결과에 따라 실제 코드 변경 수행
- 독립적인 파일 변경은 병렬 에이전트로 분배

## 병렬 실행 가이드

```
# 독립 파일 → 병렬
Agent({ description: "Update component A", ... })
Agent({ description: "Update component B", ... })

# 의존 파일 → 순차
Agent({ description: "Create base types", ... })
→ 완료 후
Agent({ description: "Implement using types", ... })
```

## 로그 확인

실행 로그는 `.claude/logs/subagent-usage.log`에 자동 기록됩니다.
