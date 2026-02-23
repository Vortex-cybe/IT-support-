param(
  [Parameter(Mandatory=$true)][string]$OutDir,
  [Parameter(Mandatory=$true)][string]$LogPath
)
Set-StrictMode -Version Latest
$ErrorActionPreference="Stop"

. "$PSScriptRoot\..\lib\Logging.ps1"
. "$PSScriptRoot\..\lib\Common.ps1"

Ensure-Admin "Cleanup nécessite l'accès à certains dossiers système."

function SafeRemove {
  param([string]$Path)
  if (Test-Path $Path) {
    Write-Log $LogPath "Suppression: $Path"
    Remove-Item -Path $Path -Recurse -Force -ErrorAction SilentlyContinue
  } else {
    Write-Log $LogPath "Absent: $Path" "WARN"
  }
}

SafeRemove "C:\Windows\Temp\*"
SafeRemove "$env:TEMP\*"

Write-Log $LogPath "Nettoyage composants Windows (soft)..." "INFO"
try { Dism.exe /Online /Cleanup-Image /StartComponentCleanup | Out-Null } catch {}

Write-Log $LogPath "Flush DNS..." "INFO"
ipconfig /flushdns | Out-Null

Write-Log $LogPath "Cleanup terminé." "OK"
Write-Host "Cleanup terminé."
