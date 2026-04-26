#!/usr/bin/env bash
# log-tool-usage.sh — PostToolUse hook (all tools)
# Tracks tool usage frequency to identify candidates for skill/slash promotion.

set -euo pipefail

TOOL_NAME="${CLAUDE_TOOL_NAME:-unknown}"
TIMESTAMP=$(date '+%Y-%m-%d %H:%M:%S')
LOG_DIR=".claude/logs"
STATS_FILE="$LOG_DIR/tool-usage-stats.jsonl"

mkdir -p "$LOG_DIR"

echo "{\"ts\":\"$TIMESTAMP\",\"tool\":\"$TOOL_NAME\"}" >> "$STATS_FILE"

LINE_COUNT=$(wc -l < "$STATS_FILE" 2>/dev/null || echo "0")
if [ "$LINE_COUNT" -gt 100 ]; then
    python3 -c "
import json, sys
from collections import Counter

counts = Counter()
with open('$STATS_FILE') as f:
    for line in f:
        try:
            event = json.loads(line.strip())
            counts[event['tool']] += 1
        except:
            pass

print('=== Tool Usage Summary ===')
for tool, count in counts.most_common(10):
    marker = ' <- skill candidate' if count > 20 else ''
    print(f'  {tool}: {count}{marker}')
" 2>/dev/null || true
fi
