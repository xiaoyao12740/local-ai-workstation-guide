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
    Get-ChildItem -Path 'src','tests' -Directory -Filter '__pycache__' -Recurse -ErrorAction SilentlyContinue |
        Remove-Item -Recurse -Force
    $changed = @(git status --short | Where-Object { $_ -notmatch '__pycache__|\.pyc$' })
    if (-not $changed) { throw 'No agent changes detected.' }
    $forbidden = @($changed | Where-Object { $_ -notmatch '^.. (src|tests)[\\/]' })
    if ($forbidden) { throw "Out-of-scope changes detected:`n$($forbidden -join "`n")" }
    $source = Get-Content -Raw -LiteralPath 'src\score_stats.py'
    if ($source -notmatch '["'']median["'']') { throw 'Median result was not found.' }
    $acceptanceProbe = @'
import importlib.util
from pathlib import Path

module_path = Path("src/score_stats.py")
spec = importlib.util.spec_from_file_location("agent_lab_score_stats", module_path)
module = importlib.util.module_from_spec(spec)
spec.loader.exec_module(module)

odd = module.score_stats([9, 1, 5])
assert odd["median"] == 5
assert odd["mean"] == 5
assert odd["minimum"] == 1
assert odd["maximum"] == 9

even = module.score_stats([1, 2, 3, 4])
assert even["median"] == 2.5
assert module.score_stats([2, 2, 9])["median"] == 2

try:
    module.score_stats([])
except ValueError:
    pass
else:
    raise AssertionError("empty input must raise ValueError")
'@
    $acceptanceProbe | python -
    if ($LASTEXITCODE -ne 0) { throw 'Repository-controlled semantic acceptance probe failed.' }
    Write-Host "[OK] $Agent tests, repository-controlled semantic acceptance, and scope checks passed."
    git diff -- src tests ':(exclude)**/__pycache__/**' ':(exclude)**/*.pyc'
}
finally { Pop-Location }
