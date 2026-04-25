#!/usr/bin/env bash
# PostToolUse hook — MCP 도구 사용 감사 로그

set -euo pipefail

LOG_FILE=".claude/mcp-audit.jsonl"
TOOL_NAME="${CLAUDE_TOOL_NAME:-unknown}"
EXIT_CODE="${CLAUDE_TOOL_EXIT_CODE:-0}"
TIMESTAMP=$(date -u +"%Y-%m-%dT%H:%M:%SZ")
PROJECT=$(basename "$(pwd)")
SERVER=$(echo "$TOOL_NAME" | cut -d'_' -f4)
ACTION=$(echo "$TOOL_NAME" | cut -d'_' -f5-)

echo "{\"ts\":\"$TIMESTAMP\",\"server\":\"$SERVER\",\"action\":\"$ACTION\",\"tool\":\"$TOOL_NAME\",\"exit\":$EXIT_CODE,\"project\":\"$PROJECT\"}" >> "$LOG_FILE"
