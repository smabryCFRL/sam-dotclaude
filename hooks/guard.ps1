# dotclaude PreToolUse guard (Windows) — a backstop against obvious footguns (NOT a sandbox).
# Exit code 2 = block the tool call.
$raw = [Console]::In.ReadToEnd()
try { $j = $raw | ConvertFrom-Json } catch { exit 0 }

$cmd  = $j.tool_input.command
$path = $j.tool_input.file_path
if (-not $path) { $path = $j.tool_input.path }

function Block($m) { [Console]::Error.WriteLine("dotclaude guard: $m"); exit 2 }

if ($cmd) {
  # rm -rf targeting / /* ~ (deep paths allowed)
  if ($cmd -match 'rm\s+-[rf]+\s+(/|/\*|~)(\s|$)') { Block "refusing rm -rf on a root/home path" }
  # force-push, but allow the safe --force-with-lease
  if ($cmd -match 'git\s+push' -and $cmd -match '(--force(?!-with-lease)|\s-f(\s|$))') { Block "refusing force-push to a shared branch" }
  if ($cmd -match 'Remove-Item.*-Recurse.*-Force.*[\\/]\s*$') { Block "refusing recursive force-delete of a root path" }
}
if ($path) {
  if ($path -match '\.env\.(example|sample|template)$') { exit 0 }
  if ($path -match '(\.env$|\.env\.|[\\/]\.env$|id_rsa|\.pem$|\.p12$|\.key$|[\\/]\.aws[\\/]credentials)') {
    Block "refusing to read a secret file: $path"
  }
}
exit 0
