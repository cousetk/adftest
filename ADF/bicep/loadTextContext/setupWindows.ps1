Write-Output "Start: [$(Get-Date)]"
Invoke-WebRequest -Uri https://github.com/PowerShell/PowerShell/releases/download/v7.3.4/PowerShell-7.3.4-win-x64.msi -OutFile PowerShell-7.3.4-win-x64.msi
msiexec.exe /package PowerShell-7.3.4-win-x64.msi /log logfile.txt /quiet ADD_EXPLORER_CONTEXT_MENU_OPENPOWERSHELL=1 ADD_FILE_CONTEXT_MENU_RUNPOWERSHELL=1 ENABLE_PSREMOTING=1 REGISTER_MANIFEST=1 USE_MU=1 ENABLE_MU=1 ADD_PATH=1