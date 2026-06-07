# dotclaude PreToolUse guard (Windows). Exit code 2 = block the tool call.
$raw = [Console]::In.ReadToEnd()
try { $j = $raw | ConvertFrom-Json } catch { exit 0 }

$cmd  = $j.tool_input.command
$path = $j.tool_input.file_path
if (-not $path) { $path = $j.tool_input.path }

function Block($m) { [Console]::Error.WriteLine("dotclaude guard: $m"); exit 2 }

if ($cmd) {
  if ($cmd -match 'rm\s+-rf\s+[/~]')                 { Block "refusing rm -rf on a root/home path" }
  if ($cmd -match 'git\s+push.*(--force|\s-f\b)')    { Block "refusing force-push to a shared branch" }
  if ($cmd -match 'Remove-Item.*-Recurse.*-Force.*[\\/]\s*$') { Block "refusing recursive force-delete of a root path" }
}
if ($path) {
  if ($path -match '\.env\.(example|sample|template)$') { exit 0 }
  if ($path -match '(\.env$|\.env\.|[\\/]\.env$|id_rsa|\.pem$|\.p12$|\.key$|[\\/]\.aws[\\/]credentials)') {
    Block "refusing to read a secret file: $path"
  }
}
exit 0
