---
name: atlas
description: How Claude curates its own Obsidian knowledge vault ("Atlas" / the Agent vault) — capture, link, recall, and synthesize notes proactively. Use whenever working with the vault: recalling prior context, writing/updating a note, weaving links, or surfacing connections across topics.
---

# Atlas — curating your own knowledge vault

Atlas is your persistent, linked workspace. You own it: capture what matters, weave it into a graph,
recall it before new work, and mine it for connections. Be a thinking partner, not a filing cabinet —
**curate, don't dump.**

## Locate the vault
Use the **Agent vault** path from `CLAUDE.local.md`. If unset, ask the user. The vault is
**sensitive** — never commit it or copy its contents into a shared repo.

## Note anatomy
Path `<vault>/<category>/<Title>.md` — **the filename is the note's title** (Title Case, spaces OK;
strip `/ \ : * ? " < > | #`). Keep titles **unique** so links resolve. Categories: `decision · project ·
research · reference · entity · case · idea · incident · personal · moc`. Frontmatter:
```yaml
---
title: <Title>            # = the filename; keep unique so [[wikilinks]] resolve
category: <category>
tags: [<tag>, <tag>]
created: <YYYY-MM-DD>
updated: <YYYY-MM-DD>
sensitive: <true|false>
---
```
Body: open with a one-line summary, then the content as clean markdown.

## Linking is the whole point — use `[[wikilinks]]`
Obsidian links are **double brackets** and resolve to a **filename**: `[[Atlas Home]]` → `Atlas Home.md`
(not `[term]`, and not a kebab path). So keep filename == title.
- Link each note to the projects, decisions, and entities it touches: e.g. `[[dotclaude]]`, `[[Acme Corp]]`.
- If the target doesn't exist yet, the link still creates a graph node — make that note later when it
  earns one.
- Maintain **MOC (Map of Content) hub notes** in `moc/` — one per topic — that `[[link]]` the cluster
  and summarize its through-line. MOCs keep the graph navigable as it grows.

## Capture — proactively, as you work
Write or update a note when you hit something **notable**: a decision + rationale, a finding, a
reusable reference, an entity/relationship, an open question, or a genuinely useful idea. Skip trivia.
- **Dedup first:** `rg -l -i '<key terms>' "<vault>"`. Close match → **update** it (bump `updated:`,
  merge, add links) rather than duplicate.
- After writing: append to `<vault>/INDEX.md` →
  `- <date> | <category> | <Title> — <summary> [[<Title>]]`, and add `[[links]]` to/from the relevant MOC.
- **Verify** with a read-back before claiming it's saved (global rigor rule).

## Recall — proactively, before work
Before a project/decision/investigation, search and surface what's relevant:
`rg -l -i '<terms>' "<vault>"`, read the hits, follow `[[links]]` and MOCs to related notes. Ground new
work in prior context.

## Synthesize — the creative payoff
Periodically, and whenever you notice it, look **across** notes for what the user hasn't connected:
overlapping problems, a pattern repeating across projects, an idea from one domain that transfers to
another, a contradiction worth resolving. Capture these as `idea/` notes or fold them into MOCs, link
the sources, and tell the user. This is what makes the vault a thinking partner.
