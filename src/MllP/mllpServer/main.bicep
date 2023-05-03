
var location = 'eastus'

resource vnet 'Microsoft.Network/virtualNetworks@2022-09-01' existing = {
  name: 'vnet-paas'
}

resource logAnalytics 'Microsoft.OperationalInsights/workspaces@2021-06-01' = {
  name: 'logacahg'
  location: location
  properties: {
    sku: {
      name: 'PerGB2018'
    }
  }
}

resource containerAppEnv 'Microsoft.App/managedEnvironments@2022-01-01-preview' = {
  name: 'mllpenvhg'
  location: location
  properties: {
    appLogsConfiguration: {
      destination: 'log-analytics'
      logAnalyticsConfiguration: {
        customerId: logAnalytics.properties.customerId
        sharedKey: logAnalytics.listKeys().primarySharedKey
      }
    }
    vnetConfiguration: {
      infrastructureSubnetId: vnet.properties.subnets[2].id
      internal: true
    }
  }
}


resource mllpserver 'Microsoft.App/containerApps@2022-06-01-preview' = {
  name: 'mllpserver'
  location: location
  properties: {
    environmentId: containerAppEnv.id    
    configuration: {
      ingress: {
        external: false
        transport: 'tcp'
        allowInsecure: false
        targetPort: 1080
        exposedPort: 1080        
      }
      secrets: [
        {
          name: 
          value: ''
        }
      ]
      registries: [
        {
          server: 'acrhl7.azurecr.io'
          username: 'acrhl7'
          passwordSecretRef:'
        }
      ]
    }
    template: {
      containers: [
        {
          name: 'mllpserver'
          image: 'acrhl7.azurecr.io/hl7/mllpserver:v2'
          resources: {
            cpu: 2
            memory: '4Gi'
          }
        }
      ]
      scale: {
        minReplicas: 1
        maxReplicas: 1
      }
    }
  }

}
