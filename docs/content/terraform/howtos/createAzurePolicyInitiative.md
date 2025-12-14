---
title: Creating an Azure Policy initiative (policy set)
weight: 10
---

This guide explains how to create Azure Policy initiatives (also known as policy sets) in your Azure Landing Zone deployment. Initiatives allow you to group multiple policy definitions together for easier management and assignment.

{{< hint type=important >}}
You will need to have a [custom library]({{< relref "customLibrary" >}}) if you want to add custom initiatives.
Make sure you have completed that step before continuing.
{{< /hint >}}

## Overview

An initiative (policy set) is a collection of policy definitions grouped together towards a specific goal. Benefits include:

- **Simplified assignment**: Assign multiple policies with a single assignment
- **Easier compliance tracking**: View compliance for related policies as a group
- **Parameter management**: Define parameters once and pass them to multiple policies
- **Versioning**: Update multiple policies by updating the initiative

## Initiative Structure

Initiatives in the ALZ library follow a specific naming convention and structure:

- **Filename**: `<InitiativeName>.alz_policy_set_definition.json` (or `.yaml`)
- **Location**: `lib/policy_set_definitions/` folder in your custom library

### Basic Initiative Template

```json
{
  "name": "My-Initiative-Name",
  "type": "Microsoft.Authorization/policySetDefinitions",
  "properties": {
    "displayName": "My Initiative Display Name",
    "description": "Description of what this initiative does.",
    "policyType": "Custom",
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
      // Initiative-level parameters defined here
    },
    "policyDefinitions": [
      // Policy definitions included in the initiative
    ]
  }
}
```

## Including Policy Definitions

The `policyDefinitions` array contains references to the policies included in your initiative. Each policy reference requires:

| Field | Description |
|-------|-------------|
| `policyDefinitionId` | Resource ID of the policy definition |
| `policyDefinitionReferenceId` | Unique identifier for this reference within the initiative |
| `parameters` | Parameter values to pass to the policy definition |
| `groupNames` | (Optional) Array of group names for organizing policies |

### Referencing Built-in Policies

For built-in policies, use the full Azure resource ID:

```json
{
  "policyDefinitionId": "/providers/Microsoft.Authorization/policyDefinitions/871b6d14-10aa-478d-b590-94f262ecfa99",
  "policyDefinitionReferenceId": "Require-Tag-On-Resources",
  "parameters": {
    "tagName": {
      "value": "Environment"
    }
  }
}
```

