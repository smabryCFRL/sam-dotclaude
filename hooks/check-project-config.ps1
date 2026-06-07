# dotclaude SessionStart hook (Windows) — nudge if a git repo lacks a .claude/ directory.
$cwd = (Get-Location).Path
if ((Test-Path "$cwd\.git") -and -not (Test-Path "$cwd\.claude")) {
  $msg = "dotclaude: this repo has no .claude/ - per global rules, offer to run the project-init skill before substantial work (skip for third-party clones)."
  '{"hookSpecificOutput":{"hookEventName":"SessionStart","additionalContext":"' + $msg + '"}}'
}
exit 0
