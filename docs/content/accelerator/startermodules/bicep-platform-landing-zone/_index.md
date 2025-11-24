---
title: Bicep AVM - Complete
weight: 5
---

The `complete` starter module for the new Bicep framework uses Azure Verified Modules from the [alz-bicep-accelerator](https://github.com/Azure/alz-bicep-accelerator) repository.

{{< hint type=tip >}}
This is the **new Bicep framework** (`iac_type: bicep`) built on Azure Verified Modules. For the traditional framework, see [Bicep Classic - Complete]({{< relref "../bicep-classic-platform-landing-zone" >}}).
{{< /hint >}}

## Framework Overview

* **Repository**: [alz-bicep-accelerator](https://github.com/Azure/alz-bicep-accelerator)
* **Architecture**: Built on Azure Verified Modules (AVM)
* **Benefits**: Enhanced modularity, better maintainability, alignment with Microsoft's latest best practices
* **Recommended for**: New Azure Landing Zone deployments
* **IAC Type**: `bicep`

## Key Features

The new framework provides:

* **Modular Architecture**: Leverages Azure Verified Modules for better component isolation
* **Enhanced Maintainability**: Improved code structure and organization
* **Future-Proof**: Aligned with Microsoft's latest Azure Landing Zone guidance
* **Simplified Deployment**: Streamlined module structure for easier customization

## Module Structure

The framework includes the following core modules:

* **Core Governance**: Management group structure and policy assignments
* **Core Logging**: Centralized logging and monitoring setup
* **Networking Options**:
  * Hub networking for traditional hub-spoke architectures
  * Virtual WAN for modern connectivity patterns

## Configuration Inputs

The following table describes the inputs required for the `complete` starter module:

| Input | Placeholder | Description |
| - | -- | --- |
| `Prefix` | `landing-zone` | This is the defaut prefix for names of resources and management groups. |
| `Environment` | `live` | The environment name for the landing zone. This can be any lower case string. (e.g. `live` or `canary`)  |
| `networkType` | `hubNetworking` | The type of network configuration to deploy. Currently only `hubNetworking`, `hubNetworkingMultiRegion`, `vwanConnectivity,` `vwanConnectivityMultiRegion` or `none` are supported. |
| `SecurityContact` | `<email-address>` | The email address of the security contact for the landing zone. |

## Example Configuration Files

Example configurations for the new Bicep AVM framework will be available in the [alz-bicep-accelerator repository](https://github.com/Azure/alz-bicep-accelerator) documentation.

## Getting Started

To use the new Bicep AVM framework:

1. Set your `iac_type` to `bicep` in your configuration file
2. Refer to the [alz-bicep-accelerator documentation](https://github.com/Azure/alz-bicep-accelerator) for detailed examples
3. Customize the inputs according to your requirements
4. Follow the [User Guide]({{< relref "../../userguide" >}}) for deployment steps

## Migration from Classic

If you're considering migrating from the classic framework:

* **New Deployments**: Start with the new framework for enhanced capabilities
* **Existing Deployments**: Continue with the classic framework for stability
* **Migration Planning**: Evaluate your specific requirements and timeline

{{< hint type=note >}}
Migration guidance will be provided as the new framework reaches general availability.
{{< /hint >}}
