#!/usr/bin/env bash
# PostToolUse: 민감 경로·패턴 접근 이력을 타임스탬프와 함께 로그
set -euo pipefail

INPUT="$(cat)"
TOOL="$(jq -r '.tool_name // empty' <<<"$INPUT" 2>/dev/null || echo '')"
LOG_DIR="${HOME}/.claude/logs"
mkdir -p "$LOG_DIR"
ts="$(date +%Y-%m-%dT%H:%M:%S)"

log_line() {
  echo "$ts | $TOOL | $1" >> "$LOG_DIR/secrets-audit.log"
}

case "$TOOL" in
  Bash)
    CMD="$(jq -r '.tool_input.command // empty' <<<"$INPUT")"
    if [[ "$CMD" =~ (\.env|credentials|\.ssh/|\.pem|\.key|id_rsa|id_ed25519|TOKEN|SECRET|API_KEY|PASSWORD) ]]; then
      log_line "cmd=$CMD"
    fi
    ;;
  Read|Edit|Write)
    P="$(jq -r '.tool_input.file_path // empty' <<<"$INPUT")"
    if [[ "$P" =~ (\.env|credentials|\.ssh/|\.pem|\.key|id_rsa|id_ed25519|secrets?) ]]; then
      log_line "path=$P"
    fi
    ;;
esac

exit 0
