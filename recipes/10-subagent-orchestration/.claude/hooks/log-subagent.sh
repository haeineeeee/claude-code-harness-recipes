#!/usr/bin/env bash
# PostToolUse hook — Agent 완료 후 실행 로그 기록
set -euo pipefail

INPUT=$(cat)
TOOL=$(echo "$INPUT" | jq -r '.tool_name // empty')
[ "$TOOL" != "Agent" ] && exit 0

LOG_DIR=".claude/logs"
mkdir -p "$LOG_DIR"

TIMESTAMP=$(date '+%Y-%m-%d %H:%M:%S')
SUBAGENT_TYPE=$(echo "$INPUT" | jq -r '.tool_input.subagent_type // "general-purpose"')
DESCRIPTION=$(echo "$INPUT" | jq -r '.tool_input.description // "N/A"')
RESULT_LEN=$(echo "$INPUT" | jq -r '.tool_result // "" | length')

echo "$TIMESTAMP | type=$SUBAGENT_TYPE | desc=$DESCRIPTION | result_len=$RESULT_LEN" >> "$LOG_DIR/subagent-usage.log"
exit 0
