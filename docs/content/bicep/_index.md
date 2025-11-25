---
title: Bicep
geekdocCollapseSection: true
weight: 20
---

ALZ ❤️ AVM - Azure Verified Modules for Platform Landing Zones (ALZ)

Based on continuous feedback from the community, we have adopted a more modular approach to deploying Azure Landing Zones with Bicep.
This new approach is based on [Azure Verified Modules](https://aka.ms/avm) (AVM) and is designed to be more flexible.

## Branding

With the move to using Azure Verified Modules, we have new branding!
We are using the following wording to describe the new offerings:

> **Azure Verified Modules for Platform Landing Zones (ALZ)**

## Why have we made this change?

We received feedback from our community that the following improvements were needed:

### Customization

You asked us to be able to fully customize the configuration of each component.
Examples included defining a custom management group hierarchy, or setting specific settings (and names!) on resources.
This requirement was front and center in our minds when designing the new approach.

***You can now fully customize the configuration of each component (including the resource names 😇).***

### Modularity

You didn't like that the module contained a combination of components that you may not need, and that you had to deploy the entire module even if you only wanted to use a subset of the components.

You also asked that we make it easier for organizations to have different teams manage different components of the Azure Landing Zone.

***You can now choose your own adventure and pick and choose only the components you need.***

## What is the new approach?

The new approach is based on [Azure Verified Modules](https://aka.ms/avm) and is designed to be more flexible.

The [alz-bicep-accelerator](https://github.com/Azure/alz-bicep-accelerator) repository provides Bicep templates that leverage Azure Verified Modules for deploying Azure Landing Zones. These templates cover the complete scope of an Azure Landing Zone deployment:

- **ALZ core**: Management group hierarchy, policies, and policy assignments
- **ALZ management**: Log Analytics workspace and Automation account for centralized management
- **Hub networking**: Hub virtual network with Azure Firewall, Bastion, and Gateway subnets
- **Virtual WAN**: Virtual WAN hub with routing and security configurations

{{< hint type=tip >}}
The Bicep templates in the alz-bicep-accelerator repository reference Azure Verified Modules to provide a consistent and maintainable approach to deploying Azure Landing Zones.
In this documentation site, we will cover the core concepts and customization options.
For detailed module documentation, refer to the [Azure Verified Modules registry](https://aka.ms/avm).
{{< /hint >}}

Using these templates together, you can create a fully customized Azure Landing Zone.

## Azure Deployment Stacks

A key differentiator of Azure Verified Modules for ALZ is the use of **Azure Deployment Stacks** for deploying and managing resources. This represents a significant improvement over previous deployment approaches.

### What are Deployment Stacks?

[Azure Deployment Stacks](https://learn.microsoft.com/azure/azure-resource-manager/bicep/deployment-stacks) are a native Azure feature that provides intelligent lifecycle management for your deployed resources. Think of them as "Bicep with memory" - they track what resources should exist based on your templates and automatically clean up resources that are no longer defined.

### Key Benefits

#### Automatic Cleanup

Unlike traditional ARM/Bicep deployments, deployment stacks automatically remove resources that are no longer in your template:

- **Deprecated policy assignments** are automatically unassigned when you update the ALZ library
- **No manual cleanup scripts** required when policies are removed or renamed
- **Consistent state** between your templates and deployed resources
- **Safe deletion** - only removes resources managed by the deployment stack

{{< hint type=important >}}
This is a **major improvement** over ALZ Bicep Classic. Previously, when Microsoft deprecated a policy in the ALZ library, you had to manually identify and remove it before deploying the updated templates. With deployment stacks and `ActionOnUnmanage: DeleteAll`, deprecated policies are automatically cleaned up during your next deployment.
{{< /hint >}}

#### Drift Detection

Deployment stacks track the resources they manage, making it easy to:

- Identify resources created outside your templates
- Detect manual changes to managed resources
- Maintain infrastructure-as-code compliance

#### Deployment History

Each deployment stack maintains its own history, separate from subscription/management group deployment history:

- See what changed in each update
- Audit who made changes and when
- Rollback capabilities for managed resources

### How We Use Deployment Stacks

The alz-bicep-accelerator's CI/CD pipelines use deployment stacks with the following configuration:

```powershell
New-AzManagementGroupDeploymentStack `
  -Name "alz-mgmt-groups-<timestamp>" `
  -TemplateFile "./main.bicep" `
  -TemplateParameterFile "./main.bicepparam" `
  -ManagementGroupId "alz" `
  -Location "eastus" `
  -ActionOnUnmanage DeleteAll `
  -DenySettingsMode None `
  -Force
```

**Configuration Explained:**

- `ActionOnUnmanage: DeleteAll` - Automatically delete resources (policies, assignments, etc.) that are removed from templates
- `DenySettingsMode: None` - Allow policy remediation and updates (no deny assignments)
- `Force` - Suppress confirmation prompts for automated deployments

### What-If Support

{{< hint type=note >}}
Azure Deployment Stacks do not currently support what-if operations. To provide preview capabilities, the CI/CD pipelines run what-if analysis using standard Azure deployments with the `-WhatIf` parameter before executing the deployment stack.

This means:

- **CI pipelines** validate changes with `New-AzManagementGroupDeployment -WhatIf`
- **CD pipelines** deploy using `New-AzManagementGroupDeploymentStack`
{{< /hint >}}

### Deployment Stack Lifecycle

When updating your Azure Landing Zone (e.g., updating the ALZ library version):

1. **Update templates** - Modify Bicep files or parameter files
2. **Commit and PR** - Create pull request with changes
3. **CI validation** - What-if analysis shows what will change (currently uses standard deployments; will transition to deployment stacks once what-if support is added)
4. **Merge and deploy** - CD pipeline creates/updates deployment stack
5. **Automatic cleanup** - Stack automatically removes deprecated resources that are no longer defined in templates
