---
title: 7 - Additional Regions
geekdocCollapseSection: true
weight: 7
---

Additional regions are supported. The custom can add up to 10 regions using the out of the box module.

{{< hint type=tip >}}
If you need to scale beyond 10 regions, that can be accommodated by adding additional built in replacements [here](https://github.com/Azure/alz-terraform-accelerator/blob/cf0b37351cd4f2dde9d2cf20642d76bacadf923c/templates/platform_landing_zone/locals.config.tf#L2)
{{< /hint >}}

To add an additional regions, the process is `copy` -> `paste` -> `update`:

1. Copy, paste and update the regional resource group names in `custom_replacements.names`
1. Copy, paste and update the regional resource names in `custom_replacements.names`
1. Copy, paste and update the regional private dns zone names in `custom_replacements.names`
1. Copy, paste and update the regional IP Ranges in `custom_replacements.names`
1. Copy, paste and update the regional resource group in `connectivity_resource_groups`
1. Copy, paste and update the region in `hub_and_spoke_vnet_virtual_networks` or `virtual_wan_virtual_hubs`
