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

1. Copy and paste the following inside the `management_group_settings` > `policy_assignments_to_modify` block on a new line after the first curly brace `{`:
    
    {{< hint type=warning >}}
If you have updated the `alz`, `landing-zones` or `platform`  management group ID, then you need to update the management group ID in this block setting to match. For example, replace `alz` with `contoso`.
    {{< /hint >}}

    {{< highlight terraform "linenos=table" >}}
    alz = {
      policy_assignments = {
        Deploy-MDEndpointsAMA = {
          enforcement_mode = "DoNotEnforce"
        }
      }
    }
    landing_zones = {
      policy_assignments = {
        Deploy-MDFC-DefSQL-AMA = {
          enforcement_mode = "DoNotEnforce"
        }
        Deploy-VM-ChangeTrack = {
          enforcement_mode = "DoNotEnforce"
        }
        Deploy-VM-Monitoring = {
          enforcement_mode = "DoNotEnforce"
        }
        Deploy-vmArc-ChangeTrack = {
          enforcement_mode = "DoNotEnforce"
        }
        Deploy-vmHybr-Monitoring = {
          enforcement_mode = "DoNotEnforce"
        }
        Deploy-VMSS-ChangeTrack = {
          enforcement_mode = "DoNotEnforce"
        }
        Deploy-VMSS-Monitoring = {
          enforcement_mode = "DoNotEnforce"
        }
      }
    }
    platform = {
      policy_assignments = {
        DenyAction-DeleteUAMIAMA = {
          enforcement_mode = "DoNotEnforce"
        }
        Deploy-MDFC-DefSQL-AMA = {
          enforcement_mode = "DoNotEnforce"
        }
        Deploy-VM-ChangeTrack = {
          enforcement_mode = "DoNotEnforce"
        }
        Deploy-VM-Monitoring = {
          enforcement_mode = "DoNotEnforce"
        }
        Deploy-vmArc-ChangeTrack = {
          enforcement_mode = "DoNotEnforce"
        }
        Deploy-vmHybr-Monitoring = {
          enforcement_mode = "DoNotEnforce"
        }
        Deploy-VMSS-ChangeTrack = {
          enforcement_mode = "DoNotEnforce"
        }
        Deploy-VMSS-Monitoring = {
          enforcement_mode = "DoNotEnforce"
        }
      }
    }
    {{< / highlight >}}
