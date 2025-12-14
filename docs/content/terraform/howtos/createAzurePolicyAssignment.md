---
title: Creating an Azure Policy assignment
weight: 10
---

This guide explains how to create Azure Policy assignments in your Azure Landing Zone deployment. You can assign:

- Built-in Azure policies
- Custom policy definitions
- Built-in initiatives (policy sets)
- Custom initiatives

{{< hint type=important >}}
You will need to have a [custom library]({{< relref "customLibrary" >}}) if you want to add policy assignments.
Make sure you have completed that step before continuing.
{{< /hint >}}

## Overview

To assign a policy or initiative in ALZ, you need to:

1. Create a policy assignment file
2. Create an archetype override to include the assignment
3. Update your architecture definition to use the override archetype

## Policy Assignment Structure

Policy assignments in the ALZ library follow a specific naming convention and structure:

- **Filename**: `<AssignmentName>.alz_policy_assignment.json` (or `.yaml`)
- **Location**: `lib/policy_assignments/` folder in your custom library

## Assigning a Built-in Policy

Built-in policies are provided by Microsoft and don't require a policy definition file. You only need to create an assignment file.

### Example: Require a Tag on Resources

This example assigns the built-in policy that requires a specific tag on resources.

Create a file named `Require-Tag-Environment.alz_policy_assignment.json` in your `lib/policy_assignments/` folder:

```json
{
  "type": "Microsoft.Authorization/policyAssignments",
  "apiVersion": "2024-04-01",
  "name": "Require-Tag-Environment",
  "dependsOn": [],
  "properties": {
    "displayName": "Require Environment tag on resources",
    "description": "Enforces the existence of an 'Environment' tag on all resources.",
    "policyDefinitionId": "/providers/Microsoft.Authorization/policyDefinitions/871b6d14-10aa-478d-b590-94f262ecfa99",
    "enforcementMode": "Default",
    "nonComplianceMessages": [
      {
        "message": "Resources must have an 'Environment' tag."
      }
    ],
    "parameters": {
      "tagName": {
        "value": "Environment"
      }
    },
    "scope": "/providers/Microsoft.Management/managementGroups/placeholder",
    "notScopes": []
  },
  "location": "${default_location}"
}
```

