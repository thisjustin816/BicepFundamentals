@description('The unique name of the solution. This is used to ensure that resource names are unique.')
@minLength(5)
@maxLength(30)
param solutionName string = 'toyhr${uniqueString(resourceGroup().id)}'

@description('The Azure region into which the resources should be deployed.')
param location string = 'westus'

var keyVaultName = '${solutionName}-vault'
var tenantId = subscription().tenantId

resource keyVault 'Microsoft.KeyVault/vaults@2021-11-01-preview' = {
  name: keyVaultName
  location: location
  properties: {
    sku: {
      family: 'A'
      name: 'standard'
    }
    tenantId: tenantId
    accessPolicies: [
      {
        tenantId: tenantId
        //objectId: '3b39bd60-976d-4127-b032-ad7b4ea9228c'
        objectId: guid(resourceGroup().id)
        permissions: {
          keys: [
            'all'
          ]
          secrets: [
            'get'
            'list'
            'set'
            'delete'
            'backup'
            'restore'
            'recover'
          ]
          certificates: [
            'get'
            'delete'
            'list'
            'create'
            'import'
            'update'
            'deleteissuers'
            'getissuers'
            'listissuers'
            'managecontacts'
            'manageissuers'
            'setissuers'
            'recover'
            'backup'
            'restore'
          ]
          storage: [
            'delete'
            'deletesas'
            'get'
            'getsas'
            'list'
            'listsas'
            'regeneratekey'
            'set'
            'setsas'
            'update'
            'recover'
            'backup'
            'restore'
          ]
        }
      }
    ]
    enabledForTemplateDeployment: true
  }
}

resource sqlServerAdministratorLogin 'Microsoft.KeyVault/vaults/secrets@2021-11-01-preview' = {
  parent: keyVault
  name: 'sqlServerAdministratorLogin'
  properties: {
    value: 'toyhruser'
    attributes: {
      enabled: true
    }
  }
}

resource sqlServerAdministratorPassword 'Microsoft.KeyVault/vaults/secrets@2021-11-01-preview' = {
  parent: keyVault
  name: 'sqlServerAdministratorPassword'
  properties: {
    value: 'ComplexP@ss01'
    attributes: {
      enabled: true
    }
  }
}
