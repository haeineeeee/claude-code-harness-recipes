#!/usr/bin/env bash
# PostToolUse hook — Slash command usage logger
set -euo pipefail
LOG_FILE=".claude/command-usage.jsonl"
TOOL_INPUT=$(cat)
SKILL_NAME=$(echo "$TOOL_INPUT" | python3 -c "
import json, sys
data = json.load(sys.stdin)
print(data.get('skill', data.get('name', '')))" 2>/dev/null || echo "unknown")
TIMESTAMP=$(date -u +"%Y-%m-%dT%H:%M:%SZ")
USER=$(whoami)
PROJECT=$(basename "$(pwd)")
echo "{\"ts\":\"$TIMESTAMP\",\"cmd\":\"$SKILL_NAME\",\"user\":\"$USER\",\"project\":\"$PROJECT\"}" >> "$LOG_FILE"
exit 0
