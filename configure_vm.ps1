# Criar um arquivo de log na área de trabalho
Write-Host "Criando o arquivo de log na área de trabalho..."
$logPath = "$([Environment]::GetFolderPath('Desktop'))\system_config.log"
New-Item -Path $logPath -ItemType File
Write-Host "Arquivo de log criado em: $logPath"

# Alterar a senha da VM
Write-Host "Iniciando alteração da senha do usuário 'Administrador'..."

$NewPassword = "minhasenha"
$adminUser = "Administrador"

Write-Host "Definindo nova senha para o usuário '$adminUser'..."

# Obtendo o usuário local 'Administrador'
$admin = Get-LocalUser -Name $adminUser

# Alterando a senha
Write-Host "Alterando a senha..."
$admin | Set-LocalUser -Password (ConvertTo-SecureString -AsPlainText $NewPassword -Force)

Write-Host "Senha alterada com sucesso para o usuário '$adminUser'."

# Confirmar a alteração
$admin = Get-LocalUser -Name $adminUser
Write-Host "Novo status do usuário '$adminUser':"
Write-Host "Nome do usuário: $($admin.Name)"
Write-Host "Senha alterada: Sim"
