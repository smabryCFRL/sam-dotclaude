---
paths:
  - "**/*.py"
  - "**/pyproject.toml"
  - "**/uv.lock"
  - "**/mise.toml"
---

# Python conventions

Clean, per-project isolation — nothing installed globally.

- **Packaging & deps: `uv`.** Scaffold with `uv init`; add deps with `uv add <pkg>` (updates
  `pyproject.toml` + `uv.lock`); run via `uv run <cmd>` (never manually `source .venv/bin/activate`).
  Each project owns its `.venv/` (gitignored).
- **`pip` is intentionally blocked** by a shell function that nudges to uv. Never instruct
  `pip install ...`; use `uv add` / `uv pip install`. Escape hatch only if truly needed: `command pip ...`.
- **Runtimes: `mise`.** Pin with `mise use python@3.12` (writes `mise.toml`, auto-activates per dir).
  Per-project env vars go in `[env]` of `mise.toml` (no direnv).
- **Lint/format: `ruff`, defaults only.** `uv run ruff check` and `uv run ruff format`. Don't add
  custom ruff config unless asked.
- **Commit** `pyproject.toml`, `uv.lock`, `mise.toml`; **gitignore** `.venv/`.
