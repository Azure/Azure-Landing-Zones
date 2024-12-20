---
title: Terraform - Azure Verified Modules for Platform Landing Zone (ALZ)
geekdocCollapseSection: true
---

The Azure Verified Modules for Platform Landing Zone (ALZ) (`platform_landing_zone`) starter module deploys the end to end platform landing zone using Azure Verified Modules. It is fully configurable to meet different scenarios.

This documentation covers the top scenarios and documents all available configuration settings for this module.

We aim to cover 80% of common scenarios. If the particular scenario is not covered here, it may be possible to adjust the configuration settings to match the requirements. If not, then please raise an [Issue](https://aka.ms/alz/acc/issues) and we'll see if we can support it.

This documentation covers the following:

* [Scenarios]({{< relref "scenarios">}}): The scenarios supported with example configuration files
* [Options]({{< relref "options">}}): Common customization tasks and how to perform them are documented here
* [Platform landing zone configuration file]({{< relref "configuration">}}): Comprehensive documentation of the available input variables
* [Azure Verified Modules Reference]({{< relref "module-index">}}): A reference list and explanation of the Azure Verified Modules used in this starter module 

Follow these steps to populate and configure your platform landing zone configuration file:

{{< hint type=tip >}}
If you followed our [phase 0 planning and decisions]({{< relref "../../userguide/0_planning">}}) guidance, you should have these choices already.
{{< /hint >}}

## 1 - Scenarios

Scenarios are common high level use cases when deploying the platform landing zone.

Choose your preferred scenario and copy the example configuration file to your `platform-landing-zone.tfvars` file.

The scenarios can be found in the [Scenarios]({{< relref "scenarios" >}}) documentation.

## 2 - Options

The options section details how to make configuration changes that apply to the common scenarios.

Choose your preferred option and update the your `platform-landing-zone.tfvars` file by following the detailed instructions for each option.

The options can be found in the [Options]({{< relref "options" >}}) documentation.

## 3 - Advanced

If you were unable to cover all your platform landing zone requirements with our standard scenarios and options, you can use the con

## Next Steps

Now head back to [Phase 2]({{< relref "../../userguide/2_start" >}}) to continue your deployment.
