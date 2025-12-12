---
title: Subscription Vending
geekdocCollapseSection: true
weight: 30
resources:
  - name: subscription-vending-journey
    src: img/subscription-vending-journey.png
    title: Subscription Vending Journey
---

Welcome to the avm-ptn-alz-sub-vending module documentation.

Please see the [README][readme] for information on module requirements, variables and outputs.
This section contains longer form documentation.

This module can be used standalone, or combined with the [Azure landing zone Terraform module][alz_tf_module] to create a landing zone within the [Azure landing zone conceptual architecture][alz_conceptual_arch].

{{< img name="subscription-vending-journey" size="origin" lazy=true >}}

In the above diagram, this module provides the capability to deploy landing zones (subscriptions) and the core resources, e.g. networking.

We recommend that you deploy the platform using the [Azure landing zone Terraform module][alz_tf_module] and then use this module to deploy the landing zones.

Before deployment, please review the [required permissions](permissions) and [provider configuration](provider-configuration).
Then to get started, look at one of the [examples](examples).

[alz_conceptual_arch]: https://docs.microsoft.com/azure/cloud-adoption-framework/ready/landing-zone/#azure-landing-zone-conceptual-architecture
[alz_tf_module]: https://aka.ms/alz/tf
[readme]: https://github.com/Azure/terraform-azurerm-avm-ptn-alz-sub-vending#readme
