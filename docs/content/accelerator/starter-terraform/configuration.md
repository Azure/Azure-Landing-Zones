---
title: Configuration File
geekdocCollapseSection: true
weight: 3
---

This section details the available configuration settings / variables in this starter module.

## Custom Replacements (`custom_replacements`)

The `custom_replacements` variable builds on the built-in replacements to provide user defined replacements that can be used throughout your configuration. This reduces the complexity of the configuration file by allowing re-use of names and other definitions that may be repeated throughout the configuration.

There are 4 layers of replacements that can be built upon to provide the level of flexibility you need. The order of precedence determines which other replacements can be used to build your replacement. For example a 'Name' replacement can be used to build a 'Resource Group Identifier' replacement, but a 'Resource Group Identifier' replacement cannot be used to build a 'Name' replacement.

The layers and precedence order is:

1. Built-in Replacements: These can be found at the top of our example config files
2. Names: This is for resource names and other basic strings
3. Resource Group Identifiers: This is for resource group IDs
4. Resource Identifiers: This is for resource IDs

### Names (`custom_replacements.names`)

Used to define custom names and strings that can be used throughout the configuration file. This can leverage the built-in replacements.

### Resource Group Identifiers (`custom_replacements.resource_group_identifiers`)

Used to define resource group IDs that can be used throughout the configuration file. This can leverage the built-in replacements and custom names.

### Resource Identifiers (`custom_replacements.resource_identifiers`)

Used to define resource IDs that can be used throughout the configuration file. This can leverage the built-in replacements, custom names, and resource group IDs.

## Enable Telemetry (`enable_telemetry`)

The `enable_telemetry` variable determines whether telemetry about module usage is sent to Microsoft, enabling us to invest in improvements to the Accelerator and Azure Verified Modules.

## Tags (`tags`)

The `tags` variable is a default set of tags to apply to resources that support them. In many cases, these tags can be overridden on a per resource basis.

## Management Resource Settings (`management_resource_settings`)

The `management_resource_settings` variable is used to configure the management resources. This includes the log analytics workspace, automation account, and data collection rules for Azure Monitoring Agent (AMA).

This definition of this variable can be found in the [variables.management.tf](https://github.com/Azure/alz-terraform-accelerator/blob/main/templates/platform_landing_zone/variables.management.tf) file.


## Management Group Settings (`management_group_settings`)

The `management_group_settings` variable is used to configure the management groups, policies, and policy role assignments.

This definition of this variable can be found in the [variables.management.tf](https://github.com/Azure/alz-terraform-accelerator/blob/main/templates/platform_landing_zone/variables.management.tf) file.

## Connectivity Type (`connectivity_type`)

The `connectivity_type` variable is used to choose the type of connectivity to deploy. Supported values are:

* `hub_and_spoke_vnet`: Deploy hub and spoke networking using Azure Virtual Networks
* `virtual_wan`: Deploy Azure Virtual WAN networking
* `none`: Don't deploy any networking

## Connectivity Resource Groups (`connectivity_resource_groups`)

The `connectivity_resource_groups` variable is used to specify the name and location of the resource groups used for connectivity.

The definition of this variable can be found in the [variables.connectivity.tf](https://github.com/Azure/alz-terraform-accelerator/blob/main/templates/platform_landing_zone/variables.connectivity.tf) file.

## Hub and Spoke Virtual Network Settings (`hub_and_spoke_networks_settings`)

The `hub_and_spoke_networks_settings` variable is used to set the non-regional settings for the hub and spoke Virtual Network connectivity option. It is only used to set the DDOS Protection Plan at this time.

The definition of this variable can be found in the [variables.connectivity.hub.and.spoke.virtual.network.tf](https://github.com/Azure/alz-terraform-accelerator/blob/main/templates/platform_landing_zone/variables.connectivity.hub.and.spoke.virtual.network.tf) file.

## Hub and Spoke Virtual Networks (`hub_virtual_networks`)

The `hub_virtual_networks` variable is used to set the regional settings for the hub and spoke Virtual Network connectivity options. This includes Hub Networks, Peering, Routing, Subnets, Firewalls, Virtual Network Gateways, Bastion Hosts, Private DNS Zones, and Private DNS Resolver

The definition of this variable can be found in the [variables.connectivity.hub.and.spoke.virtual.network.tf](https://github.com/Azure/alz-terraform-accelerator/blob/main/templates/platform_landing_zone/variables.connectivity.hub.and.spoke.virtual.network.tf) file.

## Virtual WAN Settings (`virtual_wan_settings`)

The `virtual_wan_settings` variable is used to set the non-regional settings for the Virtual WAN connectivity option. It is used to set the Virtual WAN non-regional properties and the DDOS Protection Plan.

The definition of this variable can be found in the [variables.connectivity.virtual.wan.tf](https://github.com/Azure/alz-terraform-accelerator/blob/main/templates/platform_landing_zone/variables.connectivity.virtual.wan.tf) file.

## Virtual WAN Virtual Hubs (`virtual_hubs`)

The `virtual_hubs` variable is used to set the regional settings for the Virtual WAN connectivity options. This includes Virtual WAN Hubs, Firewalls, Virtual Network Gateways, Bastion Hosts, Private DNS Zones, and Private DNS Resolver

The definition of this variable can be found in the [variables.connectivity.virtual.wan.tf](https://github.com/Azure/alz-terraform-accelerator/blob/main/templates/platform_landing_zone/variables.connectivity.virtual.wan.tf) file.
