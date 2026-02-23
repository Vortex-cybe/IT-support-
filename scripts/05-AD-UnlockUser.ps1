param(
  [Parameter(Mandatory=$true)][string]$OutDir,
  [Parameter(Mandatory=$true)][string]$LogPath
)
Set-StrictMode -Version Latest
$ErrorActionPreference="Stop"

. "$PSScriptRoot\..\lib\Logging.ps1"
. "$PSScriptRoot\..\lib\Common.ps1"

Ensure-Admin
Ensure-Module "ActiveDirectory"

$user = Read-Host "SamAccountName (ex: jdupont)"
Write-Log $LogPath "Unlock demandé pour $user"

Unlock-ADAccount -Identity $user

Write-Log $LogPath "Unlock OK pour $user" "OK"
Write-Host "OK. Compte déverrouillé."
