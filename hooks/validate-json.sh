#!/usr/bin/env bash
# dotclaude PostToolUse hook — validate JSON right after a Write/Edit, so malformed or
# schema-invalid config is caught at write-time instead of at the next launch.
# Exit code 2 feeds the error back to the agent so it must fix it before moving on.
input="$(cat)"

command -v jq >/dev/null 2>&1 || exit 0   # need jq to read the hook payload
path="$(printf '%s' "$input" | jq -r '.tool_input.file_path // .tool_input.path // empty' 2>/dev/null)"
[ -n "$path" ] && [ -f "$path" ] || exit 0
case "$path" in *.json) ;; *) exit 0 ;; esac   # only act on .json files

fail() { printf '🛑 dotclaude: %s\n' "$1" >&2; exit 2; }

# 1) JSON syntax — every .json file
jq empty "$path" 2>/dev/null || fail "invalid JSON in $path — fix the syntax before continuing."

# 2) Claude settings files — pin $schema and run full schema validation
base="$(basename "$path")"
if [ "$base" = "settings.json" ] || [ "$base" = "settings.local.json" ]; then
  want='https://json.schemastore.org/claude-code-settings.json'
  got="$(jq -r '.["$schema"] // empty' "$path" 2>/dev/null)"
  if [ -n "$got" ] && [ "$got" != "$want" ]; then
    fail "\$schema in $path must be \"$want\" (got \"$got\")."
  fi
  schema="$HOME/.claude/hooks/schemas/claude-code-settings.schema.json"
  if [ -f "$schema" ] && command -v uvx >/dev/null 2>&1; then
    out="$(uvx check-jsonschema --schemafile "$schema" "$path" 2>&1)" \
      || fail "settings schema check failed for $path:
$out"
  else
    printf '⚠️  dotclaude: schema validation skipped for %s (needs uv + the vendored schema).\n' "$path" >&2
  fi
fi
exit 0
