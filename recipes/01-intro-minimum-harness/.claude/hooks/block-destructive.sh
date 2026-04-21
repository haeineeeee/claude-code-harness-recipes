#!/usr/bin/env bash
# PreToolUse: rm -rf / chmod 777 / git push --force 류 위험 명령 차단
# stdin으로 JSON 입력 (tool_input.command 포함), stdout으로 JSON 판정 반환
set -euo pipefail

INPUT="$(cat)"
CMD="$(jq -r '.tool_input.command // empty' <<< "$INPUT" 2>/dev/null || echo '')"

block_with() {
  local reason="$1"
  jq -n --arg r "$reason" '{decision: "block", reason: $r}'
  exit 0
}

# 1) 루트·홈·와일드카드 대상 rm -rf
if grep -qE 'rm[[:space:]]+(-[a-zA-Z]*r[a-zA-Z]*f|-rf|-fr)[[:space:]]+(/|~|\*|\$HOME)' <<< "$CMD"; then
  block_with "rm -rf 대상 경로가 위험합니다. 명시적으로 안전한 경로를 지정해 주세요."
fi

# 2) chmod 777
if grep -qE 'chmod[[:space:]]+777' <<< "$CMD"; then
  block_with "chmod 777은 보안 리스크가 있습니다. 최소 권한 원칙에 맞는 값을 사용하세요."
fi

# 3) git push --force / -f (main/master 대상만 차단 — feature 브랜치는 허용)
if grep -qE 'git[[:space:]]+push[[:space:]]+.*(--force|[[:space:]]-f([[:space:]]|$)).*(main|master)' <<< "$CMD"; then
  block_with "main/master 브랜치에 force push는 금지입니다."
fi

# 4) .env / credentials 류 직접 cat·조회
if grep -qE '(cat|less|more|head|tail)[[:space:]]+.*\.env' <<< "$CMD"; then
  block_with ".env 파일 직접 출력은 차단되었습니다. 필요한 값만 변수로 로드하세요."
fi

# 통과
jq -n '{decision: "approve"}'
