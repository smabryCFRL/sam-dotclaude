# Global operating rules — `dotclaude`

> Always-loaded base layer. Keep it lean: detailed reference lives in `rules/` (auto- or
> on-demand) and in skills. Person- and machine-specific values live in `CLAUDE.local.md`
> (gitignored). Update this file and `rules/` in the same task whenever conventions change.

## Rigor — research first, verify before "done" (IMPORTANT)
- **Don't write from memory when an authoritative source exists.** Generating against a config
  schema, API, CLI flags, or a library? Check the real docs / JSON schema / `--help` first —
  memory is a hypothesis to confirm, not a source to ship.
- **Validate every generated artifact before claiming it works.** Parse/lint/schema-check config,
  run code or its tests, dry-run commands. JSON especially: parse *and* schema-validate.
  **Show the evidence — the command and its output — don't just assert success.**
- **Fix the root cause, don't suppress it.** Never silence an error, skip a test, or paper over a
  failing check just to make something "pass."
- **"Done" means verified.** Never report success on unverified work; if something couldn't be
  verified, say so and name exactly what's unchecked.
- Simple, preventable mistakes (typos, wrong schema, guessed flags, unparsed config) are
  unacceptable — they're cheap to catch and they erode trust.

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
- `skills/save-note` / `skills/recall-note` — persist & recall notes in the Obsidian agent vault (path in `CLAUDE.local.md`)
