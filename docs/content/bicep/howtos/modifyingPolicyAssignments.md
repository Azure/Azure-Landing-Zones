---
title: Modifying Policy Assignments
weight: 10
---

To modify a policy assignment, you will need to update the `parPolicyAssignmentParameterOverrides` object in the appropriate management group's `.bicepparam` file under `templates/core/governance/mgmt-groups/`.

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

To disable a policy assignment without removing it, add it to the `managementGroupDoNotEnforcePolicyAssignments` array:

**platform/main.bicepparam:**

```bicep-params
param platformConfig = {
  // ... other config
  managementGroupDoNotEnforcePolicyAssignments: [
    'Enable-DDoS-VNET'  // This policy will be set to DoNotEnforce mode
  ]
}
```

Alternatively, you can exclude a policy assignment entirely using `managementGroupExcludedPolicyAssignments`:

```bicep-params
param platformConfig = {
  // ... other config
  managementGroupExcludedPolicyAssignments: [
    'Enable-DDoS-VNET'  // This policy will not be deployed at all
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

## Adding Non-Compliance Messages

Non-compliance messages are part of the policy assignment JSON files in the `lib/alz` directory. To add or modify non-compliance messages, you would need to modify those JSON files or add custom policy assignments.

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

### DDoS Protection

If you don't have a DDoS protection plan, disable the `Enable-DDoS-VNET` policy assignment at the `platform` management group:

**platform/main.bicepparam:**

```bicep-params
param platformConfig = {
  // ... other config
  managementGroupExcludedPolicyAssignments: [
    'Enable-DDoS-VNET'
  ]
}
```

Or set it to DoNotEnforce mode:

```bicep-params
param platformConfig = {
  // ... other config
  managementGroupDoNotEnforcePolicyAssignments: [
    'Enable-DDoS-VNET'
  ]
}
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

## Best Practices

1. **Use Parameter Overrides**: Keep your customizations in the `parPolicyAssignmentParameterOverrides` object rather than modifying JSON files
2. **Document Changes**: Add comments in your `.bicepparam` files explaining why policy assignments are disabled or modified
3. **Test Thoroughly**: Test policy changes in a non-production environment before applying to production
4. **Review Compliance**: Regularly review policy compliance reports to ensure policies are working as expected
5. **Understand Policy Lifecycle**: Deploy management groups in order (parent before children) to ensure policies apply correctly
