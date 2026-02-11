---
title: Bicep classic
geekdocCollapseSection: true
weight: 70
hidden: true
---

This section provides guidance for performing common tasks with the **Bicep Classic** framework using the traditional [ALZ-Bicep](https://github.com/Azure/ALZ-Bicep) modules.

{{< hint type=note >}}
This documentation is specific to the **Bicep Classic** framework (`iac_type: bicep-classic`). For the new Azure Verified Modules framework, see [Bicep]({{< relref "../bicep" >}}).
{{< /hint >}}

## Framework Overview

- **Repository**: [ALZ-Bicep](https://github.com/Azure/ALZ-Bicep)
- **Foundation**: Traditional ALZ-Bicep modules
- **Benefits**: Proven stability and compatibility with existing deployments
- **Use Case**: Ideal for organizations with existing ALZ-Bicep deployments
- **IAC Type**: `bicep-classic`

## Getting Started

If you're working with the Bicep Classic framework:

- [ALZ-Bicep Repository](https://github.com/Azure/ALZ-Bicep) - Main repository with modules and documentation
- [ALZ-Bicep Release Notes](https://github.com/Azure/ALZ-Bicep/releases) - Latest updates and changes
- [Deploying with the Accelerator]({{< relref "../accelerator" >}}) - Using the PowerShell accelerator

## Common Tasks

- [Updating Release Versions]({{< relref "howtos/updatingReleaseVersion" >}}) - Keep your deployment current with latest module versions

## When to Use Bicep Classic

Choose Bicep Classic if you:

- Have existing ALZ-Bicep deployments
- Need compatibility with established patterns
- Are not ready to migrate to the new AVM framework

## Migration Considerations

If you're considering migrating to the new [Bicep]({{< relref "../bicep" >}}) framework:

- Migration guidance will be provided in future releases
- New deployments should consider starting with the new framework
- Existing deployments can continue using Bicep Classic with ongoing support
