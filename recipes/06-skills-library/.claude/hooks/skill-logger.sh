#!/usr/bin/env bash
# PostToolUse hook: Skill 호출 기록을 JSON Lines로 누적
# stdin: JSON { "tool_name": "Skill", "tool_input": { "skill": "...", "args": "..." } }

set -euo pipefail

INPUT=$(cat)
SKILL_NAME=$(echo "$INPUT" | jq -r '.tool_input.skill // "unknown"')
SKILL_ARGS=$(echo "$INPUT" | jq -r '.tool_input.args // ""')
LOG_FILE="${SKILL_LOG_FILE:-.claude/skill-usage.jsonl}"

# 호출 기록 추가
jq -n \
  --arg skill "$SKILL_NAME" \
  --arg args "$SKILL_ARGS" \
  --arg ts "$(date -u +%Y-%m-%dT%H:%M:%SZ)" \
  --arg session "${CLAUDE_SESSION_ID:-unknown}" \
  '{timestamp: $ts, skill: $skill, args: $args, session: $session}' \
  >> "$LOG_FILE"
