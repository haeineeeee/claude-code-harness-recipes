#!/usr/bin/env bash
# PreToolUse hook — Agent 호출 시 서브에이전트 유효성 검증
set -euo pipefail

INPUT=$(cat)
TOOL=$(echo "$INPUT" | jq -r '.tool_name // empty')
[ "$TOOL" != "Agent" ] && exit 0

SUBAGENT_TYPE=$(echo "$INPUT" | jq -r '.tool_input.subagent_type // "general-purpose"')
DESCRIPTION=$(echo "$INPUT" | jq -r '.tool_input.description // empty')
PROMPT=$(echo "$INPUT" | jq -r '.tool_input.prompt // empty')

if [ -z "$DESCRIPTION" ]; then
  echo '{"decision":"block","reason":"Agent 호출에 description이 없습니다. 3~5단어 설명을 추가하세요."}'
  exit 0
fi

if [ ${#PROMPT} -lt 30 ]; then
  echo '{"decision":"block","reason":"Agent prompt가 너무 짧습니다(30자 미만). 충분한 컨텍스트를 제공하세요."}'
  exit 0
fi

ALLOWED_TYPES="general-purpose Explore Plan code-reviewer"
MATCH=0
for TYPE in $ALLOWED_TYPES; do
  [ "$SUBAGENT_TYPE" = "$TYPE" ] && MATCH=1 && break
done

if [ $MATCH -eq 0 ]; then
  echo "{\"decision\":\"block\",\"reason\":\"알 수 없는 subagent_type: $SUBAGENT_TYPE. 허용: $ALLOWED_TYPES\"}"
  exit 0
fi

exit 0
