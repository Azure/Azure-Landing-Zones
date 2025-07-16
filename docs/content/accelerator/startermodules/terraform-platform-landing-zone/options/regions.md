---
title: 7 - Additional Regions
geekdocCollapseSection: true
weight: 7
---

Additional regions are supported. You can add as many regions as required with the out the box module.

To add an additional regions, the process is `copy` -> `paste` -> `update`.

The settings are slightly different depending on the chosen networking type:

## Hub and Spoke Virtual Network

1. Find, copy, paste and update the following settings by searching for the keys and copying the line or block. 

    | Setting Type | Parent block(s) | Key | Action | Count | Notes |
    | - | - | - | - | - | - |
    | line | `custom_replacements` > `names` | `connectivity_hub_<region>_resource_group_name` | Copy, Paste, and Update | 1 | `<region>` is the relevant region (e.g. `primary`) |
    | line | `custom_replacements` > `names` | `<region>_virtual_network_name` | Copy, Paste, and Update | 1 | `<region>` is the relevant region (e.g. `primary`) |
    | line | `custom_replacements` > `names` | `<region>_firewall_name` | Copy, Paste, and Update | 1 | `<region>` is the relevant region (e.g. `primary`) |
    | line | `custom_replacements` > `names` | `<region>_firewall_policy_name` | Copy, Paste, and Update | 1 | `<region>` is the relevant region (e.g. `primary`) |
    | line | `custom_replacements` > `names` | `<region>_firewall_public_ip_name` | Copy, Paste, and Update | 1 | `<region>` is the relevant region (e.g. `primary`) |
    | line | `custom_replacements` > `names` | `<region>_route_table_firewall_name` | Copy, Paste, and Update | 1 | `<region>` is the relevant region (e.g. `primary`) |
    | line | `custom_replacements` > `names` | `<region>_route_table_user_subnets_name` | Copy, Paste, and Update | 1 | `<region>` is the relevant region (e.g. `primary`) |
    | line | `custom_replacements` > `names` | `<region>_virtual_network_gateway_express_route_name` | Copy, Paste, and Update | 1 | `<region>` is the relevant region (e.g. `primary`) |
    | line | `custom_replacements` > `names` | `<region>_virtual_network_gateway_express_route_public_ip_name` | Copy, Paste, and Update | 1 | `<region>` is the relevant region (e.g. `primary`) |
    | line | `custom_replacements` > `names` | `<region>_virtual_network_gateway_vpn_name` | Copy, Paste, and Update | 1 | `<region>` is the relevant region (e.g. `primary`) |
    | line | `custom_replacements` > `names` | `<region>_virtual_network_gateway_vpn_public_ip_name` | Copy, Paste, and Update | 1 | `<region>` is the relevant region (e.g. `primary`) |
    | line | `custom_replacements` > `names` | `<region>_private_dns_resolver_name` | Copy, Paste, and Update | 1 | `<region>` is the relevant region (e.g. `primary`) |
    | line | `custom_replacements` > `names` | `<region>_bastion_host_name` | Copy, Paste, and Update | 1 | `<region>` is the relevant region (e.g. `primary`) |
    | line | `custom_replacements` > `names` | `<region>_bastion_host_public_ip_name` | Copy, Paste, and Update | 1 | `<region>` is the relevant region (e.g. `primary`) |
    | line | `custom_replacements` > `names` | `<region>_auto_registration_zone_name` | Copy, Paste, and Update | 1 | `<region>` is the relevant region (e.g. `primary`) |
    | line | `custom_replacements` > `names` | `<region>_hub_address_space` | Copy, Paste, and Update | 1 | `<region>` is the relevant region (e.g. `primary`) |
    | line | `custom_replacements` > `names` | `<region>_hub_virtual_network_address_space` | Copy, Paste, and Update | 1 | `<region>` is the relevant region (e.g. `primary`) |
    | line | `custom_replacements` > `names` | `<region>_firewall_subnet_address_prefix` | Copy, Paste, and Update | 1 | `<region>` is the relevant region (e.g. `primary`) |
    | line | `custom_replacements` > `names` | `<region>_bastion_subnet_address_prefix` | Copy, Paste, and Update | 1 | `<region>` is the relevant region (e.g. `primary`) |
    | line | `custom_replacements` > `names` | `<region>_gateway_subnet_address_prefix` | Copy, Paste, and Update | 1 | `<region>` is the relevant region (e.g. `primary`) |
    | line | `custom_replacements` > `names` | `<region>_private_dns_resolver_subnet_address_prefix` | Copy, Paste, and Update | 1 | `<region>` is the relevant region (e.g. `primary`) |
    | block | `connectivity_resource_groups` | `vnet_<region>` | Copy, Paste, and Update | 1 | `<region>` is the relevant region (e.g. `primary`) |
    | block | `hub_and_spoke_vnet_virtual_networks` | `<region>` | Copy, Paste, and Update | 1 | `<region>` is the relevant region (e.g. `primary`) |

