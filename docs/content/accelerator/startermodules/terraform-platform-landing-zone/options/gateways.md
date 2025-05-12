---
title: 6 - Turn off Virtual Network Gateways
geekdocCollapseSection: true
weight: 6
---

You can choose to not deploy Virtual Network Gateways. In order to do that, you need to update the Virtual Network Gateway configuration.

## For ExpressRoute Virtual Network Gateways

The steps to follow are:

1. Make the following settings changes by searching for the keys and updating ro removing the values

    | Setting Type | Parent block(s) | Key | Action | Count | Notes |
    | - | - | - | - | - | - |
    | line | `custom_replacements` > `names` | `<region>_virtual_network_gateway_express_route_name` | Delete (optional) | 1+ | `<region>` is the relevant region (e.g. `primary` or `secondary`) |
    | line | `custom_replacements` > `names` | `<region>_virtual_network_gateway_express_route_public_ip_name` | Delete (optional) | 1+ | `<region>` is the relevant region (e.g. `primary` or `secondary`) |
    | line | `hub_and_spoke_vnet_virtual_networks` > `virtual_network_gateways` > `express_route` OR `virtual_wan_virtual_hubs` > `virtual_network_gateways` > `express_route` | `enabled` | Update setting to `false` | 1+ | There will be two instances for a multi-region deployment |

## For VPN Virtual Network Gateways

The steps to follow are:

1. Make the following settings changes by searching for the keys and updating ro removing the values

    | Setting Type | Parent block(s) | Key | Action | Count | Notes |
    | - | - | - | - | - | - |
    | line | `custom_replacements` > `names` | `<region>_virtual_network_gateway_vpn_name` | Delete (optional) | 1+ | `<region>` is the relevant region (e.g. `primary` or `secondary`) |
    | line | `custom_replacements` > `names` | `<region>_virtual_network_gateway_vpn_public_ip_name` | Delete (optional) | 1+ | `<region>` is the relevant region (e.g. `primary` or `secondary`) |
    | line | `hub_and_spoke_vnet_virtual_networks` > `virtual_network_gateways` > `vpn` OR `virtual_wan_virtual_hubs` > `virtual_network_gateways` > `vpn` | `enabled` | Update setting to `false` | 1+ | There will be two instances for a multi-region deployment |
