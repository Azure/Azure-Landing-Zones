---
title: Getting started
weight: 10
---

{{< hint type=tip >}}
We recommend that you use the [accelerator]({{< relref "accelerator" >}}) to deploy Azure landing zone with Bicep.
This guide is for those that want to deploy Azure landing zone using the Bicep templates directly.
This guide assumes that you are comfortable composing and utilizing Bicep templates and modules.
{{< /hint >}}

## Modules Deployed by the Accelerator

When you use the accelerator bootstrap process, the following modules are deployed to your repository:

### Core Modules

- **Core/Governance/mgmt-groups**: Management group hierarchy with separate folders for each management group (int-root, platform, landingzones, sandbox, decommissioned)
  - Each management group folder contains its own `main.bicep` and `main.bicepparam` files
  - Policy definitions, policy set definitions, and policy assignments are loaded from JSON files in the `lib/alz` directory
  - Policies follow Microsoft's prescriptive Azure Landing Zone guidance

- **Core/Logging**: Log Analytics workspace with optional solutions and Data Collection Rules
  - Microsoft Sentinel integration (optional)
  - Change Tracking solution (optional)
  - Azure Automation Account (optional)
  - Azure Monitor Agent (AMA) data collection rules for VM monitoring

### Networking Modules

The accelerator provides two networking patterns. Choose one based on your connectivity requirements:

- **Networking/HubNetworking**: Traditional hub-spoke architecture with a hub virtual network
  - Azure Firewall (Basic, Standard, or Premium tier) with optional firewall policy
  - Azure Bastion for secure VM access
  - VPN and/or ExpressRoute gateways
  - Private DNS zones for Azure services
  - DDoS protection (optional)
  - DNS Private Resolver (optional)

- **Networking/VirtualWAN**: Virtual WAN architecture for global connectivity
  - Virtual WAN hub with integrated routing
  - Azure Firewall deployed directly into the hub
  - VPN, ExpressRoute, and Point-to-Site gateways
  - Sidecar virtual networks for shared services
  - Private DNS zones with auto-registration

{{< hint type=important >}}
**Multi-Region by Default**: The accelerator deploys with **two regions configured by default** (primary and secondary) to demonstrate multi-region patterns. If you only need a single region, you can easily modify this by:

- Removing the secondary region from `parLocations` arrays in the parameter files
- Removing the secondary hub configuration from the networking parameter files

The templates include logic that automatically determines recommended availability zones for each resource type and region. You can override these recommendations by specifying zone arrays in the parameter files (e.g., `zones: [1, 2, 3]` or `publicIpZones: [1, 2]`).
{{< /hint >}}

## Understanding the Template Structure

