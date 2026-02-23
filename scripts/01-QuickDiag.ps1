param(
  [Parameter(Mandatory=$true)][string]$OutDir,
  [Parameter(Mandatory=$true)][string]$LogPath
)
Set-StrictMode -Version Latest
$ErrorActionPreference="Stop"

. "$PSScriptRoot\..\lib\Logging.ps1"

$report = Join-Path $OutDir ("Diag_{0}.txt" -f (Get-Date -Format "yyyyMMdd_HHmmss"))

Write-Log $LogPath "Génération rapport: $report"

"===== QUICK DIAG REPORT =====" | Out-File $report
"Date: $(Get-Date)" | Out-File $report -Append
"" | Out-File $report -Append

"--- System ---" | Out-File $report -Append
Get-ComputerInfo | Select-Object CsName, WindowsProductName, WindowsVersion, OsBuildNumber |
  Format-List | Out-File $report -Append

"--- Network ---" | Out-File $report -Append
ipconfig /all | Out-File $report -Append

"--- DNS Test ---" | Out-File $report -Append
try {
  Resolve-DnsName "microsoft.com" -ErrorAction Stop | Select-Object Name,Type,IPAddress | Format-Table | Out-File $report -Append
} catch {
  "DNS resolve failed: $($_.Exception.Message)" | Out-File $report -Append
}

"--- Disk ---" | Out-File $report -Append
Get-CimInstance Win32_LogicalDisk -Filter "DriveType=3" |
  Select-Object DeviceID, @{n="SizeGB";e={[math]::Round($_.Size/1GB,1)}}, @{n="FreeGB";e={[math]::Round($_.FreeSpace/1GB,1)}} |
  Format-Table | Out-File $report -Append

"--- Top CPU processes ---" | Out-File $report -Append
Get-Process | Sort-Object CPU -Descending | Select-Object -First 8 Name,CPU,Id |
  Format-Table | Out-File $report -Append

Write-Log $LogPath "Rapport OK: $report" "OK"
Write-Host "Rapport: $report"
