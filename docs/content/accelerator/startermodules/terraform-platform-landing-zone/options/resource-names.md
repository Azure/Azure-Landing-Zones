---
title: 1 - Customize Resource Names
geekdocCollapseSection: true
weight: 1
---

Custom resource names are support for all resources. You can customize the resource names by updating the configuration file.

In our example configuration file, you will find all the resource names in the `custom_replacements.names` section.

To update them, you can simply change the value of the resource name in that section.

For example:

{{< highlight terraform "linenos=table" >}}
custom_replacements = {
  names = {
    ...
    # Resource names
    log_analytics_workspace_name            = "my-custom-log-analytics-workspace"
    ddos_protection_plan_name               = "my-custom-ddos-protection-plan"
    automation_account_name                 = "my-custom-automation-account"
    ama_user_assigned_managed_identity_name = "my-custom-ama-user-assigned-managed-identity"
    ...
  }
}
{{< / highlight >}}
