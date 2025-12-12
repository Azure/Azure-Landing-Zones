---
title: Modifying the Management Group Hierarchy
weight: 10
---

To modify the management group hierarchy, you will need to customize the configuration objects in the `.bicepparam` files located in `templates/core/governance/mgmt-groups/`.

## Default Management Group Structure

The default Azure Landing Zones management group hierarchy includes:

```text
<Tenant Root or Custom Parent>
└── Int-Root (alz)
    ├── Platform
    │   ├── Management
    │   ├── Connectivity
    │   ├── Identity
    │   └── Security
    ├── Landing Zones
    │   ├── Corp
    │   └── Online
    ├── Sandbox
    └── Decommissioned
```

Each management group has its own folder with a `main.bicep` and `main.bicepparam` file.

## Understanding the Configuration Structure

Each management group's `.bicepparam` file contains a configuration object. For example, `int-root/main.bicepparam`:

```bicep-params
param intRootConfig = {
  createOrUpdateManagementGroup: true
  managementGroupName: 'alz'
  managementGroupParentId: ''  // Empty means tenant root
  managementGroupDisplayName: 'Azure Landing Zones'
  managementGroupDoNotEnforcePolicyAssignments: []
  managementGroupExcludedPolicyAssignments: []
  // ... other properties
}
```

## Renaming Management Groups

### Option 1: Change Display Name Only

To change the display name without affecting the ID, update the `managementGroupDisplayName` in the `.bicepparam` file:

**platform/main.bicepparam:**

```bicep-params
param platformConfig = {
  createOrUpdateManagementGroup: true
  managementGroupName: 'platform'
  managementGroupParentId: 'alz'
  managementGroupDisplayName: 'My Organization Platform'  // Changed from 'Platform'
  // ... rest of config
}
```

### Option 2: Change Management Group ID

To change the management group ID, update the `managementGroupName` property:

**platform/main.bicepparam:**

```bicep-params
param platformConfig = {
  createOrUpdateManagementGroup: true
  managementGroupName: 'myorg-platform'  // Changed from 'platform'
  managementGroupParentId: 'alz'
  managementGroupDisplayName: 'Platform'
  // ... rest of config
}
```

{{< hint type=important >}}
If you change management group IDs, you must also update:

1. The `managementGroupParentId` in all child management groups
2. The `--management-group-id` parameter in your deployment commands
3. Any policy assignment scopes or role assignments that reference the old ID

{{< /hint >}}

For example, if you change the int-root ID from `alz` to `myorg`, update all child parameter files:

**platform/main.bicepparam:**

```bicep-params
param platformConfig = {
  // ...
  managementGroupParentId: 'myorg'  // Changed from 'alz'
  managementGroupIntermediateRootName: 'myorg'  // Changed from 'alz'
  // ...
}
```

{{< hint type=important >}}
**Critical**: If you change the int-root management group ID, you must update **both** `managementGroupParentId` AND `managementGroupIntermediateRootName` in ALL child management group parameter files. The `managementGroupIntermediateRootName` property is used to dynamically update policy definition references throughout the hierarchy. Missing this update will cause policy assignment failures.

For example, if changing int-root from `alz` to `myorg`, update these properties in:

- `platform/main.bicepparam`
- `landingzones/main.bicepparam`
- `sandbox/main.bicepparam`
- `decommissioned/main.bicepparam`
- `platform/platform-connectivity/main.bicepparam`
- `platform/platform-identity/main.bicepparam`
- `platform/platform-management/main.bicepparam`
- `platform/platform-security/main.bicepparam`
- `landingzones/landingzones-corp/main.bicepparam`
- `landingzones/landingzones-online/main.bicepparam`

{{< /hint >}}

## Changing the Parent Management Group

To change where a management group sits in the hierarchy, update the `managementGroupParentId`:

**landingzones/main.bicepparam:**

