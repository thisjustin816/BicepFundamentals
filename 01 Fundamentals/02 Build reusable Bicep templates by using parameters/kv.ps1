$keyVaultName = 'toyhr52hvwc6kx2f6o-kv' # A unique name for the key vault.
$login = 'toyhruser' # The login that you used in the previous step.
$password = 'ComplexP@ss01!' # The password that you used in the previous step.

$sqlServerAdministratorLogin = ConvertTo-SecureString $login -AsPlainText -Force
$sqlServerAdministratorPassword = ConvertTo-SecureString $password -AsPlainText -Force

New-AzKeyVault -VaultName $keyVaultName -Location westus -EnabledForTemplateDeployment
Set-AzKeyVaultSecret -VaultName $keyVaultName -Name 'sqlServerAdministratorLogin' -SecretValue $sqlServerAdministratorLogin
Set-AzKeyVaultSecret -VaultName $keyVaultName -Name 'sqlServerAdministratorPassword' -SecretValue $sqlServerAdministratorPassword

( Get-AzKeyVault -Name $keyVaultName ).ResourceId