---
title: Getting started
weight: 10
---

{{< hint type=tip >}}
We recommend that you use the [accelerator]({{< relref "accelerator" >}}) to deploy Azure Landing Zones with Bicep.
This guide is for those that want to deploy Azure Landing Zones using the Bicep templates directly.
This guide assumes that you are comfortable composing Bicep templates.
{{< /hint >}}

## Understanding the Template Structure

The [alz-bicep-accelerator](https://github.com/Azure/alz-bicep-accelerator) repository contains Bicep templates organized into the following areas:

- **Core/Governance/mgmt-groups**: Management group hierarchy with separate folders for each management group (int-root, platform, landingzones, sandbox, decommissioned)
  - Each management group folder contains its own `main.bicep` and `main.bicepparam` files
  - Policy definitions, policy set definitions, and policy assignments are loaded from JSON files in the `lib/alz` directory
- **Core/Logging**: Log Analytics workspace, Automation Account, and Azure Monitoring Agent (AMA) data collection rules
- **Networking/HubNetworking**: Hub virtual network with Azure Firewall, Bastion, VPN/ER Gateway, and private DNS zones
- **Networking/VirtualWAN**: Virtual WAN hub with integrated security and routing

Each management group template is deployed independently, referencing the parent management group ID.

## Decide if you need custom configuration

If you want to do any of the following, you will need to customize the template configuration:

- [Modify the management group hierarchy]({{< relref "howtos/modifyingMgHierarchy" >}}) (including re-naming management groups)
- [Modify policy assignments]({{< relref "howtos/modifyingPolicyAssignments" >}})
- Customize resource names and locations
- Adjust networking configurations

The Bicep parameter files (`.bicepparam`) in the repository provide the interface for customization.

## Supply Policy Assignment Parameters

Policy assignments in Azure Landing Zones require parameters to be supplied via the `parPolicyAssignmentParameterOverrides` object in each management group's `.bicepparam` file.
You only need to specify the parameters you want to override - others will use defaults from the policy assignment JSON files.

### Log Analytics Workspace Resource ID

Many policy assignments require a Log Analytics workspace for centralized logging and monitoring.

Example in `int-root/main.bicepparam`:

```bicep-params
param parPolicyAssignmentParameterOverrides = {
  'Deploy-MDFC-Config-H224': {
    parameters: {
      logAnalytics: {
        value: '/subscriptions/<subscription-id>/resourcegroups/rg-alz-logging-eastus/providers/Microsoft.OperationalInsights/workspaces/law-alz-eastus'
      }
      emailSecurityContact: {
        value: 'security@yourcompany.com'
      }
    }
  }
  'Deploy-AzActivity-Log': {
    parameters: {
      logAnalytics: {
        value: '/subscriptions/<subscription-id>/resourcegroups/rg-alz-logging-eastus/providers/Microsoft.OperationalInsights/workspaces/law-alz-eastus'
      }
    }
  }
}
```

### DDoS Protection Plan

The DDoS protection policy assignment is in the `platform` management group. Example override:

```bicep-params
param parPolicyAssignmentParameterOverrides = {
  'Enable-DDoS-VNET': {
    parameters: {
      ddosProtectionPlanId: {
        value: '/subscriptions/<subscription-id>/resourceGroups/<rg-name>/providers/Microsoft.Network/ddosProtectionPlans/<plan-name>'
      }
    }
  }
}
```

### Private DNS Zones Resource Group

For the Deploy-Private-DNS-Zones policy in the `landingzones-corp` management group:

```bicep-params
param parPolicyAssignmentParameterOverrides = {
  'Deploy-Private-DNS-Zones': {
    parameters: {
      privateDnsZoneResourceGroupId: {
        value: '/subscriptions/<subscription-id>/resourceGroups/<rg-name>'
      }
    }
  }
}
```

{{< hint type=important >}}
Ensure that resources referenced in policy parameters (like Log Analytics workspaces) are deployed before deploying the policy assignments that reference them.
{{< /hint >}}

## Deployment Order

When deploying Azure Landing Zones manually with Bicep, follow this recommended order:

### 1. Int-Root Management Group

Deploy the root management group first with policy definitions and assignments:

```bash
az deployment mg create \
  --location <location> \
  --management-group-id <parent-mg-id> \
  --template-file templates/core/governance/mgmt-groups/int-root/main.bicep \
  --parameters templates/core/governance/mgmt-groups/int-root/main.bicepparam
```

{{< hint type=note >}}
Update the `managementGroupParentId` in `main.bicepparam` to match your tenant's root management group, or leave empty to use the tenant root.
{{< /hint >}}

### 2. Child Management Groups

Deploy the child management groups (Platform, Landing Zones, Sandbox, Decommissioned):

```bash
# Platform management group
az deployment mg create \
  --location <location> \
  --management-group-id alz \
  --template-file templates/core/governance/mgmt-groups/platform/main.bicep \
  --parameters templates/core/governance/mgmt-groups/platform/main.bicepparam

# Landing Zones management group
az deployment mg create \
  --location <location> \
  --management-group-id alz \
  --template-file templates/core/governance/mgmt-groups/landingzones/main.bicep \
  --parameters templates/core/governance/mgmt-groups/landingzones/main.bicepparam

# Sandbox management group
az deployment mg create \
  --location <location> \
  --management-group-id alz \
  --template-file templates/core/governance/mgmt-groups/sandbox/main.bicep \
  --parameters templates/core/governance/mgmt-groups/sandbox/main.bicepparam

# Decommissioned management group
az deployment mg create \
  --location <location> \
  --management-group-id alz \
  --template-file templates/core/governance/mgmt-groups/decommissioned/main.bicep \
  --parameters templates/core/governance/mgmt-groups/decommissioned/main.bicepparam
```

### 3. Logging Infrastructure

Deploy the Log Analytics workspace, Automation Account, and data collection rules:

```bash
az deployment sub create \
  --location <location> \
  --subscription <management-subscription-id> \
  --template-file templates/core/logging/main.bicep \
  --parameters templates/core/logging/main.bicepparam
```

{{< hint type=important >}}
After deploying logging infrastructure, update the `parPolicyAssignmentParameterOverrides` in the management group parameter files with the actual Log Analytics workspace resource ID before deploying or updating management groups.
{{< /hint >}}

### 4. Networking

Deploy hub networking or Virtual WAN based on your requirements:

**Hub Networking:**

```bash
az deployment sub create \
  --location <location> \
  --subscription <connectivity-subscription-id> \
  --template-file templates/networking/hubnetworking/main.bicep \
  --parameters templates/networking/hubnetworking/main.bicepparam
```

**Virtual WAN:**

```bash
az deployment sub create \
  --location <location> \
  --subscription <connectivity-subscription-id> \
  --template-file templates/networking/virtualwan/main.bicep \
  --parameters templates/networking/virtualwan/main.bicepparam
```

## Review Policy Assignments

{{< hint type=tip >}}
Azure Landing Zones contains Microsoft's prescriptive guidance for getting started in Azure.
We recommend leaving these policy assignments enabled unless you have a specific reason to disable them.
{{< /hint >}}

We recommend that you review the following policy assignments before deploying:

### DDoS Protection

Azure Landing Zones includes a policy assignment that enables DDoS protection on all in-scope virtual networks.
It is assigned at the `platform` management group.

If you do not have a DDoS protection plan, you should either:

1. Remove this policy assignment from your templates
2. Set the policy enforcement mode to `DoNotEnforce` in your parameter file

### Private DNS Zones for Private Endpoints

If you do not use private endpoints for Azure services in your environment, you should disable the policy assignment called `Deploy-Private-DNS-Zones` that is assigned at the `corp` management group.

### Azure Monitor Agent

If you use a third-party monitoring solution, you should consider disabling the following policy assignments at the `landing_zones` management group:

- `Deploy-VM-Monitoring`
- `Deploy-VMSS-Monitoring`
- `Deploy-VM-ChangeTrack`
- `Deploy-VMSS-ChangeTrack`
- `Deploy-MDFC-DefSQL-AMA`

To disable a policy assignment, you can either:

1. Remove it from the template
2. Set `enforcementMode: 'DoNotEnforce'` in the policy assignment definition

## Role Assignments for Policy Managed Identities

Many policy assignments use managed identities to perform deployments or modifications. These managed identities require appropriate role assignments.

The Bicep templates automatically create role assignments for:

- Policy assignments at their assignment scope
- Resources referenced in policy parameters that have the `assignPermissions` metadata

## Working with Parameter Files

The alz-bicep-accelerator repository uses `.bicepparam` files for managing parameters. These files provide a strongly-typed way to supply parameters to your Bicep templates.

Example `.bicepparam` file:

```bicep
using './main.bicep'

param location = 'eastus'
param resourceGroupName = 'rg-alz-management'
param logAnalyticsWorkspaceName = 'law-alz-management'
param automationAccountName = 'aa-alz-management'
```

{{< hint type=note >}}
Parameter files make it easier to maintain different configurations for different environments (dev, test, prod) or deployment scenarios.
{{< /hint >}}

## Next Steps

Once you have successfully deployed the core components:

1. Review the [howtos]({{< relref "howtos" >}}) section for common customization scenarios
2. Configure your CI/CD pipelines for ongoing management
3. Review and adjust policy assignments based on your organizational requirements
4. Deploy landing zones for your application teams
