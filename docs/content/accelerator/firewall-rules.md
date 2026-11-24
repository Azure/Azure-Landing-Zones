---
title: Manage firewall rules independently
weight: 111
---

Firewall rules often change more frequently than platform infrastructure. For Terraform and Bicep AVM deployments, manage these rules in a separate repository or deployment pipeline rather than changing the platform landing zone configuration for every application request.

This guidance applies to Azure Firewall using **Firewall Policy**, in either a hub-and-spoke network or a secured Virtual WAN hub. It does not cover classic rules configured directly on the firewall or rules for a third-party network virtual appliance.

## Define resource ownership

Use a rule collection group as the deployment and ownership boundary. A group is a child resource of a firewall policy and contains rule collections, which in turn contain rules.

| Resource | Recommended owner |
| --- | --- |
| Firewall, firewall policy, policy association, routing, DNS and diagnostic settings | Platform deployment |
| Platform baseline rule collection groups | Platform or central network-security deployment |
| Workload rule collection groups, their collections and rules | Separate firewall-rules deployment with network-security approval |
| Shared IP Groups used by rules | An explicitly agreed owner, with a stable resource-ID handoff |

Each Azure resource must have one deployment owner. Do not configure the same rule collection group in both the platform AVM inputs and the separate rules deployment. Likewise, do not divide collections or individual rules in one group between different deployments: updating a group submits its collections and rules as a unit and can overwrite another owner's changes.

Separating repositories or Terraform state does not create a security boundary. Use scoped deployment identities, least-privilege RBAC and pull-request approvals appropriate to the shared policy. Where several teams share a policy, a central rules pipeline can accept their requests without giving every team permission to change all groups.

{{< hint type=warning >}}
Rule collection groups still depend on the platform-owned policy. Deleting or replacing that policy can delete its child groups, and changing its firewall association or routing can change which traffic reaches them. Coordinate platform lifecycle changes with the rules owner; a separate pipeline does not make the rules independent of platform teardown.
{{< /hint >}}

## Establish the handoff

1. Deploy the platform and identify the firewall policy actually associated with the target firewall. For multiple regions or hubs, identify each policy rather than assuming one policy covers every firewall.
2. Publish that policy's resource ID as an explicit input to the rules pipeline. For Bicep, also supply its subscription, resource group and name as the deployment scope and parameters. Use the outputs available in your chosen starter/module version or an authorized resource lookup; do not assume a particular output name is universal.
3. Agree stable group names, reserved priority ranges and who owns the entire contents of each group. Keep required platform baseline rules under their existing owner.
4. Deploy the rules only after the policy exists. Serialize changes that affect the same policy across platform and rules pipelines; separate Terraform state locks do not coordinate those pipelines.

The following examples each create one group on an existing policy. They demonstrate the ownership boundary, not a complete production rule set. Replace the sample workload CIDR, destination, group name and priorities with approved values. Choose **one** implementation for a group; do not deploy both examples to the same policy and group name.

## Terraform example

Use `azurerm_firewall_policy_rule_collection_group` in a separate root module with its own remote state backend and locking. Pass the platform-owned policy ID as an input rather than declaring an `azurerm_firewall_policy` resource in this state. Reading platform outputs should not require granting the rules pipeline access to unrelated sensitive state.

Configure the remote backend separately, and authenticate the AzureRM provider to the policy's subscription using your approved identity, for example through OIDC and `ARM_SUBSCRIPTION_ID`. Pin and test provider versions and commit the dependency lock file in your rules repository.

```terraform
terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 4.0"
    }
  }
}

provider "azurerm" {
  features {}
}

variable "firewall_policy_id" {
  type = string
}

resource "azurerm_firewall_policy_rule_collection_group" "workload_egress" {
  name               = "workload-egress"
  firewall_policy_id = var.firewall_policy_id
  priority           = 500

  application_rule_collection {
    name     = "approved-package-downloads"
    priority = 500
    action   = "Allow"

    rule {
      name = "allow-package-downloads"

      protocols {
        type = "Https"
        port = 443
      }

      source_addresses  = ["10.20.1.0/24"]
      destination_fqdns = ["packages.microsoft.com"]
    }
  }
}
```

Review a plan from the rules root module before applying it. It should not create, replace or destroy the platform-owned firewall or policy. Keep the existing backend/state separation; do not copy the platform's state into the rules repository.

