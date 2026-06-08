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

## Personalize

The installer seeds two gitignored files from their `.example` templates — edit them:
- **`CLAUDE.local.md`** — your dev-area paths, identity, machine/investigation specifics.
- **`settings.local.json`** — personal settings (e.g. `skipDangerousModePermissionPrompt`).

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
