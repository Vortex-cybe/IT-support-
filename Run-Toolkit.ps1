# Run-Toolkit.ps1
Set-StrictMode -Version Latest
$ErrorActionPreference = "Stop"

. "$PSScriptRoot\lib\Logging.ps1"
. "$PSScriptRoot\lib\Common.ps1"

$OutDir = Join-Path $PSScriptRoot "output"
$Log = New-LogFile -BaseDir $OutDir -Prefix "toolkit"

Write-Log -Path $Log -Level INFO -Message "Support IT Pro Toolkit démarré."

function Run-Script {
    param([string]$ScriptName)
    $path = Join-Path $PSScriptRoot "scripts\$ScriptName"
    if (-not (Test-Path $path)) { throw "Script introuvable: $path" }
    Write-Log -Path $Log -Level INFO -Message "Execution: $ScriptName"
    & $path -OutDir $OutDir -LogPath $Log
    Write-Log -Path $Log -Level OK -Message "Terminé: $ScriptName"
}

while ($true) {
    Write-Host ""
    Write-Host "=== Support IT Pro Toolkit ==="
    Write-Host "1) Quick Diag (rapport poste)"
    Write-Host "2) Network Fix (DNS/IP/Winsock)"
    Write-Host "3) Cleanup Workstation (temp/cache)"
    Write-Host "4) AD Reset Password (admin)"
    Write-Host "5) AD Unlock User (admin)"
    Write-Host "6) Software Inventory (CSV)"
    Write-Host "0) Quit"
    $c = Read-Host "Choix"

    try {
        switch ($c) {
            "1" { Run-Script "01-QuickDiag.ps1" }
            "2" { Run-Script "02-NetworkFix.ps1" }
            "3" { Run-Script "03-CleanupWorkstation.ps1" }
            "4" { Run-Script "04-AD-ResetPassword.ps1" }
            "5" { Run-Script "05-AD-UnlockUser.ps1" }
            "6" { Run-Script "06-Inventory-Software.ps1" }
            "0" { Write-Log -Path $Log -Level INFO -Message "Quit."; break }
            default { Write-Host "Choix invalide." }
        }
    } catch {
        Write-Log -Path $Log -Level ERROR -Message $_.Exception.Message
    }
}
