# /audit — 도구 사용 현황 분석

Analyze the tool usage logs and recommend optimizations.

## Instructions
1. Read `.claude/logs/tool-usage-stats.jsonl`
2. Count tool invocations by name
3. Identify high-frequency tools (>20 calls) — candidates for Skill promotion
4. Identify repetitive Bash patterns — candidates for Slash Command
5. Check if any Hook is firing excessively — candidate for matcher refinement
6. Present findings in a table with actionable recommendations
