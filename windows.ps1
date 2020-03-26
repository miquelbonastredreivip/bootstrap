Write-Host "Inici bootstrap Windows"

$INSTALLER_URL = "https://repo.saltstack.com/windows/Salt-Minion-3000-Py2-x86-Setup.exe"
$MASTER_IP     = "10.20.2.2"
$TEMP_EXE      = "C:\TEMP\Salt-Minion-Setup.exe"

$VerbosePreference = "continue"

Write-Host "Modificar fitxer host"
Get-Date
Add-Content C:\Windows\system32\drivers\etc\hosts "$MASTER_IP salt"

Write-Host "Descarregar Salt-Minion"
Get-Date
(new-object net.webclient).DownloadFile("$INSTALLER_URL","$TEMP_EXE")

Write-Host "Executar instal·lador"
Get-Date
Start-Process -Filepath $TEMP_EXE

Write-Host "Final bootstrap"
Get-Date
