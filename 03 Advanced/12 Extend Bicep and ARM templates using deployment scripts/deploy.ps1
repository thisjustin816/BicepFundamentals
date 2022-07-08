$resourceGroupName = 'learndeploymentscript_exercise_2'
New-AzResourceGroup -Location eastus -Name $resourceGroupName

$templateFile = 'main.bicep'
$templateParameterFile = 'azuredeploy.parameters.json'
$today = Get-Date -Format 'MM-dd-yyyy'
$deploymentName = "deploymentscript-$today"

New-AzResourceGroupDeployment `
    -ResourceGroupName $resourceGroupName `
    -Name $deploymentName `
    -TemplateFile $templateFile `
    -TemplateParameterFile $templateParameterFile

$storageAccountName = (Get-AzResourceGroupDeployment -ResourceGroupName $resourceGroupName -Name $deploymentName).Outputs.storageAccountName.Value
$storageAccount = Get-AzStorageAccount -ResourceGroupName $resourceGroupName
Get-AzStorageBlob -Context $storageAccount.Context -Container config |
    Select-Object Name

Get-AzDeploymentScriptLog -ResourceGroupName $resourceGroupName -Name CopyConfigScript
