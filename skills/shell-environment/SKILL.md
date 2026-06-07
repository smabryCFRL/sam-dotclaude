---
name: shell-environment
description: Reference for the user's terminal setup — shell aliases, installed CLI tools (Homebrew), and zsh plugins. Consult when running shell commands, choosing a CLI tool, or discussing the dev environment.
---

# Shell environment reference

macOS · Ghostty · zsh + antidote · Homebrew `/opt/homebrew`. Personal specifics in `CLAUDE.local.md`.

## Aliases (interactive shell only — in Bash tool calls use the REAL binary)
| Alias | Real | Notes |
|-------|------|-------|
| `ll` | `eza -la --git` | long listing w/ git status |
| `ls` | `eza` | modern ls |
| `cat` | `bat` | syntax-highlighted; `bat -p` for plain |
| `find` | `fd` | different syntax than GNU find |
| `grep` | `rg` | ripgrep |
| `top` | `btop` | |
| `g` | `git` | |
| `lg` | `lazygit` | git TUI |
| `osint` | Firefox isolated profile | see `CLAUDE.local.md` |

> Because `cat`/`find`/`grep` are aliased interactively, a command copy-pasted from the user's
> terminal may behave differently in a script. In Bash tool calls, call `rg`/`fd`/`bat`/`eza` directly.

## Installed CLI tools (Homebrew)
- **Shell/env:** starship (prompt), zoxide (`z` smart cd), fzf (Ctrl+R / Ctrl+T), mise, tmux, antidote.
- **Modern Unix:** eza, bat, fd, ripgrep (`rg`), btop, tree.
- **Git:** git, gh, lazygit.
- **Editor:** neovim (`nvim`).
- **Python:** uv, ruff (see `rules/python.md`).
- **Data / HTTP:** jq, yq, httpie, wget.

## zsh plugins (antidote, `~/.zsh_plugins.txt`)
zsh-autosuggestions · zsh-syntax-highlighting · zsh-completions · zsh-you-should-use · ohmyzsh git plugin.
