---
title: 4 - Turn off Bastion host
geekdocCollapseSection: true
weight: 4
---

You can choose to not deploy a Bastion Host. In order to do that, they need to remove the Bastion Host configuration. You can either comment out or remove the configuration entirely.

The steps to follow are:

1. To keep the code tidy remove the follow settings from `custom_replacements.names`:
  1. `<region>_bastion_subnet_address_prefix` where `<region>` is for each region
1. Remove the whole `bastion` section from each `hub_and_spoke_vnet_virtual_networks` or `virtual_wan_virtual_hubs` region
