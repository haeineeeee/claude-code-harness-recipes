#!/usr/bin/env bash
# PostToolUse: next build / npm run build 소요시간을 로그
set -euo pipefail

INPUT="$(cat)"
CMD="$(jq -r '.tool_input.command // empty' <<<"$INPUT" 2>/dev/null || echo '')"
DUR_MS="$(jq -r '.tool_response.duration_ms // 0' <<<"$INPUT" 2>/dev/null || echo 0)"

# build 관련 명령만 로깅
if grep -qE '(next[[:space:]]+build|npm[[:space:]]+run[[:space:]]+build|pnpm[[:space:]]+build|yarn[[:space:]]+build)' <<<"$CMD"; then
  LOG_DIR="${LOG_DIR:-$HOME/.claude/logs}"
  mkdir -p "$LOG_DIR"
  ts="$(date +%Y-%m-%dT%H:%M:%S)"
  echo "$ts | ${DUR_MS}ms | $CMD" >> "$LOG_DIR/build-times.log"
fi

# PostToolUse 는 output 필요 없음 (approve 불필요)
exit 0
