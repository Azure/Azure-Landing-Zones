---
title: 5 - Management Groups, Policy and Management Resources Only
weight: 5
---

A Platform landing zone deployment without any connectivity resources.

* Example Platform landing zone configuration file: [management_only/management.tfvars](https://raw.githubusercontent.com/Azure/alz-terraform-accelerator/refs/heads/main/templates/platform_landing_zone/examples/management-only/management.tfvars)

## Resources

The following resources are deployed by default in this scenario:

### Management

#### Management Groups

- Management Groups
- Policy Definitions
- Policy Set Definitions
- Policy Assignments (not those related to connectivity)
- Policy Assignment Role Assignments

#### Management Resources

- Log Analytics Workspace
- Log Analytics Data Collection Rules for AMA
- User Assigned Managed Identity for AMA
- Automation Account

#### Subscription Placement

{{< hint type=tip >}}
**Identity and Security subscriptions are recommended but optional.** If you do not yet have dedicated subscriptions for identity and security workloads, you can comment out or remove the identity and security subscription placement blocks in the configuration file and add them later.
{{< /hint >}}

- Management subscription - placed under the `management` management group
- Identity subscription - placed under the `identity` management group (recommended)
- Security subscription - placed under the `security` management group (recommended)
