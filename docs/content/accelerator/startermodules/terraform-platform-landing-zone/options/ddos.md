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

1. Update the following settings by searching for the keys and updating the value

    | Setting Type | Parent block(s) | Key | Action | Count | Notes |
    | - | - | - | - | - | - |
    | line | `custom_replacements` > `names` | `ddos_protection_plan_enabled` | Update setting to `false` | 1 | |

1. Copy and paste the following inside the `management_group_settings` > `policy_assignments_to_modify`

    {{< hint type=warning >}}
If you have updated the `connectivity` or `landingzones` management group ID, then you need to update the management group ID in this block setting to match. For example, replace `connectivity` with `contoso-connectivity`.
    {{< /hint >}}

    ```terraform
    connectivity = {
      policy_assignments = {
        Enable-DDoS-VNET = {
          enforcement_mode = "DoNotEnforce"
        }
      }
    }
    landingzones = {
      policy_assignments = {
        Enable-DDoS-VNET = {
          enforcement_mode = "DoNotEnforce"
        }
      }
    }
    ```