If a group already exists under another Terraform owner, coordinate a reviewed state-ownership transfer before declaring or importing it in the new state. Removing configuration without transferring ownership can plan a deletion; importing alone does not stop the old state from managing the same resource. Back up state and ensure only one owner remains before either pipeline applies.

See the [AzureRM rule collection group resource](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/firewall_policy_rule_collection_group) for network rules, DNAT rules and IP Group inputs.

## Bicep example

Target the resource group containing the existing policy. The `existing` declaration references the policy without redeploying it; only the child group is deployed. Authenticate with the approved rules-pipeline identity and use an incremental resource-group deployment.

```bicep
targetScope = 'resourceGroup'

param firewallPolicyName string

resource firewallPolicy 'Microsoft.Network/firewallPolicies@2024-05-01' existing = {
  name: firewallPolicyName
}

resource workloadEgress 'Microsoft.Network/firewallPolicies/ruleCollectionGroups@2024-05-01' = {
  parent: firewallPolicy
  name: 'workload-egress'
  properties: {
    priority: 500
    ruleCollections: [
      {
        name: 'approved-package-downloads'
        priority: 500
        ruleCollectionType: 'FirewallPolicyFilterRuleCollection'
        action: {
          type: 'Allow'
        }
        rules: [
          {
            name: 'allow-package-downloads'
            ruleType: 'ApplicationRule'
            sourceAddresses: [
              '10.20.1.0/24'
            ]
            protocols: [
              {
                protocolType: 'Https'
                port: 443
              }
            ]
            targetFqdns: [
              'packages.microsoft.com'
            ]
          }
        ]
      }
    ]
  }
}
```

You can also consume the standalone [Bicep AVM rule collection group child module](https://github.com/Azure/bicep-registry-modules/tree/main/avm/res/network/firewall-policy/rule-collection-group) from a separate deployment. Use its documented existing-parent input and pin the published module version. Do not redeploy the parent firewall-policy module just to manage workload rules.

Review a what-if result at the correct subscription and resource-group scope before deployment. Use incremental mode, not complete mode, for a template that manages only a subset of the resource group. If using deployment stacks, review their managed-resource and delete/detach behavior before handing ownership to another deployment.

Updating the group replaces its configured rule collections and rules. Omitting an entire group from an incremental template does **not** delete the existing Azure resource; plan an explicit, reviewed removal of an obsolete group. Do not rely on omission to revoke access.

## Design and review rules

- Record the business justification, owner, source, destination, protocol, ports and any expiry date. Avoid wildcard sources or destinations unless explicitly justified and approved.
- Allocate priorities centrally. Lower numbers run first within the applicable rule type; use unique priorities for groups within a policy and collections within a group, leaving gaps for future changes.
- Account for policy inheritance and rule type: parent-policy groups take precedence within each type, and DNAT, network and application rules are processed in that order regardless of group priorities. A matching broad network allow can prevent application-level restrictions from being evaluated. See [Azure Firewall rule processing](https://learn.microsoft.com/azure/firewall/rule-processing).
- Reuse IP Groups for approved address sets where appropriate, with one owner for each IP Group. Choose network versus application rules based on the traffic, and verify DNS requirements for FQDN-based filtering.
- Validate routing, DNS, NSGs and the firewall SKU as well as rules. An allow rule does not route traffic through the firewall, and Premium-only capabilities require the appropriate configuration.

## Operate the rules pipeline

1. Submit a pull request with the rule change, justification and expected allowed and denied flows. Require review from the network-security owner.
2. Run formatting, schema/compile validation and automated checks for duplicate names/priorities, unapproved wildcards and expiry. Generate a Terraform plan or Bicep what-if for the target policy.
3. Review the **whole group** change, including deletions, inherited rules and any concurrent platform work. Approve and serialize the deployment.
4. Test both expected allowed and denied flows from the intended workload network. Inspect firewall diagnostics to confirm the traffic matched the intended rule; a successful IaC deployment alone is not a connectivity or security test.
5. Retain the deployed revision and change record. For rollback, revert to the previous approved rule configuration, review a fresh plan/what-if and redeploy it. Do not roll back by restoring the entire platform state.

Schedule drift and expiry reviews. Reconcile emergency portal changes back into the owning repository before the next deployment so they are not unexpectedly overwritten. Keep diagnostic settings under their agreed owner and give rules operators the access needed to review logs.