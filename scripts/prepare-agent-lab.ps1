[CmdletBinding()]
param(
    [ValidateSet('claude', 'codex', 'all')]
    [string]$Agent = 'all',
    [switch]$Force
)

$ErrorActionPreference = 'Stop'
$repoRoot = Split-Path -Parent $PSScriptRoot
$template = Join-Path $repoRoot 'examples\agent-lab\template'
$runtimeRoot = Join-Path $repoRoot '.agent-runtime'
$targets = if ($Agent -eq 'all') { @('claude', 'codex') } else { @($Agent) }

if (-not (Test-Path -LiteralPath $template)) { throw "Template not found: $template" }
New-Item -ItemType Directory -Path $runtimeRoot -Force | Out-Null

foreach ($name in $targets) {
    $target = Join-Path $runtimeRoot $name
    if (Test-Path -LiteralPath $target) {
        if (-not $Force) { throw "Runtime already exists: $target. Re-run with -Force only if you intend to replace this disposable copy." }
        $resolvedRuntime = (Resolve-Path -LiteralPath $runtimeRoot).Path
        $resolvedTarget = (Resolve-Path -LiteralPath $target).Path
        if (-not $resolvedTarget.StartsWith($resolvedRuntime + [IO.Path]::DirectorySeparatorChar)) { throw 'Refusing unsafe target.' }
        Remove-Item -LiteralPath $resolvedTarget -Recurse -Force
    }
    Copy-Item -LiteralPath $template -Destination $target -Recurse
    Get-ChildItem -LiteralPath $target -Directory -Filter '__pycache__' -Recurse -ErrorAction SilentlyContinue |
        Remove-Item -Recurse -Force
    Push-Location $target
    try {
        git init -q
        git add README.md AGENT_TASK.md src tests
        git -c user.name='Agent Lab Baseline' -c user.email='agent-lab@example.invalid' commit -q -m 'test: establish safe agent lab baseline'
    }
    finally { Pop-Location }
    Write-Host "[OK] Prepared isolated $name lab: $target"
}
