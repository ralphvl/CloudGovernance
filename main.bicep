var webappname1 = 'ralphvl-webapp-1'
var webappname2 = 'ralphvl-webapp-2'
var webapplocation1 = 'West Europe'
var webapplocation2 = 'North Europe'
var webappnamehosting1 = 'ralphvl-webapphostingplan-1'
var webappnamehosting2 = 'ralphvl-webapphostingplan-2'

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

