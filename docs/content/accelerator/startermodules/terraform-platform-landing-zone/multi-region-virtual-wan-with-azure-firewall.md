---
title: Scenario - Multi-region Virtual WAN with Azure Firewall
---

A full platform landing zone deployment with Virtual WAN network connectivity using Azure Firewall.

## Links

- Example Platform landing zone config file: [full-multi-region/virtual-wan.tfvars](https://raw.githubusercontent.com/Azure/alz-terraform-accelerator/refs/heads/main/templates/platform_landing_zone/examples/full-multi-region/virtual-wan.tfvars)

## Resources

The following resources are deployed by default in this scenario:

### Management

#### Management Groups

- Management Groups
- Policy Definitions
- Policy Set Definitions
- Policy Assignments
- Policy Assignment Role Assignments

#### Management Resources

- Log Analytics Workspace
- Log Analytics Data Collection Rules for AMA
- User Assigned Managed Identity for AMA
- Automation Account

### Connectivity

#### Azure DDOS Protection Plan

- DDOS Protection Plan

#### Azure Virtual WAN

- Virtual WAN homed in the primary region
- Virtual Hubs in each region

#### Azure Virtual Networks

- Sidecar Virtual Networks
- Sidecar to Virtual Hub peering
- Subnets for Bastion, and Private DNS Resolver in each region

#### Azure Firewall

- Azure Firewall per region
- Azure Firewall public IP per region
- Azure Firewall policy per region

#### Azure Bastion

- Azure Bastion per region
- Azure Bastion puplic ip per region

#### Azure Private DNS

- Azure Private DNS Resolver per region
- Azure non-regional Private Link Private DNS zones in primary region
- Azure regional Private Link Private DNS zones per region
- Azure Virtual Machine auto-registration Private DNS zone per region
- Azure Private Link DNS zone virtual network links per region

#### Azure Virtual Network Gateways

- Azure ExpressRoute Virtual Network Gateway per region
- Azure VPN Virtual Network Gateway per region

## Configuration

The following relevant configuration is applied:

### Azure DNS

Private DNS is configured ready for using Private Link and Virtual Machine Auto-registration. Spoke Virtual Networks should use the Azure Firewall IP Address in the same region as their DNS configuration.

- Azure Firewall is configured as DNS proxy
- Azure Firewall forwards DNS traffic to the Private DNS resolver
- Azure Private DNS Resolver has an inbound endpoint from the sidecar network
- Azure Private Link DNS zones are linked to the all hub sidcar Virtual Networks
