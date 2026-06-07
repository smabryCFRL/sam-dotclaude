# Git & PR conventions

- **Branching:** for nontrivial work, branch first — never commit straight to `main`/`master` or
  other shared branches. Never `git push --force` / `-f` to a shared branch (use
  `--force-with-lease` on your own branch, deliberately).
- **Commits:** concise present-tense subject; explain *why* in the body when nontrivial. Commit or
  push only when I ask.
- **PRs:** use `gh` (`gh pr create`). Reference issues/PRs as full clickable URLs, never bare `#123`.
- **Review:** prefer the native `/code-review` skill and the `pr-review-toolkit` plugin over ad-hoc
  review; run a review before opening a PR on substantial changes.
- **Secrets:** never read or print `.env`, key files, or credentials; never commit them.
