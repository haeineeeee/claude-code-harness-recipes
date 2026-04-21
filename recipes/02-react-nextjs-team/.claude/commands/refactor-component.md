---
description: 지정한 React 컴포넌트를 분석·분할·정리합니다 (함수형 분할·상태 추출·prop 정리)
---

대상 파일: $ARGUMENTS

다음을 순서대로 수행하세요:

1. 파일 읽고 진단 테이블 생성 — LOC, hook 수, prop 수, 중첩 depth, 책임 영역 추정
2. 리팩토링 기회 2~4개 탐지, 장단점 포함해 표로 제시
   - 예: "상태 3개를 useReducer로 통합", "JSX 60줄 블록을 Subcomponent로 추출"
3. 사용자에게 어느 제안을 적용할지 선택 요청
4. 선택된 리팩토링만 실제 적용
5. 변경 후 확인:
   - `npx tsc --noEmit` 에러 없음
   - `npx eslint <파일>` 경고 없음
   - 가능하면 관련 테스트 실행
6. 변경 diff 요약 1 문단으로 보고

Next.js App Router 프로젝트라면 서버/클라이언트 경계 유지 ("use client" 지시어 오염 금지).
