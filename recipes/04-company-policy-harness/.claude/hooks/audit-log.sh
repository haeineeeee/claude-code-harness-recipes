#!/usr/bin/env bash
# PostToolUse hook: 모든 Bash/Write/Edit 호출을 감사 로그에 기록
set -euo pipefail
INPUT=$(cat)
TOOL_NAME=$(echo "$INPUT" | jq -r '.tool_name // "unknown"')
LOG_DIR="${AUDIT_LOG_DIR:-.claude}"
LOG_FILE="$LOG_DIR/audit.jsonl"
mkdir -p "$LOG_DIR"
TIMESTAMP=$(date -u +"%Y-%m-%dT%H:%M:%SZ")
SESSION_ID="${CLAUDE_SESSION_ID:-$(echo $PPID)}"
USER_NAME="${CLAUDE_USER:-$(whoami)}"
case "$TOOL_NAME" in
  Bash)   SUMMARY=$(echo "$INPUT" | jq -r '.tool_input.command // "" | .[0:200]') ;;
  Write)  SUMMARY=$(echo "$INPUT" | jq -r '.tool_input.file_path // "unknown"') ;;
  Edit)   SUMMARY=$(echo "$INPUT" | jq -r '.tool_input.file_path // "unknown"') ;;
  *)      SUMMARY="$TOOL_NAME invoked" ;;
esac
jq -n -c \
  --arg ts "$TIMESTAMP" \
  --arg sid "$SESSION_ID" \
  --arg user "$USER_NAME" \
  --arg tool "$TOOL_NAME" \
  --arg summary "$SUMMARY" \
  '{timestamp:$ts, session:$sid, user:$user, tool:$tool, summary:$summary}' \
  >> "$LOG_FILE"
exit 0
