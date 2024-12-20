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

1. To keep the code tidy remove the follow settings from `custom_replacements.names`:
  1. `ddos_resource_group_name`
  1. `ddos_protection_plan_name`
1. To keep the code tidy remove the follow settings from `custom_replacements.resource_group_identifiers`:
  1. `ddos_protection_plan_resource_group_id`
1. To keep the code tidy remove the follow settings from `custom_replacements.resource_identifiers`:
  1. `ddos_protection_plan_id`
1. Remove the follow configuration settings from `management_group_settings.policy_default_values`:
  1. `ddos_protection_plan_id`
1. Add the follow section to `management_group_settings.policy_assignments_to_modify`:
    
    {{< highlight terraform "linenos=table" >}}
    connectivity = {
      policy_assignments = {
        Enable-DDoS-VNET = {
          enforcement_mode = "DoNotEnforce"
        }
      }
    }
    {{< / highlight >}}
1. Remove the whole `ddos_protection_plan` section from `hub_and_spoke_vnet_settings` or `virtual_wan_settings`
