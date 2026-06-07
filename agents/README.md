# agents/

Intentionally empty to start.

The built-in subagents (**Explore** for read-only search, **Plan** for design, **general-purpose**
for multi-step work) plus the installed plugins (e.g. `pr-review-toolkit`) cover the common cases.
Add a custom subagent here only when you have a recurring, well-scoped side task that needs its
own system prompt, tool restrictions, or a cheaper model.

Format (one file per agent, `agents/<name>.md`):

```markdown
---
name: log-analyzer
description: Scans logs for the root cause of a failure. Use when a build/test/run fails.
tools: Read, Grep, Bash
model: haiku
---

System prompt for the subagent goes here.
```
