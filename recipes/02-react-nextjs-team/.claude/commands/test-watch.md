---
description: 수정된 파일의 테스트만 watch 모드로 실행합니다 (Jest / Vitest 자동 감지)
---

다음을 수행하세요:

1. `git diff --name-only HEAD` 로 수정된 파일 수집
2. 각 파일에 대응하는 테스트 파일 찾기 (같은 경로의 `*.test.ts(x)` / `*.spec.ts(x)`, 또는 `__tests__/` 하위)
3. 패키지 매니저·테스트 러너 감지
   - `package.json` 의 `scripts.test` 읽어 러너 결정 (jest / vitest)
   - lockfile 로 매니저 결정 (pnpm-lock / yarn.lock / package-lock)
4. 실행 명령 구성
   - Jest: `npx jest --watch --findRelatedTests <파일>`
   - Vitest: `npx vitest watch <파일>`
5. 사용자에게 구성된 명령을 먼저 보여주고 확인 받은 뒤 실행
