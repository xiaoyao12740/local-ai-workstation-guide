[CmdletBinding()]
param()

$ErrorActionPreference = 'Stop'
$root = Split-Path -Parent $PSScriptRoot
$extensions = @('.md', '.py', '.ps1', '.sh', '.yml', '.yaml', '.json', '.toml')
$failures = [System.Collections.Generic.List[string]]::new()
$checked = 0

Get-ChildItem -LiteralPath $root -Recurse -File | Where-Object {
    $extensions -contains $_.Extension.ToLowerInvariant() -and
    $_.FullName -notmatch '[\\/](\.git|\.venv|\.agent-runtime|node_modules|__pycache__)[\\/]'
} | ForEach-Object {
    $checked++
    $lineNumber = 0
    foreach ($line in [System.IO.File]::ReadLines($_.FullName, [System.Text.Encoding]::UTF8)) {
        $lineNumber++
        if ($line.Contains([char]0xFFFD)) {
            $failures.Add("$($_.FullName):$lineNumber contains U+FFFD")
        }
        if ($line -match '\?{3,}') {
            $failures.Add("$($_.FullName):$lineNumber contains 3+ consecutive ASCII question marks")
        }
        $questionCount = ([regex]::Matches($line, '\?')).Count
        if ($line.Length -ge 12 -and $questionCount -ge 5 -and ($questionCount / $line.Length) -ge 0.25) {
            $failures.Add("$($_.FullName):$lineNumber has suspicious question-mark density")
        }
    }
}

if ($failures.Count) {
    $failures | Sort-Object -Unique | ForEach-Object { Write-Error $_ }
    exit 1
}

Write-Host "Text integrity check passed. Files checked: $checked"
