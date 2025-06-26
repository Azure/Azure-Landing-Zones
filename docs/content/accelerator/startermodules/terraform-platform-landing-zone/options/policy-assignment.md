---
title: 10 - Remove a policy assignment
geekdocCollapseSection: true
weight: 10
---

Follow these steps to remove policy assignments from the platform landing zone.

1. Locate the `lib` folder in your `config` directory. This folder was created in the initial steps of phase 2. The `lib` folder structure should look like this:

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

    Each `alz_archetype_override.yaml` file corresponds to an archetype in the accelerator. The `base_archetype` is the archetype that you are overriding, and the `name` is the name of the override archetype.

    By default, each override file is empty, meaning that it will inherit all policy assignments from the base archetype. To remove a policy assignment, you need to add it to the `policy_assignments_to_remove` list in the override file.

    Here is an example of the default `alz_archetype_override.yaml` file for the `landing_zones` archetype:

    ```yaml
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

1. You can now open each `alz_archetype_override.yaml` file in turn and add the assignments you want to remove.

    For example to remove just the `Enable-DDoS-VNET` policy assignment from the `landing_zones` management group archetype, the file would look like this:

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

1. Make sure to save the files after making the changes.
