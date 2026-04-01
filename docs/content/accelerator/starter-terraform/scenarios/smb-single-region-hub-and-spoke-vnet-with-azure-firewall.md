---
title: 10 - SMB Single-Region Hub and Spoke Virtual Network with Azure Firewall
weight: 10
---

A cost-optimized Platform landing zone deployment designed for small-medium businesses (SMB) **only** (e.g. less than 10 workloads or less than 100/200 FTEs) that want to start with an Azure landing zone (ALZ) aligned platform landing zone but perhaps are not yet ready for the full scale of ALZ and the associated cost. This scenario uses hub and spoke Virtual Network connectivity with Azure Firewall (Basic SKU) in a single region.

{{< hint type=tip >}}
This scenario is designed to minimize costs while still providing a solid foundation for your Azure Landing Zone. As your organization grows, you can enable additional resources and expand to multiple regions.
{{< /hint >}}

{{< hint type=warning >}}
The single region option is here for completeness, we recommend always having at least 2 regions to support resiliency.
{{< /hint >}}

* Example Platform landing zone configuration file: [smb-single-region/hub-and-spoke-vnet.tfvars](https://raw.githubusercontent.com/Azure/alz-terraform-accelerator/refs/heads/main/templates/platform_landing_zone/examples/smb-single-region/hub-and-spoke-vnet.tfvars)

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

- Azure Private DNS Resolver in one region
- Azure non-regional Private Link Private DNS zones in one region
- Azure regional Private Link Private DNS zones in one region
- Azure Virtual Machine auto-registration Private DNS zone in one region
- Azure Private Link DNS zone virtual network links in one region

#### Azure Virtual Network Gateways

- Azure VPN Virtual Network Gateway in one region

### Resources Not Deployed (Cost Optimization)

The following resources are **not deployed** in this scenario to reduce costs:

{{< hint type=danger >}}
**DDoS Network Protection Plan is disabled in this scenario.** This means your public-facing resources are not protected by an Azure DDoS Network Protection Plan. Disabling it without an alternative may leave your applications and workloads vulnerable to DDoS attacks. You should weigh up the pros and cons of before deciding to disable the DDoS Network Protection Plan and also consider how you will protect your applications and services without it. You may decide the DDoS IP Protection offering per-Public IP is a suitable option, as detailed [here](https://learn.microsoft.com/azure/ddos-protection/ddos-protection-sku-comparison), or an alternative solution. 
{{< /hint >}}

- DDoS Protection Plan (see warning above - per-IP DDoS protection must be implemented as an alternative)
- ExpressRoute Gateway
- Azure Bastion

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

Private DNS is configured ready for using Private Link and Virtual Machine Auto-registration. Spoke Virtual Networks should use the Azure Firewall IP Address as their DNS configuration.

- Azure Firewall is configured as DNS proxy
- Azure Firewall forwards DNS traffic to the Private DNS resolver
- Azure Private DNS Resolver has an inbound endpoint from the hub network
- Azure Private Link DNS zones are linked to the all hub Virtual Networks

### Azure Routing

Route tables are pre-configured for spoke virtual networks in one region. Assign the user subnet route table to any subnets created in spokes.

- Azure Firewall in one region as next hop in Route Table

### DDoS Policy

- The `Enable-DDoS-VNET` policy assignment is set to `DoNotEnforce` on the `connectivity` and `landingzones` management groups, since DDoS Protection Plan is not deployed.
