#!/usr/bin/env bash
# dotclaude PreToolUse guard — a backstop against obvious footguns (NOT a sandbox).
# Blocks catastrophic shell commands and secret-file reads; fires even in bypass mode.
# Exit code 2 = block the tool call. Extend the patterns to taste.
input="$(cat)"

# Pull fields with jq if present, else fall back to scanning the raw payload.
if command -v jq >/dev/null 2>&1; then
  cmd="$(printf '%s' "$input"  | jq -r '.tool_input.command // empty' 2>/dev/null)"
  path="$(printf '%s' "$input" | jq -r '.tool_input.file_path // .tool_input.path // empty' 2>/dev/null)"
else
  cmd="$input"; path="$input"
fi

block() { printf '🛑 dotclaude guard: %s\n' "$1" >&2; exit 2; }

# --- Dangerous shell commands -------------------------------------------------
if [ -n "$cmd" ]; then
  # rm -rf (/-fr/-r) whose target is / , /* , ~ , or $HOME. Deep paths (e.g. /tmp/x) are allowed.
  rm_re='rm[[:space:]]+-[rf]+[[:space:]]+(--no-preserve-root[[:space:]]+)?(/|/\*|~|\$HOME)([[:space:]]|$)'
  [[ "$cmd" =~ $rm_re ]] && block "refusing 'rm -rf' on a root/home path"

  # force-push — but --force-with-lease (the safe, deliberate variant) is intentionally ALLOWED
  if [[ "$cmd" =~ git[[:space:]]+push ]]; then
    fp_re='(--force([[:space:]]|$)|[[:space:]]-f([[:space:]]|$))'
    [[ "$cmd" =~ $fp_re ]] && block "refusing force-push to a shared branch (use --force-with-lease deliberately)"
  fi

  case "$cmd" in
    *":(){ :|:& };:"*)       block "fork bomb" ;;
    *"mkfs."*)               block "filesystem format" ;;
    *" dd if="*"of=/dev/"*)  block "destructive disk write" ;;
  esac
fi

# --- Secret-file reads --------------------------------------------------------
case "$path" in
  *.env.example|*.env.sample|*.env.template) : ;;                 # allowed
  *.env|*.env.*|*/.env|*id_rsa*|*.pem|*.p12|*.key|*/.aws/credentials)
      block "refusing to read a secret file ($path)" ;;
esac

exit 0