The [alz-bicep-accelerator](https://github.com/Azure/alz-bicep-accelerator) repository is structured with each module in its own folder, containing both the Bicep template (`main.bicep`) and its corresponding parameter file (`main.bicepparam`). Each management group template is deployed independently, referencing the parent management group ID you define in the parameter files.

{{< hint type=note >}}
When you run the bootstrap, the accelerator pre-populates subscription IDs in each `.bicepparam` file based on the values you provided in the YAML configuration.
{{< /hint >}}

## Determine What to Customize

The bootstrap process pre-populates subscription IDs in the `.bicepparam` files based on your YAML configuration. However, you should still review and customize other parameters to match your requirements.

Common customizations include:

- **Regions**: Update `parLocations` arrays to your target regions (default is two regions)
- **Management Groups**: [Modify the hierarchy]({{< relref "howtos/modifyingMgHierarchy" >}}) or rename management groups
- **Networking**: Adjust address prefixes, enable/disable optional services (Firewall, Bastion, Gateways, DDoS)
- **Availability Zones**: Override the automatic zone recommendations by adding `zones` or `publicIpZones` properties to resource settings in parameter files
- **Logging**: Configure retention periods, workspace capacity, and enable/disable Sentinel or Change Tracking
- **Policies**: Review and adjust policy assignments to match your governance requirements

{{< hint type=note >}}
The Bicep templates automatically determine the best availability zones for each resource type and region. This logic uses `pickZones()` in the `main.bicep` files to ensure resources are deployed with zone-redundancy where supported. You can override these automatic selections by specifying zone arrays in the parameter files (e.g., `zones: [1, 2]` for specific zones, or `zones: []` to disable zones).
{{< /hint >}}

### Regional Configuration

The parameter files are pre-configured with **two regions by default** to demonstrate multi-region patterns:

```bicep
// templates/core/logging/main.bicepparam
param parLocations = [
  'uksouth'
  'ukwest'
]
```

**For single-region deployments**: Remove the secondary region from all `parLocations` arrays and remove the corresponding hub configuration from networking parameter files.

**For different regions**: Replace the region names with your target Azure regions (e.g., `eastus`, `westus2`, `northeurope`).

### Networking Configuration and Availability Zones

The Hub Networking parameter file includes **two hub definitions by default** to support multi-region deployments. Each hub is configured with zone-aware resources:

```bicep
// templates/networking/hubnetworking/main.bicepparam
param hubNetworks = [
  {
    name: 'vnet-alz-uksouth'
    location: parLocations[0]
    addressPrefixes: ['10.10.0.0/16']
    azureFirewallSettings: {
      deployAzureFirewall: true
      azureFirewallName: 'afw-alz-uksouth'
      azureSkuTier: 'Standard'
      // zones: [1, 2, 3] // Uncomment to override automatic zone selection
    }
    vpnGatewaySettings: {
      deployVpnGateway: true
      name: 'vgw-alz-uksouth'
      skuName: 'VpnGw2AZ'
      // publicIpZones: [1, 2, 3] // Uncomment to override automatic zone selection
    }
    expressRouteGatewaySettings: {
      deployExpressRouteGateway: true
      name: 'ergw-alz-uksouth'
      // publicIpZones: [1, 2, 3] // Uncomment to override automatic zone selection
    }
  }
  {
    name: 'vnet-alz-ukwest'
    location: parLocations[1]
    addressPrefixes: ['10.20.0.0/16']
    azureFirewallSettings: {
      deployAzureFirewall: true
      azureFirewallName: 'afw-alz-ukwest'
      azureSkuTier: 'Standard'
    }
    vpnGatewaySettings: {
      deployVpnGateway: true
      name: 'vgw-alz-ukwest'
      skuName: 'VpnGw2AZ'
    }
  }
]
```

**Key configuration points**:

- **Address Prefixes**: Update to align with your IP addressing strategy and avoid conflicts with on-premises networks
- **Single Region**: Remove the second hub object entirely if deploying to one region
- **Availability Zones**: Zones are automatically determined by the template based on regional support. Override by adding `zones` or `publicIpZones` properties to resource settings (e.g., `zones: [1, 2, 3]` for specific zones, `zones: []` to disable)
- **Zone Support**: For regions without zone support, templates automatically return empty arrays. You can also explicitly use non-zonal SKUs (e.g., `VpnGw2` instead of `VpnGw2AZ`)
- **Optional Services**: Enable or disable Azure Firewall, Bastion, VPN Gateway, ExpressRoute Gateway, DDoS protection, and DNS Private Resolver by setting the `deploy*` properties

{{< hint type=important >}}
**DDoS Protection Policy Assignment**: The networking module does not control the DDoS protection policy assignment. If you don't have a DDoS protection plan, you must disable or modify the [DDoS Protection policy assignment]({{< relref "howtos/modifyingPolicyAssignments" >}}#ddos-protection) separately in your management group configuration.
{{< /hint >}}

### Virtual WAN Configuration

If you choose the Virtual WAN networking pattern, the parameter file includes **two hub definitions by default** for multi-region connectivity:

```bicep
// templates/networking/virtualwan/main.bicepparam
param vwanHubs = [
  {
    hubName: 'vhub-alz-uksouth'
    location: parLocations[0]
    addressPrefix: '10.100.0.0/23'
    azureFirewallSettings: {
      deployAzureFirewall: true
      azureFirewallName: 'afw-vwan-uksouth'
      azureFirewallTier: 'Standard'
      // zones: [1, 2, 3] // Uncomment to override automatic zone selection
    }
    virtualNetworkGatewaySettings: {
      deployVpnGateway: true
      vpnGatewayName: 'vgw-vwan-uksouth'
      expressRouteGatewayName: 'ergw-vwan-uksouth'
      deployExpressRouteGateway: true
      gatewayType: 'ExpressRoute'
      // publicIpZones: [1, 2, 3] // Uncomment to override automatic zone selection
    }
    sideCarVirtualNetwork: {
      sidecarVirtualNetworkEnabled: true
      addressPrefixes: ['10.100.1.0/24']
    }
  }
  {
    hubName: 'vhub-alz-ukwest'
    location: parLocations[1]
    addressPrefix: '10.101.0.0/23'
    azureFirewallSettings: {
      deployAzureFirewall: true
      azureFirewallName: 'afw-vwan-ukwest'
      azureFirewallTier: 'Standard'
    }
    virtualNetworkGatewaySettings: {
      deployVpnGateway: true
      vpnGatewayName: 'vgw-vwan-ukwest'
      expressRouteGatewayName: 'ergw-vwan-ukwest'
      deployExpressRouteGateway: true
      gatewayType: 'ExpressRoute'
    }
    sideCarVirtualNetwork: {
      sidecarVirtualNetworkEnabled: true
      addressPrefixes: ['10.101.1.0/24']
    }
  }
]
```

**Key configuration points**:

- **Address Prefixes**: Ensure hub address spaces and sidecar virtual network ranges don't overlap with other networks
- **Single Region**: Remove the second hub object if deploying to one region
- **Gateway Types**: Choose `ExpressRoute`, `VPN`, or both based on your connectivity requirements
- **Availability Zones**: Zones are automatically determined by the template. Override by adding `zones` or `publicIpZones` properties (e.g., `zones: [1, 2]` for specific zones, `zones: []` to disable)
- **Sidecar Virtual Networks**: Enable for hosting shared services that require virtual network features (e.g., private endpoints, VNet integration)
- **Optional Services**: Configure Azure Firewall, DDoS protection, and DNS Private Resolver by setting the appropriate `deploy*` properties

{{< hint type=important >}}
**DDoS Protection Policy Assignment**: The networking module does not control the DDoS protection policy assignment. If you don't have a DDoS protection plan, you must disable or modify the [DDoS Protection policy assignment]({{< relref "howtos/modifyingPolicyAssignments" >}}#ddos-protection) separately in your management group configuration.
{{< /hint >}}

## Next Steps

Once you have successfully deployed the core components:

1. Review the [howtos]({{< relref "howtos" >}}) section for common customization scenarios
