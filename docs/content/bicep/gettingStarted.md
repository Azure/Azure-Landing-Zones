---
title: Getting started
weight: 10
---

{{< hint type=tip >}}
We recommend that you use the [accelerator]({{< relref "accelerator" >}}) to deploy Azure Landing Zones with Bicep.
This guide is for those that want to deploy Azure Landing Zones using the Bicep templates directly.
This guide assumes that you are comfortable composing and utilizing Bicep templates and modules.
{{< /hint >}}

## Understanding the Template Structure

The [alz-bicep-accelerator](https://github.com/Azure/alz-bicep-accelerator) repository contains Bicep templates organized into the following areas:

- **Core/Governance/mgmt-groups**: Management group hierarchy with separate folders for each management group (int-root, platform, landingzones, sandbox, decommissioned)
  - Each management group folder contains its own `main.bicep` and `main.bicepparam` files
  - Policy definitions, policy set definitions, and policy assignments are loaded from JSON files in the `lib/alz` directory
- **Core/Logging**: Log Analytics workspace, Automation Account, and Azure Monitoring Agent (AMA) data collection rules
- **Networking/HubNetworking**: Hub virtual network with Azure Firewall, Bastion, VPN/ER Gateway, and private DNS zones
- **Networking/VirtualWAN**: Virtual WAN hub with integrated security and routing

Each management group template is deployed independently, referencing the parent management group ID you define in the parameter files.

## Determine What to Customize

Before you deploy, review the parameter files in each template folder and tailor them so they reflect the regions, services, and conventions you actually require. The Bicep parameter files (`.bicepparam`) in the repository provide the interface for these changes. Advanced users can also fork or clone the repository and modify the corresponding `.bicep` templates directly when structural changes, additional resources, or new outputs are required.

Common updates include:

- [Modify the management group hierarchy]({{< relref "howtos/modifyingMgHierarchy" >}}) or rename management groups to match your tenant structure.
- Update `parLocations` and any downstream names to the regions you are targeting.
- Adjust networking address prefixes, optional platform services, and availability-zone settings.
- Tune logging defaults such as retention, workspace capacity, and whether Microsoft Sentinel is enabled.

{{< hint type=note >}}
We plan to surface the most common questions (regions, address spaces, availability zones, logging retention, and policy overrides) directly in a future version of the bootstrap experience. Until then, make these edits in the parameter files before you run any deployments.
{{< /hint >}}

### Regional selections and naming

The starter parameter files ship with placeholders for a primary and secondary region:

```bicep
// templates/core/logging/main.bicepparam
param parLocations = [
  'uksouth'
  'ukwest'
]
```

If you are deploying to a single region, remove the secondary entry and any configuration that references it.

### Networking multi-region and availability zones

The networking parameter file includes two hub definitions to illustrate an active/standby design. Tailor the list to match the number of regions you intend to support and verify any availability-zone settings:

```bicep
// templates/networking/hubnetworking/main.bicepparam
param hubNetworks = [
  {
    name: 'vnet-alz-uksouth'
    location: parLocations[0]
    addressPrefixes: [
      '10.10.0.0/16'
    ]
    virtualNetworkGatewaySettings: {
      enableVirtualNetworkGateway: true
      skuName: 'VpnGw2AZ'
      publicIpZones: [1, 2, 3]
    }
  }
]
```

- Replace the address ranges with blocks that align to your IP strategy.
- Remove the secondary hub entry if you are not building a multi-region topology, or extend the array if you need more than two regions.
- Confirm the availability-zone arrays (for example `publicIpZones`) use zone numbers that exist in the target region; adjust SKU choices if zones are not available.

### Virtual WAN hub configuration

If you are deploying the optional Virtual WAN pattern, adjust the hub list so it reflects the routing architecture you expect to run in production:

```bicep
// templates/networking/virtualwan/main.bicepparam
param vwanHubs = [
  {
    hubName: 'vhub-alz-uksouth'
    location: parLocations[0]
    addressPrefix: '10.100.0.0/23'
    virtualNetworkGatewaySettings: {
      enableVirtualNetworkGateway: true
      gatewayType: 'ExpressRoute'
      skuName: 'ErGw2AZ'
      publicIpZones: [1, 2, 3]
    }
    sideCarVirtualNetwork: {
      sidecarVirtualNetworkEnabled: true
      addressPrefixes: ['10.100.1.0/24']
    }
  }
]
```

- Pick an address space that aligns with the rest of your IP plan and avoids overlap with on-premises networks.
- Enable or disable services such as Azure Firewall, Virtual Network Gateway, DDOS protection, and DNS Private Resolver to match your connectivity strategy.
- Adjust `publicIpZones`, gateway SKU, or even the `preferredRoutingGateway` to reflect whether this region needs ExpressRoute, VPN, or both. Use single-zone SKUs if the target region does not support zones.
- Update or add hub entries for additional regions; remove the secondary entry entirely if you only require a single regional hub.

### Logging and monitoring defaults

The logging template provisions the Log Analytics workspace, Automation Account, and data-collection rules. Adjust the defaults so they match your governance requirements:

```bicep
// templates/core/logging/main.bicepparam
param parLogAnalyticsWorkspaceLogRetentionInDays = 365
param parLogAnalyticsWorkspaceCapacityReservationLevel = 100
param parLogAnalyticsWorkspaceOnboardSentinel = true
```

Lower the retention period, change the capacity reservation tier, or disable Sentinel onboarding if those choices do not fit your cost or compliance goals.

### Policy overrides and assignments

Many policy assignments expect resource IDs that reference the logging resources created earlier. Update the `parPolicyAssignmentParameterOverrides` block in each management group parameter file so those IDs match the subscriptions and resource group names you plan to deploy:

```bicep
// templates/core/governance/mgmt-groups/platform/main.bicepparam
param parPolicyAssignmentParameterOverrides = {
  'Deploy-VM-Monitoring': {
    dcrResourceId: {
      value: '/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-alz-mgmt-uksouth/providers/Microsoft.Insights/dataCollectionRules/dcr-vmi-alz-uksouth'
    }
  }
}
```

Update the subscription IDs, resource group names, and resource names so the policy engine can resolve the correct dependencies during deployment. For a deeper walkthrough of override strategies (including how to disable, scope, or parameterize policy assignments), review the [Modifying Policy Assignments how-to]({{< relref "howtos/modifyingPolicyAssignments" >}}). That article highlights the common policies you should double-check before running a deployment.

{{< hint type=note >}}
When you run the bootstrap, the accelerator pre-populates subscription IDs in each `.bicepparam` file based on the values you provided in the YAML configuration.
{{< /hint >}}

## Next Steps

Once you have successfully deployed the core components:

1. Review the [howtos]({{< relref "howtos" >}}) section for common customization scenarios
