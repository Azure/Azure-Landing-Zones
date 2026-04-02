---
title: 3 - Multi-Region Hub and Spoke Virtual Network with Network Virtual Appliance (NVA)
weight: 3
---

A full Platform landing zone deployment with hub and spoke Virtual Network connectivity in multiple regions, ready for a third party Network Virtual Appliance (NVA).

* Example Platform landing zone configuration file: [full-multi-region-nva/hub-and-spoke-vnet.tfvars](https://raw.githubusercontent.com/Azure/alz-terraform-accelerator/refs/heads/main/templates/platform_landing_zone/examples/full-multi-region-nva/hub-and-spoke-vnet.tfvars)

## Contents

- [Estimated Costs](#estimated-costs) - Approximate monthly infrastructure costs
- [Resources](#resources) - What gets deployed in this scenario
- [Configuration](#configuration) - How DNS, routing, and policies are configured

## Estimated Costs

| Resource | Estimated Monthly Cost (USD) |
| - | -: |
| VPN Gateway (VpnGw2AZ) x2 | 788.40 |
| ExpressRoute GW (ErGw2AZ) x2 | 922.72 |
| Azure Bastion (Standard) x2 | 423.40 |
| DDoS Protection Plan | 2,944.00 |
| Private DNS Resolver x2 | 360.00 |
| Private DNS Zones (x110) | 55.00 |
| Public IP Addresses (x6) | 21.90 |
| **Total** | **5,515.42** |

{{< hint type=note >}}
This estimate does not include the cost of the Network Virtual Appliance (NVA) itself, which varies by vendor and configuration.
{{< /hint >}}

{{< hint type=note >}}
Estimated fixed infrastructure costs based on [Azure Retail Prices](https://learn.microsoft.com/rest/api/cost-management/retail-prices/azure-retail-prices) for the **westus** region in **USD** as of **2026-04-02**. Consumption-based costs (data processing, log ingestion, DNS queries, etc.) are not included and will vary based on usage. DDoS Protection Plan pricing is sourced from the [Azure DDoS Protection pricing page](https://azure.microsoft.com/pricing/details/ddos-protection/). You can generate your own estimates for any region and currency using the [Get-ScenarioCostEstimates.ps1](https://github.com/Azure/Azure-Landing-Zones/blob/main/utl/cost-estimates/Get-ScenarioCostEstimates.ps1) script.
{{< /hint >}}

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

- Hub virtual networks in each region
- Hub virtual network peering
- Subnets for Network Virtual Appliance, Gateway, Bastion, and Private DNS Resolver in each region
- Azure Route table for Network Virtual Appliance per region
- Azure Route table for other subnets and spokes per region

#### Azure Bastion

- Azure Bastion per region
- Azure Bastion public ip per region

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

Private DNS is configured ready for using Private Link and Virtual Machine Auto-registration. Spoke Virtual Networks should use the Network Virtual Appliance IP Address in the same region as their DNS configuration.

- Network Virtual Appliance should be configured as DNS proxy
- Network Virtual Appliance should be forward DNS traffic to the Private DNS resolver
- Azure Private DNS Resolver has an inbound endpoint from the hub network
- Azure Private Link DNS zones are linked to the all hub Virtual Networks

### Azure Routing

Route tables are pre-configured for spoke virtual networks in each region. Assign the user subnet route table to any subnets created in spokes.

- Network Virtual Appliance in relevant region as next hop in Route Table
