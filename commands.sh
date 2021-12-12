#!/bin/sh
# Create resource group
az group create --name CloudGovernance --location westeurope

# Create a deployment
az deployment group create --resource-group CloudGovernance --template-file main.bicep --name W3L1