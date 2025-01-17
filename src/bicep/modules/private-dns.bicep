/*
Copyright (c) Microsoft Corporation.
Licensed under the MIT License.
*/

@description('Array of Virtual Networks subscriptionId, resourceGroup and name to link the Private DNS Zones to')
param vnetsToLink array

@description('The tags that will be associated to the resources')
param tags object

var privateDnsZones_privatelink_monitor_azure_name = ( environment().name =~ 'AzureCloud' ? 'privatelink.monitor.azure.com' : 'privatelink.monitor.azure.us' ) 
var privateDnsZones_privatelink_ods_opinsights_azure_name = ( environment().name =~ 'AzureCloud' ? 'privatelink.ods.opinsights.azure.com' : 'privatelink.ods.opinsights.azure.us' )
var privateDnsZones_privatelink_oms_opinsights_azure_name = ( environment().name =~ 'AzureCloud' ? 'privatelink.oms.opinsights.azure.com' : 'privatelink.oms.opinsights.azure.us' )
var privateDnsZones_privatelink_blob_core_cloudapi_net_name = ( environment().name =~ 'AzureCloud' ? 'privatelink.blob.${environment().suffixes.storage}' : 'privatelink.blob.core.usgovcloudapi.net' )
var privateDnsZones_privatelink_agentsvc_azure_automation_name = ( environment().name =~ 'AzureCloud' ? 'privatelink.agentsvc.azure-automation.net' : 'privatelink.agentsvc.azure-automation.us' )

resource privatelink_monitor_azure_com 'Microsoft.Network/privateDnsZones@2018-09-01' = {
  name: privateDnsZones_privatelink_monitor_azure_name
  location: 'global'
  tags: tags
}

resource privatelink_oms_opinsights_azure_com 'Microsoft.Network/privateDnsZones@2018-09-01' = {
  name: privateDnsZones_privatelink_oms_opinsights_azure_name
  location: 'global'
  tags: tags
}

resource privatelink_ods_opinsights_azure_com 'Microsoft.Network/privateDnsZones@2018-09-01' = {
  name: privateDnsZones_privatelink_ods_opinsights_azure_name
  location: 'global'
  tags: tags
}

resource privatelink_agentsvc_azure_automation_net 'Microsoft.Network/privateDnsZones@2018-09-01' = {
  name: privateDnsZones_privatelink_agentsvc_azure_automation_name
  location: 'global'
  tags: tags
}

resource privatelink_blob_core_cloudapi_net 'Microsoft.Network/privateDnsZones@2018-09-01' = {
  name: privateDnsZones_privatelink_blob_core_cloudapi_net_name
  location: 'global'
  tags: tags
}

resource privatelink_monitor_azure_com_link 'Microsoft.Network/privateDnsZones/virtualNetworkLinks@2018-09-01' = [for vnet in vnetsToLink: {
  name: '${privateDnsZones_privatelink_monitor_azure_name}/${vnet.name}-link'
  location: 'global'
  properties: {
    registrationEnabled: false
    virtualNetwork: {
      id: resourceId(vnet.subscriptionId, vnet.resourceGroup, 'Microsoft.Network/virtualNetworks', vnet.name)
    }
  }
  dependsOn: [
    privatelink_monitor_azure_com
  ]
}]

resource privatelink_oms_opinsights_azure_com_link 'Microsoft.Network/privateDnsZones/virtualNetworkLinks@2018-09-01' = [for vnet in vnetsToLink: {
  name: '${privateDnsZones_privatelink_oms_opinsights_azure_name}/${vnet.name}-link'
  location: 'global'
  properties: {
    registrationEnabled: false
    virtualNetwork: {
      id: resourceId(vnet.subscriptionId, vnet.resourceGroup, 'Microsoft.Network/virtualNetworks', vnet.name)
    }
  }
  dependsOn: [
    privatelink_oms_opinsights_azure_com
  ]
}]

resource privatelink_ods_opinsights_azure_com_link 'Microsoft.Network/privateDnsZones/virtualNetworkLinks@2018-09-01' = [for vnet in vnetsToLink: {
  name: '${privateDnsZones_privatelink_ods_opinsights_azure_name}/${vnet.name}-link'
  location: 'global'
  properties: {
    registrationEnabled: false
    virtualNetwork: {
      id: resourceId(vnet.subscriptionId, vnet.resourceGroup, 'Microsoft.Network/virtualNetworks', vnet.name)
    }
  }
  dependsOn: [
    privatelink_ods_opinsights_azure_com
  ]
}]

resource privatelink_agentsvc_azure_automation_net_link 'Microsoft.Network/privateDnsZones/virtualNetworkLinks@2018-09-01' = [for vnet in vnetsToLink: {
  name: '${privateDnsZones_privatelink_agentsvc_azure_automation_name}/${vnet.name}-link'
  location: 'global'
  properties: {
    registrationEnabled: false
    virtualNetwork: {
      id: resourceId(vnet.subscriptionId, vnet.resourceGroup, 'Microsoft.Network/virtualNetworks', vnet.name)
    }
  }
  dependsOn: [
    privatelink_agentsvc_azure_automation_net
  ]
}]

resource privateDnsZones_privatelink_blob_core_cloudapi_net_link 'Microsoft.Network/privateDnsZones/virtualNetworkLinks@2018-09-01' = [for vnet in vnetsToLink: {
  name: '${privateDnsZones_privatelink_blob_core_cloudapi_net_name}/${vnet.name}-link'
  location: 'global'
  properties: {
    registrationEnabled: false
    virtualNetwork: {
      id: resourceId(vnet.subscriptionId, vnet.resourceGroup, 'Microsoft.Network/virtualNetworks', vnet.name)
    }
  }
  dependsOn: [
    privatelink_blob_core_cloudapi_net
  ]
}]

output monitorPrivateDnsZoneId string = privatelink_monitor_azure_com.id
output omsPrivateDnsZoneId string = privatelink_oms_opinsights_azure_com.id
output odsPrivateDnsZoneId string = privatelink_ods_opinsights_azure_com.id
output agentsvcPrivateDnsZoneId string = privatelink_agentsvc_azure_automation_net.id
output storagePrivateDnsZoneId string = privatelink_blob_core_cloudapi_net.id
