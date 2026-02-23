# lib/Logging.ps1
Set-StrictMode -Version Latest

function New-LogFile {
    param(
        [Parameter(Mandatory=$true)][string]$BaseDir,
        [Parameter(Mandatory=$true)][string]$Prefix
    )
    if (-not (Test-Path $BaseDir)) { New-Item -ItemType Directory -Path $BaseDir | Out-Null }
    $ts = Get-Date -Format "yyyyMMdd_HHmmss"
    return Join-Path $BaseDir "$Prefix`_$ts.log"
}

function Write-Log {
    param(
        [Parameter(Mandatory=$true)][string]$Path,
        [Parameter(Mandatory=$true)][string]$Message,
        [ValidateSet("INFO","WARN","ERROR","OK")][string]$Level="INFO"
    )
    $line = "{0} [{1}] {2}" -f (Get-Date -Format "yyyy-MM-dd HH:mm:ss"), $Level, $Message
    Add-Content -Path $Path -Value $line
    Write-Host $line
}
