# Instala o IIS
Install-WindowsFeature -Name Web-Server -IncludeManagementTools

# Habilita o RDP (Remote Desktop Protocol)
$rdpKey = "HKLM:\System\CurrentControlSet\Control\Terminal Server"
$rdpValue = "fDenyTSConnections"

# Altera o valor do registro para permitir RDP
Set-ItemProperty -Path $rdpKey -Name $rdpValue -Value 0
