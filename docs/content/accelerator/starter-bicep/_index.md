---
title: Bicep
description: The Azure Verified Modules for Platform landing zone (ALZ) (`platform_landing_zone`) starter module deploys the end to end Platform landing zone using Azure Verified Modules. It is fully configurable to meet different scenarios.
weight: 50
---

The `platform_landing_zone` starter module for the new Bicep framework uses Azure Verified Modules from the [alz-bicep-accelerator](https://github.com/Azure/alz-bicep-accelerator) repository.

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

The following table describes the inputs required for the `platform_landing_zone` starter module:

| Input | Placeholder | Description |
| - | -- | --- |
| `networkType` | `hubNetworking` | The type of network configuration to deploy. Currently only `hubNetworking`, `vwanConnectivity,` or `none` are supported. |
| `bootstrap_module_version` | `<version>` | The specific release version of the Acccelerator Bootstrap modules to target. We recommend using "Latest" |
| starter_module_version | `<version>` | The specific release version of the ALZ Bicep Accelerator modules to target. We recommend using "Latest" |

## Example Configuration Files

* [inputs-azure-devops.yaml][example_powershell_inputs_azure_devops_bicep_platform_landing_zone]
* [inputs-github.yaml][example_powershell_inputs_github_bicep_platform_landing_zone]
* [inputs-local.yaml][example_powershell_inputs_local_bicep_platform_landing_zone]

## Options

### Implement Sovereign Landing Zone (SLZ) controls

The Sovereign Landing Zone (SLZ) implementation is available for the Azure landing zone accelerator Bicep starter module.

The SLZ deployment using the Bicep accelerator follows the same overall pattern as the Terraform accelerator:

1. Bootstrap the delivery environment.
1. Overlay the SLZ-specific configuration.
1. Update deployment inputs.
1. Deploy through the generated CI/CD workflow.

The Bicep implementation uses a compact SLZ package containing only the files required to add the sovereign management groups and policies.

Follow the Azure landing zone accelerator [user guide](https://azure.github.io/Azure-Landing-Zones/accelerator/):

1. Complete [Phase 0 - Planning]({{< relref "../0_planning" >}}) and choose Bicep as the IaC type and GitHub or Azure DevOps as the CI/CD platform.
1. Complete [Phase 1 - Prerequisites]({{< relref "../1_prerequisites" >}}).
1. Complete [Phase 2 - Bootstrap]({{< relref "../2_bootstrap" >}}).
1. Apply the SLZ Bicep deployment package.
1. Complete [Phase 3 - Run]({{< relref "../3_run" >}}).
1. Iterate, customize, and extend your landing zone through your chosen version control system and CI/CD pipelines.

#### Apply the SLZ Bicep deployment package

To apply the SLZ package, run the following PowerShell script after the bootstrap process creates your accelerator configuration:

```pwsh
$tempFolderName = "~/accelerator/temp"
New-Item -ItemType "directory" $tempFolderName
$tempFolder = Resolve-Path -Path $tempFolderName
git clone -n --depth=1 --filter=tree:0 "https://github.com/Azure/alz-bicep-accelerator" "$tempFolder"
cd $tempFolder

$configFolderPath = "examples/slz/.config"
$templatesFolderPath = "examples/slz/templates"
git sparse-checkout set --no-cone $configFolderPath $templatesFolderPath
git checkout

cd ~
Copy-Item `
  -Path "$tempFolder/$configFolderPath" `
  -Destination "~/accelerator/config" `
  -Recurse `
  -Force
Copy-Item `
  -Path "$tempFolder/$templatesFolderPath" `
  -Destination "~/accelerator/config" `
  -Recurse `
  -Force
Remove-Item -Path $tempFolder -Recurse -Force
```

The SLZ package is sourced from:

1. [`examples/slz/.config`](https://github.com/Azure/alz-bicep-accelerator/tree/main/examples/slz/.config)
1. [`examples/slz/templates`](https://github.com/Azure/alz-bicep-accelerator/tree/main/examples/slz/templates)

You can also copy or replace starter module files during the bootstrap process, like the Terraform accelerator approach. This allows the SLZ-specific files to be applied directly while the starter module is being prepared.

## Migration from Classic

If you're considering migrating from the classic framework:

* **New Deployments**: Start with the new framework for enhanced capabilities
* **Existing Deployments**: Start looking at migrating from the classic framework to get the latest capabilities and improvements. Detailed migration guidance will be provided in the coming months.

{{< hint type=note >}}
Migration guidance will be provided as the new framework reaches general availability.
{{< /hint >}}

 [//]: # (************************)
 [//]: # (INSERT LINK LABELS BELOW)
 [//]: # (************************)

[example_powershell_inputs_azure_devops_bicep_platform_landing_zone]: https://raw.githubusercontent.com/Azure/alz-bicep-accelerator/refs/heads/main/examples/bootstrap/inputs-azure-devops.yaml "Example - PowerShell Inputs - Azure DevOps - Bicep - Platform landing zone"
[example_powershell_inputs_github_bicep_platform_landing_zone]:  https://raw.githubusercontent.com/Azure/alz-bicep-accelerator/refs/heads/main/examples/bootstrap/inputs-github.yaml "Example - PowerShell Inputs - GitHub - Bicep - Platform landing zone"
[example_powershell_inputs_local_bicep_platform_landing_zone]:  https://raw.githubusercontent.com/Azure/alz-bicep-accelerator/refs/heads/main/examples/bootstrap/inputs-local.yaml "Example - PowerShell Inputs - Local - Bicep - Platform landing zone"
