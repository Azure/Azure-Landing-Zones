---
title: Modifying Policy Assignments
weight: 10
---

To modify a ALZ provided policy assignment (reside in `templates/core/governance/lib/alz`), you will need to update the `parPolicyAssignmentParameterOverrides` object in the appropriate management group's `.bicepparam` file under `templates/core/governance/mgmt-groups/`.

Policy assignments are loaded from JSON files in the `lib/alz` directory, and you can override specific parameters without modifying the JSON files directly.

## Understanding Policy Assignment Overrides

Each management group's `.bicepparam` file contains a `parPolicyAssignmentParameterOverrides` object where you can specify changes to policy assignments.

Example from `int-root/main.bicepparam`:

```bicep-params
param parPolicyAssignmentParameterOverrides = {
  'Deploy-MDFC-Config-H224': {
    parameters: {
      logAnalytics: {
        value: '/subscriptions/.../workspaces/law-alz-eastus'
      }
      emailSecurityContact: {
        value: 'security@yourcompany.com'
      }
    }
  }
}
```

{{< hint type=warning >}}
In alz-bicep-accelerator v2.5.0 and earlier, `parPolicyAssignmentParameterOverrides` doesn't support `enforcementMode`. If you add it, the deployment succeeds, but the enforcement mode doesn't change. To enforce an assignment that ships in `DoNotEnforce` mode, see [Enforcing a policy assignment that ships in DoNotEnforce mode](#enforcing-a-policy-assignment-that-ships-in-donotenforce-mode).
{{< /hint >}}

## Disabling a Policy Assignment

You can either set a policy assignment's enforcement mode to DoNotEnforce or exclude it entirely from deployment.

To change the Enforcement mode of a policy assignment to DoNotEnforce, but still assign the policy, add it to the `managementGroupDoNotEnforcePolicyAssignments` array in the corresponding management group's `.bicepparam` file:

**Example using `landingzones/main.bicepparam`:**

```bicep-params
param landingZonesConfig = {
  // ... other config
  managementGroupDoNotEnforcePolicyAssignments: [
    'Deny-Subnet-Without-Nsg'  // This policy will be set to DoNotEnforce mode
  ]
}
```

Alternatively, you can exclude a policy assignment entirely from the deployment using `managementGroupExcludedPolicyAssignments`:

```bicep-params
param landingZonesConfig = {
  // ... other config
  managementGroupExcludedPolicyAssignments: [
    'Deny-Subnet-Without-Nsg'  // This policy will not be deployed at all
  ]
}
```

`managementGroupDoNotEnforcePolicyAssignments` can only set an assignment to `DoNotEnforce`. If you remove an assignment from the list, it goes back to the enforcement mode in the ALZ library file, which is `DoNotEnforce` for some assignments. See [Enforcing a policy assignment that ships in DoNotEnforce mode](#enforcing-a-policy-assignment-that-ships-in-donotenforce-mode).

## Enforcing a Policy Assignment That Ships in DoNotEnforce Mode

Some ALZ policy assignments are deployed with `enforcementMode` set to `DoNotEnforce` in the ALZ library, so you can review their compliance results before you enforce them. These include most of the **Enforce recommended guardrails** assignments (`Enforce-GR-*`), `Enforce-Encrypt-CMK0` and `Enforce-Subnet-Private` at the `landingzones` and `platform` management groups.

In alz-bicep-accelerator v2.5.0 and earlier, you can't change the enforcement mode with `parPolicyAssignmentParameterOverrides`. To enforce one of these assignments without editing the library files, exclude the ALZ assignment, then deploy it again as a customer policy assignment with a new name.

**landingzones/main.bicepparam:**

```bicep-params
// Intermediate root management group ID (same value as managementGroupIntermediateRootName)
var intRootMgId = 'alz'

var enforceGrStorage = loadJsonContent('../../lib/alz/landingzones/Enforce-GR-Storage0.alz_policy_assignment.json')

param landingZonesConfig = {
  // ... other config
  managementGroupExcludedPolicyAssignments: [
    'Enforce-GR-Storage0'
  ]
  customerPolicyAssignments: [
    union(enforceGrStorage, {
      name: 'Enforce-GR-Storage-Cust'
      location: parLocations[0]
      properties: union(enforceGrStorage.properties, {
        enforcementMode: 'Default'
        policyDefinitionId: replace(
          enforceGrStorage.properties.policyDefinitionId,
          '/managementGroups/alz/',
          '/managementGroups/${intRootMgId}/'
        )
        roleDefinitionIds: [
          '/providers/Microsoft.Authorization/roleDefinitions/b24988ac-6180-42a0-ab88-20f7382dd24c' // Contributor
        ]
      })
    })
  ]
}
```

For the `platform` management group, make the same change in `platform/main.bicepparam` (`platformConfig`), and load the file from `../../lib/alz/platform/`.

Before you apply this change:

- **Use a new name** of up to 24 characters. If you keep the ALZ name, the ALZ entry takes precedence and the assignment stays in `DoNotEnforce` mode.
- **Set `roleDefinitionIds`.** Customer policy assignments don't get the role definitions that the template assigns to ALZ assignments. Use the roles listed for the original assignment in `alzPolicyAssignmentRoleDefinitions` in the management group's `main.bicep`. All `Enforce-GR-*` assignments use Contributor.
- **Set `intRootMgId`** to your intermediate root management group ID, so that the policy set definition ID resolves.
- **Expect the assignment to be replaced.** The accelerator deploys with deployment stacks that use `ActionOnUnmanage = DeleteAll`, so the next deployment deletes the original assignment and its role assignments, then creates the new one. Compliance history starts again, and you need to recreate any policy exemptions that target the original assignment.
- **Review the impact.** Check the assignment's compliance results first. Once an assignment is enforced, its deny effects block non-compliant create and update requests. Test the change in a non-production hierarchy before you deploy it to production.

## Modifying Policy Parameters

To modify policy parameters, add an override entry in `parPolicyAssignmentParameterOverrides`:

**landingzones/main.bicepparam:**

```bicep-params
param parPolicyAssignmentParameterOverrides = {
  'Deny-PublicPaaSEndpoints': {
    parameters: {
      effect: {
        value: 'Audit'  // Changed from default 'Deny' to 'Audit'
      }
    }
  }
}
```

You can override multiple parameters in a single policy assignment:

```bicep-params
param parPolicyAssignmentParameterOverrides = {
  'Deploy-VM-Monitoring': {
    parameters: {
      logAnalytics: {
        value: '/subscriptions/.../workspaces/law-alz-eastus'
      }
      dcrResourceId: {
        value: '/subscriptions/.../dataCollectionRules/dcr-vmi-alz-eastus'
      }
    }
  }
}
```

## Adding Custom Policy Assignments

You can add completely custom policy assignments using the `customerPolicyAssignments` array:

**landingzones/main.bicepparam:**

```bicep-params
param landingzonesConfig = {
  // ... other config
  customerPolicyAssignments: [
    {
      name: 'Custom-Tag-Policy'
      location: 'eastus'
      properties: {
        displayName: 'Require specific tags on resources'
        policyDefinitionId: '/providers/Microsoft.Authorization/policyDefinitions/1e30110a-5ceb-460c-a204-c1c3969c6d62'
        scope: '/providers/Microsoft.Management/managementGroups/landingzones'
        enforcementMode: 'Default'
        parameters: {
          tagName: {
            value: 'Environment'
          }
        }
        nonComplianceMessages: [
          {
            message: 'All resources must have an Environment tag.'
          }
        ]
      }
    }
    {
        'loadJsonContent('../../lib/alz/CustomNaming.alz_policy_assignment.json'')'
    }
  ]
}
```

## Changing Policy Assignment Location

You can override the deployment location for a specific policy assignment:

```bicep-params
param parPolicyAssignmentParameterOverrides = {
  'Deploy-MDFC-Config-H224': {
    location: 'westus2'  // Override the default location
    parameters: {
      // ... parameter overrides
    }
  }
}
```

## Changing Policy Assignment Scope

To change the scope of a policy assignment:

```bicep-params
param parPolicyAssignmentParameterOverrides = {
  'Custom-Policy': {
    scope: '/subscriptions/<subscription-id>'  // Assign to a specific subscription
    parameters: {
      // ... parameter overrides
    }
  }
}
```

## Common Policy Assignments to Review

### DDoS Protection {#ddos-protection}

The `Enable-DDoS-VNET` policy assignment is deployed at two management groups:

- **Connectivity** management group — via `lib/alz/platform/connectivity/Enable-DDoS-VNET.alz_policy_assignment.json`
- **Landing Zones** management group — via `lib/alz/landingzones/Enable-DDoS-VNET.alz_policy_assignment.json`

#### Keeping the policy enabled

If you plan to keep the policy enabled, make sure you provide the DDoS protection plan resource ID via the `Enable-DDoS-VNET` override in both management group parameter files:

**platform-connectivity/main.bicepparam:**

```bicep-params
param parPolicyAssignmentParameterOverrides = {
  'Enable-DDoS-VNET': {
    parameters: {
      ddosPlan: {
        value: '/subscriptions/<subscription-id>/resourceGroups/<rg-name>/providers/Microsoft.Network/ddosProtectionPlans/<plan-name>'
      }
    }
  }
}
```

**landingzones/main.bicepparam:**

```bicep-params
param parPolicyAssignmentParameterOverrides = {
  'Enable-DDoS-VNET': {
    parameters: {
      ddosPlan: {
        value: '/subscriptions/<subscription-id>/resourceGroups/<rg-name>/providers/Microsoft.Network/ddosProtectionPlans/<plan-name>'
      }
    }
  }
}
```

#### Disabling the policy

{{< hint type=important >}}
The `Enable-DDoS-VNET` policy uses a `Modify` effect with `Default` enforcement mode. This means the policy actively intercepts VNet creation and update requests to inject the DDoS protection plan reference. If the policy is deployed with placeholder parameter values and no DDoS protection plan exists, VNet deployments will fail with `LinkedAuthorizationFailed` errors. Make sure the governance stacks are updated and deployed before running the networking stack.
{{< /hint >}}

If you aren’t using a DDoS protection plan, exclude the `Enable DDoS VNET` policy assignment from both management groups by adding it to the managementGroupExcludedPolicyAssignments parameter. For example:

**platform-connectivity/main.bicepparam:**

```bicep-params
param platformConnectivityConfig = {
  // ... other config
  managementGroupExcludedPolicyAssignments: [
    'Enable-DDoS-VNET'
  ]
}
```

**landingzones/main.bicepparam:**

```bicep-params
param landingZonesConfig = {
  // ... other config
  managementGroupExcludedPolicyAssignments: [
    'Enable-DDoS-VNET'
  ]
}
```

You must also update the cross-management group RBAC parameter files to exclude the policy assignment. These modules reference the policy assignment as an `existing` resource to retrieve its managed identity, and will fail if the assignment does not exist.

**platform/main-rbac.bicepparam:**

```bicep-params
param parManagementGroupExcludedPolicyAssignments = [
  'Enable-DDoS-VNET'
]
```

**landingzones/main-rbac.bicepparam:**

```bicep-params
param parManagementGroupExcludedPolicyAssignments = [
  'Enable-DDoS-VNET'
]
```

### Private DNS Zones

If you don't use private endpoints, disable the `Deploy-Private-DNS-Zones` policy assignment at the `landingzones-corp` management group:

**landingzones/landingzones-corp/main.bicepparam:**

```bicep-params
param landingzonesCorpConfig = {
  // ... other config
  managementGroupExcludedPolicyAssignments: [
    'Deploy-Private-DNS-Zones'
  ]
}
```

You must also update the cross-management group RBAC parameter file. The Platform Connectivity RBAC module references the `Deploy-Private-DNS-Zones` policy assignment as an `existing` resource to retrieve its managed identity. If the policy assignment is excluded but the RBAC module is not updated, the deployment will fail because the referenced policy assignment does not exist.
This behavior is similar to the `Enable-DDoS-VNET` policy assignment, where associated RBAC modules must also be updated when excluding the policy assignment.

**platform/platform-connectivity/main-rbac.bicepparam:**

```bicep-params
param parManagementGroupExcludedPolicyAssignments = [
  'Deploy-Private-DNS-Zones'
]
```

When you keep this policy enabled, provide the resource group that hosts your private DNS zones:

```bicep-params
param parPolicyAssignmentParameterOverrides = {
  'Deploy-Private-DNS-Zones': {
    parameters: {
      privateDnsZoneResourceGroupId: {
        value: '/subscriptions/<subscription-id>/resourceGroups/<rg-name>'
      }
    }
  }
}
```

### Azure Monitor Agent

If you use a third-party monitoring solution, disable these policy assignments in the `landingzones` management group:

**landingzones/main.bicepparam:**

```bicep-params
param landingzonesConfig = {
  // ... other config
  managementGroupExcludedPolicyAssignments: [
    'Deploy-VM-Monitoring'
    'Deploy-VMSS-Monitoring'
    'Deploy-VM-ChangeTrack'
    'Deploy-VMSS-ChangeTrack'
    'Deploy-MDFC-DefSQL-AMA'
  ]
}
```

If you keep these assignments active, make sure the required Log Analytics workspace and Data Collection Rules are available, and override parameters such as `logAnalytics` or `dcrResourceId` as needed in `parPolicyAssignmentParameterOverrides`.

## Best Practices

1. **Use Parameter Overrides**: Keep your customizations in the `parPolicyAssignmentParameterOverrides` object rather than modifying JSON files
2. **Document Changes**: Add comments in your `.bicepparam` files explaining why policy assignments are disabled or modified
3. **Test Thoroughly**: Test policy changes in a non-production environment before applying to production
4. **Review Compliance**: Regularly review policy compliance reports to ensure policies are working as expected
5. **Understand Policy Lifecycle**: Deploy management groups in order (parent before children) to ensure policies apply correctly
