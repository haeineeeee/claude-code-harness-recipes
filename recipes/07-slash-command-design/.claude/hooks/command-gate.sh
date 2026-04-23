#!/usr/bin/env bash
# PreToolUse hook — Slash command whitelist gate
set -euo pipefail
COMMANDS_DIR=".claude/commands"
TOOL_INPUT=$(cat)
SKILL_NAME=$(echo "$TOOL_INPUT" | python3 -c "
import json, sys
data = json.load(sys.stdin)
print(data.get('skill', data.get('name', '')))" 2>/dev/null || echo "")
if [ -z "$SKILL_NAME" ]; then exit 0; fi
REGISTERED=$(find "$COMMANDS_DIR" -name "*.md" -exec basename {} .md \; 2>/dev/null | sort)
MATCH=$(echo "$REGISTERED" | grep -Fx "$SKILL_NAME" 2>/dev/null || true)
if [ -z "$MATCH" ]; then
  ALLOWED_LIST=$(echo "$REGISTERED" | tr '\n' ', ' | sed 's/,$//')
  echo "BLOCKED: /$SKILL_NAME is not a registered command."
  echo "Registered commands: $ALLOWED_LIST"
  echo "Add $COMMANDS_DIR/$SKILL_NAME.md to register it."
  exit 2
fi
exit 0
