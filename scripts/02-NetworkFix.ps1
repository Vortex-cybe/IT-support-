param(
  [Parameter(Mandatory=$true)][string]$OutDir,
  [Parameter(Mandatory=$true)][string]$LogPath
)
Set-StrictMode -Version Latest
$ErrorActionPreference="Stop"

. "$PSScriptRoot\..\lib\Logging.ps1"
. "$PSScriptRoot\..\lib\Common.ps1"

Ensure-Admin "Network fix modifie la stack réseau (nécessite admin)."

Write-Log $LogPath "Flush DNS..."
ipconfig /flushdns | Out-Null

Write-Log $LogPath "Release/Renew IP..."
ipconfig /release | Out-Null
Start-Sleep -Seconds 2
ipconfig /renew | Out-Null

Write-Log $LogPath "Reset Winsock..."
netsh winsock reset | Out-Null

Write-Log $LogPath "Reset TCP/IP..."
netsh int ip reset | Out-Null

Write-Log $LogPath "Network fix terminé. Reboot recommandé." "OK"
Write-Host "Terminé. Redémarrage recommandé."
