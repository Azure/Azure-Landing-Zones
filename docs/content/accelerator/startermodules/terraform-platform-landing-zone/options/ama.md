---
title: 11 - Turn off Azure Monitoring Agent
geekdocCollapseSection: true
weight: 11
---

The Azure Monitoring Agent (AMA) is enabled by default. If you want to turn it off, you can follow these steps:

1. To keep the code tidy remove the follow settings from `custom_replacements.names`:
  1. `ama_user_assigned_managed_identity_name`
  1. `dcr_change_tracking_name`
  1. `dcr_defender_sql_name`
  1. `dcr_vm_insights_name`
1. To keep the code tidy remove the follow settings from `custom_replacements.resource_identifiers`:
  1. `ama_change_tracking_data_collection_rule_id`
  1. `ama_mdfc_sql_data_collection_rule_id`
  1. `ama_vm_insights_data_collection_rule_id`
  1. `ama_user_assigned_managed_identity_id`
1. Remove the whole `user_assigned_managed_identities` section from `management_resource_settings`
1. Remove the whole `data_collection_rules` section from `management_resource_settings`
1. Add the follow section to `management_group_settings.policy_assignments_to_modify`:
    
    {{< highlight terraform "linenos=table" >}}
    root = {
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
