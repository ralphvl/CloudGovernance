var webAppName1 = 'cst-webapp-1'
var webAppName2 = 'cst-webapp-2'
var webAppLocation1 = 'West Europe'
var webAppLocation2 = 'North Europe'
var webAppNameHosting1 = 'cst-webapphostingplan-1'
var webAppNameHosting2 = 'cst-webapphostingplan-2'
var frontDoorName = 'cst-frontdoor'
var frontDoorLocation = 'global'
var frontDoorBackendPoolAppName = 'cst-backend'
var loadBalancingSettingsName = 'LB-settings'
var healthProbe = 'health-prober'

resource appServicePlan1 'Microsoft.Web/serverfarms@2020-12-01' = {
  name: webAppNameHosting1
  location: webAppLocation1
  sku: {
    name: 'F1'
    capacity: 1
  }
}

resource webApplication1 'Microsoft.Web/sites@2018-11-01' = {
  name: webAppName1
  location: webAppLocation1
  tags: {
    'hidden-related:${resourceGroup().id}/providers/Microsoft.Web/serverfarms/appServicePlan': 'Resource'
  }
  properties: {
    serverFarmId: appServicePlan1.id
  }
}

resource appServicePlan2 'Microsoft.Web/serverfarms@2020-12-01' = {
  name: webAppNameHosting2
  location: webAppLocation2
  sku: {
    name: 'F1'
    capacity: 1
  }
}

resource webApplication2 'Microsoft.Web/sites@2018-11-01' = {
  name: webAppName2
  location: webAppLocation2
  tags: {
    'hidden-related:${resourceGroup().id}/providers/Microsoft.Web/serverfarms/appServicePlan': 'Resource'
  }
  properties: {
    serverFarmId: appServicePlan2.id
  }
}

resource frontDoor 'Microsoft.Network/frontDoors@2020-05-01' = {
  name: frontDoorName
  location: frontDoorLocation
  properties: {
    healthProbeSettings: [
      {
        name: loadBalancingSettingsName
        properties: {
          enabledState: 'Enabled'
          healthProbeMethod: 'HEAD'
          intervalInSeconds: 30
          path: '/'
          protocol: 'Https'
        }
      }
    ]
    loadBalancingSettings: [
      {
        name: healthProbe
        properties: {
          additionalLatencyMilliseconds: 4
          sampleSize: 2
          successfulSamplesRequired: 1
        }
      }
    ]    
    backendPools: [
      {
        name: frontDoorBackendPoolAppName
        properties: {
          backends: [
            {
              address: webApplication1.properties.defaultHostName
              enabledState: 'Enabled'
              httpPort: 80
              httpsPort: 443
              priority: 1
              weight: 50
              backendHostHeader: webApplication1.properties.defaultHostName
            }
            {
              address: webApplication2.properties.defaultHostName
              enabledState: 'Enabled'
              httpPort: 80
              httpsPort: 443
              priority: 1
              weight: 50
              backendHostHeader: webApplication2.properties.defaultHostName
            }
          ]
          loadBalancingSettings: {
            id: resourceId('Microsoft.Network/frontDoors/loadBalancingSettings', frontDoorName, healthProbe)
          }
          healthProbeSettings: {
            id: resourceId('Microsoft.Network/frontDoors/healthProbeSettings', frontDoorName, loadBalancingSettingsName)
          }
        }
      }
    ]
    backendPoolsSettings: {
      enforceCertificateNameCheck: 'Enabled'
      sendRecvTimeoutSeconds: 30
    }
    enabledState: 'Enabled'
    frontendEndpoints: [
      {
        name: 'frontendEndpoint1'
        properties: {
          hostName: '${frontDoorName}.azurefd.net'
          sessionAffinityEnabledState: 'Disabled'
          sessionAffinityTtlSeconds: 0
        } 
      }
    ]
    routingRules: [
      {
        name: 'RoutingRule1'
        properties: {
          acceptedProtocols: [
            'Http'
            'Https'
          ]
          enabledState: 'Enabled'
          frontendEndpoints: [
            {
              id: resourceId('Microsoft.Network/frontDoors/frontendEndpoints', frontDoorName, 'frontendEndpoint1')
            }
          ]
          patternsToMatch: [
            '/*'
          ]
          routeConfiguration: {
            '@odata.type': '#Microsoft.Azure.FrontDoor.Models.FrontdoorForwardingConfiguration'
            backendPool: {
              id: resourceId('Microsoft.Network/frontDoors/backendPools', frontDoorName, frontDoorBackendPoolAppName)
            }
          }
        }
      }
    ]
  }
}
output frontDoorURL string = '${frontDoor.name}.azurefd.net'
