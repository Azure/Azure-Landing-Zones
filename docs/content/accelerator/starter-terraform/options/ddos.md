---
title: 3 - Turn off DDOS protection plan
geekdocCollapseSection: true
weight: 3
---

You can choose to not deploy a DDOS protection plan. In order to do that, they need to remove the DDOS protection plan configuration and disable the DINE (deploy if not exists) policy. You can either comment out or remove the configuration entirely.

{{< hint type=danger >}}
**Security Risk:** DDoS Protection Plan is a critical security control for public-facing services. Disabling it without an alternative leaves your workloads vulnerable to DDoS attacks. If you turn off the DDoS Protection Plan, you **MUST** implement [Azure DDoS IP Protection](https://learn.microsoft.com/azure/ddos-protection/ddos-protection-sku-comparison) on every public IP address in your environment to maintain your security posture. Failure to do so exposes your public-facing services to potential service disruption.
{{< /hint >}}

The steps to follow are:

1. Update the following settings by searching for the keys and updating the value

    | Setting Type | Parent block(s) | Key | Action | Count | Notes |
    | - | - | - | - | - | - |
    | line | `custom_replacements` > `names` | `ddos_protection_plan_enabled` | Update setting to `false` | 1 | |

1. Locate the `lib` folder in your `config` directory. This folder was created in the initial steps of phase 2.

1. Open the `landing_zones_custom.alz_archetype_override.yaml` file and uncomment the AMA policy assignments in the `policy_assignments_to_remove` list.

    The file should look like this:

    ```yaml
    base_archetype: landing_zones
    name: landing_zones_custom
    policy_assignments_to_add: []
    policy_assignments_to_remove: [
    # To remove AMA policies, uncomment the following lines:
      # Deploy-MDFC-DefSQL-AMA,
      # Deploy-VM-ChangeTrack,
      # Deploy-VM-Monitoring,
      # Deploy-vmArc-ChangeTrack,
      # Deploy-vmHybr-Monitoring,
      # Deploy-VMSS-ChangeTrack,
      # Deploy-VMSS-Monitoring,
    # To remove the DDOS modify policy, uncomment the following line:
      Enable-DDoS-VNET,
    ]
    policy_definitions_to_add: []
    policy_definitions_to_remove: []
    policy_set_definitions_to_add: []
    policy_set_definitions_to_remove: []
    role_definitions_to_add: []
    role_definitions_to_remove: []

    ```

1. Open the `connectivity_custom.alz_archetype_override.yaml` file and update it to look like this:

    ```yaml
    base_archetype: connectivity
    name: connectivity_custom
    policy_assignments_to_add: []
    policy_assignments_to_remove: [
    # To remove the DDOS modify policy, uncomment the following line:
      Enable-DDoS-VNET,
    ]
    policy_definitions_to_add: []
    policy_definitions_to_remove: []
    policy_set_definitions_to_add: []
    policy_set_definitions_to_remove: []
    role_definitions_to_add: []
    role_definitions_to_remove: []

    ```

1. Make sure to save both files after making the changes.
