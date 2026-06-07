---
name: new-python-project
description: Scaffold a new Python project the user's way — uv init, mise-pinned runtime, ruff, and a sane .gitignore. Use when starting or creating a new Python project, package, or script project.
---

# New Python project

Scaffold a fresh Python project following `rules/python.md`. Confirm the target directory and
Python version first (default 3.12), then:

1. `mise use python@3.12` — pin the runtime (writes `mise.toml`).
2. `uv init` — create `pyproject.toml` (+ layout). Use `uv init --package` for a library.
3. Add baseline dev deps if wanted: `uv add --dev ruff`.
4. Ensure `.gitignore` includes `.venv/`, `__pycache__/`, `.DS_Store`.
5. `uv run ruff check` / `uv run ruff format` to confirm the toolchain works.
6. `git init` + an initial commit — only if the user asks.

Commit `pyproject.toml`, `uv.lock`, `mise.toml`. Never use `pip`. Don't add custom ruff config.
If the repo has no `.claude/`, offer to also run the `project-init` skill.
