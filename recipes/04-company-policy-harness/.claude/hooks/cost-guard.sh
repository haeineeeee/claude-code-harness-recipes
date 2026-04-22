#!/usr/bin/env bash
# PostToolUse hook: Bash 실행 횟수 추적 및 한도 초과 시 경고
set -euo pipefail
COUNTER_FILE="${COST_COUNTER_FILE:-.claude/cost-counter.json}"
MAX_CALLS="${MAX_BASH_CALLS:-200}"
WARN_THRESHOLD="${WARN_BASH_CALLS:-150}"
mkdir -p "$(dirname "$COUNTER_FILE")"
if [[ ! -f "$COUNTER_FILE" ]]; then
  echo '{"bash_calls":0,"started":"'$(date -u +%Y-%m-%dT%H:%M:%SZ)'"}' > "$COUNTER_FILE"
fi
CURRENT=$(jq -r '.bash_calls // 0' "$COUNTER_FILE")
NEXT=$((CURRENT + 1))
jq --argjson n "$NEXT" '.bash_calls = $n | .last_updated = "'"$(date -u +%Y-%m-%dT%H:%M:%SZ)"'"' \
  "$COUNTER_FILE" > "${COUNTER_FILE}.tmp" && mv "${COUNTER_FILE}.tmp" "$COUNTER_FILE"
if (( NEXT >= MAX_CALLS )); then
  echo "COST GUARD: Bash call limit reached ($NEXT/$MAX_CALLS). Reset $COUNTER_FILE to continue." >&2
elif (( NEXT >= WARN_THRESHOLD )); then
  REMAINING=$((MAX_CALLS - NEXT))
  echo "COST GUARD WARNING: $NEXT/$MAX_CALLS Bash calls used. $REMAINING remaining." >&2
fi
exit 0
