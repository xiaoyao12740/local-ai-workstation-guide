[CmdletBinding()]
param([switch]$Detailed)

$ErrorActionPreference = "Continue"
$results = [System.Collections.Generic.List[object]]::new()

function Add-Result([string]$Status, [string]$Component, [string]$Detail) {
    $results.Add([PSCustomObject]@{ Status = $Status; Component = $Component; Detail = $Detail })
}

function Test-CommandAvailable([string]$Name) {
    return [bool](Get-Command $Name -ErrorAction SilentlyContinue)
}

function Invoke-SafeCommand([scriptblock]$Script) {
    try {
        $output = & $Script 2>&1
        $normalized = (($output -join " ") -replace "`0", "").Trim()
        return [PSCustomObject]@{ Success = ($LASTEXITCODE -eq 0); Output = $normalized }
    } catch {
        return [PSCustomObject]@{ Success = $false; Output = $_.Exception.Message }
    }
}

Write-Host "Local AI Workstation - read-only environment check" -ForegroundColor Cyan
Write-Host "No installation, deletion, configuration change, or secret-value printing is performed.`n"

$os = Get-CimInstance Win32_OperatingSystem -ErrorAction SilentlyContinue
if ($os) {
    $supportedName = $os.Caption -match 'Windows 10|Windows 11'
    $build = [int]$os.BuildNumber
    $minimumBuild = if ($os.Caption -match 'Windows 11') { 22631 } elseif ($os.Caption -match 'Windows 10') { 19045 } else { [int]::MaxValue }
    $supportedBuild = $supportedName -and ($build -ge $minimumBuild)
    $osDetail = "$($os.Caption), build $build"
    if ($supportedName -and -not $supportedBuild) {
        $osDetail += "; below the currently documented Docker Desktop baseline build $minimumBuild"
    }
    Add-Result $(if ($supportedBuild) { "OK" } else { "WARN" }) "Windows" $osDetail
} else {
    Add-Result "WARN" "Windows" "Unable to read operating-system information"
}

$systemDrive = Get-PSDrive -Name $env:SystemDrive.TrimEnd(':') -ErrorAction SilentlyContinue
if ($systemDrive) {
    $freeGiB = [math]::Round($systemDrive.Free / 1GB, 1)
    Add-Result $(if ($freeGiB -ge 20) { "OK" } else { "WARN" }) "System disk" "$freeGiB GiB free; images, WSL data, and models need additional space"
}

$cpu = Get-CimInstance Win32_Processor -ErrorAction SilentlyContinue | Select-Object -First 1
if ($cpu) {
    $enabled = [bool]$cpu.VirtualizationFirmwareEnabled
    Add-Result $(if ($enabled) { "OK" } else { "WARN" }) "Virtualization" $(if ($enabled) { "Firmware virtualization enabled" } else { "Firmware status not enabled or unavailable" })
}

$memoryGiB = if ($os) { [math]::Round($os.TotalVisibleMemorySize / 1MB, 1) } else { 0 }
if ($memoryGiB -gt 0) {
    $tier = if ($memoryGiB -lt 12) { "very small local models" } elseif ($memoryGiB -lt 24) { "start with 1B-4B Q4 models" } else { "choose by GPU/VRAM and available RAM" }
    Add-Result "INFO" "Memory" "$memoryGiB GiB visible; $tier"
}

if (Test-CommandAvailable "wsl.exe") {
    $wsl = Invoke-SafeCommand { wsl.exe --list --verbose }
    $hasVersion2 = $wsl.Success -and ($wsl.Output -match '\s2(?:\s|$)')
    $wslStatus = if ($hasVersion2) { "OK" } elseif ($wsl.Success) { "WARN" } else { "WARN" }
    $wslDetail = if ($hasVersion2) { "At least one WSL 2 distribution detected" } elseif ($wsl.Success) { "Command works, but no VERSION 2 row was detected" } else { "Command failed; installation or restart may be required" }
    Add-Result $wslStatus "WSL" $wslDetail
    $wslNames = Invoke-SafeCommand { wsl.exe --list --quiet }
    $hasUbuntu = $wslNames.Success -and ($wslNames.Output -match '(?i)Ubuntu')
    Add-Result $(if ($hasUbuntu) { "OK" } else { "WARN" }) "Ubuntu distribution" $(if ($hasUbuntu) { "Ubuntu is registered in WSL" } else { "No Ubuntu distribution was detected" })
    $wslDefaults = Invoke-SafeCommand { wsl.exe --status }
    $defaultVersion2 = $wslDefaults.Success -and ($wslDefaults.Output -match '(?i)(Default Version|默认版本)\s*:?\s*2')
    Add-Result $(if ($defaultVersion2) { "OK" } else { "INFO" }) "WSL default version" $(if ($defaultVersion2) { "New distributions default to WSL 2" } else { "Could not confirm default version 2; existing Ubuntu VERSION is checked separately" })
    if ($Detailed -and $wsl.Output) { Write-Host "WSL: $($wsl.Output)" }
} else {
    Add-Result "ERROR" "WSL" "wsl.exe was not found"
}

