---
title: Configuration File
geekdocCollapseSection: true
weight: 3
---

## Platform landing zone configuration file

This section details the available configuration settings / variables in this starter module.

### Custom Replacements (`custom_replacements`)

The `custom_replacements` variable builds on the built-in replacements to provide user defined replacements that can be used throughout your configuration. This reduces the complexity of the configuration file by allowing re-use of names and other definitions that may be repeated throughout the configuration. 

There are 4 layers of replacements that can be built upon to provide the level of flexibility you need. The order of precedence determines which other replacements can be used to build your replacement. For example a 'Name' replacement can be used to build a 'Resource Group Identifier' replacement, but a 'Resource Group Identifier' replacement cannot be used to build a 'Name' replacement.

The layers and precedence order is:

1. Built-in Replacements: These can be found at the top of our example config files and you can also see them in the code base [here](https://github.com/Azure/alz-terraform-accelerator/blob/cf0b37351cd4f2dde9d2cf20642d76bacadf923c/templates/platform_landing_zone/locals.config.tf#L2)
2. Names: This is for resource names and other basic strings
3. Resource Group Identifiers: This is for resource group IDs
4. Resource Identifiers: This is for resource IDs

#### Names (`custom_replacements.names`)

Used to define custom names and strings that can be used throughout the configuration file. This can leverage the built-in replacements. 

Example usage:

{{< include file="/static/examples/tf/accelerator/config/custom_replacements.names.tfvars" language="terraform" >}}

#### Resource Group Identifiers (`custom_replacements.resource_group_identifiers`)

Used to define resource group IDs that can be used throughout the configuration file. This can leverage the built-in replacements and custom names. 

Example usage:

{{< include file="/static/examples/tf/accelerator/config/custom_replacements.resource_group_identifiers.tfvars" language="terraform" >}}

#### Resource Identifiers (`custom_replacements.resource_identifiers`)

Used to define resource IDs that can be used throughout the configuration file. This can leverage the built-in replacements, custom names, and resource group IDs. 

Example usage:

{{< include file="/static/examples/tf/accelerator/config/custom_replacements.resource_identifiers.tfvars" language="terraform" >}}

### Enable Telemetry (`enable_telemetry`)

The `enable_telemetry` variable determines whether telemetry about module usage is sent to Microsoft, enabling us to invest in improvements to the Accelerator and Azure Verified Modules.

Example usage:

{{< include file="/static/examples/tf/accelerator/config/enable_telemetry.tfvars" language="terraform" >}}

### Tags (`tags`)

The `tags` variable is a default set of tags to apply to resources that support them. In many cases, these tags can be overridden on a per resource basis.

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

This variable is of type `map(object)`. Some of the object properties map directly to the Azure Verified Module variables. To determine what can be supplied to these variable you can refer to the documentation for this module directly.

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

### Virtual WAN Settings (`virtual_wan_settings`)

The `virtual_wan_settings` variable is used to set the non-regional settings for the Virtual WAN connectivity option. It is used to set the Virtual WAN non-regional properties and the DDOS Protection Plan.

This variable is of type `any` as it maps directly to the Azure Verified Module variables. To determine what can be supplied to this variable you can refer to the documentation for this module directly:

Documentation link: [registry.terraform.io/modules/Azure/avm-ptn-virtualwan](https://registry.terraform.io/modules/Azure/avm-ptn-virtualwan/azurerm/0.5.3?tab=inputs)

Example usage:

{{< include file="/static/examples/tf/accelerator/config/virtual_wan_settings.tfvars" language="terraform" >}}

### Virtual WAN Virtual Hubs (`virtual_wan_virtual_hubs`)

The `hub_and_spoke_vnet_virtual_networks` variable is used to set the regional settings for the Virtual WAN connectivity options. This includes Virtual WAN Hubs, Firewalls, Virtual Network Gateways, Bastion Hosts, Private DNS Zones, and Private DNS Resolver

This variable is of type `map(object)`. Some of the object properties map directly to the Azure Verified Module variables. To determine what can be supplied to these variable you can refer to the documentation for this module directly.

The `map(object)` definition can be found [here](https://github.com/Azure/alz-terraform-accelerator/blob/cf0b37351cd4f2dde9d2cf20642d76bacadf923c/templates/platform_landing_zone/modules/hub-and-spoke-vnet/variables.tf#L14).

The supported object properties are:

* `hub`: This `object` maps directly to the `virtual_hubs` variable of the Azure Verified Module, which can be found here: [registry.terraform.io/modules/Azure/avm-ptn-virtualwan](https://registry.terraform.io/modules/Azure/avm-ptn-virtualwan/azurerm/0.5.3?tab=inputs)
* `firewall`: This `object` maps directly to the `firewalls` variable of the Azure Verified Module, which can be found here: [registry.terraform.io/modules/Azure/avm-ptn-virtualwan](https://registry.terraform.io/modules/Azure/avm-ptn-virtualwan/azurerm/0.5.3?tab=inputs)
* `firewall_policy`: This `object` maps directly to the Azure Verified Module, which can be found here: [registry.terraform.io/modules/Azure/avm-res-network-firewallpolicy](https://registry.terraform.io/modules/Azure/avm-res-network-firewallpolicy/azurerm/0.2.3?tab=inputs)
* `bastion`: This an `object` to specify the Bastion Host settings (omit this object if you don't want to deploy a Bastion Host)
  * `subnet_address_prefix`: The Bastion Host subnet address space
  * `bastion_host`: This `object` maps directly to the variables of the Azure Verified Module, which can be found here: [registry.terraform.io/modules/Azure/avm-res-network-bastionhost](https://registry.terraform.io/modules/Azure/avm-res-network-bastionhost/azurerm/0.3.1?tab=inputs)
  * `bastion_public_ip`: This `object` maps directly to the variables of the Azure Verified Module, which can be found here: [registry.terraform.io/modules/Azure/avm-res-network-publicipaddress](https://registry.terraform.io/modules/Azure/avm-res-network-publicipaddress/azurerm/0.1.2?tab=inputs) 
* `virtual_network_gateways`: This an `object` to specify the Virtual Network Gateways settings (omit this object if you don't want to deploy any Virtual Network Gateways)
  * `express_route`: This `object` maps directly to the `expressroute_gateways` variable of the Azure Verified Module, which can be found here: [registry.terraform.io/modules/Azure/avm-ptn-virtualwan](https://registry.terraform.io/modules/Azure/avm-ptn-virtualwan/azurerm/0.5.3?tab=inputs)
  * `vpn`: This `object` maps directly to the `vpn_gateways` variable of the Azure Verified Module, which can be found here: [registry.terraform.io/modules/Azure/avm-ptn-virtualwan](https://registry.terraform.io/modules/Azure/avm-ptn-virtualwan/azurerm/0.5.3?tab=inputs)
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
* `side_car_virtual_network`: This `object` maps directly to the variables of the Azure Verified Module, which can be found here: [registry.terraform.io/modules/Azure/avm-res-network-virtualnetwork](https://registry.terraform.io/modules/Azure/avm-res-network-virtualnetwork/azurerm/0.7.1?tab=inputs)

Example usage:

{{< include file="/static/examples/tf/accelerator/config/virtual_wan_virtual_hubs.tfvars" language="terraform" >}}
