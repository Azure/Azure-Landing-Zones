---
title: Terraform - Azure Verified Modules for Platform Landing Zone (ALZ)
geekdocCollapseSection: true
---

The Azure Verified Modules for Platform Landing Zone (ALZ) (`platform_landing_zone`) starter module deploys the end to end platform landing zone using Azure Verified Modules. It is fully configurable to meet different scenarios.

This documentation covers the top scenarios and documents all available configuration settings for this module.

We aim to cover 80% of common scenarios. If the particular scenario is not covered here, it may be possible to adjust the configuration settings to match the requirements. If not, then please raise an [Issue](https://aka.ms/alz/acc/issues) and we'll see if we can support it.

This documentation covers the following:

* [Microsoft Defender for Cloud security contact email address]({{< relref "#microsoft-defender-for-cloud-security-contact-email-address" >}}): The email address used by Microsoft Defender for Cloud to send security alerts to the security contact at your organization
* [Scenarios]({{< relref "scenarios">}}): The scenarios supported with example configuration files
* [Options]({{< relref "options">}}): Common customization tasks and how to perform them are documented here
* [Platform landing zone configuration file]({{< relref "configuration">}}): Comprehensive documentation of the available input variables
* [Azure Verified Modules Reference]({{< relref "module-index">}}): A reference list and explanation of the Azure Verified Modules used in this starter module 

Follow these steps to populate and configure your platform landing zone configuration file:

{{< hint type=tip >}}
If you followed our [phase 0 planning and decisions]({{< relref "../../userguide/0_planning">}}) guidance, you should have these choices already.
{{< /hint >}}

## 1 - Microsoft Defender for Cloud security contact email address

The `defender_email_security_contact` is used by Microsoft Defender for Cloud to send security alerts to the security contact at your organization. You need to update the value with a valid security contact email address for your organization.

You'll find this setting near the top of the `platform-landing-zone.tfvars` file.

To update it:

1. Use <kbd>Ctrl</kbd> + <kbd>F</kbd> to bring up the search dialog
1. Enter `defender_email_security_contact` in the search dialog
1. Hit enter to search for the key
1. Update the value `replace_me@replace_me.com` with a valid security contact email address for your organization
1. Save the configuration file

## 2 - Scenarios

Scenarios are common high level use cases when deploying the platform landing zone.

Choose your preferred scenario and copy the example configuration file to your `platform-landing-zone.tfvars` file.

The scenarios can be found in the [Scenarios]({{< relref "scenarios" >}}) documentation.

## 3 - Options

The options section details how to make configuration changes that apply to the common scenarios.

Choose your preferred option and update the your `platform-landing-zone.tfvars` file by following the detailed instructions for each option.

The options can be found in the [Options]({{< relref "options" >}}) documentation.

## 4 - Advanced

If you were unable to cover all your platform landing zone requirements with our standard scenarios and options, you can use the advanced configuration settings to further customize your deployment.

The advanced configuration settings can be found in the [Platform landing zone configuration file]({{< relref "configuration" >}}) documentation.

## Next Steps

Now head back to [Phase 2]({{< relref "../../userguide/2_start" >}}) to continue your deployment.
