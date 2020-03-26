Write-Host "Inici bootstrap Windows"

$INSTALLER_URL = "https://repo.saltstack.com/windows/Salt-Minion-3000-Py2-x86-Setup.exe"
$MASTER_IP     = "10.20.2.2"
$TEMP_EXE      = "C:\WINDOWS\TEMP\Salt-Minion-Setup.exe"

$MinionIP = (
    Get-NetIPConfiguration |
    Where-Object {
        $_.IPv4DefaultGateway -ne $null -and
        $_.NetAdapter.Status -ne "Disconnected"
    }
).IPv4Address.IPAddress

$SetupArgs = "/minion-name=$MinionIP"

# $VerbosePreference = "continue"

Write-Host "Modificar fitxer host"
Get-Date
Add-Content C:\Windows\system32\drivers\etc\hosts "$MASTER_IP salt"



Write-Host "Descarregar Salt-Minion"
Write-Host "URL: $INSTALLER_URL"
Get-Date
(new-object net.webclient).DownloadFile("$INSTALLER_URL","$TEMP_EXE")

Write-Host "Executar instal·lador"
Write-Host "CMD: Start-Process -Filepath $TEMP_EXE -ArgumentList $SetupArgs -verbose"
Get-Date
Start-Process -Filepath $TEMP_EXE -ArgumentList $SetupArgs -verbose

Write-Host "Final bootstrap"
Get-Date
