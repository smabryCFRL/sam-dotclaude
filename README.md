# dotclaude

A portable, shareable Claude Code configuration framework. It *is* your `~/.claude/` — version
controlled, cross-platform, and generic enough to hand to a colleague who does similar work.

**Design principle: context hygiene.** The always-loaded layer (`CLAUDE.md`) stays tiny; everything
else loads on demand — path-scoped `rules/`, on-demand `skills/`, and native auto-memory. Personal
and machine-specific values live in gitignored `*.local.*` files, so the repo itself stays shareable.

## Layout

```
CLAUDE.md                  # lean, always-loaded rules
rules/                     # python.md (auto-loads on Python files), git.md
skills/                    # new-python-project, project-init, shell-environment, atlas
hooks/                     # guard (safety), check-project-config (session nudge)   [.sh + .ps1]
agents/                    # empty to start — built-ins + plugins cover most cases
templates/project/.claude/ # drop-in starter for any repo
settings.json              # model effort, permissions, hooks, plugins   (shared)
CLAUDE.local.md            # personal — gitignored, seeded from .example
settings.local.json        # personal — gitignored, seeded from .example
install.sh / install.ps1   # symlink into ~/.claude (backs up anything it replaces)
```

## Install

**macOS / Linux**
```bash
git clone <your-fork-url> dotclaude && cd dotclaude
./install.sh
```

**Windows (PowerShell)**
```powershell
git clone <your-fork-url> dotclaude; cd dotclaude
./install.ps1   # file symlinks may require Developer Mode or an elevated shell
```

The installer symlinks the managed items into `~/.claude/`, backing up anything it replaces to
`~/.claude/_pre-dotclaude-backup-<timestamp>/`. It's idempotent — re-run any time.

## First-time setup (let your agent do it)

The fastest way to tailor dotclaude is to let Claude set it up for you. After installing, open Claude
Code and say **"run the dotclaude setup skill"** — it also offers automatically when your personal
config is still the unfilled template. The `setup` skill **auto-detects what it can** (OS, shell,
package manager, installed tools, git identity) and **asks you the rest**: where your repos live, your
primary languages and preferred tooling, your workflow style (plan-first/TDD, auto-format, PR
conventions), your permissions posture, and whether you want an Obsidian knowledge vault — then writes
your personal layer for you. A new teammate on Windows just clones, runs `install.ps1`, and tells their
agent to run setup.

Prefer to do it by hand? The manual reference is below.

## Personalize

The committed files are **generic best-practice defaults** that work for any user/OS. Your personal
and machine-specific bits live in gitignored files the installer seeds from `.example` templates —
edit them:
- **`CLAUDE.local.md`** — your dev-area paths, identity, machine/OS specifics.
- **`settings.local.json`** — personal settings (e.g. `skipDangerousModePermissionPrompt`).
- **`skills/shell-environment/SKILL.md`** — your shell, aliases, and installed tools (fill it in, or
  let your agent build it up over time).

To adapt the shared base itself: add overrides in `CLAUDE.local.md` (recommended — survives
`git pull`), or edit the committed `CLAUDE.md` directly for your own use case if you maintain a fork.

## Plugins

Declared in `settings.json` so they're reproducible across machines. On first launch Claude Code
prompts to trust the marketplaces. **Official (Anthropic)** plugins:
- `pyright-lsp` — Python type-checking / code intelligence
- `pr-review-toolkit` — PR review agents
- `commit-commands` — commit / push / PR workflow

**One community exception** (review before adopting): `superpowers` — planning + TDD discipline.

If your build doesn't auto-install from `settings.json`, run them manually:
```
/plugin install pyright-lsp@claude-plugins-official
/plugin install pr-review-toolkit@claude-plugins-official
/plugin install commit-commands@claude-plugins-official
/plugin marketplace add obra/superpowers-marketplace
/plugin install superpowers@superpowers-marketplace
```
> Plugins run with your privileges. Keep to official sources except deliberate exceptions.

## Models & effort

The shared default is **`model: sonnet`** at **`effortLevel: high`** — Sonnet handles the bulk of
coding at near-Opus quality and is friendly to limited plans. Override it in your **personal**
`settings.local.json` (gitignored) so the shared default stays safe for the whole team, e.g.:

```json
{ "model": "opusplan" }
```

**Model choices** (set `model` in `settings.local.json`, or run `/model <name>` for the session):
- **`sonnet`** — the default; fast, capable, cost-friendly. Best all-rounder.
- **`opus`** — deepest reasoning; reserve for hard architecture/bugs (heaviest plan usage).
- **`opusplan`** — *Opus does the planning, then auto-switches to Sonnet to execute.* Heavy model for
  the thinking, cheap/fast for the doing — pairs with the plan-first rule. (Needs Opus access on your plan.)
- **`haiku`** — fastest and cheapest; quick edits and search.

**Effort** — `effortLevel` in settings, or `/effort low|medium|high|xhigh|max` for the session, adjusts
reasoning depth on the *current* model (it doesn't change the model). `/effort ultracode` turns on
Opus-4.8 dynamic workflows for big multi-phase jobs.

**Limited Opus plan?** Stay on `sonnet` (the default) and raise `/effort` when you need more depth;
reach for `/model opus` sparingly on the hardest problems. Note: model changes **don't hot-reload** —
run `/model` or restart Claude Code to apply a new default.

## Per-project config

In any repo, ask Claude to run the **`project-init`** skill — and per the global `CLAUDE.md`, Claude
offers it automatically when a repo has no `.claude/` (it skips third-party repos you cloned).
It drops `templates/project/.claude/` in and fills it out. Global rules apply everywhere
automatically, so project files only hold project-specific guidance.

## Memory vault (Obsidian) — "Atlas"

Atlas is Claude's **own** knowledge workspace — it reads and writes there on its own initiative (no
manual command needed). `rules/atlas.md` (always-on) tells Claude to recall before substantial work,
capture notable findings as it goes, link everything with `[[wikilinks]]`, and surface cross-note
connections; the `atlas` skill is the method (note schema, MOC hubs, synthesis); and a SessionStart
hook (`hooks/atlas-context.sh`) makes each session start vault-aware (counts + categories only — never
note titles or bodies). Set the vault path under **Agent vault** in `CLAUDE.local.md`.

Notes are `<category>/<Title>.md` with frontmatter; links resolve by filename (`[[Title]]`). This
complements native auto-memory (machine-local working memory) — the vault is the *deliberate, curated,
portable* layer you also browse in Obsidian. Keep it **non-cloud-synced and sensitive**; never commit it.

## Sharing with colleagues

The repo is generic — all personal data lives in gitignored `*.local.*` files. A colleague
forks/clones, runs the installer (which seeds their own local files from the `.example` templates),
fills them in, and — to stay strictly official-only — can remove the `superpowers` lines from
`settings.json`.

## Uninstall

Remove the symlinks under `~/.claude/` and restore from the most recent
`~/.claude/_pre-dotclaude-backup-*/` folder.
