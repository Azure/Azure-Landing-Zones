---
title: Terraform
geekdocCollapseSection: true
weight: 20
---

ALZ ❤️ AVM - A new approach to Azure Landing Zones with Terraform

Based on continuous feedback from the community, we have adopted a more modular approach to deploying Azure Landing Zones with Terraform.
This new approach is based on the Azure Virtual Network Module (AVM) and is designed to be more flexible.

## Why have we made this change?

We received feedback from our community that the following improvements were needed:

### Customization

You asked us to be able to fully customize the configuration of each component.
Examples included defining a custom management group hierarchy, or setting specific settings (and names!) on resources.
This requirement was front and center in our minds when designing the new approach.

***You can now fully customize the configuration of each component (including the resource names 😇).***

### Modularity

You didn't like that the module contained a combination of components that you may not need, and that you had to deploy the entire module even if you only wanted to use a subset of the components.

You also asked that we make it easier for organizations to have different teams manage different components of the Azure Landing Zone.

***You can now choose your own adventure and pick and choose only the components you need.***

## What is the new approach?

The new approach is based on  Azure Virtual Network Modules (AVM) and is designed to be more flexible.

Here is the list of modules that pertain to Azure Landing Zones and covers the scope of the original ALZ Terraform module:

- [ALZ core](https://registry.terraform.io/modules/Azure/avm-ptn-alz/azurerm/latest)
- [ALZ management](https://registry.terraform.io/modules/Azure/avm-ptn-alz-management/azurerm/latest)
- [Hub networking](https://registry.terraform.io/modules/Azure/avm-ptn-hubnetworking/azurerm/latest)
- [Virtual network gateway](https://registry.terraform.io/modules/Azure/avm-ptn-virtualwan/azurerm/latest)
- [Virtual WAN](https://registry.terraform.io/modules/Azure/avm-ptn-virtualwan/azurerm/latest)
- [Private link DNS zones](https://registry.terraform.io/modules/Azure/avm-ptn-network-private-link-private-dns-zones/azurerm/latest)

Using these modules together, you can create a fully customized Azure Landing Zone.

## What if I want to use the old approach?

If you want a simpler, more opinionated approach, you can use the [Accelerator]({{< relref "accelerator" >}}).
This uses all the modules above, but in a pre-defined configuration and opinionated approach.
There are still customization options available, but the [Accelerator]({{< relref "accelerator" >}}) is designed to get you up and running quickly - as a bonus it also includes CI/CD pipelines!

## How do I get started?

We recognize that this is a significant change, and we want to make it as easy as possible for you to get started.
We have created this documentation site to centralize the integration documentation for the new modular approach.

In here you will find examples and guidance on how to use the new modules to build your very own Azure Landing Zone.

{{< hint type=note title="Deployment order" >}}
This guide will walk you through the deployment of the management components first, then the networking components, and finally  management groups and policy.

it is possible to deploy all these in one apply, but for the purposes of this guide we will break it down into these three sections.
{{< /hint >}}

[Get started with deploying the management components]({{< relref "terraform/1_managementcomponents" >}})
