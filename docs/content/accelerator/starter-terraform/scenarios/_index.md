---
title: Scenarios
geekdocCollapseSection: true
weight: 1
---

Scenarios are common use cases when deploying the Platform landing zone. The following section provide a description of the scenario and link to the pre-configured files for that scenario.

## Contents

- [Full Scenarios](#full-scenarios) - Enterprise-scale deployments with full resource coverage
- [SMB Scenarios](#smb-small-medium-business-scenarios) - Cost-optimized deployments for smaller organizations
- [Estimated Costs](#estimated-costs) - Approximate monthly infrastructure cost comparison

### Full Scenarios

1. [Multi-Region Hub and Spoke Virtual Network with Azure Firewall]({{< relref "multi-region-hub-and-spoke-vnet-with-azure-firewall" >}})
2. [Multi-Region Virtual WAN with Azure Firewall]({{< relref "multi-region-virtual-wan-with-azure-firewall" >}})
3. [Multi-Region Hub and Spoke Virtual Network with Network Virtual Appliance (NVA)]({{< relref "multi-region-hub-and-spoke-vnet-with-nva" >}})
4. [Multi-Region Virtual WAN with Network Virtual Appliance (NVA)]({{< relref "multi-region-virtual-wan-with-nva" >}})
5. [Management Groups, Policy and Management Resources Only]({{< relref "management-only" >}})
6. [Single-Region Hub and Spoke Virtual Network with Azure Firewall]({{< relref "single-region-hub-and-spoke-vnet-with-azure-firewall" >}})
7. [Single-Region Virtual WAN with Azure Firewall]({{< relref "single-region-virtual-wan-with-azure-firewall" >}})
8. [Single-Region Hub and Spoke Virtual Network with Network Virtual Appliance (NVA)]({{< relref "single-region-hub-and-spoke-vnet-with-nva" >}})
9. [Single-Region Virtual WAN with Network Virtual Appliance (NVA)]({{< relref "single-region-virtual-wan-with-nva" >}})

### SMB (Small-Medium Business) Scenarios

These scenarios are designed for small-medium businesses **only** (e.g. less than 10 workloads or less than 100/200 FTEs) that want to start with an Azure landing zone (ALZ) aligned platform landing zone but perhaps are not yet ready for the full scale of ALZ and the associated cost. However, they want to start on the right path and not pin themselves in to an architecture they cannot expand upon later. They are cost-optimized with reduced resource deployment, out of the box.

Identity and security subscriptions are recommended but optional in these scenarios also.

{{< hint type=warning >}}
The SMB scenarios disable the DDoS Network Protection Plan to reduce costs. If you use these scenarios, you **MUST** consider and plan how to sufficiently protect your applications and workloads from DDoS attacks, like using [DDoS IP Protection](https://learn.microsoft.com/azure/ddos-protection/ddos-protection-sku-comparison), or an alternative solution.
{{< /hint >}}

10. [SMB Single-Region Hub and Spoke Virtual Network with Azure Firewall]({{< relref "smb-single-region-hub-and-spoke-vnet-with-azure-firewall" >}})
11. [SMB Single-Region Virtual WAN with Azure Firewall]({{< relref "smb-single-region-virtual-wan-with-azure-firewall" >}})

### Estimated Costs

The following table provides an approximate monthly cost comparison for the fixed infrastructure resources deployed by each scenario. Costs are based on the **westus** region in **USD**.

| Scenario | Estimated Monthly Cost (USD) |
| - | -: |
| Multi-Region Hub & Spoke with Azure Firewall | 7,547.72 |
| Multi-Region Virtual WAN with Azure Firewall | 7,533.12 |
| Multi-Region Hub & Spoke with NVA | 5,515.42 * |
| Multi-Region Virtual WAN with NVA | 5,500.82 * |
| Management Only | 0.00 |
| Single-Region Hub & Spoke with Azure Firewall | 5,273.36 |
| Single-Region Virtual WAN with Azure Firewall | 5,266.06 |
| Single-Region Hub & Spoke with NVA | 4,257.21 * |
| Single-Region Virtual WAN with NVA | 4,249.91 * |
| SMB Single-Region Hub & Spoke | 689.85 |
| SMB Single-Region Virtual WAN | 689.85 |

\* NVA scenarios do not include the cost of the Network Virtual Appliance itself, which varies by vendor and configuration.

> **Note:** Estimated fixed infrastructure costs based on [Azure Retail Prices](https://learn.microsoft.com/rest/api/cost-management/retail-prices/azure-retail-prices) for the **westus** region in **USD** as of **2026-04-02**. Consumption-based costs (data processing, log ingestion, DNS queries, etc.) are not included and will vary based on usage. DDoS Protection Plan pricing is sourced from the [Azure DDoS Protection pricing page](https://azure.microsoft.com/pricing/details/ddos-protection/). You can generate your own estimates for any region and currency using the [Get-ScenarioCostEstimates.ps1](https://github.com/Azure/Azure-Landing-Zones/blob/main/utl/cost-estimates/Get-ScenarioCostEstimates.ps1) script.
