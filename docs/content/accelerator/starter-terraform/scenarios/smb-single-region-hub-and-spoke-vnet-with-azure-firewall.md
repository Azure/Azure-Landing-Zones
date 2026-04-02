---
title: 10 - SMB Single-Region Hub and Spoke Virtual Network with Azure Firewall
weight: 10
---

A cost-optimized Platform landing zone deployment designed for small-medium businesses (SMB) **only** (e.g. less than 10 workloads or less than 100/200 FTEs) that want to start with an Azure landing zone (ALZ) aligned platform landing zone but perhaps are not yet ready for the full scale of ALZ and the associated cost. This scenario uses hub and spoke Virtual Network connectivity with Azure Firewall (Basic SKU) in a single region.

{{< hint type=tip >}}
This scenario is designed to minimize costs while still providing a solid foundation for your Azure landing zone. As your organization grows, you can enable additional resources and expand to multiple regions easily without having to redeploy etc.
{{< /hint >}}

{{< hint type=warning >}}
This scenario deploys to a single region to reduce cost and complexity. As your organization grows, we recommend expanding to at least 2 regions to support resiliency. See [Upgrading to Enterprise Scale](#upgrading-to-enterprise-scale) for details.
{{< /hint >}}

* Example Platform landing zone configuration file: [smb-single-region/hub-and-spoke-vnet.tfvars](https://raw.githubusercontent.com/Azure/alz-terraform-accelerator/refs/heads/main/templates/platform_landing_zone/examples/smb-single-region/hub-and-spoke-vnet.tfvars)

## Contents

- [Estimated Costs](#estimated-costs) - Approximate monthly infrastructure costs
- [Resources](#resources) - What gets deployed in this scenario
- [Configuration](#configuration) - How DNS, routing, and policies are configured
- [Upgrading to Enterprise Scale](#upgrading-to-enterprise-scale) - Steps to grow beyond SMB

## Estimated Costs

| Resource | Estimated Monthly Cost (USD) |
| - | -: |
| Azure Firewall (Basic) | 288.35 |
| VPN Gateway (VpnGw2AZ) | 394.20 |
| Public IP Addresses (x2) | 7.30 |
| **Total** | **689.85** |

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

### Connectivity

#### Azure Virtual Networks

- Hub virtual network in one region
- Subnets for Firewall, Gateway, and Private DNS Resolver in one region
- Azure Route table for Firewall in one region
- Azure Route table for other subnets and spokes in one region

#### Azure Firewall

- Azure Firewall (Basic SKU) in one region
- Azure Firewall public IP in one region
- Azure Firewall policy (Basic SKU) in one region

#### Azure Private DNS

Private DNS zones and Private DNS Resolver are **not deployed** by default in this scenario. See the [DNS](#azure-dns) section below for details.

#### Azure Virtual Network Gateways

- Azure VPN Virtual Network Gateway in one region

### Resources Not Deployed (Cost Optimization)

The following resources are **not deployed** in this scenario to reduce costs:

{{< hint type=danger >}}
**DDoS Network Protection Plan is disabled in this scenario.** This means your public-facing resources are not protected by an Azure DDoS Network Protection Plan. Disabling it without an alternative may leave your applications and workloads vulnerable to DDoS attacks. You should weigh up the pros and cons of before deciding to disable the DDoS Network Protection Plan and also consider how you will protect your applications and services without it. You may decide the DDoS IP Protection offering per-Public IP is a suitable option, as detailed [here](https://learn.microsoft.com/azure/ddos-protection/ddos-protection-sku-comparison), or an alternative solution.
{{< /hint >}}

- DDoS Protection Plan
- ExpressRoute Gateway
- Azure Bastion
- Private DNS Zones and Private DNS Resolver (see [DNS](#azure-dns) section below)

### Subscription Placement

{{< hint type=tip >}}
**Identity and Security subscriptions are recommended but optional.** The configuration has the identity and security subscription placements commented out. When you are ready to add dedicated subscriptions for identity and security workloads, uncomment the relevant blocks in the configuration file and supply the subscription IDs.
{{< /hint >}}

- Connectivity subscription - placed under the `connectivity` management group
- Management subscription - placed under the `management` management group
- Identity subscription - **commented out** (uncomment when ready)
- Security subscription - **commented out** (uncomment when ready)

## Configuration

The following relevant configuration is applied:

### Azure DNS

Azure Firewall Basic SKU does not support the DNS proxy feature. As a result, centralized Private DNS zone management and Private DNS Resolver are **disabled by default** in this scenario.

At the scale this scenario is designed for (less than 10 workloads), Private Link Private DNS zones can be created directly in spoke subscriptions as needed, rather than centrally managing them. This keeps the configuration simpler and avoids the cost of additional infrastructure.

{{< hint type=tip >}}
**As your organization grows**, you should upgrade the firewall SKU from `Basic` to `Standard` (by updating the `primary_firewall_sku_tier` setting) and enable the centralized Private DNS zones and Private DNS Resolver (see [Turn off Private DNS zones]({{< relref "../options/dns" >}}) for details on how to enable them). This will allow you to use Azure Firewall as a DNS proxy and centrally manage DNS resolution for Private Link across all spokes.
{{< /hint >}}

### Azure Routing

Route tables are pre-configured for spoke virtual networks in one region. Assign the user subnet route table to any subnets created in spokes.

- Azure Firewall in one region as next hop in Route Table

### DDoS Policy

- The `Enable-DDoS-VNET` policy assignment is set to `DoNotEnforce` on the `connectivity` and `landingzones` management groups, since DDoS Protection Plan is not deployed.

### Private DNS Zones Policy

- The `Deploy-Private-DNS-Zones` policy assignment is set to `DoNotEnforce` on the `corp` management group, since centralized Private DNS zones are not deployed.

## Upgrading to Enterprise Scale

As your organization grows beyond the SMB scale, you can upgrade this deployment to a full enterprise-scale configuration without redeploying. Update your Platform landing zone configuration file with the following changes:

1. **Upgrade the Azure Firewall SKU** - Update `primary_firewall_sku_tier` from `"Basic"` to `"Standard"` (or `"Premium"` for [Zero Trust]({{< relref "../options/zero-trust" >}})).
2. **Enable centralized Private DNS zones and Private DNS Resolver** - Set `primary_private_dns_zones_enabled`, `primary_private_dns_auto_registration_zone_enabled`, and `primary_private_dns_resolver_enabled` to `true`. See [Turn off Private DNS zones]({{< relref "../options/dns" >}}) for details.
3. **Enable DDoS Protection Plan** - Set `ddos_protection_plan_enabled` to `true`. See [Turn off DDOS protection plan]({{< relref "../options/ddos" >}}) for details.
4. **Enforce DDoS policy** - Remove the `Enable-DDoS-VNET` entries from the `policy_assignments_to_modify` section for the `connectivity` and `landingzones` management groups.
5. **Enforce Private DNS Zones policy** - Remove the `Deploy-Private-DNS-Zones` entry from the `policy_assignments_to_modify` section for the `corp` management group.
6. **Enable Azure Bastion** - Set `primary_bastion_enabled` to `true`. See [Turn off Bastion host]({{< relref "../options/bastion" >}}) for details.
5. **Enable ExpressRoute Gateway** - Set `primary_virtual_network_gateway_express_route_enabled` to `true`. See [Turn off Virtual Network Gateways]({{< relref "../options/gateways" >}}) for details.
6. **Add Identity and Security subscriptions** - Uncomment the `identity` and `security` blocks in the `management_group_settings` > `subscription_placement` section of your configuration file and supply the subscription IDs.
7. **Add additional regions** - See [Additional Regions]({{< relref "../options/regions" >}}) for details.

Once you have made the changes, commit and push them to your repository. The Continuous Delivery pipeline / workflow will run a plan and apply the changes.

### Post-Deployment Steps

After the Continuous Delivery pipeline has completed:

1. **Migrate spoke Private DNS zones** - Delete any Private Link Private DNS zones that were created directly in spoke subscriptions. The centralized zones deployed by the platform will replace them.
2. **Remediate the Private DNS Zones policy** - Trigger a [policy remediation](https://learn.microsoft.com/azure/governance/policy/how-to/remediate-resources) for `Deploy-Private-DNS-Zones` on the `corp` management group to create the Private DNS zone links for any existing Private Link endpoints in your spokes.
3. **Remediate the DDoS policy** - Trigger a policy remediation for `Enable-DDoS-VNET` on the `connectivity` and `landingzones` management groups to associate the DDoS Protection Plan with existing virtual networks.
