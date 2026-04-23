# Skill Manager

스킬 라이브러리를 관리하고, 새 스킬을 등록하고, 기존 스킬 목록을 조회하는 스킬.

## 트리거

- "스킬 목록", "skill list", "registered skills"
- "새 스킬 등록", "register skill", "add skill"
- "스킬 사용 통계", "skill usage", "skill stats"

## 동작

### 스킬 목록 조회
1. `.claude/skills/` 디렉토리를 탐색하여 모든 `SKILL.md` 파일을 찾는다
2. 각 스킬의 이름, 트리거 키워드, 설명을 테이블로 출력한다

### 새 스킬 등록
1. 스킬 이름과 목적을 사용자에게 확인한다
2. `.claude/skills/<name>/SKILL.md` 파일을 표준 템플릿으로 생성한다
3. 생성 후 `skill-validator.sh` 훅이 자동으로 필수 섹션을 검증한다

### 사용 통계
1. `.claude/skill-usage.jsonl` 파일을 읽어 스킬별 호출 횟수를 집계한다
2. 최근 7일간 호출 빈도, 가장 많이 쓴 스킬 Top 5를 출력한다

## 주의사항
- 스킬 이름은 영문 소문자 + 하이픈만 허용
- 하나의 SKILL.md에 트리거 섹션이 반드시 포함되어야 한다