if (Test-CommandAvailable "docker.exe") {
    $docker = Invoke-SafeCommand { docker.exe version --format '{{.Server.Version}}' }
    Add-Result $(if ($docker.Success) { "OK" } else { "WARN" }) "Docker Engine" $(if ($docker.Success) { "Server version $($docker.Output.Trim())" } else { "CLI exists, but the Engine did not respond" })
    $compose = Invoke-SafeCommand { docker.exe compose version --short }
    Add-Result $(if ($compose.Success) { "OK" } else { "WARN" }) "Docker Compose" $(if ($compose.Success) { "Version $($compose.Output.Trim())" } else { "Compose plugin did not respond" })
    if ($docker.Success) {
        $container = Invoke-SafeCommand { docker.exe ps -a --filter 'label=com.docker.compose.service=open-webui' --format '{{.Names}}: {{.Status}}' }
        if ($container.Success -and [string]::IsNullOrWhiteSpace($container.Output)) {
            # Compatibility fallback for older/manual deployments that used a fixed container name.
            $container = Invoke-SafeCommand { docker.exe ps -a --filter 'name=^/open-webui$' --format '{{.Names}}: {{.Status}}' }
        }
        if (-not $container.Success) {
            Add-Result "WARN" "Open WebUI container" "Docker responded, but the container query failed"
        } elseif ([string]::IsNullOrWhiteSpace($container.Output)) {
            Add-Result "INFO" "Open WebUI container" "Container does not exist yet; chapter 05 creates it"
        } elseif ($container.Output -match ': Up ') {
            Add-Result "OK" "Open WebUI container" $container.Output
        } else {
            Add-Result "INFO" "Open WebUI container" "Container exists but is not running: $($container.Output)"
        }
    } else {
        Add-Result "INFO" "Open WebUI container" "State unavailable while Docker Engine is stopped"
    }
} else {
    Add-Result "ERROR" "Docker" "docker.exe was not found"
}

if (Test-CommandAvailable "ollama.exe") {
    $ollamaVersion = Invoke-SafeCommand { ollama.exe --version }
    $ollamaCliDetail = if ($ollamaVersion.Output -match '(?i)could not connect') { "Installed; version command also reports that the service is stopped" } else { $ollamaVersion.Output.Trim() }
    Add-Result "OK" "Ollama CLI" $ollamaCliDetail
    try {
        $null = Invoke-RestMethod -Uri "http://127.0.0.1:11434/api/tags" -TimeoutSec 3
        Add-Result "OK" "Ollama API" "http://127.0.0.1:11434 is responding"
    } catch {
        Add-Result "WARN" "Ollama API" "CLI exists, but the local API is not responding"
    }
} else {
    Add-Result "ERROR" "Ollama" "ollama.exe was not found"
}

try {
    $response = Invoke-WebRequest -Uri "http://127.0.0.1:3000/health" -TimeoutSec 3 -UseBasicParsing
    Add-Result $(if ($response.StatusCode -eq 200) { "OK" } else { "WARN" }) "Open WebUI" "HTTP $($response.StatusCode) from /health"
} catch {
    Add-Result "INFO" "Open WebUI health" "Not reachable on port 3000; complete chapter 05 to enable it"
}

$gpus = Get-CimInstance Win32_VideoController -ErrorAction SilentlyContinue | Select-Object -ExpandProperty Name
Add-Result "INFO" "Display adapter" $(if ($gpus) { $gpus -join "; " } else { "No adapter information returned; no acceleration is assumed" })

foreach ($tool in @("git", "python", "node", "npm")) {
    $available = Test-CommandAvailable $tool
    Add-Result "INFO" "Later tool: $tool" $(if ($available) { "Available" } else { "Not installed; not required for the V0.1 local-chat milestone" })
}

$results | Format-Table -AutoSize -Wrap
Write-Host "`nOK=ready; INFO=context or optional state; WARN=needs attention; ERROR=required V0.1 component missing."
Write-Host "GPU offload must be confirmed with 'ollama ps' while a model is loaded."
exit 0
