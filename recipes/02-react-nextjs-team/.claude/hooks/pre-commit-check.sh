#!/usr/bin/env bash
# PreToolUse: git commit 전 Prettier · ESLint · TypeScript 통과 여부 검증
# git commit 이 아닌 모든 Bash 명령은 즉시 통과
set -euo pipefail

INPUT="$(cat)"
CMD="$(jq -r '.tool_input.command // empty' <<<"$INPUT" 2>/dev/null || echo '')"

ok()   { jq -n '{decision:"approve"}'; exit 0; }
block(){ jq -n --arg r "$1" '{decision:"block", reason:$r}'; exit 0; }

# git commit 아니면 즉시 통과
grep -qE '^[[:space:]]*git[[:space:]]+commit' <<<"$CMD" || ok

# 스테이징된 JS/TS 파일만 추출
STAGED=$(git diff --cached --name-only --diff-filter=ACM 2>/dev/null \
  | grep -E '\.(ts|tsx|js|jsx|mjs|cjs)$' || true)
[ -z "$STAGED" ] && ok

STAGED_ARRAY=()
while IFS= read -r line; do [ -n "$line" ] && STAGED_ARRAY+=("$line"); done <<<"$STAGED"

# 1) Prettier 포맷 체크
if command -v npx >/dev/null 2>&1; then
  if ! npx --yes prettier --check "${STAGED_ARRAY[@]}" >/tmp/claude-prettier.log 2>&1; then
    block "Prettier 포맷 불일치. 'npx prettier --write <파일>' 로 수정 후 다시 스테이징하세요. 로그: /tmp/claude-prettier.log"
  fi
fi

# 2) ESLint (설정 파일 있을 때만)
if command -v npx >/dev/null 2>&1 && \
   ls .eslintrc.json .eslintrc.js .eslintrc.cjs eslint.config.js eslint.config.mjs 2>/dev/null | head -1 >/dev/null; then
  if ! npx --no-install eslint "${STAGED_ARRAY[@]}" --max-warnings 0 >/tmp/claude-eslint.log 2>&1; then
    block "ESLint 에러/경고 있음. /tmp/claude-eslint.log 확인 후 수정."
  fi
fi

# 3) TypeScript 타입체크 (tsconfig.json 있을 때만)
if [ -f tsconfig.json ] && command -v npx >/dev/null 2>&1; then
  if ! npx --no-install tsc --noEmit >/tmp/claude-tsc.log 2>&1; then
    block "TypeScript 타입 에러 있음. /tmp/claude-tsc.log 확인 후 수정."
  fi
fi

ok
