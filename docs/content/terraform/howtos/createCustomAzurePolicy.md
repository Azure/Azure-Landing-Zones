---
title: Creating a custom Azure Policy definition
weight: 10
---

This guide walks you through creating a custom Azure Policy definition for your Azure Landing Zone deployment. We'll use a practical example: creating a policy to deny specific Azure Resource Types.

{{< hint type=important >}}
You will need to have a [custom library]({{< relref "customLibrary" >}}) if you want to add custom policies.
Make sure you have completed that step before continuing.
{{< /hint >}}

Once you have created your policy definition, see [Creating an Azure Policy Assignment]({{< relref "createAzurePolicyAssignment" >}}) to learn how to assign it, or [Creating an Azure Policy Initiative]({{< relref "createAzurePolicyInitiative" >}}) to learn how to group multiple policies together.

## Policy Definition Structure

Policy definitions in the ALZ library follow a specific naming convention and structure:

- **Filename**: `<PolicyName>.alz_policy_definition.json` (or `.yaml`)
- **Location**: `lib/policy_definitions/` folder in your custom library

## Example: Deny Specific Resource Types

This policy denies the deployment of resource types that are in a denied list. This is useful for preventing the use of unapproved or legacy Azure services within your organization (e.g., blocking classic compute resources).

### Create the Policy Definition File

Create a file named `Deny-Resource-Types.alz_policy_definition.json` in your custom library's `policy_definitions` folder (create the folder if it doesn't exist):

```text
lib/
├── policy_definitions/
│   └── Deny-Resource-Types.alz_policy_definition.json
```

Add the following content:

```json
{
  "name": "Deny-Resource-Types",
  "type": "Microsoft.Authorization/policyDefinitions",
  "properties": {
    "displayName": "Only allow whitelisted Resource Types",
    "description": "This policy restricts which resource types can be deployed, ensuring only approved Azure services are available. This is enforced by checking the resource type during deployment.",
    "policyType": "Custom",
    "mode": "All",
    "metadata": {
      "version": "1.0.0",
      "category": "General",
      "source": "https://github.com/Azure/Enterprise-Scale/",
      "alzCloudEnvironments": [
        "AzureCloud",
        "AzureChinaCloud",
        "AzureUSGovernment"
      ]
    },
    "parameters": {
      "effect": {
        "type": "String",
        "metadata": {
          "displayName": "Effect",
          "description": "Enable or disable the execution of the policy"
        },
        "allowedValues": [
          "Audit",
          "Deny",
          "Disabled"
        ],
        "defaultValue": "Audit"
      },
      "deniedResourceTypes": {
        "type": "Array",
        "metadata": {
          "displayName": "Denied Resource Types",
          "description": "The list of resource types that are not allowed to be deployed. Example: Microsoft.Sql/servers, Microsoft.ClassicCompute/virtualMachines",
          "strongType": "resourceTypes"
        },
        "defaultValue": []
      }
    },
    "policyRule": {
      "if": {
        "field": "type",
        "in": "[parameters('deniedResourceTypes')]"
      },
      "then": {
        "effect": "[parameters('effect')]"
      }
    }
  }
}
```

{{< hint type=tip >}}
You can also use YAML format for policy definitions. Simply name the file with a `.yaml` or `.yml` extension instead of `.json`.
{{< /hint >}}

## Policy Definition Schema

The policy definition file follows the Azure Policy definition structure with some ALZ-specific metadata:

| Field | Description |
|-------|-------------|
| `name` | Unique identifier for the policy. Must match the filename (without extension). |
| `type` | Always `Microsoft.Authorization/policyDefinitions` |
| `properties.displayName` | Human-readable name shown in the Azure Portal |
| `properties.description` | Detailed description of what the policy does |
| `properties.policyType` | Always `Custom` for custom policies |
| `properties.mode` | `All` for policies that evaluate all resource types, `Indexed` for policies that evaluate only resource types that support tags and location |
| `properties.metadata` | Contains version, category, and ALZ-specific fields |
| `properties.parameters` | Input parameters for the policy |
| `properties.policyRule` | The logic that defines when the policy effect is triggered |

### Metadata Fields

The `metadata` section should include:

```json
"metadata": {
  "version": "1.0.0",
  "category": "General",
  "source": "https://github.com/Azure/Enterprise-Scale/",
  "alzCloudEnvironments": [
    "AzureCloud",
    "AzureChinaCloud",
    "AzureUSGovernment"
  ]
}
```

- **version**: Semantic version for tracking changes
- **category**: Groups policies in the Azure Portal (e.g., "General", "Network", "Security", "Compute")
- **source**: Reference to the source repository
- **alzCloudEnvironments**: Which Azure clouds this policy supports

## Common Policy Effects

When creating policies, choose the appropriate effect:

| Effect | Description |
|--------|-------------|
| `Deny` | Prevents the resource operation from completing |
| `Audit` | Logs a warning but allows the operation |
| `Disabled` | Policy is not evaluated |
| `Modify` | Adds, updates, or removes properties on a resource |
| `DeployIfNotExists` | Deploys a resource if it doesn't exist |
| `AuditIfNotExists` | Audits if a related resource doesn't exist |

{{< hint type=tip >}}
Always include an `effect` parameter with `Audit`, `Deny`, and `Disabled` as allowed values. This allows administrators to change the enforcement level without modifying the policy definition.
{{< /hint >}}

## Adding the Policy Definition to Your Library

After creating the policy definition file, you need to add it to an archetype so it gets deployed. Policy definitions are typically added to the `root` archetype so they are available to all child management groups.

Create an archetype override file (e.g., `root_override.alz_archetype_override.yaml`) in your `lib/archetype_definitions/` folder:

```yaml
name: "root_override"
base_archetype: "root"
policy_assignments_to_add: []
policy_assignments_to_remove: []
policy_definitions_to_add:
  - "Deny-Resource-Types"
policy_definitions_to_remove: []
policy_set_definitions_to_add: []
policy_set_definitions_to_remove: []
role_definitions_to_add: []
role_definitions_to_remove: []
```

{{< hint type=note >}}
Adding a policy definition to an archetype only deploys the definition. To enforce the policy, you must also create and assign a policy assignment. See [Creating an Azure Policy Assignment]({{< relref "createAzurePolicyAssignment" >}}) for details.
{{< /hint >}}

## Best Practices

1. **Use meaningful names**: Policy definition names should clearly indicate their purpose using the format `Action-Resource-Description` (e.g., `Deny-Resource-Types`, `Audit-Storage-Encryption`).

2. **Version your policies**: Include a version number in the metadata to track changes over time.

3. **Include all cloud environments**: Unless your policy is cloud-specific, include all Azure cloud environments in `alzCloudEnvironments`.

4. **Parameterize values**: Make configurable values into parameters rather than hardcoding them in the policy rule.

5. **Provide sensible defaults**: Include default values for parameters where appropriate.

6. **Write clear descriptions**: Both the policy and parameter descriptions should clearly explain the purpose and expected values.

## Additional Resources

- [Azure Landing Zones Library Documentation](https://azure.github.io/Azure-Landing-Zones-Library/)
- [ALZ Library - Policy Definitions](https://github.com/Azure/Azure-Landing-Zones-Library/tree/main/platform/alz/policy_definitions)
- [Azure Policy Definition Structure](https://learn.microsoft.com/en-us/azure/governance/policy/concepts/definition-structure)
- [Azure Policy Effects](https://learn.microsoft.com/en-us/azure/governance/policy/concepts/effects)
