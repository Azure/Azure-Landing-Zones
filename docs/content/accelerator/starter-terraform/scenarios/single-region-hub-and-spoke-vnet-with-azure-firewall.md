---
title: 6 - Single-Region Hub and Spoke Virtual Network with Azure Firewall
weight: 6
---

A full Platform landing zone deployment with hub and spoke Virtual Network connectivity using Azure Firewall in a single region.

{{< hint type=warning >}}
The single region option is here for completeness, we recommend always having at least 2 regions to support resiliency.
{{< /hint >}}

* Example Platform landing zone configuration file: [full-single-region/hub-and-spoke-vnet.tfvars](https://raw.githubusercontent.com/Azure/alz-terraform-accelerator/refs/heads/main/templates/platform_landing_zone/examples/full-single-region/hub-and-spoke-vnet.tfvars)

## Contents

- [Estimated Costs](#estimated-costs) - Approximate monthly infrastructure costs
- [Resources](#resources) - What gets deployed in this scenario
- [Configuration](#configuration) - How DNS, routing, and policies are configured

## Estimated Costs

| Resource | Estimated Monthly Cost (USD) |
| - | -: |
| Azure Firewall (Standard) | 912.50 |
| Firewall Policy (Standard) | 100.00 |
| VPN Gateway (VpnGw2AZ) | 394.20 |
| ExpressRoute GW (ErGw2AZ) | 461.36 |
| Azure Bastion (Standard) | 211.70 |
| DDoS Protection Plan | 2,944.00 |
| Private DNS Resolver | 180.00 |
| Private DNS Zones (x110) | 55.00 |
| Public IP Addresses (x4) | 14.60 |
| **Total** | **5,273.36** |

> **Note:** Estimated fixed infrastructure costs based on [Azure Retail Prices](https://learn.microsoft.com/rest/api/cost-management/retail-prices/azure-retail-prices) for the **westus** region in **USD** as of **2026-04-02**. Consumption-based costs (data processing, log ingestion, DNS queries, etc.) are not included and will vary based on usage. DDoS Protection Plan pricing is sourced from the [Azure DDoS Protection pricing page](https://azure.microsoft.com/pricing/details/ddos-protection/). You can generate your own estimates for any region and currency using the [Get-ScenarioCostEstimates.ps1](https://github.com/Azure/Azure-Landing-Zones/blob/main/utl/cost-estimates/Get-ScenarioCostEstimates.ps1) script.

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

#### Subscription Placement

{{< hint type=tip >}}
**Identity and Security subscriptions are recommended but optional.** If you do not yet have dedicated subscriptions for identity and security workloads, you can comment out or remove the identity and security subscription placement blocks in the configuration file and add them later.
{{< /hint >}}

- Connectivity subscription - placed under the `connectivity` management group
- Management subscription - placed under the `management` management group
- Identity subscription - placed under the `identity` management group (recommended)
- Security subscription - placed under the `security` management group (recommended)

#### Azure DDOS Protection Plan

- DDOS Protection Plan

#### Azure Virtual Networks

- Hub virtual network in one region
- Subnets for Firewall, Gateway, Bastion, and Private DNS Resolver in one region
- Azure Route table for Firewall in one region
- Azure Route table for other subnets and spokes in one region

#### Azure Firewall

- Azure Firewall in one region
- Azure Firewall public IP in one region
- Azure Firewall policy in one region

#### Azure Bastion

- Azure Bastion in one region
- Azure Bastion public ip in one region

#### Azure Private DNS

- Azure Private DNS Resolver in one region
- Azure non-regional Private Link Private DNS zones in one region
- Azure regional Private Link Private DNS zones in one region
- Azure Virtual Machine auto-registration Private DNS zone in one region
- Azure Private Link DNS zone virtual network links in one region

#### Azure Virtual Network Gateways

- Azure ExpressRoute Virtual Network Gateway in one region
- Azure VPN Virtual Network Gateway in one region

## Configuration

The following relevant configuration is applied:

### Azure DNS

Private DNS is configured ready for using Private Link and Virtual Machine Auto-registration. Spoke Virtual Networks should use the Azure Firewall IP Address as their DNS configuration.

- Azure Firewall is configured as DNS proxy
- Azure Firewall forwards DNS traffic to the Private DNS resolver
- Azure Private DNS Resolver has an inbound endpoint from the hub network
- Azure Private Link DNS zones are linked to the all hub Virtual Networks

### Azure Routing

Route tables are pre-configured for spoke virtual networks in one region. Assign the user subnet route table to any subnets created in spokes.

- Azure Firewall in one region as next hop in Route Table
