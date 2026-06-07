#!/usr/bin/env bash
# dotclaude SessionStart hook — nudge if a git repo lacks a .claude/ directory.
cwd="$(pwd)"
if [ -d "$cwd/.git" ] && [ ! -d "$cwd/.claude" ]; then
  msg="dotclaude: this repo has no .claude/ — per global rules, offer to run the project-init skill before substantial work (skip for third-party clones)."
  printf '{"hookSpecificOutput":{"hookEventName":"SessionStart","additionalContext":"%s"}}\n' "$msg"
fi
exit 0
