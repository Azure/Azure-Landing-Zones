---
title: 5 - Turn off Private DNS zones and Private DNS resolver
geekdocCollapseSection: true
weight: 5
---

You can choose to not deploy any DNS related resources. In order to do that, they need to remove the DNS configuration and disable the DINE (deploy if not exists) policy. You can either comment out or remove the configuration entirely.

The steps to follow are:

1. Delete the following settings by searching for the keys and removing the line or block

    | Setting Type | Parent block(s) | Key | Action | Count | Notes |
    | - | - | - | - | - | - |
    | line | `custom_replacements` > `names` | `dns_resource_group_name` | Delete (optional) | 1 | |
    | line | `custom_replacements` > `names` | `<region>_private_dns_resolver_name` | Delete (optional) | 1+ | `<region>` is the relevant region (e.g. `primary` or `secondary`) |
    | line | `custom_replacements` > `names` | `<region>_auto_registration_zone_name` | Delete (optional) | 1+ | `<region>` is the relevant region (e.g. `primary` or `secondary`) |
    | line | `custom_replacements` > `names` | `<region>_private_dns_resolver_subnet_address_prefix` | Delete (optional) | 1+ | `<region>` is the relevant region (e.g. `primary` or `secondary`) |
    | line | `management_group_settings` > `policy_default_values` | `private_dns_zone_subscription_id` | Delete | 1 | |
    | line | `management_group_settings` > `policy_default_values` | `private_dns_zone_region` | Delete | 1 | |
    | line | `management_group_settings` > `policy_default_values` | `private_dns_zone_resource_group_name` | Delete | 1 | |
    | line | `hub_and_spoke_vnet_virtual_networks` > `private_dns_zones` OR `virtual_wan_virtual_hubs` > `private_dns_zones` | `enabled` | Update setting to `false` | 1+ | There will be two instances for a multi-region deployment |

1. Add the follow configuration to the `management_group_settings` > `policy_assignments_to_modify` block setting

    {{< hint type=warning >}}
If you have updated the `corp` management group ID, then you need to update the management group ID in this block setting to match. For example, replace `corp` with `contoso-corp`.
    {{< /hint >}}

    ```terraform
    corp = {
      policy_assignments = {
        Deploy-Private-DNS-Zones = {
          enforcement_mode = "DoNotEnforce"
        }
      }
    }
    ```
