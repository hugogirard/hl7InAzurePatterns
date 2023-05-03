param location string

resource nsgJumpbox 'Microsoft.Network/networkSecurityGroups@2021-05-01' = {
  name: 'nsg-jumpbox'
  location: location
  properties: {
    securityRules: [
    ]
  }
}

resource vnet 'Microsoft.Network/virtualNetworks@2021-05-01' = {
  name: 'vnet-spoke-health'
  location: location
  properties: {
    addressSpace: {
      addressPrefixes: [
        '11.0.0.0/16'
      ]
    }
    subnets: [
      {
        name: 'snet-aca'
        properties: {
          addressPrefix: '11.0.0.0/23'
        }
      }
      {
        name: 'snet-jumpbox'
        properties: {
          addressPrefix: '11.0.2.0/27'
          networkSecurityGroup: {
            id: nsgJumpbox.id
          }
        }
      }
    ]
  }
}

output acaSubnetId string = vnet.properties.subnets[0].id

