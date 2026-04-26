#!/usr/bin/env bash
# classify-intent.sh — PreToolUse hook for Bash
# Logs which automation layer triggered this call and classifies intent.

set -euo pipefail

TOOL_NAME="${CLAUDE_TOOL_NAME:-unknown}"
TIMESTAMP=$(date '+%Y-%m-%d %H:%M:%S')
LOG_DIR=".claude/logs"
LOG_FILE="$LOG_DIR/intent-classification.log"

mkdir -p "$LOG_DIR"

INPUT=$(cat)

COMMAND=$(echo "$INPUT" | python3 -c "
import json, sys
try:
    data = json.load(sys.stdin)
    print(data.get('command', data.get('input', '')))
except:
    print('')
" 2>/dev/null || echo "")

INTENT="unknown"
if echo "$COMMAND" | grep -qiE '(test|jest|pytest|vitest)'; then
    INTENT="testing"
elif echo "$COMMAND" | grep -qiE '(lint|eslint|prettier|format)'; then
    INTENT="code-quality"
elif echo "$COMMAND" | grep -qiE '(build|compile|tsc|webpack|vite)'; then
    INTENT="build"
elif echo "$COMMAND" | grep -qiE '(git|gh )'; then
    INTENT="version-control"
elif echo "$COMMAND" | grep -qiE '(npm|yarn|pnpm|pip|cargo)'; then
    INTENT="dependency"
elif echo "$COMMAND" | grep -qiE '(docker|kubectl|terraform)'; then
    INTENT="infrastructure"
fi

echo "[$TIMESTAMP] tool=$TOOL_NAME intent=$INTENT cmd=\"${COMMAND:0:120}\"" >> "$LOG_FILE"
echo '{}'
