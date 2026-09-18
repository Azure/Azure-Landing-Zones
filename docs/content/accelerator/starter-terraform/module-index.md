---
title: Module Index
geekdocCollapseSection: true
weight: 4
---

For reference, the following is a list of the [Azure Verified Modules](https://aka.ms/avm) used by this starter module

| Applies To | Module Type | Module Name |  Description | Link |
| -- | -- | -- | -- | -- |
| All | Pattern | Management Groups and Policy | Used to create the management group structure, deploy policy definitions, assign policies, and create role assignments | [avm-ptn-alz](https://github.com/Azure/terraform-azurerm-avm-ptn-alz) |
| All | Pattern | Management Resources | Used to deploy the management resource, including log analytics workspace and automation account | [avm-ptn-alz-management](https://github.com/Azure/terraform-azurerm-avm-ptn-alz-management) |
| All | Utility | Regions | Used to lookup the location short name, so they can be used in the replacements | [avm-utl-regions](https://github.com/Azure/terraform-azurerm-avm-utl-regions) |
| Hub and Spoke Virtual Network | Pattern | Hub Networking | Used to deploy and configure the Hub and Spoke Virtual Network if that option is selected | [alz-connectivity-hub-and-spoke-vnet](https://github.com/Azure/terraform-azurerm-avm-ptn-alz-connectivity-hub-and-spoke-vnet) |
| Virtual WAN | Pattern | Virtual WAN | Used to deploy and configure the Virtual WAN if that option is selected | [alz-connectivity-virtual-wan](https://github.com/Azure/terraform-azurerm-avm-ptn-alz-connectivity-virtual-wan) |

## Terraform and provider versions

The `platform_landing_zone` starter module declares the following version constraints in its root [`terraform.tf`](https://github.com/Azure/alz-terraform-accelerator/blob/main/templates/platform_landing_zone/terraform.tf) file:

| Requirement | Source | Version constraint |
| -- | -- | -- |
| Terraform | n/a | `~> 1.12` |
| AzureRM provider | `hashicorp/azurerm` | `~> 4.0` |
| AzAPI provider | `Azure/azapi` | `~> 2.0` |
| ALZ provider | `Azure/alz` | `~> 0.21` |
| Local provider | `hashicorp/local` | `~> 2.5` |

{{< hint type=important >}}
AzureRM provider v5.x is the latest release, but it is not currently supported. The Platform landing zone requires **AzureRM provider v4**, as we are planning to move to the AzAPI provider. Keep the AzureRM constraint in your root module set to `~> 4.0`.
{{< /hint >}}

The **Requirements** section of each module's registry page lists its current provider constraints. If your root module requests AzureRM v5.x, `terraform init` fails — see [Troubleshooting]({{< relref "../troubleshooting#no-available-releases-match-the-given-constraints-for-hashicorpazurerm" >}}).
