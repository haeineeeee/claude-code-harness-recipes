# /orchestrate — 3단계 서브에이전트 오케스트레이션

사용자의 요청을 Explore → Plan → Implement 3단계 서브에이전트 파이프라인으로 처리합니다.

## 사용법

```
/orchestrate <작업 설명>
```

## 동작

1. **Explore 단계**: `subagent_type: "Explore"`로 코드베이스를 탐색하여 관련 파일과 패턴을 파악합니다.
2. **Plan 단계**: `subagent_type: "Plan"`으로 탐색 결과를 기반으로 구현 전략을 수립합니다.
3. **Implement 단계**: `subagent_type: "general-purpose"`로 계획에 따라 실제 변경을 수행합니다.
   - 독립적인 변경은 병렬 에이전트로 분배합니다.
   - 의존성이 있는 변경은 순차적으로 처리합니다.

## 예시

```
/orchestrate 로그인 페이지에 2FA 인증 추가
/orchestrate API 응답 캐싱 레이어 구현
/orchestrate 테스트 커버리지가 낮은 모듈 개선
```
