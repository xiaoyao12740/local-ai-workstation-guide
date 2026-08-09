# Backward-compatible entry point. The unified checker is authoritative.
[CmdletBinding()]
param([switch]$Detailed)

$checker = Join-Path $PSScriptRoot "check-environment.ps1"
& $checker -Detailed:$Detailed
exit $LASTEXITCODE
