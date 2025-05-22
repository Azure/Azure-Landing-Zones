---
title: 6 - Turn off Virtual Network Gateways
geekdocCollapseSection: true
weight: 6
---

You can choose to not deploy Virtual Network Gateways. In order to do that, you need to update the Virtual Network Gateway configuration.

## For ExpressRoute Virtual Network Gateways

The steps to follow are:

1. Update the following settings by searching for the keys and updating the value

    | Setting Type | Parent block(s) | Key | Action | Count | Notes |
    | - | - | - | - | - | - |
    | line | `custom_replacements` > `names` | `enabled` | Update setting to `<region>_virtual_network_gateway_express_route_enabled` | 1+ | `<region>` is the relevant region (e.g. `primary`) |

    {{< hint type=warning >}}
You should not remove the ExpressRoute Gateway names from the `custom_replacements` section as it will result in a templating error. Advanced Terraform users are welcome to tidy up the config and remove the names and related templates if there is no future plan to use an ExpressRoute Gateway.
    {{< /hint >}}

## For VPN Virtual Network Gateways

The steps to follow are:

1. Update the following settings by searching for the keys and updating the value

    | Setting Type | Parent block(s) | Key | Action | Count | Notes |
    | - | - | - | - | - | - |
    | line | `custom_replacements` > `names` | `<region>_virtual_network_gateway_vpn_enabled` | Update setting to `false` | 1+ | `<region>` is the relevant region (e.g. `primary`) |

    {{< hint type=warning >}}
You should not remove the VPN Gateway names from the `custom_replacements` section as it will result in a templating error. Advanced Terraform users are welcome to tidy up the config and remove the names and related templates if there is no future plan to use a VPN Gateway.
    {{< /hint >}}
