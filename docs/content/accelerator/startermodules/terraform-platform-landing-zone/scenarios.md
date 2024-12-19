---
title: Scenarios
geekdocCollapseSection: true
weight: 1
---

Scenarios are common use cases when deploying the platform landing zone. The following section provide a description of the scenario and link to the pre-configured files for that scenario.

The available scenarios are:

* [Multi-Region Hub and Spoke Virtual Network with Azure Firewall](#multi-region-hub-and-spoke-virtual-network-with-azure-firewall)
* [Multi-Region Virtual WAN with Azure Firewall](#multi-region-virtual-wan-with-azure-firewall)
* [Multi-Region Hub and Spoke Virtual Network with Network Virtual Appliance (NVA)](#multi-region-hub-and-spoke-virtual-network-with-network-virtual-appliance-nva)
* [Multi-Region Virtual WAN with Network Virtual Appliance (NVA)](#multi-region-virtual-wan-with-network-virtual-appliance-nva)
* [Single-Region Hub and Spoke Virtual Network with Azure Firewall](#single-region-hub-and-spoke-virtual-network-with-azure-firewall)
* [Single-Region Virtual WAN with Azure Firewall](#single-region-virtual-wan-with-azure-firewall)
* [Management Groups, Policy and Management Resources Only](#management-groups-policy-and-management-resources-only)

## Multi-Region Hub and Spoke Virtual Network with Azure Firewall

A full platform landing zone deployment with hub and spoke Virtual Network connectivity using Azure Firewall in multiple regions.

* Example Platform landing zone configuration file: [full-multi-region/hub-and-spoke-vnet.tfvars](https://raw.githubusercontent.com/Azure/alz-terraform-accelerator/refs/heads/main/templates/platform_landing_zone/examples/full-multi-region/hub-and-spoke-vnet.tfvars)
* Detailed documentation: [Multi-region hub and spoke virtual network with Azure Firewall]({{< relref "multi-region-hub-and-spoke-vnet-with-azure-firewall" >}})

## Multi-Region Virtual WAN with Azure Firewall

A full platform landing zone deployment with Virtual WAN network connectivity using Azure Firewall in multiple regions.

* Example platform landing zone configuration file: [full-multi-region/virtual-wan.tfvars](https://raw.githubusercontent.com/Azure/alz-terraform-accelerator/refs/heads/main/templates/platform_landing_zone/examples/full-multi-region/virtual-wan.tfvars)
* Detailed documentation: [Multi-region virtual wan with Azure Firewall]({{< relref "multi-region-virtual-wan-with-azure-firewall" >}})

## Multi-Region Hub and Spoke Virtual Network with Network Virtual Appliance (NVA)

A full platform landing zone deployment with hub and spoke Virtual Network connectivity in multiple regions, ready for a third party Network Virtual Appliance (NVA).

* Example platform landing zone configuration file: [full-multi-region-nva/virtual-wan.tfvars](https://raw.githubusercontent.com/Azure/alz-terraform-accelerator/refs/heads/main/templates/platform_landing_zone/examples/full-multi-region-nva/virtual-wan.tfvars)
* Detailed documentation: [Multi-region virtual wan with Network Virtual Appliance]({{< relref "multi-region-virtual-wan-with-nva" >}})

## Multi-Region Virtual WAN with Network Virtual Appliance (NVA)

A full platform landing zone deployment with Virtual WAN network connectivity in multiple regions, ready for a third party Network Virtual Appliance (NVA).

* Example platform landing zone configuration file: [full-multi-region-nva/virtual-wan.tfvars](https://raw.githubusercontent.com/Azure/alz-terraform-accelerator/refs/heads/main/templates/platform_landing_zone/examples/full-multi-region-nva/virtual-wan.tfvars)
* Detailed documentation: [Multi-region virtual wan with Azure Firewall]({{< relref "multi-region-virtual-wan-with-nva" >}})

## Single-Region Hub and Spoke Virtual Network with Azure Firewall

A full platform landing zone deployment with hub and spoke Virtual Network connectivity using Azure Firewall in a single region.

{{< hint type=warning >}}
The single region option is here for completeness, we recommend always having at least 2 regions to support resiliency.
{{< /hint >}}

* Example Platform landing zone configuration file: [full-single-region/hub-and-spoke-vnet.tfvars](https://raw.githubusercontent.com/Azure/alz-terraform-accelerator/refs/heads/main/templates/platform_landing_zone/examples/full-single-region/hub-and-spoke-vnet.tfvars)
* Detailed documentation: [Single-region hub and spoke virtual network with Azure Firewall]({{< relref "multi-region-hub-and-spoke-vnet-with-azure-firewall" >}})

## Single-Region Virtual WAN with Azure Firewall

A full platform landing zone deployment with Virtual WAN network connectivity using Azure Firewall in a single region.

{{< hint type=warning >}}
The single region option is here for completeness, we recommend always having at least 2 regions to support resiliency.
{{< /hint >}}

* Example platform landing zone configuration file: [full-single-region/virtual-wan.tfvars](https://raw.githubusercontent.com/Azure/alz-terraform-accelerator/refs/heads/main/templates/platform_landing_zone/examples/full-single-region/virtual-wan.tfvars)
* Detailed documentation: [Single-region virtual wan with Azure Firewall]({{< relref "multi-region-virtual-wan-with-azure-firewall" >}})

## Management Groups, Policy and Management Resources Only

A platform landing zone deployment without any connectivity resources.

* Example Platform landing zone configuration file: [management_only/management.tfvars](https://raw.githubusercontent.com/Azure/alz-terraform-accelerator/refs/heads/main/templates/platform_landing_zone/examples/management_only/management.tfvars)
* Detailed documentation: [Management Only]({{< relref "management_only" >}})
