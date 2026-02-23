param(
  [Parameter(Mandatory=$true)][string]$OutDir,
  [Parameter(Mandatory=$true)][string]$LogPath
)
Set-StrictMode -Version Latest
$ErrorActionPreference="Stop"

. "$PSScriptRoot\..\lib\Logging.ps1"

$csv = Join-Path $OutDir ("SoftwareInventory_{0}.csv" -f (Get-Date -Format "yyyyMMdd_HHmmss"))
Write-Log $LogPath "Inventaire logiciels -> $csv"

$paths = @(
  "HKLM:\Software\Microsoft\Windows\CurrentVersion\Uninstall\*",
  "HKLM:\Software\WOW6432Node\Microsoft\Windows\CurrentVersion\Uninstall\*"
)

$items = foreach ($p in $paths) {
  Get-ItemProperty $p -ErrorAction SilentlyContinue |
    Where-Object { $_.DisplayName } |
    Select-Object @{n="Name";e={$_.DisplayName}},
                  @{n="Version";e={$_.DisplayVersion}},
                  @{n="Publisher";e={$_.Publisher}},
                  @{n="InstallDate";e={$_.InstallDate}}
}

$items | Sort-Object Name -Unique | Export-Csv -NoTypeInformation -Encoding UTF8 -Path $csv
Write-Log $LogPath "Inventaire OK" "OK"
Write-Host "CSV: $csv"
