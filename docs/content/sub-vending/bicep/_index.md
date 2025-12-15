---
title: Bicep
geekdocCollapseSection: true
weight: 40
---
Welcome to the Bicep Subscription vending module documentation.

Please see the [README](https://aka.ms/lz-vending/bicep) (in the BRM repository) for information on module requirements, parameters and outputs. This wiki contains longer form documentation.

This module can be used standalone, or combined with the [Azure Verified Modules (AVM) for Platform landing zone (ALZ) - Bicep]({{< relref "../../bicep">}}) to create a landing zone within the [Azure Landing Zones reference architecture](https://aka.ms/alz#azure-landing-zone-architecture).

![Subscription vending](https://learn.microsoft.com/azure/cloud-adoption-framework/ready/landing-zone/design-area/media/subscription-vending-high-res.png)

In the above diagram, this module provides the capability to deploy landing zones (subscriptions) and the core resources, e.g. networking.

We recommend that you deploy the platform using the [Azure Verified Modules (AVM) for Platform landing zone (ALZ) - Bicep]({{< relref "../../bicep">}}) and then use this module to deploy the landing zones.

Before deployment, please review the [required permissions]({{< relref "permissions">}}). Then to get started, look at one of the [examples]({{< relref "examples">}}).
