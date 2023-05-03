param location string
param suffix string

resource acr 'Microsoft.ContainerRegistry/registries@2021-09-01' = {
  name: 'acr${suffix}'
  location: location
  sku: {
    name: 'Basic'
  }
  properties: {
    adminUserEnabled: true
  }
}

output acrName string = acr.name
