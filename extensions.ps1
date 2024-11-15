# Instala o IIS
Install-WindowsFeature -Name Web-Server -IncludeManagementTools

# Habilita o RDP (Remote Desktop Protocol)
$rdpKey = "HKLM:\System\CurrentControlSet\Control\Terminal Server"
$rdpValue = "fDenyTSConnections"
Set-ItemProperty -Path $rdpKey -Name $rdpValue -Value 0

# Baixar e instalar o 7-Zip
$7zipUrl = "https://www.7-zip.org/a/7z1900-x64.exe"
$downloadPath = "C:\Temp\7z1900-x64.exe"
New-Item -ItemType Directory -Force -Path "C:\Temp"
Invoke-WebRequest -Uri $7zipUrl -OutFile $downloadPath
Start-Process -FilePath $downloadPath -ArgumentList "/S" -Wait
