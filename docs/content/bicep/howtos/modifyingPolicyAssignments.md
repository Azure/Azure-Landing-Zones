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

If you don't have a DDoS protection plan, exclude the `Enable-DDoS-VNET` policy assignment from both management groups:

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
