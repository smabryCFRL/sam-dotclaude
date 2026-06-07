---
name: project-init
description: Scaffold a .claude/ directory into the current repo from the dotclaude template (project CLAUDE.md + settings). Use when a project has no .claude/ and the user wants Claude's per-project config set up.
---

# Project init — drop in the `.claude/` template

Set up per-project Claude config for the current repo from the dotclaude template.

1. Confirm we're at the repo root and there's no existing `.claude/` (never clobber one).
2. Copy the template:
   - `mkdir -p .claude`
   - copy `~/.claude/templates/project/.claude/CLAUDE.md` → `.claude/CLAUDE.md`
   - copy `~/.claude/templates/project/.claude/settings.json` → `.claude/settings.json`
3. Fill the placeholders: project name, one-line purpose, language/stack, key commands
   (install / run / test / lint), and project-specific gotchas. Infer from the repo (README,
   `pyproject.toml`, `package.json`) and confirm with the user before writing.
4. Global rules in `~/.claude/rules/` already apply automatically while working anywhere under
   the user's account, so the project `.claude/` only needs *project-specific* additions —
   don't duplicate global rules.
5. Add `.claude/settings.local.json` to the project's `.gitignore`.
6. Ask the user to review `.claude/CLAUDE.md` before committing it.

**Do not** run this in a third-party repo the user cloned unless they explicitly ask.
