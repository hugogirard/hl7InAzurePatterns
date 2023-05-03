param containerEnvironmentName string
param location string
param azureContainerRegistry string
@secure()
param azureContainerRegistryUsername string
@secure()
param azureContainerRegistryPassword string
param image string

resource containerAppEnv 'Microsoft.App/managedEnvironments@2022-01-01-preview' existing = {
  name: containerEnvironmentName
}

resource mllpServer 'Microsoft.App/containerApps@2022-10-01' = {
  name: 'mllp-server'
  location: location
  properties: {
    managedEnvironmentId: containerAppEnv.id
    configuration: {
      secrets: [
        {
          name: 'containerregistrypasswordref'
          value: azureContainerRegistryPassword          
        }
      ]
      ingress: {
        external: true
        exposedPort: 1080
        targetPort: 1080
        transport: 'tcp'
      }
      registries: [
        {
          server: azureContainerRegistry
          username: azureContainerRegistryUsername
          passwordSecretRef: 'containerregistrypasswordref'
        }
      ]
    }
    template: {
      containers: [
        {
          image: image
          name: 'mllp-server'
          resources: {
            cpu: 1
            memory: '2Gi'
          }
          probes: [
            {
              tcpSocket: {
                port: 1200                            
              }              
              periodSeconds: 10
              type: 'Liveness'
            }
          ]
        }        
      ]
      scale: {
        minReplicas: 1
        maxReplicas: 1
      }
    }
  }
}
