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

1. Locate the `lib` folder in your output directory. This folder is created when you run the accelerator and contains the necessary files for customizing the platform landing zone. The `lib` folder structure should look like this:

    ```plaintext
    ┣ 📂lib
    ┃ ┣ 📜alz_library_metadata.json
    ┃ ┣ 📂architecture_definitions
    ┃ ┃ ┗ 📜alz_custom.alz_architecture_definition.yaml
    ┃ ┗ 📂archetype_overrides
    ┃   ┃ 📜connectivity_custom.alz_archetype_override.yaml
    ┃   ┃ 📜corp_custom.alz_archetype_override.yaml
    ┃   ┃ 📜decommissioned_custom.alz_archetype_override.yaml
    ┃   ┃ 📜identity_custom.alz_archetype_override.yaml
    ┃   ┃ 📜management_custom.alz_archetype_override.yaml
    ┃   ┃ 📜landing_zones_custom.alz_archetype_override.yaml
    ┃   ┃ 📜platform_custom.alz_archetype_override.yaml
    ┃   ┃ 📜root_custom.alz_archetype_override.yaml
    ┃   ┗ 📜sandboxes_custom.alz_archetype_override.yaml
    ```

1. Open the `landing_zones_custom.alz_architecture_definition.yaml` file to remove the policy assignment.

    The default file looks like this:

    ```yaml
    # Example of how to add items to the lists below
    #
    # policy_assignments_to_remove
    # - example_policy_assignment_1
    # - example_policy_assignment_2
    base_archetype: landing_zones
    name: landing_zones_custom
    policy_assignments_to_add: []
    policy_assignments_to_remove: []
    policy_definitions_to_add: []
    policy_definitions_to_remove: []
    policy_set_definitions_to_add: []
    policy_set_definitions_to_remove: []
    role_definitions_to_add: []
    role_definitions_to_remove: []
    ```

1. Add the `Enable-DDoS-VNET` to the `policy_assignments_to_remove` list:

    ```yaml
    base_archetype: landing_zones
    name: landing_zones_custom
    policy_assignments_to_add: []
    policy_assignments_to_remove:
      - Enable-DDoS-VNET
    policy_definitions_to_add: []
    policy_definitions_to_remove: []
    policy_set_definitions_to_add: []
    policy_set_definitions_to_remove: []
    role_definitions_to_add: []
    role_definitions_to_remove: []
    ```

1. Repeat the above step for the `connectivity_custom.alz_architecture_definition.yaml` file, adding the `Enable-DDoS-VNET` to the `policy_assignments_to_remove` list.

    The default file looks like this:

    ```yaml
    base_archetype: connectivity
    name: connectivity_custom
    policy_assignments_to_add: []
    policy_assignments_to_remove: []
    policy_definitions_to_add: []
    policy_definitions_to_remove: []
    policy_set_definitions_to_add: []
    policy_set_definitions_to_remove: []
    role_definitions_to_add: []
    role_definitions_to_remove: []
    ```

    Update it to:

    ```yaml
    base_archetype: connectivity
    name: connectivity_custom
    policy_assignments_to_add: []
    policy_assignments_to_remove:
      - Enable-DDoS-VNET
    policy_definitions_to_add: []
    policy_definitions_to_remove: []
    policy_set_definitions_to_add: []
    policy_set_definitions_to_remove: []
    role_definitions_to_add: []
    role_definitions_to_remove: []
    ```

1. Now run a Terraform plan and apply to deploy the changes. The DDOS protection plan will not be deployed and the policy assignment will be removed.
