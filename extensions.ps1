# Definir o caminho do arquivo de log
$logFilePath = "C:\Temp\WindowsUpdateLog.txt"

# Função para escrever logs
function Write-Log {
    param(
        [string]$message
    )
    $timestamp = (Get-Date).ToString("yyyy-MM-dd HH:mm:ss")
    $logMessage = "$timestamp - $message"
    Add-Content -Path $logFilePath -Value $logMessage
    Write-Host $logMessage  # Para também mostrar no console
}

# Início do script
Write-Log "Iniciando o processo de configuração do sistema."

# Desabilitar o Windows Update
Write-Log "Desabilitando o Windows Update."
try {
    Set-Service -Name wuauserv -StartupType Disabled -ErrorAction Stop
    Stop-Service -Name wuauserv -ErrorAction Stop
    Write-Log "Windows Update desabilitado com sucesso."
} catch {
    Write-Log "Erro ao desabilitar o Windows Update: $_"
    exit 1
}

# Instalar o IIS
Write-Log "Iniciando a instalação do IIS com as ferramentas de gerenciamento."
try {
    Install-WindowsFeature -Name Web-Server -IncludeManagementTools -ErrorAction Stop
    Write-Log "IIS instalado com sucesso."

    # Verificar se o IIS foi instalado com sucesso
    $iisFeature = Get-WindowsFeature -Name Web-Server
    if ($iisFeature.Installed) {
        Write-Log "IIS está instalado e funcionando corretamente."
    } else {
        Write-Log "Falha na instalação do IIS."
        exit 1
    }
} catch {
    Write-Log "Erro durante o processo de instalação do IIS: $_"
    exit 1
}

# Habilitar o RDP (Remote Desktop Protocol)
Write-Log "Habilitando o RDP (Remote Desktop Protocol)."
try {
    Set-ItemProperty -Path 'HKLM:\System\CurrentControlSet\Control\Terminal Server' -Name "fDenyTSConnections" -Value 0 -ErrorAction Stop
    Enable-NetFirewallRule -DisplayGroup "Remote Desktop" -ErrorAction Stop
    Write-Log "RDP habilitado com sucesso."
} catch {
    Write-Log "Erro ao habilitar o RDP: $_"
    exit 1
}

# Baixar e instalar o 7-Zip
Write-Log "Baixando e instalando o 7-Zip."
$7zipUrl = "https://www.7-zip.org/a/7z1900-x64.exe"
$downloadPath = "C:\Temp\7z1900-x64.exe"
New-Item -ItemType Directory -Force -Path "C:\Temp"
try {
    Invoke-WebRequest -Uri $7zipUrl -OutFile $downloadPath -ErrorAction Stop
    Start-Process -FilePath $downloadPath -ArgumentList "/S" -Wait
    Write-Log "7-Zip instalado com sucesso."
} catch {
    Write-Log "Erro ao baixar ou instalar o 7-Zip: $_"
    exit 1
}

# Configurar Região e Cultura para o Brasil
Write-Log "Configurando região e cultura para o Brasil."
try {
    Set-WinSystemLocale -SystemLocale "pt-BR" -ErrorAction Stop
    Set-WinHomeLocation -GeoId 32 -ErrorAction Stop
    Set-Culture -CultureInfo "pt-BR" -ErrorAction Stop
    Write-Log "Região e cultura configuradas para o Brasil."
} catch {
    Write-Log "Erro ao configurar região e cultura: $_"
    exit 1
}

# Configurar Formatos de Data e Hora
Write-Log "Configurando formatos de data e hora."
try {
    Set-WinDefaultInputMethodOverride -InputTip "0406:00000406" -ErrorAction Stop
    Set-ItemProperty -Path "HKCU:\Control Panel\International" -Name "sShortDate" -Value "dd/MM/yyyy" -ErrorAction Stop
    Set-ItemProperty -Path "HKCU:\Control Panel\International" -Name "sLongDate" -Value "dddd, d' de 'MMMM' de 'yyyy" -ErrorAction Stop
    Set-ItemProperty -Path "HKCU:\Control Panel\International" -Name "sShortTime" -Value "HH:mm" -ErrorAction Stop
    Set-ItemProperty -Path "HKCU:\Control Panel\International" -Name "sLongTime" -Value "HH:mm:ss" -ErrorAction Stop
    Set-ItemProperty -Path "HKCU:\Control Panel\International" -Name "FirstDayOfWeek" -Value "0" -ErrorAction Stop
    Write-Log "Formatos de data e hora configurados."
} catch {
    Write-Log "Erro ao configurar formatos de data e hora: $_"
    exit 1
}

# Configurar o Fuso Horário (Brasília)
Write-Log "Configurando o fuso horário para Brasília."
try {
    Set-TimeZone -Id "E. South America Standard Time" -ErrorAction Stop
    Write-Log "Fuso horário configurado para Brasília."
} catch {
    Write-Log "Erro ao configurar o fuso horário: $_"
    exit 1
}

