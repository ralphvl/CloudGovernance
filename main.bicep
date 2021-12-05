var webappname1 = 'ralphvl-webapp-1'
var webappname2 = 'ralphvl-webapp-2'
var webapplocation1 = 'West Europe'
var webapplocation2 = 'North Europe'
var webappnamehosting1 = 'ralphvl-webapphostingplan-1'
var webappnamehosting2 = 'ralphvl-webapphostingplan-2'
var frontdoorname = 'ralphvl-frontdoor-1'
var frontdoorlocation = 'global'

resource appServicePlan1 'Microsoft.Web/serverfarms@2020-12-01' = {
  name: webappnamehosting1
  location: webapplocation1
  sku: {
    name: 'F1'
    capacity: 1
  }
}

resource webApplication1 'Microsoft.Web/sites@2018-11-01' = {
  name: webappname1
  location: webapplocation1
  tags: {
    'hidden-related:${resourceGroup().id}/providers/Microsoft.Web/serverfarms/appServicePlan': 'Resource'
  }
  properties: {
    serverFarmId: appServicePlan1.id
  }
}

resource appServicePlan2 'Microsoft.Web/serverfarms@2020-12-01' = {
  name: webappnamehosting2
  location: webapplocation2
  sku: {
    name: 'F1'
    capacity: 1
  }
}

resource webApplication2 'Microsoft.Web/sites@2018-11-01' = {
  name: webappname2
  location: webapplocation2
  tags: {
    'hidden-related:${resourceGroup().id}/providers/Microsoft.Web/serverfarms/appServicePlan': 'Resource'
  }
  properties: {
    serverFarmId: appServicePlan2.id
  }
}

resource frontDoor1 'Microsoft.Network/frontDoors@2020-05-01' = {
  name: frontdoorname
  location: frontdoorlocation
  properties: {
    backendPools: [
      {
        name: 'ralphvl-test-webappfront2.azurefd.net'
        properties: {
          backends: [
            {
              address: 'ralphvl-webapp-1.azurewebsites.net'
              privateLinkResourceId: null
              privateLinkLocation: null
              privateEndpointStatus: null
              privateLinkApprovalMessage: null
              enabledState: 'Enabled'
              httpPort: 80
              httpsPort: 443
              priority: 1
              weight: 50
              backendHostHeader: 'ralphvl-webapp-1.azurewebsites.net'
            }
          ]
          healthProbeSettings: {
            id: '/subscriptions/847facc0-8b90-4374-a58b-cc375b39646f/resourceGroups/ralphvl-dev-rg-cloudgv-01/providers/Microsoft.Network/frontdoors/ralphvl-frontdoor-1/healthProbeSettings/healthProbeSettings-1638437038422'
          }
          loadBalancingSettings: {
            id: '/subscriptions/847facc0-8b90-4374-a58b-cc375b39646f/resourceGroups/ralphvl-dev-rg-cloudgv-01/providers/Microsoft.Network/frontdoors/ralphvl-frontdoor-1/loadBalancingSettings/loadBalancingSettings-1638437038422'
          }
        }
      }
    ]
    backendPoolsSettings: {
      enforceCertificateNameCheck: 'Enabled'
      sendRecvTimeoutSeconds: 30
    }
    enabledState: 'Enabled'
    friendlyName: 'ralphvl-test-webappfront1-azurefd-net'
    frontendEndpoints: [
      {
        name: 'ralphvl-test-webappfront1-azurefd-net'
        properties: {
          hostName: 'ralphvl-test-webappfront.azurefd.net'
          sessionAffinityEnabledState: 'Disabled'
          sessionAffinityTtlSeconds: 0
          webApplicationFirewallPolicyLink: null
        }
        
      }
    ]
    healthProbeSettings: [
      {
        name: 'healthProbeSettings-1638437038422'
        properties: {
          enabledState: 'Enabled'
          healthProbeMethod: 'Head'
          intervalInSeconds: 30
          path: '/'
          protocol: 'Https'
        }
      }
    ]
    loadBalancingSettings: [
      {
        name: 'loadBalancingSettings-1638437038422'
        properties: {
          additionalLatencyMilliseconds: 4
          sampleSize: 2
          successfulSamplesRequired: 0
        }
      }
    ]
    routingRules: [
      {
        name: 'erbrtsfdbseadffdb'
        properties: {
          
          acceptedProtocols: [
            'Http'
            'Https'
          ]
          enabledState: 'Enabled'
          frontendEndpoints: [
            {
              id: '/subscriptions/847facc0-8b90-4374-a58b-cc375b39646f/resourceGroups/ralphvl-dev-rg-cloudgv-01/providers/Microsoft.Network/frontdoors/ralphdoeteentest/frontendEndpoints/ralphdoeteentest-azurefd-net'
            }
          ]
          patternsToMatch: [
            '*'
          ]
          routeConfiguration: {
              
          }
        }
      }
    ]
  }
}

