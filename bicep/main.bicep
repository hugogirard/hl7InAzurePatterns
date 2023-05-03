targetScope = 'subscription'

param location string = 'eastus'

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


output acaEnvName string = env.outputs.containerAppEnvName
output acrName string = acr.outputs.acrName