{{< hint type=tip >}}
To find the `policyDefinitionId` for built-in policies, use [AzAdvertizer](https://www.azadvertizer.net/azpolicyadvertizer_all.html) or the Azure Portal.
{{< /hint >}}

## Assigning a Custom Policy

For custom policies, you first need to create the policy definition (see [Creating a Custom Azure Policy Definition]({{< relref "createCustomAzurePolicy" >}})), then create an assignment that references it.

### Example: Whitelist Resource Providers

This example assigns a custom policy that restricts which resource providers can be registered.

Create a file named `Deny-Resource-Providers.alz_policy_assignment.json` in your `lib/policy_assignments/` folder:

```json
{
  "type": "Microsoft.Authorization/policyAssignments",
  "apiVersion": "2024-04-01",
  "name": "Deny-Resource-Providers",
  "dependsOn": [],
  "properties": {
    "displayName": "Only allow whitelisted Resource Providers",
    "description": "This policy restricts which resource providers can be registered, ensuring only approved Azure services are available.",
    "policyDefinitionId": "/providers/Microsoft.Management/managementGroups/placeholder/providers/Microsoft.Authorization/policyDefinitions/Deny-Resource-Providers",
    "enforcementMode": "Default",
    "nonComplianceMessages": [
      {
        "message": "Resource provider registration is not allowed. Only approved resource providers can be registered."
      }
    ],
    "parameters": {
      "effect": {
        "value": "Deny"
      },
      "allowedResourceProviders": {
        "value": [
          "Microsoft.Compute",
          "Microsoft.Storage",
          "Microsoft.Network",
          "Microsoft.KeyVault",
          "Microsoft.ManagedIdentity",
          "Microsoft.Authorization",
          "Microsoft.Resources"
        ]
      }
    },
    "scope": "/providers/Microsoft.Management/managementGroups/placeholder",
    "notScopes": []
  },
  "location": "${default_location}"
}
```

{{< hint type=note >}}
For custom policies, the `policyDefinitionId` references a placeholder management group. The ALZ provider automatically resolves the correct resource ID based on the policy definition name.
{{< /hint >}}

## Assigning a Built-in Initiative

Built-in initiatives group multiple related policies together. You assign them the same way as individual policies.

### Example: Allowed Locations

This example assigns the built-in "Allowed locations" initiative that restricts which Azure regions resources can be deployed to.

Create a file named `Allowed-Locations.alz_policy_assignment.json` in your `lib/policy_assignments/` folder:

```json
{
  "type": "Microsoft.Authorization/policyAssignments",
  "apiVersion": "2024-04-01",
  "name": "Allowed-Locations",
  "dependsOn": [],
  "properties": {
    "displayName": "Allowed locations for resource deployment",
    "description": "This initiative restricts the locations where resources can be deployed to enforce data residency requirements.",
    "policyDefinitionId": "/providers/Microsoft.Authorization/policySetDefinitions/e56962a6-4747-49cd-b67b-bf8b01975c4c",
    "enforcementMode": "Default",
    "nonComplianceMessages": [
      {
        "message": "Resources must be deployed to an approved location."
      }
    ],
    "parameters": {
      "listOfAllowedLocations": {
        "value": [
          "eastus",
          "eastus2",
          "westus2",
          "westeurope",
          "northeurope"
        ]
      }
    },
    "scope": "/providers/Microsoft.Management/managementGroups/placeholder",
    "notScopes": []
  },
  "location": "${default_location}"
}
```

{{< hint type=tip >}}
To find the `policyDefinitionId` for built-in initiatives, use [AzAdvertizer](https://www.azadvertizer.net/azpolicyinitiativesadvertizer_all.html) or the Azure Portal.
{{< /hint >}}

## Assigning a Custom Initiative

For custom initiatives, you first need to create the initiative definition (see [Creating an Azure Policy Initiative]({{< relref "createAzurePolicyInitiative" >}})), then create an assignment that references it.

### Example: Enforce Mandatory Tags Initiative

This example assigns a custom initiative that enforces mandatory tags.

Create a file named `Enforce-Mandatory-Tags.alz_policy_assignment.json` in your `lib/policy_assignments/` folder:

```json
{
  "type": "Microsoft.Authorization/policyAssignments",
  "apiVersion": "2024-04-01",
  "name": "Enforce-Mandatory-Tags",
  "dependsOn": [],
  "properties": {
    "displayName": "Enforce mandatory tags on resources",
    "description": "This initiative enforces mandatory tags on all resources to ensure proper governance and cost management.",
    "policyDefinitionId": "/providers/Microsoft.Management/managementGroups/placeholder/providers/Microsoft.Authorization/policySetDefinitions/Enforce-Mandatory-Tags",
    "enforcementMode": "Default",
    "nonComplianceMessages": [
      {
        "message": "Resources must have all mandatory tags (Environment, Owner, CostCenter)."
      },
      {
        "policyDefinitionReferenceId": "Require-Environment-Tag",
        "message": "Resources must have an 'Environment' tag."
      },
      {
        "policyDefinitionReferenceId": "Require-Owner-Tag",
        "message": "Resources must have an 'Owner' tag."
      },
      {
        "policyDefinitionReferenceId": "Require-CostCenter-Tag",
        "message": "Resources must have a 'CostCenter' tag."
      }
    ],
    "parameters": {
      "effect": {
        "value": "Audit"
      },
      "environmentTagName": {
        "value": "Environment"
      },
      "ownerTagName": {
        "value": "Owner"
      },
      "costCenterTagName": {
        "value": "CostCenter"
      }
    },
    "scope": "/providers/Microsoft.Management/managementGroups/placeholder",
    "notScopes": []
  },
  "location": "${default_location}"
}
```

{{< hint type=note >}}
For initiatives, you can specify `nonComplianceMessages` for the overall initiative and for individual policies using `policyDefinitionReferenceId`.
{{< /hint >}}

## Policy Assignment Schema

| Field | Description |
|-------|-------------|
| `name` | Unique identifier for the assignment. Must match the filename (without extension). |
| `type` | Always `Microsoft.Authorization/policyAssignments` |
| `apiVersion` | API version, typically `2024-04-01` |
| `properties.displayName` | Human-readable name shown in the Azure Portal |
| `properties.description` | Detailed description of the assignment |
| `properties.policyDefinitionId` | Resource ID of the policy definition or initiative to assign |
| `properties.enforcementMode` | `Default` (enforced) or `DoNotEnforce` (audit only) |
| `properties.nonComplianceMessages` | Messages shown when resources are non-compliant |
| `properties.parameters` | Parameter values for the policy |
| `properties.scope` | Use `/providers/Microsoft.Management/managementGroups/placeholder` |
| `properties.notScopes` | Array of scopes to exclude from the assignment |
| `location` | Use `${default_location}` for the deployment location |

## Creating an Archetype Override

After creating your assignment file, you need to add it to an archetype using an override file.

Create a file named `<archetype>_override.alz_archetype_override.yaml` in your `lib/archetype_definitions/` folder.

### Example: Adding Assignment to Landing Zones

```yaml
name: "landing_zones_override"
base_archetype: "landing_zones"
policy_assignments_to_add:
  - "Require-Tag-Environment"
  - "Deny-Resource-Providers"
  - "Allowed-Locations"
policy_assignments_to_remove: []
policy_definitions_to_add:
  - "Deny-Resource-Providers"
policy_definitions_to_remove: []
policy_set_definitions_to_add: []
policy_set_definitions_to_remove: []
role_definitions_to_add: []
role_definitions_to_remove: []
```

{{< hint type=important >}}
- If you're assigning a custom policy, ensure the policy definition is also added to an archetype (typically `root`) via `policy_definitions_to_add`.
- If you're assigning a custom initiative, ensure the initiative is added via `policy_set_definitions_to_add` and any custom policy definitions it contains are added via `policy_definitions_to_add`.
{{< /hint >}}

### Example: Adding Assignment to Root (All Management Groups)

For policies that should apply to the entire hierarchy:

```yaml
name: "root_override"
base_archetype: "root"
policy_assignments_to_add:
  - "Require-Tag-Environment"
policy_assignments_to_remove: []
policy_definitions_to_add: []
policy_definitions_to_remove: []
policy_set_definitions_to_add: []
policy_set_definitions_to_remove: []
role_definitions_to_add: []
role_definitions_to_remove: []
```

## Updating the Architecture Definition

Create or update your architecture definition to use the override archetype.

Create `alz.alz_architecture_definition.yaml` in your `lib/architecture_definitions/` folder:

```yaml
name: alz
management_groups:
  - id: "yourorg"
    display_name: "Your Organization"
    archetypes:
      - "root_override"
    parent_id: null
    exists: false
  - id: "yourorg-platform"
    display_name: "Platform"
    archetypes:
      - "platform"
    parent_id: "yourorg"
    exists: false
  - id: "yourorg-landingzones"
    display_name: "Landing Zones"
    archetypes:
      - "landing_zones_override"
    parent_id: "yourorg"
    exists: false
  - id: "yourorg-decommissioned"
    display_name: "Decommissioned"
    archetypes:
      - "decommissioned"
    parent_id: "yourorg"
    exists: false
  - id: "yourorg-sandbox"
    display_name: "Sandbox"
    archetypes:
      - "sandbox"
    parent_id: "yourorg"
    exists: false
```

## Configuring Parameters via Terraform

Instead of hardcoding parameter values in the assignment file, you can override them using the `policy_assignments_to_modify` variable:

```terraform
module "alz" {
  source = "Azure/avm-ptn-alz/azurerm"
  # ... other configuration

  policy_assignments_to_modify = {
    landing_zones = {
      policy_assignments = {
        Require-Tag-Environment = {
          parameters = {
            tagName = jsonencode({ value = "CostCenter" })  # Override the tag name
          }
        }
        Deny-Resource-Providers = {
          enforcement_mode = "DoNotEnforce"  # Start in audit mode
          parameters = {
            effect = jsonencode({ value = "Audit" })
            allowedResourceProviders = jsonencode({
              value = [
                "Microsoft.Compute",
                "Microsoft.Storage",
                "Microsoft.Network",
                "Microsoft.KeyVault",
                "Microsoft.ManagedIdentity",
                "Microsoft.Authorization",
                "Microsoft.Resources",
                "Microsoft.Web",
                "Microsoft.Sql"
              ]
            })
          }
        }
      }
    }
  }
}
```

## Removing Existing Policy Assignments

To remove a policy assignment from an existing archetype, use the `policy_assignments_to_remove` field:

```yaml
name: "landing_zones_override"
base_archetype: "landing_zones"
policy_assignments_to_add: []
policy_assignments_to_remove:
  - "Deny-IP-forwarding"
  - "Deny-MgmtPorts-Internet"
policy_definitions_to_add: []
policy_definitions_to_remove: []
policy_set_definitions_to_add: []
policy_set_definitions_to_remove: []
role_definitions_to_add: []
role_definitions_to_remove: []
```

## Complete Library Structure

After creating assignments, your library structure should look like this:

```text
lib/
├── alz_library_metadata.json
├── architecture_definitions/
│   └── alz.alz_architecture_definition.yaml
├── archetype_definitions/
│   ├── root_override.alz_archetype_override.yaml
│   └── landing_zones_override.alz_archetype_override.yaml
├── policy_assignments/
│   ├── Require-Tag-Environment.alz_policy_assignment.json
│   ├── Deny-Resource-Providers.alz_policy_assignment.json
│   ├── Allowed-Locations.alz_policy_assignment.json
│   └── Enforce-Mandatory-Tags.alz_policy_assignment.json
├── policy_definitions/
│   └── Deny-Resource-Providers.alz_policy_definition.json
└── policy_set_definitions/
    └── Enforce-Mandatory-Tags.alz_policy_set_definition.json
```

## Best Practices

1. **Start with DoNotEnforce**: When deploying new deny policies, set `enforcementMode` to `DoNotEnforce` to audit the impact before enforcing.

2. **Use non-compliance messages**: Always provide clear, actionable non-compliance messages to help users understand what they need to fix.

3. **Scope appropriately**: Assign policies at the appropriate management group level—not everything needs to be at root.

4. **Use notScopes sparingly**: Exclusions should be the exception, not the rule. Document why exclusions are needed.

5. **Test thoroughly**: Test assignments in a sandbox environment before applying to production management groups.

## Troubleshooting

### Assignment not appearing

- Verify the assignment name in the archetype override matches the filename
- Ensure the archetype override is referenced in the architecture definition
- Check that your custom library is correctly referenced in the provider configuration

### Policy definition not found

- For custom policies, ensure the definition is deployed before the assignment
- Verify the `policyDefinitionId` references the correct definition name
- Ensure the policy definition is added to an archetype via `policy_definitions_to_add`

### Initiative definition not found

- Ensure the initiative is added to an archetype via `policy_set_definitions_to_add`
- Verify the `policyDefinitionId` references the correct initiative name
- For custom initiatives with custom policies, ensure all custom policy definitions are also added to the archetype

### Parameters not applying

- Verify parameter names match exactly (case-sensitive)
- Ensure parameter values are in the correct format (especially for arrays)
- Check that the parameter exists in the policy definition

## Additional Resources

- [Azure Landing Zones Library Documentation](https://azure.github.io/Azure-Landing-Zones-Library/)
- [ALZ Library - Policy Assignments](https://github.com/Azure/Azure-Landing-Zones-Library/tree/main/platform/alz/policy_assignments)
- [Azure Policy Assignment Structure](https://learn.microsoft.com/en-us/azure/governance/policy/concepts/assignment-structure)
- [AzAdvertizer - Policy Index](https://www.azadvertizer.net/azpolicyadvertizer_all.html)
- [AzAdvertizer - Initiative Index](https://www.azadvertizer.net/azpolicyinitiativesadvertizer_all.html)
- [Creating an Azure Policy Initiative]({{< relref "createAzurePolicyInitiative" >}})