# Baixar e instalar o .NET Hosting Bundle 8.0.8
Write-Log "Baixando e instalando o .NET Hosting Bundle 8.0.8."
$dotNetUrl = "https://download.visualstudio.microsoft.com/download/pr/ef1366bd-3111-468b-93da-17e6ccb057e1/1fac364775c1accb09b9ac5314179004/dotnet-hosting-8.0.8-win.exe"
$dotNetInstallerPath = "C:\Temp\dotnet-hosting-8.0.8-win.exe"
try {
    Invoke-WebRequest -Uri $dotNetUrl -OutFile $dotNetInstallerPath -ErrorAction Stop
    Start-Process -FilePath $dotNetInstallerPath -ArgumentList "/quiet /norestart" -Wait
    Write-Log ".NET Hosting Bundle 8.0.8 instalado com sucesso."
} catch {
    Write-Log "Erro ao baixar ou instalar o .NET Hosting Bundle: $_"
    exit 1
}

# Baixar e instalar o .NET Framework 4.8 Web Installer
Write-Log "Baixando e instalando o .NET Framework 4.8."
$dotNetFrameworkUrl = "https://download.visualstudio.microsoft.com/download/pr/2d6bb6b2-226a-4baa-bdec-798822606ff1/9b7b8746971ed51a1770ae4293618187/ndp48-web.exe"
$dotNetFrameworkPath = "C:\Temp\ndp48-web.exe"
try {
    Invoke-WebRequest -Uri $dotNetFrameworkUrl -OutFile $dotNetFrameworkPath -ErrorAction Stop
    Start-Process -FilePath $dotNetFrameworkPath -ArgumentList "/quiet /norestart" -Wait
    Write-Log ".NET Framework 4.8 instalado com sucesso."
} catch {
    Write-Log "Erro ao baixar ou instalar o .NET Framework 4.8: $_"
    exit 1
}

# Baixar e instalar o IIS URL Rewrite Module
Write-Log "Baixando e instalando o IIS URL Rewrite Module."
$rewriteModuleUrl = "https://download.microsoft.com/download/1/2/8/128E2E22-C1B9-44A4-BE2A-5859ED1D4592/rewrite_amd64_en-US.msi"
$rewriteModulePath = "C:\Temp\rewrite_amd64_en-US.msi"
try {
    Invoke-WebRequest -Uri $rewriteModuleUrl -OutFile $rewriteModulePath -ErrorAction Stop
    Start-Process -FilePath msiexec.exe -ArgumentList "/i $rewriteModulePath /quiet /norestart" -Wait
    Write-Log "IIS URL Rewrite Module instalado com sucesso."
} catch {
    Write-Log "Erro ao baixar ou instalar o IIS URL Rewrite Module: $_"
    exit 1
}

# Baixar e instalar o Web Deploy
Write-Log "Baixando e instalando o Web Deploy."
$webDeployUrl = "https://download.microsoft.com/download/b/d/8/bd882ec4-12e0-481a-9b32-0fae8e3c0b78/webdeploy_amd64_en-US.msi"
$webDeployPath = "C:\Temp\webdeploy_amd64_en-US.msi"
try {
    Invoke-WebRequest -Uri $webDeployUrl -OutFile $webDeployPath -ErrorAction Stop
    Start-Process -FilePath msiexec.exe -ArgumentList "/i $webDeployPath /quiet /norestart" -Wait
    Write-Log "Web Deploy instalado com sucesso."
} catch {
    Write-Log "Erro ao baixar ou instalar o Web Deploy: $_"
    exit 1
}

# Crystal Reports 32
Write-Log "Baixando e instalando o Crystal Reports 32."
$url = "https://multisoftware-my.sharepoint.com/personal/henrique_brito_multisoftware_com_br/_layouts/15/download.aspx?SourceUrl=%2Fpersonal%2Fhenrique%5Fbrito%5Fmultisoftware%5Fcom%5Fbr%2FDocuments%2FArquivos%20de%20Chat%20do%20Microsoft%20Teams%2FCR13SP35MSI32%5F0%2D80007712%2EMSI"
$destination = "C:\Temp\CR13SP35MSI32.msi"
try {
    Invoke-WebRequest -Uri $url -OutFile $destination -ErrorAction Stop
    Write-Log "Crystal Reports 32 instalado com sucesso."
} catch {
    Write-Log "Erro ao baixar ou instalar o Crystal Reports 32: $_"
    exit 1
}

# Crystal Reports 64
Write-Log "Baixando e instalando o Crystal Reports 64."
$url64 = "https://multisoftware-my.sharepoint.com/personal/henrique_brito_multisoftware_com_br/_layouts/15/download.aspx?SourceUrl=%2Fpersonal%2Fhenrique%5Fbrito%5Fmultisoftware%5Fcom%5Fbr%2FDocuments%2FArquivos%20de%20Chat%20do%20Microsoft%20Teams%2FCR13SP35MSI64%5F0%2D80007712%2EMSI"
$destination64 = "C:\Temp\CR13SP35MSI64.msi"
try {
    Invoke-WebRequest -Uri $url64 -OutFile $destination64 -ErrorAction Stop
    Write-Log "Crystal Reports 64 instalado com sucesso."
} catch {
    Write-Log "Erro ao baixar ou instalar o Crystal Reports 64: $_"
    exit 1
}

Write-Log "Processo de configuração concluído com sucesso."
