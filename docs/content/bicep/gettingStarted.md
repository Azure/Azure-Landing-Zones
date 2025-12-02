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

## Determine what to customize

Now that you have deployed If you want to do any of the following, you will need to customize the template configuration:

- [Modify the management group hierarchy]({{< relref "howtos/modifyingMgHierarchy" >}}) (including re-naming management groups)
- Customize resource names and locations
- Adjust networking configurations

The Bicep parameter files (`.bicepparam`) in the repository provide the interface for customization.

### Policy Assignments

Policy assignments often need parameter overrides (for example, Log Analytics workspaces, DDoS plans, or private DNS resource groups). Instead of duplicating the guidance here, review the detailed steps and examples in the [Modifying Policy Assignments how-to]({{< relref "howtos/modifyingPolicyAssignments" >}}). That article explains how to override or disable assignments and highlights the common policies to consider before you deploy.

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
