---
title: Module Index
geekdocCollapseSection: true
weight: 4
---

For reference, the following is a list of the [Azure Verified Modules](https://aka.ms/avm) used by this starter module

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
