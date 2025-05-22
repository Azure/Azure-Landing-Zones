---
title: 5 - Turn off Private DNS zones and Private DNS resolver
geekdocCollapseSection: true
weight: 5
---

You can choose to not deploy any DNS related resources. In order to do that, you need to update the DNS configuration and disable the DINE (deploy if not exists) policy.

The steps to follow are:

1. Update the following settings by searching for the keys and updating the value

    | Setting Type | Parent block(s) | Key | Action | Count | Notes |
    | - | - | - | - | - | - |
    | line | `custom_replacements` > `names` | `<region>_private_dns_zones_enabled` | Update setting to `false` | 1+ | `<region>` is the relevant region (e.g. `primary`) |

    {{< hint type=warning >}}
You should not remove the DNS names from the `custom_replacements` section as it will result in a templating error. Advanced Terraform users are welcome to tidy up the config and remove the names and related templates if there is no future plan to use Private DNS.
    {{< /hint >}}

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
