---
title: 4 - Turn off Bastion host
geekdocCollapseSection: true
weight: 4
---

You can choose to not deploy a Bastion Host. In order to do that, you need to remove the Bastion Host configuration. You can either comment out or remove the configuration entirely.

The steps to follow are:

1. Delete the following settings by searching for the keys and removing the line or block

    | Setting Type | Parent block(s) | Key | Action | Count | Notes |
    | - | - | - | - | - | - |
    | line | `custom_replacements` > `names` | `<region>_bastion_host_name` | Delete (optional) | 1+ | `<region>` is the relevant region (e.g. `primary` or `secondary`) |
    | line | `custom_replacements` > `names` | `<region>_bastion_public_ip_name` | Delete (optional) | 1+ | `<region>` is the relevant region (e.g. `primary` or `secondary`) |
    | line | `custom_replacements` > `names` | `<region>_bastion_subnet_address_prefix` | Delete (optional) | 1+ | `<region>` is the relevant region (e.g. `primary` or `secondary`) |
    | line | `hub_and_spoke_vnet_virtual_networks` > `bastion` OR `virtual_wan_virtual_hubs` > `bastion` | `enabled` | Update setting to `false` | 1+ | There will be two instances for a multi-region deployment |
