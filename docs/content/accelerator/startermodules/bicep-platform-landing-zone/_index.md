---
title: Bicep AVM - Azure Verified Modules for Platform landing zone (ALZ)
weight: 5
---

The `complete` starter module for the new Bicep framework uses Azure Verified Modules from the [alz-bicep-accelerator](https://github.com/Azure/alz-bicep-accelerator) repository.

{{< hint type=tip >}}
This is the **new Bicep framework** (`iac_type: bicep`) built on Azure Verified Modules. For the traditional framework, see [Bicep Classic - Complete]({{< relref "../bicep-classic-complete" >}}).
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
  * Virtual WAN for integrated and automated hub and spoke configuration and connectivity

## Configuration Inputs

The following table describes the inputs required for the `complete` starter module:

| Input | Placeholder | Description |
| - | -- | --- |
| `networkType` | `hubNetworking` | The type of network configuration to deploy. Currently only `hubNetworking`, `vwanConnectivity,` or `none` are supported. |
| `bootstrap_module_version` | `<version>` | The specific release version of the Acccelerator Bootstrap modules to target. We recommend using "Latest" |
| starter_module_version | `<version>` | The specific release version of the ALZ Bicep Accelerator modules to target. We recommend using "Latest" |

## Example Configuration Files

* [inputs-azure-devops.yaml][example_powershell_inputs_azure_devops_bicep_platform_landing_zone]
* [inputs-github.yaml][example_powershell_inputs_github_bicep_platform_landing_zone]
* [inputs-local.yaml][example_powershell_inputs_local_bicep_platform_landing_zone]

## Migration from Classic

If you're considering migrating from the classic framework:

* **New Deployments**: Start with the new framework for enhanced capabilities
* **Existing Deployments**: Continue with the classic framework for stability for now

{{< hint type=note >}}
Migration guidance will be provided as the new framework reaches general availability.
{{< /hint >}}

 [//]: # (************************)
 [//]: # (INSERT LINK LABELS BELOW)
 [//]: # (************************)

[example_powershell_inputs_azure_devops_bicep_platform_landing_zone]: https://raw.githubusercontent.com/Azure/alz-bicep-accelerator/refs/heads/main/examples/inputs-azure-devops.yaml "Example - PowerShell Inputs - Azure DevOps - Bicep - Platform landing zone"
[example_powershell_inputs_github_bicep_platform_landing_zone]:  https://raw.githubusercontent.com/Azure/alz-bicep-accelerator/refs/heads/main/examples/inputs-github.yaml "Example - PowerShell Inputs - GitHub - Bicep - Platform landing zone"
[example_powershell_inputs_local_bicep_platform_landing_zone]:  https://raw.githubusercontent.com/Azure/alz-bicep-accelerator/refs/heads/main/examples/inputs-local.yaml "Example - PowerShell Inputs - Local - Bicep - Platform landing zone"
