#!/usr/bin/env bash
# dotclaude SessionStart hook — make Claude aware of its Atlas vault each session so it
# recalls/curates proactively. Surfaces ONLY structure (note count + category names) —
# never note titles or bodies — to keep sensitive content out of every session's context.
# Uses only standard tools so it works regardless of the hook shell's PATH.
loc="$HOME/.claude/CLAUDE.local.md"
[ -f "$loc" ] || exit 0

# Vault path from the "- Agent vault: <path>" line in CLAUDE.local.md (single source of truth).
vault="$(grep -m1 '^- Agent vault:' "$loc" 2>/dev/null | sed -E 's/^- Agent vault:[[:space:]]*//; s/[[:space:]].*$//')"
case "$vault" in "~"*) vault="$HOME${vault#\~}" ;; esac
[ -n "$vault" ] && [ -d "$vault" ] || exit 0   # not configured yet → silent no-op

count="$(find "$vault" -type f -name '*.md' ! -name 'INDEX.md' 2>/dev/null | wc -l | tr -d ' ')"
cats="$(find "$vault" -mindepth 1 -maxdepth 1 -type d ! -name '.*' -exec basename {} \; 2>/dev/null | sort | tr '\n' ' ')"
[ -z "$cats" ] && cats="none yet "

msg="Atlas vault is active: ${count} notes across [ ${cats}]. This is your own knowledge workspace -- before substantial work, recall relevant notes; as you work, capture and [[link]] notable findings proactively, and surface cross-note connections. Method: the atlas skill."
printf '{"hookSpecificOutput":{"hookEventName":"SessionStart","additionalContext":"%s"}}\n' "$msg"
exit 0
