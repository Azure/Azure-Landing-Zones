---
title: Bicep
geekdocCollapseSection: true
weight: 20
---

This section provides guidance for performing common tasks with the **new Bicep framework** using Azure Verified Modules from the [alz-bicep-accelerator](https://github.com/Azure/alz-bicep-accelerator) repository.

{{< hint type=tip >}}
This documentation is for the **new Bicep framework** (`iac_type: bicep`) built on Azure Verified Modules. For the traditional framework, see [Bicep Classic]({{< relref "../bicep-classic" >}}).
{{< /hint >}}

## Framework Overview

- **Repository**: [alz-bicep-accelerator](https://github.com/Azure/alz-bicep-accelerator)
- **Foundation**: Built on Azure Verified Modules (AVM)
- **Benefits**: Enhanced modularity, better maintainability, and alignment with Microsoft's latest best practices
- **Use Case**: Recommended for new Azure Landing Zone deployments
- **IAC Type**: `bicep`

## Key Features

The new Bicep framework leverages Azure Verified Modules to provide:

- **Enhanced Modularity**: Better separation of concerns and reusable components
- **Improved Maintainability**: Cleaner code structure and easier updates
- **Latest Best Practices**: Alignment with Microsoft's current recommendations
- **Future-Proof Architecture**: Built to evolve with Azure platform capabilities

## Getting Started

If you're new to the new Bicep framework:

- [alz-bicep-accelerator Repository](https://github.com/Azure/alz-bicep-accelerator) - Main repository with AVM-based modules
- [Azure Verified Modules](https://aka.ms/avm) - Learn about the underlying module framework
- [Deploying with the Accelerator]({{< relref "accelerator/userguide" >}}) - Using the PowerShell accelerator

## When to Choose This Framework

Choose the new Bicep framework if you:

- Are starting a new Azure Landing Zone deployment
- Want to leverage the latest Azure best practices
- Prefer enhanced modularity and maintainability
- Want to future-proof your infrastructure code

## Migration from Bicep Classic

If you have an existing Bicep Classic deployment:

- Continue using [Bicep Classic]({{< relref "../bicep-classic" >}}) for existing deployments
- Migration guidance will be provided in future releases
- Consider the new framework for new environment deployments

## Framework Comparison

| Factor | Bicep (New Framework) | [Bicep Classic]({{< relref "../bicep-classic" >}}) |
|--------|----------------------|---------------|
| **Best For** | New deployments | Existing deployments |
| **Architecture** | Azure Verified Modules | Traditional ALZ modules |
| **Modularity** | High | Moderate |
| **Maintenance** | Latest best practices | Established patterns |
| **Repository** | alz-bicep-accelerator | ALZ-Bicep |
