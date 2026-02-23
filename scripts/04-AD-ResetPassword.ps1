param(
  [Parameter(Mandatory=$true)][string]$OutDir,
  [Parameter(Mandatory=$true)][string]$LogPath
)
Set-StrictMode -Version Latest
$ErrorActionPreference="Stop"

. "$PSScriptRoot\..\lib\Logging.ps1"
. "$PSScriptRoot\..\lib\Common.ps1"

Ensure-Admin "AD tools: exécute depuis une machine/jumpbox autorisée."
Ensure-Module "ActiveDirectory"

$user = Read-Host "SamAccountName (ex: jdupont)"
$newPass = Read-Host "Nouveau mot de passe" -AsSecureString

Write-Log $LogPath "Reset password demandé pour $user"
Set-ADAccountPassword -Identity $user -Reset -NewPassword $newPass
Set-ADUser -Identity $user -ChangePasswordAtLogon $true

Write-Log $LogPath "Password reset OK pour $user" "OK"
Write-Host "OK. Mot de passe réinitialisé + changement obligatoire à la connexion."
