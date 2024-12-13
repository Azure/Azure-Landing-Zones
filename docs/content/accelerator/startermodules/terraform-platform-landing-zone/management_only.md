---
title: Scenario - Management Groups, Policy and Management Resources Only
weight: 20
---

A platform landing zone deployment without any connectivity resources.

* Example Platform landing zone configuration file: [management_only/management.tfvars](https://raw.githubusercontent.com/Azure/alz-terraform-accelerator/refs/heads/main/templates/platform_landing_zone/examples/management_only/management.tfvars)

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
