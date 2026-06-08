---
name: setup
description: First-time setup for dotclaude — interview the user and fill in their personal config layer (CLAUDE.local.md, settings.local.json, shell-environment skill) for their OS, tools, and workflows. Use right after cloning/installing dotclaude on a new machine, when onboarding a new user, or when CLAUDE.local.md is still the unfilled template.
---

# dotclaude setup — tailor it to this user

Turn the generic dotclaude defaults into *this* user's setup by filling the gitignored personal layer.
Principle: **detect what you can; only ask what you can't.** Confirm before writing. Never commit these files.

## 1. Auto-detect (run these — don't ask the user what a command can tell you)
- OS / arch: `uname -sm` (macOS/Linux) or `$env:OS` / `systeminfo` (Windows)
- Shell + prompt/plugin manager: `echo $SHELL`, `$0`
- Package manager: `command -v brew winget scoop apt dnf pacman`
- Tools the agent should assume are present: `command -v git gh rg fd bat eza jq yq uv node pnpm npm python3 mise fzf zoxide starship tmux nvim` (record which exist)
- Git identity: `git config --global user.name` / `user.email`
- Likely dev roots: check for `~/Developer ~/dev ~/code ~/src ~/projects ~/work`

Summarize what you found, then ask the user to confirm or correct it.

## 2. Ask (only what detection can't answer) — keep it to ~5–7 crisp questions
1. **Identity** — name + git email (confirm the detected values, or ask).
2. **Where repos live** — one dev root, or split by area (e.g. `personal` / `work`)? Offer detected paths as defaults.
3. **Primary stacks & tooling** — which languages, and preferred tools per stack (e.g. Python → uv/mise/ruff; JS/TS → pnpm/bun; Go; Rust). This decides which rules matter to them.
4. **Workflow preferences** — plan-first / TDD? auto-format on save? PR conventions? how much should the agent verify before calling work "done"?
5. **Permissions posture** — fast flow (bypass prompts) or prompt on risky actions?
6. **Knowledge vault** — want an Obsidian "Atlas" agent vault (proactive memory)? If yes, the path (non-cloud, sensitive). If no, skip — `rules/atlas.md` self-disables when no vault is set.
7. **Domain / specialized work** — anything the agent should always know (industry, security posture, recurring tasks)?

Use the question tool where it speeds things up; otherwise ask conversationally. Don't over-ask.

## 3. Write the personal layer (seed each from its `.example` if missing, then fill in)
- **`CLAUDE.local.md`** — dev-area paths, identity, OS/machine specifics, vault path, domain notes.
- **`skills/shell-environment/SKILL.md`** — OS, shell, package manager, the detected tools, and any aliases they mention.
- **`settings.local.json`** — set `skipDangerousModePermissionPrompt` per their permissions choice; any other personal settings.

Show the user each file's final content before moving on.

## 4. Tailor the base (optional, with consent)
- If their main stack isn't Python, note `rules/python.md` only loads on Python files (harmless) — offer to add a `rules/<stack>.md` for their primary language.
- Keep the shared `CLAUDE.md` generic; put their specifics in `CLAUDE.local.md` (survives `git pull`). Only edit `CLAUDE.md` if they maintain their own fork.

## 5. Finish
- Tell them to **restart Claude Code** so the new config + skills load.
- If they set up a vault, remind them to back it up / add it to sync.
- Summarize what changed. Do **not** commit the gitignored personal files.
