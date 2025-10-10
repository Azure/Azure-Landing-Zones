---
title: 11 - Turn off Azure Monitoring Agent
geekdocCollapseSection: true
weight: 11
---

The Azure Monitoring Agent (AMA) is enabled by default. If you want to turn it off, you can follow these steps to remove the policy assignments:

{{< hint type=info >}}
This option removes the policy assignments, but we are still deploying the identity and data collections rules associated with Azure Monitoring Agent. This is to make it easier to enable it in the future. If you really don't want to deploy those resources, it is possible to remove them from the configuration by reviewing he documentation for the [Management Resources Module](https://registry.terraform.io/modules/Azure/avm-ptn-alz-management/azurerm/latest?tab=inputs).
{{< /hint >}}

1. Locate the `lib` folder in your `config` directory. This folder was created in the initial steps of phase 2.

1. Open the `landing_zones_custom.alz_archetype_override.yaml` file and uncomment the AMA policy assignments in the `policy_assignments_to_remove` list.

    The file should look like this:

    ```yaml
    base_archetype: landing_zones
    name: landing_zones_custom
    policy_assignments_to_add: []
    policy_assignments_to_remove: [
    # To remove AMA policies, uncomment the following lines:
      Deploy-MDFC-DefSQL-AMA,
      Deploy-VM-ChangeTrack,
      Deploy-VM-Monitoring,
      Deploy-vmArc-ChangeTrack,
      Deploy-vmHybr-Monitoring,
      Deploy-VMSS-ChangeTrack,
      Deploy-VMSS-Monitoring,
    # To remove the DDOS modify policy, uncomment the following line:
      # Enable-DDoS-VNET,
    ]
    policy_definitions_to_add: []
    policy_definitions_to_remove: []
    policy_set_definitions_to_add: []
    policy_set_definitions_to_remove: []
    role_definitions_to_add: []
    role_definitions_to_remove: []

    ```

1. Open the `platform_custom.alz_archetype_override.yaml` file and uncomment the AMA policy assignments in the `policy_assignments_to_remove` list.

    The file should look like this:

    ```yaml
    base_archetype: platform
    name: platform_custom
    policy_assignments_to_add: []
    policy_assignments_to_remove: [
    # To disable AMA policies, uncomment the following lines:
      DenyAction-DeleteUAMIAMA,
      Deploy-MDFC-DefSQL-AMA,
      Deploy-VM-ChangeTrack,
      Deploy-VM-Monitoring,
      Deploy-vmArc-ChangeTrack,
      Deploy-vmHybr-Monitoring,
      Deploy-VMSS-ChangeTrack,
      Deploy-VMSS-Monitoring,
    ]
    policy_definitions_to_add: []
    policy_definitions_to_remove: []
    policy_set_definitions_to_add: []
    policy_set_definitions_to_remove: []
    role_definitions_to_add: []
    role_definitions_to_remove: []

    ```

1. Make sure to save both files after making the changes.
