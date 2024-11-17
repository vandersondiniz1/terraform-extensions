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

#Configurando Região/Data/Hora
Set-WinUILanguageOverride -Language pt-BR
Set-WinLocale -SystemLocale pt-BR
Set-Culture -CultureInfo pt-BR
Set-WinHomeLocation -GeoId 29
Set-TimeZone -Id "E. South America Standard Time"
