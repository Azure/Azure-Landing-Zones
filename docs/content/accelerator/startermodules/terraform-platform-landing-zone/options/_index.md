---
title: Options
geekdocCollapseSection: true
weight: 2
---

This section provides detailed instructions for updating your configuration to implement each option.

If you are familiar with Terraform `tfvars` file structure, you can skip the next section that explains how to update the configuration file and go directly to the [Options](#options) you want to implement.

## Platform configuration file updates

Most of the options require you to update the platform configuration file. The platform configuration file is a HCL (tfvars) file that contains the configuration settings for the platform landing zone.

There are two types of settings in the platform configuration file that you may need to update. For the sake of simplicity we will refer to these as `line` and `block` settings.

Depending on the option you want to implement, you may need to delete and / or add configuration settings to the platform configuration file.

### Line setting

A line setting is a single line in the configuration file that you need to update. For example, the following line setting is used to specify the name of the resource group:

{{< highlight terraform "linenos=table" >}}
ddos_resource_group_name = "rg-hub-ddos-$${starter_location_01}"
{{< / highlight >}}

A line setting is denoted by the `<key> = "<value>"` format.

If you are asked to update a line setting, you will need to find the line based on it's key. You can use <kbd>Ctrl</kbd> + <kbd>F</kbd> to search for the key in the file.

For example, if you are asked to delete a line setting, you would:

1. Use <kbd>Ctrl</kbd> + <kbd>F</kbd> to bring up the search dialog
1. Enter the key in the search dialog. E.g. `ddos_resource_group_name`
1. Hit enter to search for the key
1. Delete the whole line from the configuration file
1. Save the configuration file

### Block setting

A block setting is a group of settings that are enclosed in curly braces `{}`. For example, the following block setting is used to specify the policy assignments for a management group:

{{< hint type=tip >}}
For those familiar with Terraform, what we refer to as a `block` here is generally an `object` or a `map` type in HCL.
{{< /hint >}}

{{< highlight terraform "linenos=table" >}}
ddos = {
  name     = "$${ddos_resource_group_name}"
  location = "$${starter_location_01}"
}
{{< / highlight >}}

A block setting is denoted by the `<key> = { <value> }` format, where the curly braces and value span multiple lines in the configuration file.

If you are asked to update a block setting, you will need to find the block based on it's key. You can use <kbd>Ctrl</kbd> + <kbd>F</kbd> to search for the key in the file.

For example, if you are asked to delete a block setting, you would:

1. Use <kbd>Ctrl</kbd> + <kbd>F</kbd> to bring up the search dialog
1. Enter the key in the search dialog. E.g. `ddos`
1. Hit enter to search for the key
1. Identify the start and end of the block by looking for the opening and closing curly braces `{}`. This is made easier when using an IDE like Visual Studio Code, which will highlight the matching braces when you click on one of them.
1. Select the whole block, including the key and delete all the lines from the configuration file
1. Save the configuration file

If you are asked to paste configuration inside a block setting, you would:

1. Use <kbd>Ctrl</kbd> + <kbd>F</kbd> to bring up the search dialog
1. Enter the key in the search dialog. E.g. `management_group_settings`
1. If the block is denoted as a nested block (e.g. `management_group_settings` > `policy_assignments_to_modify`), you will need to find the last child block. In this case, you would then search for `policy_assignments_to_modify`
1. Repeat the last step for each nested block until you find the block where you need to paste the code
1. Copy the code you need to paste into the clipboard
1. Place the cursor at the end of the first line of the block after the and press <kbd>Enter</kbd> to create a new line. If you are using Visual Studio Code, it will automatically indent the new line to match the indentation of the block
1. Paste the code from the clipboard using <kbd>Ctrl</kbd> + <kbd>V</kbd>
1. Save the configuration file

## Options

The available options are:

1. [Customise Resource Names]({{< relref "resource-names">}})
1. [Customize Management Group Names and IDs]({{< relref "management-groups">}})
1. [Turn off DDOS protection plan]({{< relref "ddos">}})
1. [Turn off Bastion host]({{< relref "bastion">}})
1. [Turn off Private DNS zones and Private DNS resolver]({{< relref "dns">}})
1. [Turn off Virtual Network Gateways]({{< relref "gateways">}})
1. [Additional Regions]({{< relref "regions">}})
1. [IP Address Ranges]({{< relref "ip-addresses">}})
1. [Change a policy assignment enforcement mode]({{< relref "policy-enforcement">}})
1. [Remove a policy assignment]({{< relref "policy-assignment">}})
1. [Turn off Azure Monitoring Agent]({{< relref "ama">}})
1. [Deploy Azure Monitoring Baseline Alerts (AMBA)]({{< relref "amba">}})
1. [Turn off Defender Plans]({{< relref "defender">}})
1. [Implement Zero Trust Networking]({{< relref "zero-trust">}})
1. [Implement Sovereign Landing Zone (SLZ) controls]({{< relref "slz">}})
