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

| Variable | Child Variable | Description |
| -- | -- | -- | -- |
| `custom_replacements` | `names` | Used to define custom names and strings that can be used throughout the configuration file. This can leverage the built in  {{< include file="/static/examples/tf/accelerator/config/custom_replacements.names.tfvars" language="terraform" >}} |
| `custom_replacements` | `names` |

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
