# dotclaude installer (Windows / PowerShell).
# Symlinks managed items into %USERPROFILE%\.claude, backing up anything it would replace.
# Re-runnable. Directory links use junctions (no elevation); file links use symlinks
# (may require Developer Mode or an elevated shell).
$ErrorActionPreference = "Stop"

$RepoDir   = Split-Path -Parent $MyInvocation.MyCommand.Path
$ClaudeDir = if ($env:CLAUDE_HOME) { $env:CLAUDE_HOME } else { Join-Path $env:USERPROFILE ".claude" }
$Stamp     = Get-Date -Format "yyyyMMdd-HHmmss"
$BackupDir = Join-Path $ClaudeDir "_pre-dotclaude-backup-$Stamp"

$Items = @("CLAUDE.md","CLAUDE.local.md","settings.json","settings.local.json","rules","skills","agents","hooks","templates")

New-Item -ItemType Directory -Force -Path $ClaudeDir | Out-Null

if (-not (Test-Path "$RepoDir\CLAUDE.local.md"))     { Copy-Item "$RepoDir\CLAUDE.local.md.example"     "$RepoDir\CLAUDE.local.md" }
if (-not (Test-Path "$RepoDir\settings.local.json")) { Copy-Item "$RepoDir\settings.local.json.example" "$RepoDir\settings.local.json" }
if (-not (Test-Path "$RepoDir\skills\shell-environment\SKILL.md")) { Copy-Item "$RepoDir\skills\shell-environment\SKILL.md.example" "$RepoDir\skills\shell-environment\SKILL.md" }

function Link-Item($name) {
  $src = Join-Path $RepoDir $name
  $dst = Join-Path $ClaudeDir $name
  if (-not (Test-Path $src)) { return }
  $existing = Get-Item $dst -Force -ErrorAction SilentlyContinue
  if ($existing -and $existing.Target -eq $src) { Write-Host "  OK  $name (already linked)"; return }
  if ($existing) {
    New-Item -ItemType Directory -Force -Path $BackupDir | Out-Null
    Move-Item $dst $BackupDir
    Write-Host "  ->  backed up existing $name"
  }
  if (Test-Path $src -PathType Container) {
    New-Item -ItemType Junction -Path $dst -Target $src | Out-Null
  } else {
    New-Item -ItemType SymbolicLink -Path $dst -Target $src | Out-Null
  }
  Write-Host "  ->  linked $name"
}

Write-Host "Installing dotclaude -> $ClaudeDir"
foreach ($i in $Items) { Link-Item $i }

Write-Host ""
Write-Host "Done."
if (Test-Path $BackupDir) { Write-Host "  Previous files backed up to: $BackupDir" }
Write-Host "  Note: hooks call bash; on native Windows install Git Bash/WSL, or switch the hook"
Write-Host "  commands in settings.local.json to the .ps1 variants in hooks/."
Write-Host "  Next: open Claude Code and install plugins (see README -> Plugins)."
