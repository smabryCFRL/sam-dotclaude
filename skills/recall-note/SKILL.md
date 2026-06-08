---
name: recall-note
description: Search and recall notes from the user's Obsidian knowledge vault. Use when the user asks "what do I have on X", "recall my notes about…", "load from my vault", "what did we decide about…", or wants past decisions, research, entities, or references surfaced.
---

# Recall notes from the Obsidian vault

Search the user's Obsidian vault (plain markdown) with ripgrep and surface relevant notes. No MCP.

## 1. Locate the vault
Use the **Agent vault** path from `CLAUDE.local.md`. If unset, ask — don't guess.

## 2. Search
- Files: `rg -l -i '<term1>|<term2>' "<vault>"`
- Context: `rg -i -n -C1 '<terms>' "<vault>"`
- By category: list `<vault>/<category>/`. By recency: tail `<vault>/INDEX.md`, or sort on the
  `created:` / `updated:` frontmatter.

## 3. Present top matches
`N. [<category>] <Title>  (<created>)  → <category>/<slug>.md` — one line each on why it matched.
Surface exact-keyword and recent hits even if sparse (new notes may not be linked yet).

## 4. Fetch on demand
`Read` the chosen note (or the top hit) and present it. Follow `[[wikilinks]]` to related notes
when useful.

## 5. No match
Say so plainly. Offer to broaden the terms or list recent notes. Never fabricate a recall.
