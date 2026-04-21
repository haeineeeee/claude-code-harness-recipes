---
description: 현재 브랜치를 기반으로 GitHub Draft PR 을 생성합니다
---

PR 제목: $ARGUMENTS

다음을 순서대로 수행하세요:

1. 현재 브랜치명·베이스 브랜치(main 또는 develop) 확인
2. `git log {base}..HEAD --oneline` 으로 커밋 목록 요약
3. `git diff {base}...HEAD --stat` 으로 변경 파일·LOC 요약
4. PR 본문을 아래 템플릿으로 작성:

```markdown
## Summary
- 무엇을·왜 변경했는지 1~3 bullet

## Changes
- 주요 파일별 한 줄 요약
- 영향 범위 (UI / API / 스키마 / 성능)

## Test plan
- [ ] 로컬 `npm test` 통과
- [ ] 로컬 `npm run build` 통과
- [ ] 수동 검증 시나리오 (필요 시)

## Screenshots / Recording
UI 변경 시 첨부, 아니면 "N/A"
```

5. `gh pr create --draft --title "$ARGUMENTS" --body "<위 본문>"` 실행
6. 생성된 PR URL 출력
