param location string
param suffix string
@secure()
param publisherName string
@secure()
param publisherEmail string

resource apim 'Microsoft.ApiManagement/service@2022-08-01' = {
  name: 'apim-${suffix}'
  location: location
  properties: {
    publisherEmail: publisherEmail
    publisherName: publisherName
  }
  sku: {
    name: 'Consumption'
    capacity: 0
  }
} 

output apimName string = apim.name
