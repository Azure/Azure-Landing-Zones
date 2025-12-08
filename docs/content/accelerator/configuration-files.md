---
title: Configuration Files
geekdocCollapseSection: true
weight: 120
---

Three configuration inputs are available:

* [Bootstrap Configuration File](#bootstrap-configuration-file)
* [Platform Landing Zone Configuration File](#platform-landing-zone-configuration-file)
* [Platform Landing Zone Library (lib) Folder](#platform-landing-zone-library-lib-folder)

### Bootstrap Configuration File

YAML file containing configuration for bootstrapping your VCS and Azure. Examples are provided for each IaC and VCS combination.

{{< hint type=note >}}
Some of this configuration is also fed into the starter module to avoid duplication of inputs. This includes management group ID, subscriptions IDs, starter locations, etc. You will see a `terraform.tfvars.json` file is created in your repository after the bootstrap has run for this purpose.
{{< /hint >}}

### Platform Landing Zone Configuration File

#### Terraform

{{< hint type=note >}}
Only required for Terraform ALZ starter module. Bicep users can skip this.
{{< /hint >}}

HCL `tfvars` file determining deployed resources and hub networking type. Copied to your repository as `*.auto.tfvars`.

Examples: [Scenarios]({{< relref "startermodules/terraform-platform-landing-zone/scenarios">}})

#### Bicep

This is the `yaml` file that determines resource names and other configuration for the Bicep Azure Verified Modules for Platform Landing Zone (ALZ) starter module.

### Platform Landing Zone Library (lib) Folder

{{< hint type=note >}}
Only required for Terraform ALZ starter module. Bicep users can skip this.
{{< /hint >}}

Configuration files for customizing management groups and policies. By default, an empty `lib` folder is provided.

Use cases:
* Renaming or restructuring management groups
* Modifying policy assignments
* Adding custom policy definitions

Documentation:
* [Platform Landing Zone Library](https://azure.github.io/Azure-Landing-Zones-Library/)
* [AVM for Management Groups and Policy](https://registry.terraform.io/modules/Azure/avm-ptn-alz/azurerm/0.10.0)
