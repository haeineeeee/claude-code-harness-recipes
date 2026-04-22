#!/usr/bin/env bash
# PreToolUse hook: Bash 명령 허용 리스트 검증
set -euo pipefail
INPUT=$(cat)
TOOL_NAME=$(echo "$INPUT" | jq -r '.tool_name // empty')
if [[ "$TOOL_NAME" != "Bash" ]]; then
  echo '{"decision":"approve"}'
  exit 0
fi
COMMAND=$(echo "$INPUT" | jq -r '.tool_input.command // empty')
BLOCKED_PATTERNS=(
  "rm -rf /"
  "curl.*| *bash"
  "curl.*| *sh"
  "wget.*| *bash"
  "wget.*| *sh"
  "eval "
  "sudo "
  "chmod 777"
  "git push --force"
  "git push.*-f "
  "DROP TABLE"
  "npm publish"
  "> /dev/sd"
  "mkfs\."
  "dd if="
)
for pattern in "${BLOCKED_PATTERNS[@]}"; do
  if echo "$COMMAND" | grep -qiE "$pattern"; then
    echo "{\"decision\":\"block\",\"reason\":\"Policy violation: blocked pattern '$pattern'.\"}"
    exit 0
  fi
done
if [[ "${ALLOWLIST_MODE:-}" == "strict" ]]; then
  ALLOWED_PREFIXES=(
    "git " "npm " "npx " "node " "python " "python3 "
    "cat " "ls " "pwd" "echo " "mkdir " "cp " "mv "
    "grep " "rg " "find " "head " "tail " "wc "
    "docker " "make " "cargo " "go "
    "pytest " "jest " "vitest "
  )
  MATCHED=false
  for prefix in "${ALLOWED_PREFIXES[@]}"; do
    if [[ "$COMMAND" == "$prefix"* ]]; then
      MATCHED=true
      break
    fi
  done
  if [[ "$MATCHED" == "false" ]]; then
    echo "{\"decision\":\"block\",\"reason\":\"Strict mode: command not in allowlist.\"}"
    exit 0
  fi
fi
echo '{"decision":"approve"}'
