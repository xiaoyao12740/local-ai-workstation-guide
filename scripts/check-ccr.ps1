[CmdletBinding()]
param()

$ErrorActionPreference = 'Stop'
$ports = 3456, 3458
$listeners = @(Get-NetTCPConnection -State Listen -LocalPort $ports -ErrorAction SilentlyContinue)

foreach ($port in $ports) {
    $matches = @($listeners | Where-Object LocalPort -eq $port)
    if (-not $matches) {
        Write-Host "[INFO] CCR port $port is not listening."
        continue
    }
    foreach ($listener in $matches) {
        $safe = $listener.LocalAddress -in @('127.0.0.1', '::1')
        $label = if ($safe) { 'OK' } else { 'WARN' }
        Write-Host "[$label] CCR port $port listener: $($listener.LocalAddress) (PID $($listener.OwningProcess))"
    }
}

try {
    $response = Invoke-WebRequest -UseBasicParsing -MaximumRedirection 0 -TimeoutSec 3 http://127.0.0.1:3458/ -ErrorAction Stop
    $status = [int]$response.StatusCode
    if ($status -ge 200 -and $status -lt 400) {
        Write-Host "[OK] CCR management endpoint HTTP $status."
    }
    else {
        Write-Host "[WARN] CCR management endpoint returned unexpected HTTP $status."
    }
}
catch {
    if ($_.Exception.Response) {
        $status = [int]$_.Exception.Response.StatusCode
        if ($status -in @(401, 403)) {
            Write-Host "[INFO] CCR management endpoint HTTP $status; authentication protection may be expected."
        }
        elseif ($status -in @(400, 404)) {
            Write-Host "[WARN] CCR management endpoint HTTP $status; verify the current management path and version."
        }
        elseif ($status -ge 500) {
            Write-Host "[WARN] CCR management endpoint HTTP $status; the service responded with a server error."
        }
        else {
            Write-Host "[WARN] CCR management endpoint returned unexpected HTTP $status."
        }
    }
    else {
        Write-Host '[INFO] CCR management endpoint is not reachable.'
    }
}

Write-Host '[INFO] This check never prints management URLs, tokens, provider keys, databases, or request bodies.'