For example, to add a third region you would copy and paste all the `primary` configuration. Then replace the `<region>` `primary` with `tertiary` and `starter_location_01` with `starter_location_03`. 

## Virtual WAN

1. Find, copy, paste and update the following settings by searching for the keys and copying the line or block. 

    | Setting Type | Parent block(s) | Key | Action | Count | Notes |
    | - | - | - | - | - | - |
    | line | `custom_replacements` > `names` | `connectivity_hub_<region>_resource_group_name` | Copy, Paste, and Update | 1 | `<region>` is the relevant region (e.g. `primary`) |
    | line | `custom_replacements` > `names` | `<region>_hub_name` | Copy, Paste, and Update | 1 | `<region>` is the relevant region (e.g. `primary`) |
    | line | `custom_replacements` > `names` | `<region>_sidecar_virtual_network_name` | Copy, Paste, and Update | 1 | `<region>` is the relevant region (e.g. `primary`) |
    | line | `custom_replacements` > `names` | `<region>_firewall_name` | Copy, Paste, and Update | 1 | `<region>` is the relevant region (e.g. `primary`) |
    | line | `custom_replacements` > `names` | `<region>_firewall_policy_name` | Copy, Paste, and Update | 1 | `<region>` is the relevant region (e.g. `primary`) |
    | line | `custom_replacements` > `names` | `<region>_virtual_network_gateway_express_route_name` | Copy, Paste, and Update | 1 | `<region>` is the relevant region (e.g. `primary`) |
    | line | `custom_replacements` > `names` | `<region>_virtual_network_gateway_vpn_name` | Copy, Paste, and Update | 1 | `<region>` is the relevant region (e.g. `primary`) |
    | line | `custom_replacements` > `names` | `<region>_private_dns_resolver_name` | Copy, Paste, and Update | 1 | `<region>` is the relevant region (e.g. `primary`) |
    | line | `custom_replacements` > `names` | `<region>_bastion_host_name` | Copy, Paste, and Update | 1 | `<region>` is the relevant region (e.g. `primary`) |
    | line | `custom_replacements` > `names` | `<region>_bastion_host_public_ip_name` | Copy, Paste, and Update | 1 | `<region>` is the relevant region (e.g. `primary`) |
    | line | `custom_replacements` > `names` | `<region>_auto_registration_zone_name` | Copy, Paste, and Update | 1 | `<region>` is the relevant region (e.g. `primary`) |
    | line | `custom_replacements` > `names` | `<region>_hub_address_space` | Copy, Paste, and Update | 1 | `<region>` is the relevant region (e.g. `primary`) |
    | line | `custom_replacements` > `names` | `<region>_side_car_virtual_network_address_space` | Copy, Paste, and Update | 1 | `<region>` is the relevant region (e.g. `primary`) |
    | line | `custom_replacements` > `names` | `<region>_bastion_subnet_address_prefix` | Copy, Paste, and Update | 1 | `<region>` is the relevant region (e.g. `primary`) |
    | line | `custom_replacements` > `names` | `<region>_private_dns_resolver_subnet_address_prefix` | Copy, Paste, and Update | 1 | `<region>` is the relevant region (e.g. `primary`) |
    | block | `connectivity_resource_groups` | `vwan_hub_<region>` | Copy, Paste, and Update | 1 | `<region>` is the relevant region (e.g. `primary`) |
    | block | `virtual_wan_virtual_hubs` | `<region>` | Copy, Paste, and Update | 1 | `<region>` is the relevant region (e.g. `primary`) |

For example, to add a third region you would copy and paste all the `primary` configuration. Then replace the `<region>` `primary` with `tertiary` and `starter_location_01` with `starter_location_03`. 