```bicep-params
param landingzonesConfig = {
  createOrUpdateManagementGroup: true
  managementGroupName: 'landingzones'
  managementGroupParentId: 'myorg'  // Changed to point to a different parent
  managementGroupDisplayName: 'Landing Zones'
  // ... rest of config
}
```

## Adding New Management Groups

To add a completely new management group, you can either:

### Option 1: Create a New Folder (Recommended)

1. Copy an existing management group folder (e.g., `sandbox`) as a template
2. Rename the folder to your new management group name
3. Update the configuration in `main.bicepparam`:

```bicep-params
using './main.bicep'

param parLocations = ['eastus']
param parEnableTelemetry = true

param customMgConfig = {
  createOrUpdateManagementGroup: true
  managementGroupName: 'myorg-custom'
  managementGroupParentId: 'landingzones'  // Parent MG ID
  managementGroupDisplayName: 'Custom Workloads'
  managementGroupDoNotEnforcePolicyAssignments: []
  managementGroupExcludedPolicyAssignments: []
  customerRbacRoleDefs: []
  customerRbacRoleAssignments: []
  customerPolicyDefs: []
  customerPolicySetDefs: []
  customerPolicyAssignments: []
  subscriptionsToPlaceInManagementGroup: []
  waitForConsistencyCounterBeforeCustomPolicyDefinitions: 10
  waitForConsistencyCounterBeforeCustomPolicySetDefinitions: 10
  waitForConsistencyCounterBeforeCustomRoleDefinitions: 10
  waitForConsistencyCounterBeforePolicyAssignments: 10
  waitForConsistencyCounterBeforeRoleAssignment: 10
  waitForConsistencyCounterBeforeSubPlacement: 10
}

param parPolicyAssignmentParameterOverrides = {}
```

4. Update `main.bicep` parameter name to match (e.g., change `sandboxConfig` to `customMgConfig`)
5. Deploy the new management group

### Option 2: Use Custom Policy Assignments

You can add custom policy assignments to an existing management group using the `customerPolicyAssignments` array:

```bicep-params
param landingzonesConfig = {
  // ... existing config
  customerPolicyAssignments: [
    {
      name: 'Custom-Policy-Assignment'
      properties: {
        displayName: 'My Custom Policy'
        policyDefinitionId: '/providers/Microsoft.Authorization/policyDefinitions/<policy-id>'
        scope: '/providers/Microsoft.Management/managementGroups/landingzones'
        enforcementMode: 'Default'
      }
    }
  ]
}
```

## Removing Management Groups

To remove a management group from the deployment:

1. Set `createOrUpdateManagementGroup` to `false` in the `.bicepparam` file:

```bicep-params
param sandboxConfig = {
  createOrUpdateManagementGroup: false  // This will skip creation
  // ... rest of config
}
```

1. Or skip deploying that management group's template entirely

1. Manually delete the management group from Azure Portal if it already exists (ensure no subscriptions are assigned first)

{{< hint type=warning >}}
Removing a management group from the templates does not delete it from Azure. You must manually delete it after removing all subscriptions and child resources.
{{< /hint >}}

## Assigning Subscriptions to Management Groups

You can assign subscriptions to management groups using the `subscriptionsToPlaceInManagementGroup` array:

**landingzones-corp/main.bicepparam:**

```bicep-params
param landingzonesCorpConfig = {
  // ... other config
  subscriptionsToPlaceInManagementGroup: [
    'subscription-id-1'
    'subscription-id-2'
  ]
}
```

## Best Practices

1. **Plan Before Changing**: Document your desired hierarchy before making changes
2. **Update All References**: Ensure all `managementGroupParentId` values are correct after renaming
3. **Use Descriptive Names**: Choose clear, consistent naming for management group IDs and display names
4. **Test First**: Test changes in a non-production environment
5. **Document Customizations**: Maintain documentation of why you deviated from the default structure
6. **Deploy in Order**: Always deploy parent management groups before children
