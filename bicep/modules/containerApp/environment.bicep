
param location string
param logAnalyticsName string
param subnetId string
param suffix string

resource logAnalytics 'Microsoft.OperationalInsights/workspaces@2021-06-01' existing = {
  name: logAnalyticsName
}
resource containerAppEnv 'Microsoft.App/managedEnvironments@2022-01-01-preview' = {
  name: 'env-${suffix}'
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
      infrastructureSubnetId: subnetId
      internal: true
    }
  }
}

output containerAppEnvName string = containerAppEnv.name


// resource mllpserver 'Microsoft.App/containerApps@2022-06-01-preview' = {
//   name: 'mllpserver'
//   location: location
//   properties: {
//     environmentId: containerAppEnv.id    
//     configuration: {
//       ingress: {
//         external: false
//         transport: 'tcp'
//         allowInsecure: false
//         targetPort: 1080
//         exposedPort: 1080        
//       }
//       secrets: [
//         {
//           name: 
//           value: ''
//         }
//       ]
//       registries: [
//         {
//           server: 'acrhl7.azurecr.io'
//           username: 'acrhl7'
//           passwordSecretRef:'
//         }
//       ]
//     }
//     template: {
//       containers: [
//         {
//           name: 'mllpserver'
//           image: 'acrhl7.azurecr.io/hl7/mllpserver:v2'
//           resources: {
//             cpu: 2
//             memory: '4Gi'
//           }
//         }
//       ]
//       scale: {
//         minReplicas: 1
//         maxReplicas: 1
//       }
//     }
//   }

// }
