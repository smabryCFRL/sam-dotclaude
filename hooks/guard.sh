#!/usr/bin/env bash
# dotclaude PreToolUse guard — blocks dangerous shell commands and secret-file reads.
# Fires even in bypass-permissions mode. Exit code 2 = block the tool call.
input="$(cat)"

# Pull fields with jq if present, else fall back to crude grep.
if command -v jq >/dev/null 2>&1; then
  cmd="$(printf '%s' "$input"  | jq -r '.tool_input.command // empty' 2>/dev/null)"
  path="$(printf '%s' "$input" | jq -r '.tool_input.file_path // .tool_input.path // empty' 2>/dev/null)"
else
  cmd="$input"; path="$input"
fi

block() { printf '🛑 dotclaude guard: %s\n' "$1" >&2; exit 2; }

# --- Dangerous shell commands -------------------------------------------------
case "$cmd" in
  *"rm -rf /"*|*"rm -rf ~"*|*'rm -rf $HOME'*)      block "refusing 'rm -rf' on a root/home path" ;;
  *"git push"*--force*|*"git push"*" -f "*|*"git push"*" -f")  block "refusing force-push to a shared branch (use --force-with-lease deliberately)" ;;
  *":(){ :|:& };:"*)                               block "fork bomb" ;;
  *"mkfs."*)                                       block "filesystem format" ;;
  *" dd if="*"of=/dev/"*)                           block "destructive disk write" ;;
esac

# --- Secret-file reads --------------------------------------------------------
case "$path" in
  *.env.example|*.env.sample|*.env.template) : ;;                 # allowed
  *.env|*.env.*|*/.env|*id_rsa*|*.pem|*.p12|*.key|*/.aws/credentials)
      block "refusing to read a secret file ($path)" ;;
esac

exit 0
