---
title: Terraform Azure Verified Modules for Platform Landing Zone (ALZ)
---

The `platform_landing_zone` starter module deploys the end to end platform landing zone using Azure Verified Modules. It is fully configurable to meet different customer scenarios.

This documentation covers the top scenarios and documents all available configuration settings for this module.

We aim to cover the 90% of customer scenarios. If the particular customer scenario is not covered here, it may be possible to adjust the configuration settings to match the customer requirements. If not, then it my be the case the customer needs to adjust their code post deployment.

## Configuration settings

Outside of the input config file covered elsewhere in this documentation, this starter module also accepts two additional methods of customisation:

- Platform landing zone configuration file. This is a tfvars file in HCL format that determines which resources are deployed and what type of hub networking connectivity is deployed.
- Platform landing zone library (lib) folder. This is a folder of configuration files used to customise the management groups and associated policies.

Each scenario comes with a version of the platform landing zone configuration file pre-configured for that scenario.

## Scenarios

Scenarios are common customer use cases when deploying the platform landing zone. The followin section provide a description of the scenario and link to the pre-configured files for that scenario.

### [Multi-region hub and spoke vnet with Azure Firewall]({{< relref "multi-region-hub-and-spoke-vnet-with-azure-firewall" >}})

A full platform landing zone deployment with hub and spoke virtual network connectivity using Azure Firewall.

### [Multi-region virtual wan with Azure Firewall]({{< relref "multi-region-virtual-wan-with-azure-firewall" >}})

A full platform landing zone deployment with Virtual WAN network connectivity using Azure Firewall.

### Multi-region hub and spoke vnet with NVA

### Multi-region virtual wan with NVA

### Single-region hub and spoke vnet with Azure Firewall

### Single-region virtual wan with Azure Firewall

### Management groups, policy and resources only

## How to

The how to section details how to make common configuration changes that apply to the common scenarios.

### Turn off DDOS protection plan

### Turn off Bastion host

### Turn off Private DNS zones and Private DNS resolver

### Additional Regions

### IP Address Ranges


## Platform landing zone configuration file

This section details the available configuration settings / variables in this starter module.

### Custom Replacements (`custom_replacements`)

The `custom_replacements` variable builds on the built-in replacements to provide user defined replacements that can be used throughout your configuration. This reduces the complexity of the configuration file by allowing re-use of names and other definitions that may be repeated throughout the configuration. 

There are 4 layers of replacements that can be built upon to provide the level of flexibility you need. The order of precendence determines which other replacements can be used to build your replacement. For example a 'Name' replacement can be used to build a 'Resource Group Identifier' replacement, but a 'Resource Group Identifier' replacement cannot be used to build a 'Name' replacement.

The layers and precedence order is:

