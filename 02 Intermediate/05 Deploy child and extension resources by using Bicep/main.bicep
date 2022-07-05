@description('Account to create the database in.')
param cosmosDbAccountName string = 'toyrnd-${uniqueString(resourceGroup().id)}'

@description('The throughput of the database resources.')
param cosmosDbDatabaseThroughput int = 400

@description('Location to deploy resources to.')
param location string = resourceGroup().location

@description('The name of the existing sotrage account.')
param storageAccountName string

var cosmosDbDatabaseName = 'FlightTests'
var cosmosDbContainerPartitionKey = '/droneId'
var logAnalyticsWorkspaceName = 'ToyLogs'
var cosmosDbAccountDiagnosticsSettingsName = 'route-logs-to-log-analytics'
var storageAccountBlobDiagnosticSettingsName = 'route-logs-to-log-analytics'

resource cosmosDbAccount 'Microsoft.DocumentDB/databaseAccounts@2020-04-01' = {
  name: cosmosDbAccountName
  location: location
  properties: {
    databaseAccountOfferType: 'Standard'
    locations: [
      {
        locationName: location
      }
    ]
  }
}

resource cosmosDbDatabase 'Microsoft.DocumentDB/databaseAccounts/sqlDatabases@2020-04-01' = {
  parent: cosmosDbAccount
  name: cosmosDbDatabaseName
  properties: {
    resource: {
      id: cosmosDbDatabaseName
    }
    options: {
      throughput: cosmosDbDatabaseThroughput
    }
  }

  resource container 'containers' = {
    name: cosmosDbDatabaseName
    properties: {
      options: {}
      resource: {
        id: cosmosDbDatabaseName
        partitionKey: {
          kind: 'Hash'
          paths: [
            cosmosDbContainerPartitionKey
          ]
        }
      }
    }
  }
}

resource logAnalyticsWorkspace 'Microsoft.OperationalInsights/workspaces@2020-03-01-preview' existing = {
  name: logAnalyticsWorkspaceName
}

resource cosmosDbAccountDiagnostics 'Microsoft.Insights/diagnosticSettings@2017-05-01-preview' = {
  scope: cosmosDbAccount
  name: cosmosDbAccountDiagnosticsSettingsName
  properties: {
    workspaceId: logAnalyticsWorkspace.id
    logs: [
      {
        category: 'DataPlaneRequests'
        enabled: true
      }
    ]
  }
}

resource storageAccount 'Microsoft.Storage/storageAccounts@2019-06-01' existing = {
  name: storageAccountName

  resource blobService 'blobServices' existing = {
    name: 'default'
  }
}

resource storageAccountBlobDiagnostics 'Microsoft.Insights/diagnosticSettings@2017-05-01-preview' = {
  scope: storageAccount::blobService
  name: storageAccountBlobDiagnosticSettingsName
  properties: {
    workspaceId: logAnalyticsWorkspace.id
    logs: [
      {
        category: 'StorageRead'
        enabled: true
      }
      {
        category: 'StorageWrite'
        enabled: true
      }
      {
        category: 'StorageDelete'
        enabled: true
      }
    ]
  }
}
