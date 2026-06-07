# Global operating rules — `dotclaude`

> Always-loaded base layer. Keep it lean: detailed reference lives in `rules/` (auto- or
> on-demand) and in skills. Person- and machine-specific values live in `CLAUDE.local.md`
> (gitignored). Update this file and `rules/` in the same task whenever conventions change.

## Working areas & project setup
- Repos live under per-area dev roots; this machine's exact areas are in `CLAUDE.local.md`.
  State which area you're working in at session start. If it's ambiguous, ask — don't guess.
- Never clone loose into the dev root, into `~`, or into cloud-synced folders (Documents, Desktop, iCloud).
- Prefer clean, per-project isolation — nothing installed globally. (Language specifics in `rules/`.)

## Per-project config — scaffold on entry (IMPORTANT)
- When you start work in a project that has **no `.claude/` directory**, alert me and offer to
  scaffold one from the template by running the **`project-init`** skill — *before* doing the work.
- **Skip** this when I tell you to, or when it's a **third-party repo I cloned** (someone else's
  project): don't add `.claude/` there unless I explicitly ask.

## Bash tool gotcha
- My interactive shell aliases `ls→eza`, `cat→bat`, `find→fd`, `grep→rg`, `top→btop`. In **Bash
  tool** calls those aliases do **not** apply — call the real binaries by name (`rg`, `fd`,
  `bat -p`, `eza`), and remember `fd`/`rg` have different syntax than GNU `find`/`grep`.
- Full environment reference (alias table, installed CLI tools, shell plugins) is the
  **`shell-environment`** skill — consult it when you need machine details.

## Conventions index
- `rules/python.md` — uv / mise / ruff conventions (auto-loads when touching Python files)
- `rules/git.md` — commit, branch, PR & review conventions
- `skills/new-python-project` — scaffold a Python project my way
- `skills/project-init` — drop the `.claude/` template into the current repo
- `skills/shell-environment` — terminal / tooling reference (on demand)
