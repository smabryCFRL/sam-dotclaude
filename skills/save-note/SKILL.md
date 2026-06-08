---
name: save-note
description: Save a durable note to the user's Obsidian knowledge vault — a frontmatter'd markdown file the user browses in Obsidian and Claude recalls later. Use when the user says "save this", "remember this in my vault", "note this down", "add to my vault", or wants to persist a decision, finding, entity, or reference.
---

# Save a note to the Obsidian vault

Persist a durable, human-browsable note as a markdown file in the user's Obsidian vault. Plain file
I/O — no MCP, no external service.

## 1. Locate the vault
Use the **Agent vault** path from `CLAUDE.local.md`. If it isn't set, ask the user for it — and
remind them it must be a **non-cloud-synced, sensitive** location — before writing. Never guess.

## 2. Shape the note
- **Category** (→ folder): one of `decision · project · research · reference · entity · case ·
  incident · personal`, or a sensible new one. Ask if unclear.
- **Title** → **slug**: kebab-case, ≤60 chars.
- **sensitive**: `true` for anything tied to investigations, people, or non-public data.
- **Frontmatter (exact):**
  ```yaml
  ---
  title: <Title>
  category: <category>
  tags: [<tag>, <tag>]
  created: <YYYY-MM-DD>
  updated: <YYYY-MM-DD>
  source: claude-code
  sensitive: <true|false>
  ---
  ```
- **Body:** clean markdown. Use `[[wikilinks]]` to related notes/entities — Obsidian renders these
  as backlinks and graph edges (high value for connecting cases, people, and decisions).

## 3. Dedup before writing
`rg -l -i '<slug-or-key-terms>' "<vault>"`. On a close match, **update** that note (bump `updated:`,
merge content) instead of creating a duplicate.

## 4. Write
Write to `<vault>/<category>/<slug>.md` (the Write tool creates the folder).

## 5. Index it
Append one line to `<vault>/INDEX.md` (create if absent):
`- <YYYY-MM-DD> | <category> | <Title> — <one-line summary> [[<category>/<slug>]]`

## 6. Verify, then confirm
Read the file back; confirm the frontmatter + body landed; show the path as evidence (don't assert —
per the global rigor rule). Report the note path and the index line.

Never copy the vault path or note contents into a committed/shared repo — the vault is private.
