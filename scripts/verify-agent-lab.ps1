[CmdletBinding()]
param(
    [ValidateSet('claude', 'codex')]
    [Parameter(Mandatory)]
    [string]$Agent
)

$ErrorActionPreference = 'Stop'
$repoRoot = Split-Path -Parent $PSScriptRoot
$target = Join-Path $repoRoot ".agent-runtime\$Agent"
if (-not (Test-Path -LiteralPath $target)) { throw "Run prepare-agent-lab.ps1 first: $target" }

Push-Location $target
try {
    python -m unittest discover -s tests -p 'test_*.py' -v
    if ($LASTEXITCODE -ne 0) { throw 'Agent Lab tests failed.' }
    $changed = @(git status --short)
    if (-not $changed) { throw 'No agent changes detected.' }
    $forbidden = @($changed | Where-Object { $_ -notmatch '^.. (src|tests)[\\/]' })
    if ($forbidden) { throw "Out-of-scope changes detected:`n$($forbidden -join "`n")" }
    $source = Get-Content -Raw -LiteralPath 'src\score_stats.py'
    if ($source -notmatch '["'']median["'']') { throw 'Median result was not found.' }
    Write-Host "[OK] $Agent lab tests and scope checks passed."
    git diff -- src tests
}
finally { Pop-Location }
