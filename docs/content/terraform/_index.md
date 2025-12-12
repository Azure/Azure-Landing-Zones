---
title: Terraform
geekdocCollapseSection: true
weight: 25
---

ALZ ❤️ AVM - Azure Verified Modules (AVM) for Platform landing zone (ALZ)

Based on continuous feedback from the community, we have adopted a more modular approach to deploying Azure landing zone with Terraform.
This new approach is based on [Azure Verified Modules](https://aka.ms/avm) (AVM) and is designed to be more flexible.

## Branding

With the move to using Azure Verified Modules, we have new branding!
We are using the following wording to describe the new offerings:

> **Azure Verified Modules (AVM) for Platform landing zone (ALZ)**

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

The new approach is based on [Azure Verified Modules](https://aka.ms/avm) and is designed to be more flexible.

Here is the list of modules that pertain to Azure landing zone and covers the scope of the original ALZ Terraform module:

- [Management Groups, Policy and Role Assignments](https://registry.terraform.io/modules/Azure/avm-ptn-alz/azurerm/latest)
- [Management Resources](https://registry.terraform.io/modules/Azure/avm-ptn-alz-management/azurerm/latest)
- [Hub and Spoke Networking](https://registry.terraform.io/modules/Azure/avm-ptn-alz-connectivity-hub-and-spoke-vnet/azurerm/latest)
- [Virtual WAN](https://registry.terraform.io/modules/Azure/avm-ptn-alz-connectivity-virtual-wan/azurerm/latest)

{{< hint type=tip >}}
Refer to each module's documentation to understand the full list of features and customization options.
In this documentation site, we will cover the ALZ core module and the inputs that we need.
We do not cover the inputs to the other modules, as they are covered in the module documentation.
{{< /hint >}}

Using these modules together, you can create a fully customized Azure Landing Zone.

## How do I deploy?

For most customers, we recommend you use the [Accelerator]({{< relref "accelerator" >}}).
This uses all the modules above, but in a pre-defined configuration and opinionated approach.
There are still customization options available, but the [Accelerator]({{< relref "accelerator" >}}) is designed to get you up and running quickly - as a bonus it also includes CI/CD pipelines!

## I'm an advanced user, how to I get started?

We recognize that this is a significant change, and we want to make it as easy as possible for you to get started.
We have created this documentation site to centralize the integration documentation for the new modular approach.

In here you will find guidance on how to use the [ALZ core pattern module](https://registry.terraform.io/modules/Azure/avm-ptn-alz/azurerm/latest) with those listed above to build your very own Azure Landing Zone.
To proceed, you should be comfortable creating Terraform configurations and using Terraform modules.
If you are not, we recommend that you take a look at the [Accelerator]({{< relref "accelerator" >}}) as it offers a simplified experience.

Move on to the [getting started]({{< relref "gettingStarted" >}}) section to get started with the new approach.
