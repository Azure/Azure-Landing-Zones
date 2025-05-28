---
title: Migration FAQ
description: Frequently asked questions about the migration from CAF Enterprise Scale to Azure Verified Modules for Platform Landing Zones (ALZ)
geekdocCollapseSection: true
weight: 20
---

This document contains frequently asked questions about the migration from CAF Enterprise Scale to Azure Verified Modules for Platform Landing Zones (ALZ).

## When applying Terraform, I get the error "The resource operation completed with terminal provisioning state 'Failed'." for the Firewall Policy

This is a known issue with Azure Firewall Policy. The error message is as follows:

```json
{
  "code": "DeploymentFailed",
  "message": "The resource operation completed with terminal provisioning state 'Failed'.",
  "details": [
    {
      "code": "FirewallPolicyUpdateFailed",
      "message": "Put on Firewall Policy <your firewall policy name> Failed with 1 faulted referenced firewalls."
    }
  ]
}
```

In order to resolve this issue, you need to make a change to the Firewall Policy in Azure or taint the Firewall Policy in Terraform. This will force another PUT operation and will rectify the status of the Firewall Policy. For example:

1. In Azure Portal, navigate to the Firewall Policy and go the Tags section. Add a tag and save the changes.
2. Now run `terraform apply` again and the error should be resolved.

## When updating my attributes I am unable to get the data collection rules to match

This is fine, they will be updated in place with the latest version. You can ignore this change unless you have explicitly deviated from our default rules, in which case you will know about it be able to make the relevant changes.
