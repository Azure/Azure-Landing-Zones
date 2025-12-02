---
title: Bicep Classic - Complete
weight: 10
---

The `complete` starter module for the Bicep Classic framework uses the traditional [ALZ-Bicep](https://github.com/Azure/ALZ-Bicep) modules.

{{< hint type=note >}}
This documentation is specific to the **Bicep Classic** framework (`iac_type: bicep-classic`). For the new Azure Verified Modules framework, see [Bicep AVM - Azure Verified Modules for Platform Landing Zone (ALZ)]({{< relref "../bicep-platform-landing-zone" >}}).
{{< /hint >}}

## Framework Overview

* **Repository**: [ALZ-Bicep](https://github.com/Azure/ALZ-Bicep)
* **Architecture**: Traditional ALZ-Bicep modules
* **Benefits**: Proven stability and existing deployment compatibility
* **Recommended for**: Existing ALZ-Bicep deployments
* **IAC Type**: `bicep-classic`

## Configuration Inputs

The following table describes the inputs required for the `complete` starter module:

| Input | Placeholder | Description |
| - | -- | --- |
| `Prefix` | `landing-zone` | This is the defaut prefix for names of resources and management groups. |
| `Environment` | `live` | The environment name for the landing zone. This can be any lower case string. (e.g. `live` or `canary`)  |
| `networkType` | `hubNetworking` | The type of network configuration to deploy. Currently only `hubNetworking`, `hubNetworkingMultiRegion`, `vwanConnectivity,` `vwanConnectivityMultiRegion` or `none` are supported. |
| `SecurityContact` | `<email-address>` | The email address of the security contact for the landing zone. |

## Example Configuration Files

Example input files for the Bicep Classic framework:

* [inputs-azure-devops-bicep-complete.yaml][example_powershell_inputs_azure_devops_bicep_complete]
* [inputs-github-bicep-complete.yaml][example_powershell_inputs_github_bicep_complete]
* [inputs-local-bicep-complete.yaml][example_powershell_inputs_local_bicep_complete]

## Getting Started

To use the Bicep Classic framework:

1. Set your `iac_type` to `bicep-classic` in your configuration file
2. Use the example configuration files above as a starting point
3. Customize the inputs according to your requirements
4. Follow the [User Guide]({{< relref "../../userguide" >}}) for deployment steps

 [//]: # (************************)
 [//]: # (INSERT LINK LABELS BELOW)
 [//]: # (************************)

[example_powershell_inputs_azure_devops_bicep_complete]: https://raw.githubusercontent.com/Azure/ALZ-Bicep/refs/heads/main/accelerator/examples/bootstrap/inputs-azure-devop.yaml "Example - PowerShell Inputs - Azure DevOps - Bicep - Complete"
[example_powershell_inputs_github_bicep_complete]:  https://raw.githubusercontent.com/Azure/ALZ-Bicep/refs/heads/main/accelerator/examples/bootstrap/inputs-github.yaml "Example - PowerShell Inputs - GitHub - Bicep - Complete"
[example_powershell_inputs_local_bicep_complete]:  https://github.com/Azure/ALZ-Bicep/blob/main/accelerator/examples/bootstrap/inputs-local.yaml "Example - PowerShell Inputs - Local - Bicep - Complete"
