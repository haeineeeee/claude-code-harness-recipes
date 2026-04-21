# 01. Intro — 5분 최소 하네스

**대상:** Claude Code 하네스를 처음 만드는 분
**해결하는 문제:** 위험한 `rm -rf` 류 명령 차단 + PR 리뷰 Slash 명령 단축키
**난이도:** ★☆☆ (10분이면 설치·검증 완료)

## 구성

```
.claude/
├── settings.json                    # 모델·권한·훅 등록
├── hooks/
│   └── block-destructive.sh         # PreToolUse: 파괴적 Bash 차단
└── commands/
    └── review-pr.md                 # /review-pr <번호> Slash 명령
```

## 설치

```bash
# 1) 이 디렉토리의 .claude/ 를 당신 프로젝트 루트에 복사
cp -r .claude /path/to/your-project/

# 2) 훅 실행 권한
chmod +x /path/to/your-project/.claude/hooks/*.sh

# 3) Claude Code 기동
cd /path/to/your-project
claude
```

## 검증

| 확인 항목 | 명령·조작 | 기대 결과 |
|---|---|---|
| CLI 설치 | `claude --version` | 버전 번호 출력 |
| 디렉토리 | `ls .claude/` | settings.json·hooks/·commands/ 확인 |
| 훅 권한 | `ls -l .claude/hooks/*.sh` | 실행 권한 `x` 포함 |
| 훅 차단 | Claude에게 `rm -rf /tmp/test` 실행 요청 | block 판정 + 사유 반환 |
| Slash 인식 | `/review-pr 123` 입력 | 리뷰 보고서 생성 시도 |

## 커스터마이징

### 모델 변경
`settings.json`의 `model` 필드 수정. 옵션:
- `claude-sonnet-4-6` (기본·균형)
- `claude-opus-4-6` (고난도·복잡한 리팩토링)
- `claude-haiku-4-5-20251001` (빠른 응답·간단한 작업)

### 차단 패턴 확장
`hooks/block-destructive.sh`의 `grep -qE` 정규식에 패턴 추가.
예: `git push --force`, `drop database`, `chmod 777` 등.

### Slash 명령 추가
`commands/` 하위에 `.md` 파일 생성. frontmatter `description` 필수.

## 설계 원리

- **최소성** — 가장 흔한 사고(위험 명령) 방지와 가장 흔한 반복 작업(PR 리뷰) 단축만
- **가시성** — 훅은 block 판정 시 사유 문자열 반환 (Claude UI에 노출)
- **분리성** — 파괴 방지 훅과 리뷰 명령은 서로 독립, 한쪽 고장 시 다른 쪽 영향 없음
- **가역성** — `rm -rf .claude` 로 원복 (이건 안전한 `rm -rf` 예)
- **이식성** — `${HOME}` 외 고정 경로 없음

## 관련 블로그 글

- [Claude Code 하네스 설계 입문 — 레이어 구조와 선택 기준](https://claudeheadlines.com/claude-code-harness-design-intro-2026/) — 이 레시피의 이론적 배경
- [15강. Slash 명령 완전 활용](https://claudeheadlines.com/2026/04/14/claude-code-slash-commands-complete-2026/)
- [16강. Hooks 완벽 가이드](https://claudeheadlines.com/2026/04/14/claude-code-hooks-complete-guide-2026/)

## 라이선스

MIT — 자유 사용·수정·재배포.
