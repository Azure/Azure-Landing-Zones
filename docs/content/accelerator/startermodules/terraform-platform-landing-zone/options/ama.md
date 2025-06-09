---
title: 11 - Turn off Azure Monitoring Agent
geekdocCollapseSection: true
weight: 11
---

The Azure Monitoring Agent (AMA) is enabled by default. If you want to turn it off, you can follow these steps:

1. Remove the following settings by searching for the keys and removing the line or block

    | Setting Type | Parent block(s) | Key | Action | Count | Notes |
    | - | - | - | - | - | - |
    | line | `custom_replacements` > `names` | `ama_user_assigned_managed_identity_name` | Delete | 1 | |
    | line | `custom_replacements` > `names` | `dcr_change_tracking_name` | Delete | 1 | |
    | line | `custom_replacements` > `names` | `dcr_defender_sql_name` | Delete | 1 | |
    | line | `custom_replacements` > `names` | `dcr_vm_insights_name` | Delete | 1 | |
    | line | `custom_replacements` > `resource_identifiers`<br/>`management_group_settings` > `policy_default_values` | `ama_change_tracking_data_collection_rule_id` | Delete | 2 | There are two instances of this key, delete both lines |
    | line | `custom_replacements` > `resource_identifiers`<br/>`management_group_settings` > `policy_default_values` | `ama_mdfc_sql_data_collection_rule_id` | Delete | 2 | There are two instances of this key, delete both lines |
    | line | `custom_replacements` > `resource_identifiers`<br/>`management_group_settings` > `policy_default_values` | `ama_vm_insights_data_collection_rule_id` | Delete | 2 | There are two instances of this key, delete both lines |
    | line | `custom_replacements` > `resource_identifiers`<br/>`management_group_settings` > `policy_default_values` | `ama_user_assigned_managed_identity_id` | Delete | 2 | There are two instances of this key, delete both lines |
    | block | `management_resource_settings` | `user_assigned_managed_identities` | Delete | 1 | |
    | block | `management_resource_settings` | `data_collection_rules` | Delete |  1 | |

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

1. Add the following assignments to the `policy_assignments_to_remove` list:

    ```yaml
    base_archetype: landing_zones
    name: landing_zones_custom
    policy_assignments_to_add: []
    policy_assignments_to_remove:
      - Deploy-MDFC-DefSQL-AMA
      - Deploy-VM-ChangeTrack
      - Deploy-VM-Monitoring
      - Deploy-vmArc-ChangeTrack
      - Deploy-vmHybr-Monitoring
      - Deploy-VMSS-ChangeTrack
      - Deploy-VMSS-Monitoring
    policy_definitions_to_add: []
    policy_definitions_to_remove: []
    policy_set_definitions_to_add: []
    policy_set_definitions_to_remove: []
    role_definitions_to_add: []
    role_definitions_to_remove: []
    ```

1. Now edit the above step for the `platform_custom.alz_architecture_definition.yaml` file, adding the following assignments to the `policy_assignments_to_remove` list.

    The default file looks like this:

    ```yaml
    base_archetype: platform
    name: platform_custom
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
    base_archetype: platform
    name: platform_custom
    policy_assignments_to_add: []
    policy_assignments_to_remove:
      - DenyAction-DeleteUAMIAMA
      - Deploy-MDFC-DefSQL-AMA
      - Deploy-VM-ChangeTrack
      - Deploy-VM-Monitoring
      - Deploy-vmArc-ChangeTrack
      - Deploy-vmHybr-Monitoring
      - Deploy-VMSS-ChangeTrack
      - Deploy-VMSS-Monitoring
    policy_definitions_to_add: []
    policy_definitions_to_remove: []
    policy_set_definitions_to_add: []
    policy_set_definitions_to_remove: []
    role_definitions_to_add: []
    role_definitions_to_remove: []
    ```

1. Now run a Terraform plan and apply to deploy the changes. The AMA resources not be deployed and the policy assignments will be removed.
