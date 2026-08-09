$ErrorActionPreference = "Stop"
$root = (Resolve-Path (Join-Path $PSScriptRoot "..")).Path

$patterns = @{
    OpenAIStyleKey = "sk-[A-Za-z0-9_-]{16,}"
    GitHubToken    = "gh[pousr]_[A-Za-z0-9]{20,}"
    AWSAccessKey   = "AKIA[0-9A-Z]{16}"
    GoogleAPIKey   = "AIza[0-9A-Za-z_-]{30,}"
    BearerToken    = "Bearer\s+[A-Za-z0-9._~-]{20,}"
}

$forbiddenExtensions = @(
    ".gguf", ".safetensors", ".vhd", ".vhdx", ".qcow2",
    ".key", ".pem", ".p12", ".token", ".sqlite", ".sqlite3"
)

$files = Get-ChildItem -LiteralPath $root -Recurse -File |
    Where-Object { $_.FullName -notmatch "[\\/]\.git[\\/]" }

$findings = @()
foreach ($file in $files) {
    if ($file.Extension -in $forbiddenExtensions) {
        $findings += [PSCustomObject]@{
            File = $file.FullName.Substring($root.Length + 1)
            Type = "Forbidden file type"
        }
        continue
    }

    if ($file.Length -gt 2MB) { continue }
    $content = Get-Content -LiteralPath $file.FullName -Raw -ErrorAction SilentlyContinue
    foreach ($name in $patterns.Keys) {
        if ($content -match $patterns[$name]) {
            $findings += [PSCustomObject]@{
                File = $file.FullName.Substring($root.Length + 1)
                Type = $name
            }
        }
    }
}

if ($findings.Count -gt 0) {
    $findings | Format-Table -AutoSize
    Write-Error "Potential secret or forbidden artifact detected. Values were not printed."
}

Write-Host "Secret scan passed. Files checked: $($files.Count)" -ForegroundColor Green
