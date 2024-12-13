---
title: Terraform Azure Verified Modules for Platform Landing Zone (ALZ)
---

The `platform_landing_zone` starter module deploys the end to end platform landing zone using Azure Verified Modules. It is fully configurable to meet different customer scenarios.

This documentation covers the top scenarios and documents all available configuration settings for this module.

We aim to cover 80% of common customer scenarios. If the particular customer scenario is not covered here, it may be possible to adjust the configuration settings to match the customer requirements. If not, then it my be the case the customer needs to adjust their Terraform code post bootstrap.

This documentation covers the following:

* [Usage](#usage): How to use this starter module
* [Scenarios](#scenarios): The scenarios supported with example configuration files
* [How To](#how-to): Common customisation tasks and how to perform them are documented here
* [Platform landing zone configuration file](#platform-landing-zone-configuration-file): Comprehensive documentation of the available input variables
* [Azure Verified Modules Reference](#azure-verified-modules-reference): A reference list and explanation of the Azure Verified Modules used in this starter module 

## Usage

To use the module, follow the detailed steps documented in phases 1, 2, and 3 of the Accelerator. Here we cover come specifics to help with understanding.

There are 3 sets of configuration that can be supplied to the accelerator to pre-configure it. 

### Bootstrap Configuration File

This is the YAML file used to provide the base configuration required to boostrap your version control system and Azure. 

Some of this configuration is also fed into this starter module. You will see a `terraform.tfvars.json` file is created to hold these inputs. They include management group ID, subscriptions IDs, starter locatrions, etc.

We provide examples of this file for each version control system. These can be found in the [Phase 1](TBC) documentation.

### Platform Landing Zone Configuration File

This is the `tfvars` file in HCL format that determines which resources are deployed and what type of hub networking connectivity is deployed.

This file is validated by the accelerator and then directly copied to your repository, so it retains the ordering, comments, etc. You will see the file is renamed to `*.auto.tfvars`, so that it is automatically picked up by Terraform.

We provide examples of this file for each scenario. These can be found in the [scenarios](#scenarios) documentation.

### Platform Landing Zone Library (lib) Folder

This is a folder of configuration files used to customise the management groups and associated policies. This library and its usage is documented alongside the `avm-ptn-alz` module. However, we cover a common customisation use case in our [How To](#how-to) section.

By default we supply an empty `lib` folder. This folder can be overridden with a set of files to customise Management Groups and Policy Assignments. Use cases include:

* Renaming management groups
* Customising the management group structure
* Removing policy assignments
* Adding custom policy definitions and assignments

The detailed documentation for the library and it's usage can be found here:

* Platform Landing Zone Library Documentation: https://azure.github.io/Azure-Landing-Zones-Library/
* Azure Verified Module for Management Groups and Policy: https://registry.terraform.io/modules/Azure/avm-ptn-alz/azurerm/0.10.0

## Scenarios

Scenarios are common customer use cases when deploying the platform landing zone. The followin section provide a description of the scenario and link to the pre-configured files for that scenario.

### Multi-region hub and spoke vnet with Azure Firewall

A full platform landing zone deployment with hub and spoke virtual network connectivity using Azure Firewall.

Example Platform landing zone configuration file: [full-multi-region/hub-and-spoke-vnet.tfvars](https://raw.githubusercontent.com/Azure/alz-terraform-accelerator/refs/heads/main/templates/platform_landing_zone/examples/full-multi-region/hub-and-spoke-vnet.tfvars)

Detailed documentation: [Multi-region hub and spoke vnet with Azure Firewall]({{< relref "multi-region-hub-and-spoke-vnet-with-azure-firewall" >}})

### Multi-region virtual wan with Azure Firewall

A full platform landing zone deployment with Virtual WAN network connectivity using Azure Firewall.

Example Platform landing zone config file: [full-multi-region/virtual-wan.tfvars](https://raw.githubusercontent.com/Azure/alz-terraform-accelerator/refs/heads/main/templates/platform_landing_zone/examples/full-multi-region/virtual-wan.tfvars)

Detailed documentation: [Multi-region virtual wan with Azure Firewall]({{< relref "multi-region-virtual-wan-with-azure-firewall" >}})

### Multi-region hub and spoke vnet with NVA

### Multi-region virtual wan with NVA

### Single-region hub and spoke vnet with Azure Firewall

### Single-region virtual wan with Azure Firewall

### Management groups, policy and resources only

## How to

The how to section details how to make configuration changes that apply to the common scenarios.

### Customise Management Groups

### Turn off DDOS protection plan

The customer can choose to not deploy a DDOS protection plan. In order to do that, they need to remove the DDOS protection plan configuration and disable the DINE policy. The customer can either comment out or remove the configuration entirely.

>NOTE: DDOS Protection plan is a critical security protection for public facing services. Carefully consider this and be sure to put in place an alternative solution, such as per IP protection.

The steps to follow are:

1. To keep the code tidy remove the follow settings from `custom_replacements.names`:
  1. `ddos_resource_group_name`
  1. `ddos_protection_plan_name`
1. To keep the code tidy remove the follow settings from `custom_replacements.resource_group_identifiers`:
  1. `ddos_protection_plan_resource_group_id`
1. To keep the code tidy remove the follow settings from `custom_replacements.resource_identifiers`:
  1. `ddos_protection_plan_id`
1. Remove the follow configuration settings from `management_group_settings.policy_default_values`:
  1. `ddos_protection_plan_id`
1. Add the follow section to `management_group_settings.policy_assignments_to_modify`:
    ```terraform
    connectivity = {
      policy_assignments = {
        Enable-DDoS-VNET = {
          enforcement_mode = "DoNotEnforce"
        }
      }
    }
    ```
1. Remove the whole `ddos_protection_plan` section from `hub_and_spoke_vnet_settings` or `virtual_wan_settings`

### Turn off Bastion host

The customer can choose to not deploy a Bastion Host. In order to do that, they need to remove the Bastion Host configuration. The customer can either comment out or remove the configuration entirely.

The steps to follow are:

1. To keep the code tidy remove the follow settings from `custom_replacements.names`:
  1. `<region>_bastion_subnet_address_prefix` where `<region>` is for each region
1. Remove the whole `bastion` section from each `hub_and_spoke_vnet_virtual_networks` or `virtual_wan_virtual_hubs` region

### Turn off Private DNS zones and Private DNS resolver

The customer can choose to not deploy any DNS related resources. In order to do that, they need to remove the DNS configuration and disable the DINE policy. The customer can either comment out or remove the configuration entirely.

The steps to follow are:

1. To keep the code tidy remove the follow settings from `custom_replacements.names`:
  1. `dns_resource_group_name`
  1. `<region>_private_dns_resolver_subnet_address_prefix` where `<region>` is for each region
1. Remove the follow configuration settings from `management_group_settings.policy_default_values`:
  1. `private_dns_zone_subscription_id`
  1. `private_dns_zone_region`
  1. `private_dns_zone_resource_group_name`
1. Add the follow section to `management_group_settings.policy_assignments_to_modify`:
    ```terraform
    corp = {
      policy_assignments = {
        Deploy-Private-DNS-Zones = {
          enforcement_mode = "DoNotEnforce"
        }
      }
    }
    ```
1. Remove the whole `private_dns_zones` section from each `hub_and_spoke_vnet_virtual_networks` or `virtual_wan_virtual_hubs` region

### Additional Regions

Additional regions are supported. The custom can add up to 10 regions using the out of the box module.

>NOTE: If a customer needs to scale beyond 10 regions, that can be accomodated by adding additional built in replacements [here](https://github.com/Azure/alz-terraform-accelerator/blob/cf0b37351cd4f2dde9d2cf20642d76bacadf923c/templates/platform_landing_zone/locals.config.tf#L2)

To add an additional regions, the process is `copy` -> `paste` -> `update`:

1. Copy, paste and update the regional resource group names in `custom_replacements.names`
1. Copy, paste and update the regional IP Ranges in `custom_replacements.names`
1. Copy, paste and update the regional resource group in `connectivity_resource_groups`
1. Copy, paste and update the region in `hub_and_spoke_vnet_virtual_networks` or `virtual_wan_virtual_hubs`

### IP Address Ranges

The example configuration files that include connectivity include an out of the box set of ip address ranges. These ranges have been chosen to support a real world scenario with optimal use to avoid ip exhaustion as a customer scales. However many customers will not want to use these ranges if they may overlap with their existing ranges or they are planning to scale beyond the /16 per region we cater for.

In order to update the IP ranges, you can update the `custom_replacements.names` section that includes the IP ranges. For example if the customer prefers to use `172.16` or `192.168`, they could update the ranges as follows:

{{< include file="/static/examples/tf/accelerator/config/custom_replacements.names.ip_ranges.tfvars" language="terraform" >}}

## Platform landing zone configuration file

This section details the available configuration settings / variables in this starter module.

### Custom Replacements (`custom_replacements`)

The `custom_replacements` variable builds on the built-in replacements to provide user defined replacements that can be used throughout your configuration. This reduces the complexity of the configuration file by allowing re-use of names and other definitions that may be repeated throughout the configuration. 

There are 4 layers of replacements that can be built upon to provide the level of flexibility you need. The order of precendence determines which other replacements can be used to build your replacement. For example a 'Name' replacement can be used to build a 'Resource Group Identifier' replacement, but a 'Resource Group Identifier' replacement cannot be used to build a 'Name' replacement.

The layers and precedence order is:

1. Built-in Replacements: These can be found at the top of our example config files and you can also see them in the code base [here](https://github.com/Azure/alz-terraform-accelerator/blob/cf0b37351cd4f2dde9d2cf20642d76bacadf923c/templates/platform_landing_zone/locals.config.tf#L2)
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

### Hub and Spoke Virtual Network Settings (`hub_and_spoke_vnet_settings`)

The `hub_and_spoke_vnet_settings` variable is used to set the non-regional settings for the hub and spoke Virtual Network connectivity option. It is only used to set the DDOS Protection Plan at this time.

This variable is of type `any` as it will be used for other purposes moving forward.

Example usage:

{{< include file="/static/examples/tf/accelerator/config/hub_and_spoke_vnet_settings.tfvars" language="terraform" >}}

### Hub and Spoke Virtual Networks (`hub_and_spoke_vnet_virtual_networks`)

The `hub_and_spoke_vnet_virtual_networks` variable is used to set the regional settings for the hub and spoke Virtual Network connectivity options. This includes Hub Networks, Peering, Routing, Subnets, Firewalls, Virtual Network Gateways, Bastion Hosts, Private DNS Zones, and Private DNS Resolver

This variable is of type `map(object)`. Some of theobject properties map directly to the Azure Verified Module variables. To determine what can be supplied to these variable you can refer to the documentation for this module directly.

The `map(object)` definition can be found [here](https://github.com/Azure/alz-terraform-accelerator/blob/cf0b37351cd4f2dde9d2cf20642d76bacadf923c/templates/platform_landing_zone/modules/hub-and-spoke-vnet/variables.tf#L14).

The supported object properties are:

* `hub_virtual_network`: This `object` maps directly to the variables of the Azure Verified Module, which can be found here: [registry.terraform.io/modules/Azure/avm-ptn-hubnetworking](https://registry.terraform.io/modules/Azure/avm-ptn-hubnetworking/azurerm/0.4.0?tab=inputs)
* `bastion`: This an `object` to specify the Bastion Host settings (omit this object if you don't want to deploy a Bastion Host)
  * `subnet_address_prefix`: The Bastion Host subnet address space
  * `bastion_host`: This `object` maps directly to the variables of the Azure Verified Module, which can be found here: [registry.terraform.io/modules/Azure/avm-res-network-bastionhost](https://registry.terraform.io/modules/Azure/avm-res-network-bastionhost/azurerm/0.3.1?tab=inputs)
  * `bastion_public_ip`: This `object` maps directly to the variables of the Azure Verified Module, which can be found here: [registry.terraform.io/modules/Azure/avm-res-network-publicipaddress](https://registry.terraform.io/modules/Azure/avm-res-network-publicipaddress/azurerm/0.1.2?tab=inputs) 
* `virtual_network_gateways`: This an `object` to specify the Virtual Network Gateways settings (omit this object if you don't want to deploy any Virtual Network Gateways)
  * `subnet_address_prefix`: The Virtual Network Gateway subnet address space
  * `express_route`: This `object` maps directly to the variables of the Azure Verified Module, which can be found here: [registry.terraform.io/modules/Azure/avm-ptn-vnetgateway](https://registry.terraform.io/modules/Azure/avm-ptn-vnetgateway/azurerm/0.5.0?tab=inputs)
  * `vpn`: This `object` maps directly to the variables of the Azure Verified Module, which can be found here: [registry.terraform.io/modules/Azure/avm-ptn-vnetgateway](https://registry.terraform.io/modules/Azure/avm-ptn-vnetgateway/azurerm/0.5.0?tab=inputs)
* `private_dns_zones`: This an `object` to specify the Private DNS Zone settings (omit this object if you don't want to deploy any Private DNS Zones)
  * `subnet_address_prefix`: The Private DNS Resolver subnet address space
  * `resource_group_name`: The name of the resource group to deploy the Private DNS Zones into
  * `is_primary`: Whether this is the primary region. Any non-regional Private Link Private DNS Zones will be deployed into this region. Although the Private DNS Zones are a global resource, their meta-data needs to reside in a specific region.
  * `private_link_private_dns_zones`: This is a `map(object)` used to override the Private Link Private DNS Zones that are deployed, leave this empty to deploy the default set of zones specified by ALZ
    * `zone_name`: The name of the Private DNS Zone to deploy
  * `auto_registration_zone_enabled`: Whether to deploy the Virtual Machine auto-registration Private DNS Zone
  * `auto_registration_zone_name`: The name of the Virtual Machine auto-registration Private DNS Zone
  * `private_dns_resolver`: This is an `object` to specify the Private DNS Resolver
    * `name`: The name of the Private DNS Resolver
    * `resource_group_name`: The name of the resource group to deploy the Private DNS Resolver into
    * `ip_address`: The static IP Address of the Private DNS Resolver. This will be auto calculated if not supplied

Example usage:

{{< include file="/static/examples/tf/accelerator/config/hub_and_spoke_vnet_virtual_networks.tfvars" language="terraform" >}}

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
