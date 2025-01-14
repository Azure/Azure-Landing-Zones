---
title: 3 - Turn off DDOS protection plan
geekdocCollapseSection: true
weight: 3
---

You can choose to not deploy a DDOS protection plan. In order to do that, they need to remove the DDOS protection plan configuration and disable the DINE (deploy if not exists) policy. You can either comment out or remove the configuration entirely.

{{< hint type=warning >}}
DDOS Protection plan is a critical security protection for public facing services. Carefully consider this and be sure to put in place an alternative solution, such as per IP protection.
{{< /hint >}}

The steps to follow are:

1. Delete the following settings by searching for the keys and removing the line or block

    | Setting Type | Parent block(s) | Key | Action | Count | Notes |
    | - | - | - | - | - | - |
    | line | `custom_replacements` > `names` | `ddos_resource_group_name` | Delete | 1 | |
    | line | `custom_replacements` > `names` | `ddos_protection_plan_name` | Delete | 1 | |
    | line | `custom_replacements` > `resource_group_identifiers` | `ddos_protection_plan_resource_group_id` | Delete | 1 | |
    | line | `custom_replacements` > `resource_identifiers`<br/>`management_group_settings`<br/>`hub_and_spoke_vnet_virtual_networks` > `<region>` > `hub_virtual_network` | `ddos_protection_plan_id` | Delete | 3+ | There are multiple instances of this key, delete them all |
    | block | `connectivity_resource_groups` | `ddos` | Delete | 1 | |
    | block | `hub_and_spoke_vnet_settings` | `ddos_protection_plan` | Delete | 1 | |

1. Copy and paste the following inside the `management_group_settings` > `policy_assignments_to_modify`
    
    {{< hint type=warning >}}
If you have updated the `connectivity` management group ID, then you need to update the management group ID in this block setting to match. For example, replace `connectivity` with `contoso-connectivity`.
    {{< /hint >}}

    {{< highlight terraform "linenos=table" >}}
    {{< /hint >}}

    {{< highlight terraform "linenos=table" >}}
    connectivity = {
      policy_assignments = {
        Enable-DDoS-VNET = {
          enforcement_mode = "DoNotEnforce"
        }
      }
    }
    {{< / highlight >}}
