#!/usr/bin/env bash
# cost-gate.sh — PreToolUse hook
# 누적 비용이 한도를 초과하면 도구 실행을 차단한다.
# 환경변수: COST_LIMIT_USD (기본 5.00)

set -euo pipefail

COST_FILE="${COST_FILE:-.claude/cost-ledger.json}"
COST_LIMIT="${COST_LIMIT_USD:-5.00}"

if [[ ! -f "$COST_FILE" ]]; then
  exit 0
fi

CURRENT=$(python3 -c "
import json
data = json.load(open('$COST_FILE'))
print(f\"{data.get('total_usd', 0):.4f}\")
" 2>/dev/null || echo "0.0000")

OVER=$(python3 -c "print('yes' if float('$CURRENT') >= float('$COST_LIMIT') else 'no')")

if [[ "$OVER" == "yes" ]]; then
  cat <<EOF
{"decision": "block", "reason": "비용 한도 초과: \$$CURRENT / \$$COST_LIMIT USD. '/cost-reset' 으로 카운터를 초기화하거나 COST_LIMIT_USD 를 올려주세요."}
EOF
  exit 0
fi

WARNING=$(python3 -c "print('yes' if float('$CURRENT') >= float('$COST_LIMIT') * 0.8 else 'no')")
if [[ "$WARNING" == "yes" ]]; then
  echo "⚠️  비용 경고: \$$CURRENT / \$$COST_LIMIT USD (80% 초과)" >&2
fi

exit 0
