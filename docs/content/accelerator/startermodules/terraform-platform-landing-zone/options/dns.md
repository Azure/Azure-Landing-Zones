---
title: 5 - Turn off Private DNS zones
geekdocCollapseSection: true
weight: 5
---

You can choose to not deploy the private DNS zone resources. In order to do that, you need to update the DNS configuration and disable the DINE (deploy if not exists) policy.

The steps to follow are:

1. Update the following settings by searching for the keys and updating the value

    | Setting Type | Parent block(s) | Key | Action | Count | Notes |
    | - | - | - | - | - | - |
    | line | `custom_replacements` > `names` | `<region>_private_dns_zones_enabled` | Update setting to `false` | 1+ | `<region>` is the relevant region (e.g. `primary`) |

    {{< hint type=warning >}}
You should not remove the DNS names from the `custom_replacements` section as it will result in a templating error. Advanced Terraform users are welcome to tidy up the config and remove the names and related templates if there is no future plan to use Private DNS.
    {{< /hint >}}

1. Locate the `lib` folder in your `config` directory. This folder was created in the initial steps of phase 2.

1. Open the `corp_custom.alz_archetype_override.yaml` file and uncomment the AMA policy assignments in the `policy_assignments_to_remove` list.

    The file should look like this:

    ```yaml
    base_archetype: corp
    name: corp_custom
    policy_assignments_to_add: []
    policy_assignments_to_remove: [
    # To remove the private DNS zones policy for private endpoints
      Deploy-Private-DNS-Zones,
    ]
    policy_definitions_to_add: []
    policy_definitions_to_remove: []
    policy_set_definitions_to_add: []
    policy_set_definitions_to_remove: []
    role_definitions_to_add: []
    role_definitions_to_remove: []

    ```

1. Make sure to save the file after making the changes.
