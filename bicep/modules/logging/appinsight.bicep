param workspaceId string
param location string
param suffix string

resource insight 'Microsoft.Insights/components@2020-02-02' = {
  name: 'appinsight-${suffix}'
  location: location
  kind: 'web'
  properties: {
    Application_Type: 'web'
    WorkspaceResourceId: workspaceId
  }
}

output appInsightname string = insight.name
output appInsightId string = insight.id
