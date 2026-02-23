# IT Support Pro Toolkit (PowerShell)

Toolkit Helpdesk / Support IT Niveau 1 avec logs, rapports, scripts AD, diagnostic réseau et inventaire.

## Prérequis
- Windows 10/11
- PowerShell 5+ (ou PowerShell 7)
- Pour les scripts AD : module **ActiveDirectory** (RSAT) + droits AD

## Lancer (recommandé)
1) Dézipper
2) Ouvrir PowerShell **en administrateur** dans le dossier
3) (Si nécessaire) autoriser l'exécution locale :
   `Set-ExecutionPolicy -Scope CurrentUser RemoteSigned`
4) Lancer le menu :
   `.\Run-Toolkit.ps1`

## Scripts inclus
- Quick Diag : génère un rapport complet poste/réseau
- Network Fix : flush DNS, renew IP, reset winsock/tcpip
- Cleanup : temp + maintenance soft
- AD Reset Password : reset + force change at next login
- AD Unlock User : déverrouillage compte
- Software Inventory : export CSV des logiciels installés

## Output
Tout est généré dans `output/` (rapports + logs).

## Notes sécurité
- Les scripts AD doivent être exécutés sur une machine autorisée (RSAT) et avec les droits nécessaires.
- NetworkFix et Cleanup demandent les droits admin.
