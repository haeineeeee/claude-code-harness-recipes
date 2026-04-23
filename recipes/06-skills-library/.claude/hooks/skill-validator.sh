#!/usr/bin/env bash
# PreToolUse hook: Skill 호출 전 SKILL.md 존재 여부 및 필수 섹션 검증
# stdin: JSON { "tool_name": "Skill", "tool_input": { "skill": "..." } }

set -euo pipefail

INPUT=$(cat)
SKILL_NAME=$(echo "$INPUT" | jq -r '.tool_input.skill // empty')

if [ -z "$SKILL_NAME" ]; then
  echo '{"decision":"block","reason":"skill name is empty"}'
  exit 0
fi

# skill 이름에서 콜론 이전 부분 추출 (qualified name 대응)
BASE_SKILL=$(echo "$SKILL_NAME" | cut -d: -f1)

# .claude/skills/ 하위에서 SKILL.md 검색
SKILL_FILE=$(find .claude/skills -name "SKILL.md" -path "*${BASE_SKILL}*" 2>/dev/null | head -1)

if [ -z "$SKILL_FILE" ]; then
  echo "{\"decision\":\"block\",\"reason\":\"SKILL.md not found for ${BASE_SKILL}. Register it under .claude/skills/<name>/SKILL.md first.\"}"
  exit 0
fi

# 필수 섹션 검증: 트리거, 설명이 있는지
if ! grep -qi "trigger\|트리거" "$SKILL_FILE"; then
  echo '{"decision":"warn","reason":"SKILL.md missing trigger section — add trigger keywords for discoverability."}'
  exit 0
fi

echo '{"decision":"allow"}'