1. Built-in Replacements: These can be found at the top of our example config files and you can also see them in the code base [here](https://github.com/Azure/alz-terraform-accelerator/blob/cf0b37351cd4f2dde9d2cf20642d76bacadf923c/templates/complete_multi_region/locals-config.tf#L2)
2. Names: This is for resource names and other basic strings
3. Resource Group Identifiers: This is for resource group IDs
4. Resource Identifiers: This is for resource IDs

#### Names (`custom_replacements.names`)

Used to define custom names and strings that can be used throughout the configuration file. This can leverage the built-in replacements. 

Exanple usage:

{{< include file="/static/examples/tf/accelerator/config/custom_replacements.names.tfvars" language="terraform" >}}

#### Resource Group Identifiers (`custom_replacements.resource_group_identifiers`)

Used to define resource group IDs that can be used throughout the configuration file. This can leverage the built-in replacements and custom names. 

Exanple usage:

{{< include file="/static/examples/tf/accelerator/config/custom_replacements.resource_group_identifiers.tfvars" language="terraform" >}}

#### Resource Identifiers (`custom_replacements.resource_identifiers`)

Used to define resource IDs that can be used throughout the configuration file. This can leverage the built-in replacements, custom names, and resource group IDs. 

Exanple usage:

{{< include file="/static/examples/tf/accelerator/config/custom_replacements.resource_identifiers.tfvars" language="terraform" >}}

### Enable Telemetry (`enable_telemetry`)

The `enable_telemetry` variable determines whether telemetry about module usage is sent to Microsoft, enabling us to invest in improvements to the Accelerator and Azure Verified Modules.

Example usage:

{{< include file="/static/examples/tf/accelerator/config/enable_telemetry.tfvars" language="terraform" >}}

### Tags (`tags`)

The `tags` variable is a default set of tags to apply to resources that support them. In many cases, these tags can be overriden on a per resource basis.

Example usage:

{{< include file="/static/examples/tf/accelerator/config/tags.tfvars" language="terraform" >}}

### Management Resource Settings (`management_resource_settings`)

The `management_resource_settings` variable is used to configure the management resources. This includes the log analytics workspace, automation account, and data collection rules for Azure Monitoring Agent (AMA).

This variable is of type `any` as it maps directly to the Azure Verified Module variables. To determine what can be supplied to this variable you can refer to the documentation for this module directly:

Documentation link: [registry.terraform.io/modules/Azure/avm-ptn-alz-management](https://registry.terraform.io/modules/Azure/avm-ptn-alz-management/azurerm/0.4.0?tab=inputs)

Example usage:

{{< include file="/static/examples/tf/accelerator/config/management_resource_settings.tfvars" language="terraform" >}}

### Management Group Settings (`management_group_settings`)

The `management_group_settings` variable is used to configure the management groups, policies, and policy role assignments.

This variable is of type `any` as it maps directly to the Azure Verified Module variables. To determine what can be supplied to this variable you can refer to the documentation for this module directly:

Documentation link: [registry.terraform.io/modules/Azure/avm-ptn-alz](https://registry.terraform.io/modules/Azure/avm-ptn-alz/azurerm/0.10.0?tab=inputs)

Example usage:

{{< include file="/static/examples/tf/accelerator/config/management_group_settings.tfvars" language="terraform" >}}

### Connectivity Type (`connectivity_type`)

The `connectivity_type` variable is used to choose the type of connectivity to deploy. Supported values are:

* `hub_and_spoke_vnet`: Deploy hub and spoke networking using Azure Virtual Networks
* `virtual_wan`: Deploy Azure Virtual WAN networking
* `none`: Don't deploy any networking

Example usage:

{{< include file="/static/examples/tf/accelerator/config/connectivity_type.tfvars" language="terraform" >}}

### Connectivity Resource Groups (`connectivity_resource_groups`)

The `connectivity_resource_groups` variable is used to specify the name and location of the resource groups used for connectivity.

This variable is a `map(object)` and has two properties:

* `name`: The resource group name
* `location`: The resource group location

Example usage:

{{< include file="/static/examples/tf/accelerator/config/connectivity_resource_groups.tfvars" language="terraform" >}}

## Azure Verified Modules Reference

For reference, the following is a list of the Azure Verified Modules used by this starter module

### Used and can be configured

| Applies To | Module Type | Module Name |  Description | Link |
| -- | -- | -- | -- | -- |
| All | Pattern | Management Groups and Policy | Used to create the management group structure, deploy policy definitions, assign policies, and create role assignments | https://github.com/Azure/terraform-azurerm-avm-ptn-alz |
| All | Pattern | Management Resources | Used to deploy the management resource, including log analytics workspace and automation account | https://github.com/Azure/terraform-azurerm-avm-ptn-alz-management |
| All | Utility | Regions | Used to lookup the availability zones in the regions selected, so they can be used in the replacements | https://github.com/Azure/terraform-azurerm-avm-utl-regions |
| Both Connectivity | Resource | Resource Group | Used to create the Resource Groups if connectivity is enabled | https://github.com/Azure/terraform-azurerm-avm-res-resources-resourcegroup |
| Both Connectivity | Resource | Private DNS Resolver | Used to deploy the Private DNS Resolver if connectivity is enabled | https://github.com/Azure/terraform-azurerm-avm-res-network-dnsresolver |
| Both Connectivity | Pattern | Private Link Private DNS Zones | Used to deploy the Private Link Private DNS Zones if connectivity is enabled | https://github.com/Azure/terraform-azurerm-avm-ptn-network-private-link-private-dns-zones |
| Both Connectivity | Resource | Private DNS Zone | Used to deploy the Virtual Machine auto-registration DNS Zone if connectivity is enabled | https://github.com/Azure/terraform-azurerm-avm-res-network-privatednszone |
| Both Connectivity | Resource | DDOS Protection Plan | Used to deploy the DDOS Protection Plan if connectivity is enabled | https://github.com/Azure/terraform-azurerm-avm-res-network-ddosprotectionplan |
| Both Connectivity | Resource | Public IP Address | Used to deploy the Public IP Address for the Bastion Host if connectivity is enabled | https://github.com/Azure/terraform-azurerm-avm-res-network-publicipaddress |
| Both Connectivity | Resource | Bastion Host | Used to deploy the Bastion Host if connectivity is enabled | https://github.com/Azure/terraform-azurerm-avm-res-network-bastionhost |
| Hub and Spoke VNET | Pattern | Hub Networking | Used to deploy and configure the Hub and Spoke Virtual Network if that option is selected | https://github.com/Azure/terraform-azurerm-avm-ptn-hubnetworking |
| Hub and Spoke VNET | Pattern | Virtual Network Gateways | Used to deploy the virtual network gateways for the Hub and Spoke Virtual Network options | https://github.com/Azure/terraform-azurerm-avm-ptn-vnetgateway |
| Virtual WAN | Pattern | Virtual WAN | Used to deploy and configure the Virtual WAN if that option is selected | https://github.com/Azure/terraform-azurerm-avm-ptn-virtualwan |
| Virtual WAN | Resource | Firewall Policy | Used to deploy the Firewall Policy if the Virtual WAN option is selected | https://github.com/Azure/terraform-azurerm-avm-res-network-firewallpolicy |
| Virtual WAN | Resource | Virtual Network | Used to deploy the Sidecar Virtual Network and Subnets if the Virtual WAN option is selected | https://github.com/Azure/terraform-azurerm-avm-res-network-virtualnetwork |
