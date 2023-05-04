targetScope = 'subscription'

param location string = 'eastus'
@secure()
param publisherName string
@secure()
param publisherEmail string

var rgName = 'rg-healhcare-integration'

var suffix = uniqueString(rgSpoke.id)

resource rgSpoke 'Microsoft.Resources/resourceGroups@2021-04-01' = {
  name: rgName
  location: location
}


module vnetSpoke 'modules/networking/vnet.spoke.bicep' = {
  scope: resourceGroup(rgSpoke.name)
  name: 'vnetSpoke'
  params: {
    location: location    
  }
}

module log 'modules/logging/logging.bicep' = {
  scope: resourceGroup(rgSpoke.name)
  name: 'log'
  params: {
    location: location
    suffix: suffix
  }
}

module appInsight 'modules/logging/appinsight.bicep' = {
  scope: resourceGroup(rgSpoke.name)
  name: 'insight'
  params: {
    location: location
    suffix: suffix
    workspaceId: log.outputs.logId
  }
}

module env 'modules/containerApp/environment.bicep' = {
  scope: resourceGroup(rgSpoke.name)
  name: 'env'
  params: {
    location: location
    logAnalyticsName: log.outputs.logAnalyticName
    subnetId: vnetSpoke.outputs.acaSubnetId
    suffix: suffix
  }
}

module acr 'modules/registry/registry.bicep' = {
  scope: resourceGroup(rgSpoke.name)
  name: 'acr'
  params: {
    location: location
    suffix: suffix
  }
}

module asp 'modules/webApp/appservicePlan.bicep' = {
  scope: resourceGroup(rgSpoke.name)
  name: 'asp'
  params: {
    location: location
    suffix: suffix
  }
}

module soapService 'modules/webApp/soapService.bicep' = {
  scope: resourceGroup(rgSpoke.name)
  name: 'soapService'
  params: {
    appInsightName: appInsight.outputs.appInsightname
    appServiceId: asp.outputs.aspId
    location: location
    suffix: suffix
  }
}

module apim 'modules/apim/apim.bicep' = {
  scope: resourceGroup(rgSpoke.name)
  name: 'apim'
  params: {
    location: location 
    publisherEmail: publisherEmail
    publisherName: publisherName    
    suffix: suffix    
  }
}

output acaEnvName string = env.outputs.containerAppEnvName
output acrName string = acr.outputs.acrName
output apimName string = apim.outputs.apimName
output soapWebName string = soapService.outputs.soapWebName
