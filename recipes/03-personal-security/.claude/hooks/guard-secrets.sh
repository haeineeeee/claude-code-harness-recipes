#!/usr/bin/env bash
# PreToolUse: 시크릿·키·대외비 파일 접근 차단 (settings.json permissions.deny 의 보조 방어선)
set -euo pipefail

INPUT="$(cat)"
TOOL="$(jq -r '.tool_name // empty' <<<"$INPUT" 2>/dev/null || echo '')"

block() { jq -n --arg r "$1" '{decision:"block", reason:$r}'; exit 0; }
ok()    { jq -n '{decision:"approve"}'; exit 0; }

# 경로가 민감 파일인지 판정
is_sensitive_path() {
  local p="$1"
  # .env.{example,sample,template,dist} 류는 예외적으로 허용
  [[ "$p" =~ \.env\.(example|sample|template|dist)$ ]] && return 1
  [[ "$p" =~ (^|/)\.env($|\..+) ]] && return 0
  [[ "$p" =~ (^|/)\.ssh/ ]] && return 0
  [[ "$p" =~ (^|/)\.aws/(credentials|config)$ ]] && return 0
  [[ "$p" =~ (^|/)(id_rsa|id_ed25519|id_ecdsa|id_dsa)($|\.pub$) ]] && return 0
  [[ "$p" =~ \.(pem|p12|pfx|key|keystore|jks)$ ]] && return 0
  [[ "$p" =~ (^|/)secrets?(\.[^/]+)?$ ]] && return 0
  return 1
}

case "$TOOL" in
  Bash)
    CMD="$(jq -r '.tool_input.command // empty' <<<"$INPUT")"
    # 민감 파일 내용 출력
    if [[ "$CMD" =~ (cat|less|more|head|tail|grep|rg|bat|awk|sed)[[:space:]].*\.env ]] \
       || [[ "$CMD" =~ (cat|less|more|head|tail)[[:space:]].*\.(pem|key|p12|pfx) ]] \
       || [[ "$CMD" =~ (cat|less|more|head|tail)[[:space:]].*\.ssh/ ]] \
       || [[ "$CMD" =~ (cat|less|more|head|tail)[[:space:]].*\.aws/credentials ]]; then
      block "민감 파일(.env / SSH 키 / AWS credentials / .pem)의 내용 출력을 차단했습니다. 필요한 값만 개별 환경변수로 참조하세요."
    fi
    # scp/sftp/rsync/base64 -e 로 비밀 파일 외부 전송
    if [[ "$CMD" =~ (scp|sftp|rsync).+(\.env|\.pem|\.ssh/|credentials) ]]; then
      block "민감 파일을 외부로 전송하려는 명령이 차단되었습니다."
    fi
    # curl/wget 데이터에 비밀 값 참조
    if [[ "$CMD" =~ (curl|wget).+(--data|--data-urlencode|-d[[:space:]]).*(\$\{?(TOKEN|SECRET|API_KEY|PASSWORD|CREDENTIALS|PRIVATE_KEY)) ]]; then
      block "비밀 값이 외부 HTTP 요청 본문에 포함될 가능성이 감지되었습니다. 헤더·OAuth 플로 사용을 권장합니다."
    fi
    # env / printenv / set 으로 전체 환경변수 덤프
    if [[ "$CMD" =~ ^[[:space:]]*(env|printenv|set|export -p)([[:space:]]|$) ]]; then
      block "전체 환경변수 덤프가 차단되었습니다. 필요한 키만 명시적으로 \$KEY_NAME 참조하세요."
    fi
    ;;
  Read|Edit|Write)
    P="$(jq -r '.tool_input.file_path // empty' <<<"$INPUT")"
    if [ -n "$P" ] && is_sensitive_path "$P"; then
      block "민감 파일 접근이 차단되었습니다: $P (시크릿 가드). 허용 파일: .env.example, .env.sample, .env.template"
    fi
    ;;
esac

ok
