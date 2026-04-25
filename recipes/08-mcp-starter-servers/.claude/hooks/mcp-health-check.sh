#!/usr/bin/env bash
# PreToolUse hook — MCP 서버 헬스체크
# mcp__* 도구 호출 전에 해당 서버의 환경변수가 설정되어 있는지 확인

set -euo pipefail

TOOL_NAME="${CLAUDE_TOOL_NAME:-}"

# MCP 도구명에서 서버 이름 추출 (mcp__servername__toolname → servername)
SERVER=$(echo "$TOOL_NAME" | cut -d'_' -f4)

check_env() {
  local var_name="$1"
  if [ -z "${!var_name:-}" ]; then
    echo "BLOCKED: $var_name 환경변수가 설정되지 않았습니다." >&2
    echo "설정 방법: export $var_name=<your-token>" >&2
    exit 1
  fi
}

case "$SERVER" in
  slack)
    check_env "SLACK_BOT_TOKEN"
    check_env "SLACK_TEAM_ID"
    ;;
  notion)
    check_env "NOTION_API_KEY"
    ;;
  github)
    check_env "GITHUB_TOKEN"
    ;;
  *)
    echo "WARNING: 미등록 MCP 서버 '$SERVER' — 헬스체크 스킵" >&2
    ;;
esac

exit 0
