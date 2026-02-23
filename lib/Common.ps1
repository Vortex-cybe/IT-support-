# lib/Common.ps1
Set-StrictMode -Version Latest

function Test-IsAdmin {
    $id = [Security.Principal.WindowsIdentity]::GetCurrent()
    $p  = New-Object Security.Principal.WindowsPrincipal($id)
    return $p.IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)
}

function Ensure-Admin {
    param([string]$Hint = "Relance PowerShell en administrateur.")
    if (-not (Test-IsAdmin)) {
        throw "Privilèges administrateur requis. $Hint"
    }
}

function Ensure-Module {
    param([Parameter(Mandatory=$true)][string]$Name)
    if (-not (Get-Module -ListAvailable -Name $Name)) {
        throw "Module requis introuvable: $Name"
    }
    Import-Module $Name -ErrorAction Stop
}
