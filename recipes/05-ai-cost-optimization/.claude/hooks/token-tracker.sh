#!/usr/bin/env bash
# token-tracker.sh — PostToolUse hook
# 모든 도구 호출 후 비용을 원장 파일에 누적 기록한다.

set -euo pipefail

COST_FILE="${COST_FILE:-.claude/cost-ledger.json}"
LOG_FILE="${COST_LOG:-.claude/cost-log.jsonl}"

INPUT=$(cat)
TOOL_NAME=$(echo "$INPUT" | python3 -c "import json,sys; print(json.load(sys.stdin).get('tool_name','unknown'))" 2>/dev/null || echo "unknown")
TIMESTAMP=$(date -u +"%Y-%m-%dT%H:%M:%SZ")

COST=$(python3 -c "
costs = {
    'Bash': 0.003, 'Agent': 0.025, 'Write': 0.002, 'Edit': 0.002,
    'Read': 0.001, 'Grep': 0.001, 'Glob': 0.001,
}
print(f\"{costs.get('$TOOL_NAME', 0.002):.4f}\")
")

python3 << PYEOF
import json, os

cost_file = "$COST_FILE"
log_file = "$LOG_FILE"
tool = "$TOOL_NAME"
cost = float("$COST")
ts = "$TIMESTAMP"

if os.path.exists(cost_file):
    with open(cost_file) as f:
        ledger = json.load(f)
else:
    ledger = {"total_usd": 0, "calls": 0, "by_tool": {}, "session_start": ts}

ledger["total_usd"] = round(ledger["total_usd"] + cost, 4)
ledger["calls"] += 1
ledger["by_tool"][tool] = ledger["by_tool"].get(tool, 0) + 1
ledger["last_updated"] = ts

os.makedirs(os.path.dirname(cost_file) or ".", exist_ok=True)
with open(cost_file, "w") as f:
    json.dump(ledger, f, indent=2, ensure_ascii=False)

entry = json.dumps({"ts": ts, "tool": tool, "cost_usd": cost, "cumulative": ledger["total_usd"]}, ensure_ascii=False)
with open(log_file, "a") as f:
    f.write(entry + "\n")
PYEOF

exit 0
