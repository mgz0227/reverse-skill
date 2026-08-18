#requires -Version 5

[CmdletBinding()]
param(
    [string]$JebDir = (Join-Path $env:USERPROFILE 'Tools\JEB'),
    [string]$BridgeDir = (Join-Path $env:USERPROFILE 'Tools\mcp-remote'),
    [ValidateRange(1, 65535)]
    [int]$Port = 8425,
    [ValidateRange(1, 300)]
    [int]$StartupTimeoutSeconds = 60
)

$ErrorActionPreference = 'Stop'

function Test-JebMcpPort {
    param([int]$TargetPort)

    $client = New-Object System.Net.Sockets.TcpClient
    try {
        $async = $client.BeginConnect('127.0.0.1', $TargetPort, $null, $null)
        if (-not $async.AsyncWaitHandle.WaitOne(500, $false)) {
            return $false
        }
        $client.EndConnect($async)
        return $true
    }
    catch {
        return $false
    }
    finally {
        $client.Close()
    }
}

$appDir = Join-Path $JebDir 'bin\app'
$jebJar = Join-Path $appDir 'jeb.jar'
$jythonJar = Join-Path $appDir 'jython-standalone-2.7.3.jar'
$runner = Join-Path $PSScriptRoot 'jeb-mcp-headless.py'
$bridge = Join-Path $BridgeDir 'node_modules\mcp-remote\dist\proxy.js'
$node = Get-Command node.exe -ErrorAction SilentlyContinue | Select-Object -First 1 -ExpandProperty Source
$javaw = Get-Command javaw.exe -ErrorAction SilentlyContinue | Select-Object -First 1 -ExpandProperty Source

foreach ($requiredPath in @($jebJar, $jythonJar, $runner, $bridge)) {
    if (-not (Test-Path -LiteralPath $requiredPath -PathType Leaf)) {
        throw "Required JEB MCP file is missing: $requiredPath"
    }
}
if ([string]::IsNullOrWhiteSpace($node)) {
    throw 'node.exe is required for the JEB MCP stdio bridge.'
}
if ([string]::IsNullOrWhiteSpace($javaw)) {
    throw 'javaw.exe is required for the JEB headless MCP service.'
}

if (-not (Test-JebMcpPort -TargetPort $Port)) {
    $logDir = Join-Path $env:LOCALAPPDATA 'reverse-skill\logs'
    New-Item -ItemType Directory -Path $logDir -Force | Out-Null
    $stdoutLog = Join-Path $logDir 'jeb-mcp-headless.stdout.log'
    $stderrLog = Join-Path $logDir 'jeb-mcp-headless.stderr.log'
    $classpath = "$jebJar;$jythonJar"
    $arguments = @('-cp', ('"{0}"' -f $classpath), 'org.python.util.jython', ('"{0}"' -f $runner), [string]$Port)
    $service = Start-Process -FilePath $javaw -ArgumentList $arguments -WorkingDirectory $JebDir -WindowStyle Hidden -RedirectStandardOutput $stdoutLog -RedirectStandardError $stderrLog -PassThru

    $deadline = (Get-Date).AddSeconds($StartupTimeoutSeconds)
    while (-not (Test-JebMcpPort -TargetPort $Port) -and (Get-Date) -lt $deadline) {
        if ($service.HasExited) {
            throw "JEB headless MCP exited before opening port $Port. Logs: $stdoutLog ; $stderrLog"
        }
        Start-Sleep -Milliseconds 500
        $service.Refresh()
    }
    if (-not (Test-JebMcpPort -TargetPort $Port)) {
        throw "JEB headless MCP did not open port $Port. Logs: $stdoutLog ; $stderrLog"
    }
}

& $node $bridge "http://localhost:$Port/mcp" --transport sse-only --silent
exit $LASTEXITCODE
