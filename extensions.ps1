# Liberar WinRM
Write-Host "Delete any existing WinRM listeners"
winrm delete winrm/config/listener?Address=*+Transport=HTTP  2>$Null
winrm delete winrm/config/listener?Address=*+Transport=HTTPS 2>$Null

Write-Host "Create a new WinRM listener and configure"
winrm create winrm/config/listener?Address=*+Transport=HTTP
winrm set winrm/config/winrs '@{MaxMemoryPerShellMB="0"}'
winrm set winrm/config '@{MaxTimeoutms="7200000"}'
winrm set winrm/config/service '@{AllowUnencrypted="true"}'
winrm set winrm/config/service '@{MaxConcurrentOperationsPerUser="12000"}'
winrm set winrm/config/service/auth '@{Basic="true"}'
winrm set winrm/config/client/auth '@{Basic="true"}'

Write-Host "Configure UAC to allow privilege elevation in remote shells"
$Key = 'HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System'
$Setting = 'LocalAccountTokenFilterPolicy'
Set-ItemProperty -Path $Key -Name $Setting -Value 1 -Force

Write-Host "turn off PowerShell execution policy restrictions"
Set-ExecutionPolicy -ExecutionPolicy Bypass -Scope LocalMachine

Write-Host "Configure and restart the WinRM Service; Enable the required firewall exception"
Stop-Service -Name WinRM
Set-Service -Name WinRM -StartupType Automatic
netsh advfirewall firewall set rule name="Windows Remote Management (HTTP-In)" new action=allow localip=any remoteip=any
Start-Service -Name WinRM

# Desabilitar o Windows Update
Set-Service -Name wuauserv -StartupType Disabled
Stop-Service -Name wuauserv

# Instala o IIS
Install-WindowsFeature -Name Web-Server -IncludeManagementTools

# Habilita o RDP (Remote Desktop Protocol)
Set-ItemProperty -Path 'HKLM:\System\CurrentControlSet\Control\Terminal Server'-name "fDenyTSConnections" -Value 0
Enable-NetFirewallRule -DisplayGroup "Remote Desktop"

# Baixar e instalar o 7-Zip
$7zipUrl = "https://www.7-zip.org/a/7z1900-x64.exe"
$downloadPath = "C:\Temp\7z1900-x64.exe"
New-Item -ItemType Directory -Force -Path "C:\Temp"
Invoke-WebRequest -Uri $7zipUrl -OutFile $downloadPath
Start-Process -FilePath $downloadPath -ArgumentList "/S" -Wait

# Baixar e instalar o .NET Hosting Bundle 8.0.8
$dotNetUrl = "https://download.visualstudio.microsoft.com/download/pr/ef1366bd-3111-468b-93da-17e6ccb057e1/1fac364775c1accb09b9ac5314179004/dotnet-hosting-8.0.8-win.exe"
$dotNetInstallerPath = "C:\Temp\dotnet-hosting-8.0.8-win.exe"
Invoke-WebRequest -Uri $dotNetUrl -OutFile $dotNetInstallerPath
Start-Process -FilePath $dotNetInstallerPath -ArgumentList "/quiet /norestart" -Wait

# Baixar e instalar o .NET Framework 4.8 Web Installer
$dotNetFrameworkUrl = "https://download.visualstudio.microsoft.com/download/pr/2d6bb6b2-226a-4baa-bdec-798822606ff1/9b7b8746971ed51a1770ae4293618187/ndp48-web.exe"
$dotNetFrameworkPath = "C:\Temp\ndp48-web.exe"
Invoke-WebRequest -Uri $dotNetFrameworkUrl -OutFile $dotNetFrameworkPath
Start-Process -FilePath $dotNetFrameworkPath -ArgumentList "/quiet /norestart" -Wait

# Baixar e instalar o IIS URL Rewrite Module
$rewriteModuleUrl = "https://download.microsoft.com/download/1/2/8/128E2E22-C1B9-44A4-BE2A-5859ED1D4592/rewrite_amd64_en-US.msi"
$rewriteModulePath = "C:\Temp\rewrite_amd64_en-US.msi"
Invoke-WebRequest -Uri $rewriteModuleUrl -OutFile $rewriteModulePath
Start-Process -FilePath msiexec.exe -ArgumentList "/i $rewriteModulePath /quiet /norestart" -Wait
