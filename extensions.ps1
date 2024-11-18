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

# Definir Região (Brasil)
Set-WinSystemLocale -SystemLocale "pt-BR"
Set-WinHomeLocation -GeoId 32
# Definir a Cultura (Brasil)
Set-Culture -CultureInfo "pt-BR"
# Configurar Formatos de Data e Hora
Set-WinDefaultInputMethodOverride -InputTip "0406:00000406"
Set-ItemProperty -Path "HKCU:\Control Panel\International" -Name "sShortDate" -Value "dd/MM/yyyy"
Set-ItemProperty -Path "HKCU:\Control Panel\International" -Name "sLongDate" -Value "dddd, d' de 'MMMM' de 'yyyy"
# Formato de Hora Curto e Longo
Set-ItemProperty -Path "HKCU:\Control Panel\International" -Name "sShortTime" -Value "HH:mm"
Set-ItemProperty -Path "HKCU:\Control Panel\International" -Name "sLongTime" -Value "HH:mm:ss"
# Definir o primeiro dia da semana (Domingo)
Set-ItemProperty -Path "HKCU:\Control Panel\International" -Name "FirstDayOfWeek" -Value "0"
# Configurar o Fuso Horário (Brasília)
Set-TimeZone -Id "E. South America Standard Time"

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

# Baixar e instalar o Web Deploy
$webDeployUrl = "https://download.microsoft.com/download/b/d/8/bd882ec4-12e0-481a-9b32-0fae8e3c0b78/webdeploy_amd64_en-US.msi"
$webDeployPath = "C:\Temp\webdeploy_amd64_en-US.msi"
Invoke-WebRequest -Uri $webDeployUrl -OutFile $webDeployPath
Start-Process -FilePath msiexec.exe -ArgumentList "/i $webDeployPath /quiet /norestart" -Wait

# Crystal Reports 32
$url = "https://multisoftware-my.sharepoint.com/personal/henrique_brito_multisoftware_com_br/_layouts/15/download.aspx?SourceUrl=%2Fpersonal%2Fhenrique%5Fbrito%5Fmultisoftware%5Fcom%5Fbr%2FDocuments%2FArquivos%20de%20Chat%20do%20Microsoft%20Teams%2FCR13SP35MSI32%5F0%2D80007712%2EMSI"
$destination = "C:\Temp\CR13SP35MSI32.msi"
Invoke-WebRequest -Uri $url -OutFile $destination

# Crystal Reports 64
$url64 = "https://multisoftware-my.sharepoint.com/personal/henrique_brito_multisoftware_com_br/_layouts/15/download.aspx?SourceUrl=%2Fpersonal%2Fhenrique%5Fbrito%5Fmultisoftware%5Fcom%5Fbr%2FDocuments%2FArquivos%20de%20Chat%20do%20Microsoft%20Teams%2FCR13SP35MSI64%5F0%2D80007712%2EMSI"
$destination64 = "C:\Temp\CR13SP35MSI64.msi"
Invoke-WebRequest -Uri $url64 -OutFile $destination64

# Limpar arquivos temporários
Remove-Item -Path "C:\Temp\*" -Force -Recurse
