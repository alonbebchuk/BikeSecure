param location string

param serverName string
@secure()
param adminLogin string
@secure()
param adminPassword string

param firewallRuleName string
param ipAddress string

param databaseName string


resource sqlServer 'Microsoft.Sql/servers@2022-05-01-preview' = {
  name: serverName
  location: location
  properties: {
    administratorLogin: adminLogin
    administratorLoginPassword: adminPassword
    minimalTlsVersion: '1.2'
    publicNetworkAccess: 'Enabled'
    restrictOutboundNetworkAccess: 'Disabled'
  }
}

resource firewallRule 'Microsoft.Sql/servers/firewallRules@2022-05-01-preview' = {
  name: firewallRuleName
  parent: sqlServer
  properties: {
    endIpAddress: ipAddress
    startIpAddress: ipAddress
  }
}

resource sqlDB 'Microsoft.Sql/servers/databases@2022-05-01-preview' = {
  name: databaseName
  location: location
  sku: {
    name: 'Basic'
    tier: 'Basic'
  }
  parent: sqlServer
}
