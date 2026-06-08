#!/usr/bin/env bash
# dotclaude installer (macOS / Linux).
# Symlinks managed items into ~/.claude, backing up anything it would replace.
# Re-runnable (idempotent). Override target with CLAUDE_HOME=/path ./install.sh
set -euo pipefail

REPO_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
CLAUDE_DIR="${CLAUDE_HOME:-$HOME/.claude}"
STAMP="$(date +%Y%m%d-%H%M%S)"
BACKUP_DIR="$CLAUDE_DIR/_pre-dotclaude-backup-$STAMP"

# Managed items linked from the repo into ~/.claude
ITEMS=(CLAUDE.md CLAUDE.local.md settings.json settings.local.json rules skills agents hooks templates)

mkdir -p "$CLAUDE_DIR"

# Ensure personal local files exist (seed from examples) before linking.
[ -f "$REPO_DIR/CLAUDE.local.md" ]     || cp "$REPO_DIR/CLAUDE.local.md.example"     "$REPO_DIR/CLAUDE.local.md"
[ -f "$REPO_DIR/settings.local.json" ] || cp "$REPO_DIR/settings.local.json.example" "$REPO_DIR/settings.local.json"
[ -f "$REPO_DIR/skills/shell-environment/SKILL.md" ] || cp "$REPO_DIR/skills/shell-environment/SKILL.md.example" "$REPO_DIR/skills/shell-environment/SKILL.md"

# Make scripts executable.
chmod +x "$REPO_DIR"/install.sh "$REPO_DIR"/hooks/*.sh 2>/dev/null || true

link_item() {
  local name="$1"
  local src="$REPO_DIR/$name"
  local dst="$CLAUDE_DIR/$name"
  [ -e "$src" ] || return 0
  if [ -L "$dst" ] && [ "$(readlink "$dst")" = "$src" ]; then
    echo "  ✓ $name (already linked)"; return 0
  fi
  if [ -e "$dst" ] || [ -L "$dst" ]; then
    mkdir -p "$BACKUP_DIR"; mv "$dst" "$BACKUP_DIR/"
    echo "  ↪ backed up existing $name"
  fi
  ln -s "$src" "$dst"
  echo "  → linked $name"
}

echo "Installing dotclaude → $CLAUDE_DIR"
for item in "${ITEMS[@]}"; do link_item "$item"; done

echo
echo "✅ Done."
[ -d "$BACKUP_DIR" ] && echo "   Previous files backed up to: $BACKUP_DIR"
echo "   Next: open Claude Code and install plugins (see README → Plugins)."
