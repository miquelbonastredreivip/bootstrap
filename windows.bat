SET INSTALLER_URL=https://repo.saltstack.com/windows/Salt-Minion-3000-Py2-x86-Setup.exe
SET MASTER_IP=10.20.2.2

Add-Content C:\Windows\system32\drivers\etc\hosts %MASTER_IP% salt
Invoke-Expression ((new-object net.webclient).DownloadString('%INSTALLER_URL'))