{{< hint type=tip >}}
Find built-in policy definition IDs using [AzAdvertizer](https://www.azadvertizer.net/azpolicyadvertizer_all.html) or the Azure Portal.
{{< /hint >}}

### Referencing Custom Policies

For custom policies, use a placeholder management group path. The ALZ provider automatically resolves the correct resource ID:

```json
{
  "policyDefinitionId": "/providers/Microsoft.Management/managementGroups/placeholder/providers/Microsoft.Authorization/policyDefinitions/Deny-Resource-Providers",
  "policyDefinitionReferenceId": "Deny-Unapproved-Resource-Providers",
  "parameters": {
    "effect": {
      "value": "[parameters('effect')]"
    }
  }
}
```

{{< hint type=note >}}
The policy definition name (e.g., `Deny-Resource-Providers`) must match the `name` field in your custom policy definition file.
{{< /hint >}}

### Reusing the Same Policy Multiple Times

You can include the same policy definition multiple times with different parameters. Each reference must have a unique `policyDefinitionReferenceId`:

```json
"policyDefinitions": [
  {
    "policyDefinitionId": "/providers/Microsoft.Authorization/policyDefinitions/871b6d14-10aa-478d-b590-94f262ecfa99",
    "policyDefinitionReferenceId": "Require-Environment-Tag",
    "parameters": {
      "tagName": { "value": "Environment" }
    }
  },
  {
    "policyDefinitionId": "/providers/Microsoft.Authorization/policyDefinitions/871b6d14-10aa-478d-b590-94f262ecfa99",
    "policyDefinitionReferenceId": "Require-Owner-Tag",
    "parameters": {
      "tagName": { "value": "Owner" }
    }
  }
]
```

## Working with Parameters

Initiative parameters allow you to configure policies at assignment time rather than hardcoding values.

### Defining Initiative Parameters

Define parameters at the initiative level in the `parameters` object:

```json
"parameters": {
  "effect": {
    "type": "String",
    "metadata": {
      "displayName": "Effect",
      "description": "Enable or disable the execution of the policies"
    },
    "allowedValues": ["Audit", "Deny", "Disabled"],
    "defaultValue": "Audit"
  },
  "tagName": {
    "type": "String",
    "metadata": {
      "displayName": "Tag Name",
      "description": "The name of the required tag"
    },
    "defaultValue": "Environment"
  }
}
```

### Passing Parameters to Policies

Use the `[parameters('parameterName')]` syntax to pass initiative parameters to policy definitions:

```json
{
  "policyDefinitionId": "/providers/Microsoft.Authorization/policyDefinitions/871b6d14-10aa-478d-b590-94f262ecfa99",
  "policyDefinitionReferenceId": "Require-Tag",
  "parameters": {
    "tagName": {
      "value": "[parameters('tagName')]"
    },
    "effect": {
      "value": "[parameters('effect')]"
    }
  }
}
```

### Handling Recurring Parameters

When multiple policies in your initiative share the same parameter (like `effect`), you have two approaches:

#### Option 1: Single Shared Parameter

Define one parameter that applies to all policies:

```json
"parameters": {
  "effect": {
    "type": "String",
    "defaultValue": "Audit",
    "allowedValues": ["Audit", "Deny", "Disabled"]
  }
},
"policyDefinitions": [
  {
    "policyDefinitionReferenceId": "Policy-A",
    "parameters": { "effect": { "value": "[parameters('effect')]" } }
  },
  {
    "policyDefinitionReferenceId": "Policy-B",
    "parameters": { "effect": { "value": "[parameters('effect')]" } }
  }
]
```

#### Option 2: Individual Parameters per Policy

When you need granular control, define separate parameters for each policy:

```json
"parameters": {
  "policyAEffect": {
    "type": "String",
    "defaultValue": "Audit",
    "allowedValues": ["Audit", "Deny", "Disabled"]
  },
  "policyBEffect": {
    "type": "String",
    "defaultValue": "Deny",
    "allowedValues": ["Audit", "Deny", "Disabled"]
  }
},
"policyDefinitions": [
  {
    "policyDefinitionReferenceId": "Policy-A",
    "parameters": { "effect": { "value": "[parameters('policyAEffect')]" } }
  },
  {
    "policyDefinitionReferenceId": "Policy-B",
    "parameters": { "effect": { "value": "[parameters('policyBEffect')]" } }
  }
]
```

{{< hint type=tip >}}
Use a single shared parameter when policies should be enabled/disabled together. Use individual parameters when you need to control policies independently.
{{< /hint >}}

## Example 1: Built-in Policies Only

This example creates an initiative using only built-in policies to enforce mandatory tags.

Create `Enforce-Mandatory-Tags.alz_policy_set_definition.json`:

```json
{
  "name": "Enforce-Mandatory-Tags",
  "type": "Microsoft.Authorization/policySetDefinitions",
  "properties": {
    "displayName": "Enforce mandatory tags on resources",
    "description": "This initiative enforces mandatory tags on all resources to ensure proper governance and cost management.",
    "policyType": "Custom",
    "metadata": {
      "version": "1.0.0",
      "category": "Tags",
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
        "allowedValues": ["Audit", "Deny", "Disabled"],
        "defaultValue": "Audit"
      },
      "environmentTagName": {
        "type": "String",
        "metadata": {
          "displayName": "Environment Tag Name",
          "description": "Name of the environment tag"
        },
        "defaultValue": "Environment"
      },
      "ownerTagName": {
        "type": "String",
        "metadata": {
          "displayName": "Owner Tag Name",
          "description": "Name of the owner tag"
        },
        "defaultValue": "Owner"
      },
      "costCenterTagName": {
        "type": "String",
        "metadata": {
          "displayName": "Cost Center Tag Name",
          "description": "Name of the cost center tag"
        },
        "defaultValue": "CostCenter"
      }
    },
    "policyDefinitions": [
      {
        "policyDefinitionId": "/providers/Microsoft.Authorization/policyDefinitions/871b6d14-10aa-478d-b590-94f262ecfa99",
        "policyDefinitionReferenceId": "Require-Environment-Tag",
        "parameters": {
          "tagName": {
            "value": "[parameters('environmentTagName')]"
          },
          "effect": {
            "value": "[parameters('effect')]"
          }
        }
      },
      {
        "policyDefinitionId": "/providers/Microsoft.Authorization/policyDefinitions/871b6d14-10aa-478d-b590-94f262ecfa99",
        "policyDefinitionReferenceId": "Require-Owner-Tag",
        "parameters": {
          "tagName": {
            "value": "[parameters('ownerTagName')]"
          },
          "effect": {
            "value": "[parameters('effect')]"
          }
        }
      },
      {
        "policyDefinitionId": "/providers/Microsoft.Authorization/policyDefinitions/871b6d14-10aa-478d-b590-94f262ecfa99",
        "policyDefinitionReferenceId": "Require-CostCenter-Tag",
        "parameters": {
          "tagName": {
            "value": "[parameters('costCenterTagName')]"
          },
          "effect": {
            "value": "[parameters('effect')]"
          }
        }
      }
    ]
  }
}
```

## Example 2: Custom Policies Only

This example creates an initiative using the custom `Deny-Resource-Providers` policy from [Creating a Custom Azure Policy Definition]({{< relref "createCustomAzurePolicy" >}}).

First, ensure you have created `Deny-Resource-Providers.alz_policy_definition.json` in your `lib/policy_definitions/` folder.

Create `Enforce-Resource-Restrictions.alz_policy_set_definition.json`:

```json
{
  "name": "Enforce-Resource-Restrictions",
  "type": "Microsoft.Authorization/policySetDefinitions",
  "properties": {
    "displayName": "Enforce resource restrictions",
    "description": "This initiative enforces resource restrictions including approved resource providers.",
    "policyType": "Custom",
    "metadata": {
      "version": "1.0.0",
      "category": "Governance",
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
          "description": "Enable or disable the execution of the policies"
        },
        "allowedValues": ["Audit", "Deny", "Disabled"],
        "defaultValue": "Deny"
      },
      "allowedResourceProviders": {
        "type": "Array",
        "metadata": {
          "displayName": "Allowed Resource Providers",
          "description": "The list of resource providers that are allowed to be registered"
        },
        "defaultValue": [
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
    "policyDefinitions": [
      {
        "policyDefinitionId": "/providers/Microsoft.Management/managementGroups/placeholder/providers/Microsoft.Authorization/policyDefinitions/Deny-Resource-Providers",
        "policyDefinitionReferenceId": "Deny-Unapproved-Resource-Providers",
        "parameters": {
          "effect": {
            "value": "[parameters('effect')]"
          },
          "allowedResourceProviders": {
            "value": "[parameters('allowedResourceProviders')]"
          }
        }
      }
    ]
  }
}
```

{{< hint type=important >}}
When your initiative includes custom policies, you must add both the policy definition and the initiative to your archetype. The policy definition should be added via `policy_definitions_to_add` and the initiative via `policy_set_definitions_to_add`.
{{< /hint >}}

## Example 3: Combined Initiative (Built-in + Custom)

This example demonstrates how to combine the tagging policies and resource restriction policies into a single comprehensive governance initiative. This approach promotes modularity and reusability by consolidating related governance controls.

Create `Enforce-Governance-Standards.alz_policy_set_definition.json`:

```json
{
  "name": "Enforce-Governance-Standards",
  "type": "Microsoft.Authorization/policySetDefinitions",
  "properties": {
    "displayName": "Enforce governance standards",
    "description": "This initiative combines tagging requirements and resource restrictions into a comprehensive governance policy set.",
    "policyType": "Custom",
    "metadata": {
      "version": "1.0.0",
      "category": "Governance",
      "source": "https://github.com/Azure/Enterprise-Scale/",
      "alzCloudEnvironments": [
        "AzureCloud",
        "AzureChinaCloud",
        "AzureUSGovernment"
      ]
    },
    "parameters": {
      "taggingEffect": {
        "type": "String",
        "metadata": {
          "displayName": "Tagging Effect",
          "description": "Effect for tagging policies"
        },
        "allowedValues": ["Audit", "Deny", "Disabled"],
        "defaultValue": "Audit"
      },
      "resourceRestrictionEffect": {
        "type": "String",
        "metadata": {
          "displayName": "Resource Restriction Effect",
          "description": "Effect for resource restriction policies"
        },
        "allowedValues": ["Audit", "Deny", "Disabled"],
        "defaultValue": "Deny"
      },
      "environmentTagName": {
        "type": "String",
        "metadata": {
          "displayName": "Environment Tag Name",
          "description": "Name of the environment tag"
        },
        "defaultValue": "Environment"
      },
      "ownerTagName": {
        "type": "String",
        "metadata": {
          "displayName": "Owner Tag Name",
          "description": "Name of the owner tag"
        },
        "defaultValue": "Owner"
      },
      "costCenterTagName": {
        "type": "String",
        "metadata": {
          "displayName": "Cost Center Tag Name",
          "description": "Name of the cost center tag"
        },
        "defaultValue": "CostCenter"
      },
      "allowedResourceProviders": {
        "type": "Array",
        "metadata": {
          "displayName": "Allowed Resource Providers",
          "description": "The list of resource providers that are allowed to be registered"
        },
        "defaultValue": [
          "Microsoft.Compute",
          "Microsoft.Storage",
          "Microsoft.Network",
          "Microsoft.KeyVault",
          "Microsoft.ManagedIdentity",
          "Microsoft.Authorization",
          "Microsoft.Resources"
        ]
      },
      "allowedLocations": {
        "type": "Array",
        "metadata": {
          "displayName": "Allowed Locations",
          "description": "The list of locations that resources can be deployed to"
        },
        "defaultValue": [
          "eastus",
          "eastus2",
          "westus2",
          "westeurope",
          "northeurope"
        ]
      }
    },
    "policyDefinitionGroups": [
      {
        "name": "Tagging",
        "displayName": "Tagging Policies",
        "description": "Policies related to resource tagging requirements"
      },
      {
        "name": "ResourceRestrictions",
        "displayName": "Resource Restriction Policies",
        "description": "Policies that restrict resource deployments"
      }
    ],
    "policyDefinitions": [
      {
        "policyDefinitionId": "/providers/Microsoft.Authorization/policyDefinitions/871b6d14-10aa-478d-b590-94f262ecfa99",
        "policyDefinitionReferenceId": "Require-Environment-Tag",
        "groupNames": ["Tagging"],
        "parameters": {
          "tagName": {
            "value": "[parameters('environmentTagName')]"
          },
          "effect": {
            "value": "[parameters('taggingEffect')]"
          }
        }
      },
      {
        "policyDefinitionId": "/providers/Microsoft.Authorization/policyDefinitions/871b6d14-10aa-478d-b590-94f262ecfa99",
        "policyDefinitionReferenceId": "Require-Owner-Tag",
        "groupNames": ["Tagging"],
        "parameters": {
          "tagName": {
            "value": "[parameters('ownerTagName')]"
          },
          "effect": {
            "value": "[parameters('taggingEffect')]"
          }
        }
      },
      {
        "policyDefinitionId": "/providers/Microsoft.Authorization/policyDefinitions/871b6d14-10aa-478d-b590-94f262ecfa99",
        "policyDefinitionReferenceId": "Require-CostCenter-Tag",
        "groupNames": ["Tagging"],
        "parameters": {
          "tagName": {
            "value": "[parameters('costCenterTagName')]"
          },
          "effect": {
            "value": "[parameters('taggingEffect')]"
          }
        }
      },
      {
        "policyDefinitionId": "/providers/Microsoft.Management/managementGroups/placeholder/providers/Microsoft.Authorization/policyDefinitions/Deny-Resource-Providers",
        "policyDefinitionReferenceId": "Deny-Unapproved-Resource-Providers",
        "groupNames": ["ResourceRestrictions"],
        "parameters": {
          "effect": {
            "value": "[parameters('resourceRestrictionEffect')]"
          },
          "allowedResourceProviders": {
            "value": "[parameters('allowedResourceProviders')]"
          }
        }
      },
      {
        "policyDefinitionId": "/providers/Microsoft.Authorization/policyDefinitions/e56962a6-4747-49cd-b67b-bf8b01975c4c",
        "policyDefinitionReferenceId": "Allowed-Locations",
        "groupNames": ["ResourceRestrictions"],
        "parameters": {
          "listOfAllowedLocations": {
            "value": "[parameters('allowedLocations')]"
          }
        }
      }
    ]
  }
}
```

### Key Features of the Combined Initiative

1. **Policy Groups**: The `policyDefinitionGroups` field organizes policies into logical categories (Tagging, ResourceRestrictions). This improves compliance reporting and makes the initiative easier to understand.

2. **Separate Effect Parameters**: Using `taggingEffect` and `resourceRestrictionEffect` allows you to set different enforcement levels for each category. For example, start with `Audit` for tagging while enforcing `Deny` for resource restrictions.

3. **Mixed Policy Sources**: The initiative includes:
   - Built-in policy `871b6d14-10aa-478d-b590-94f262ecfa99` (Require a tag on resources)
   - Built-in policy `e56962a6-4747-49cd-b67b-bf8b01975c4c` (Allowed locations)
   - Custom policy `Deny-Resource-Providers`

## Designing Modular Initiatives

When building initiatives, consider these patterns for reusability:

### Pattern 1: Single-Purpose Initiatives

Create focused initiatives for specific compliance areas:

```text
lib/policy_set_definitions/
├── Enforce-Tagging-Standards.alz_policy_set_definition.json
├── Enforce-Network-Security.alz_policy_set_definition.json
├── Enforce-Data-Protection.alz_policy_set_definition.json
└── Enforce-Identity-Security.alz_policy_set_definition.json
```

**Benefits**:
- Assign only what's needed to each management group
- Easier to troubleshoot compliance issues
- Independent versioning and updates

### Pattern 2: Layered Initiatives

Create a base initiative and extend it for specific scenarios:

```text
lib/policy_set_definitions/
├── Governance-Baseline.alz_policy_set_definition.json       # Core policies for all workloads
├── Governance-Production.alz_policy_set_definition.json     # Baseline + stricter controls
└── Governance-Development.alz_policy_set_definition.json    # Baseline + relaxed controls
```

{{< hint type=tip >}}
When deciding between separate initiatives or a combined initiative:
- **Separate initiatives**: Better when different management groups need different policy combinations
- **Combined initiatives**: Better when policies should always be deployed together and you want simplified assignment management
{{< /hint >}}

## Adding the Initiative to Your Library

After creating the initiative file, add it to an archetype using an override file.

Create or update `root_override.alz_archetype_override.yaml` in your `lib/archetype_definitions/` folder:

```yaml
name: "root_override"
base_archetype: "root"
policy_assignments_to_add: []
policy_assignments_to_remove: []
policy_definitions_to_add:
  - "Deny-Resource-Providers"
policy_definitions_to_remove: []
policy_set_definitions_to_add:
  - "Enforce-Governance-Standards"
policy_set_definitions_to_remove: []
role_definitions_to_add: []
role_definitions_to_remove: []
```

{{< hint type=note >}}
Adding an initiative to an archetype only deploys the initiative definition. To enforce it, you must also create and assign a policy assignment. See [Creating an Azure Policy Assignment]({{< relref "createAzurePolicyAssignment" >}}) for details on assigning initiatives.
{{< /hint >}}

## Complete Library Structure

After creating initiatives, your library structure should look like this:

```text
lib/
├── alz_library_metadata.json
├── architecture_definitions/
│   └── alz.alz_architecture_definition.yaml
├── archetype_definitions/
│   └── root_override.alz_archetype_override.yaml
├── policy_assignments/
│   └── Enforce-Governance-Standards.alz_policy_assignment.json
├── policy_definitions/
│   └── Deny-Resource-Providers.alz_policy_definition.json
└── policy_set_definitions/
    └── Enforce-Governance-Standards.alz_policy_set_definition.json
```

## Additional Resources

- [Azure Landing Zones Library Documentation](https://azure.github.io/Azure-Landing-Zones-Library/)
- [ALZ Library - Policy Set Definitions](https://github.com/Azure/Azure-Landing-Zones-Library/tree/main/platform/alz/policy_set_definitions)
- [Azure Policy Initiative Structure](https://learn.microsoft.com/en-us/azure/governance/policy/concepts/initiative-definition-structure)
- [AzAdvertizer - Initiative Index](https://www.azadvertizer.net/azpolicyinitiativesadvertizer_all.html)
