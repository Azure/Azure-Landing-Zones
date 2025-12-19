---
title: Creating an Azure Policy Assignment
weight: 10
---

This guide walks you through creating Azure Policy assignments in your Azure Landing Zone (ALZ) deployment.

## What You Can Assign

| Type | Description | Example Use Case |
|------|-------------|------------------|
| **Built-in policies** | Pre-defined policies provided by Microsoft | Require tags, enforce allowed locations |
| **Custom policies** | Policies you create for specific requirements | Deny certain resource types |
| **Built-in initiatives** | Microsoft-provided collections of related policies | CIS benchmarks, Azure Security Baseline |
| **Custom initiatives** | Your own policy collections | Your own grouping of related policies|

{{< hint type=important >}}
**Before you begin:** You must have a [custom library]({{< relref "customLibrary" >}}) configured before adding policy assignments.
{{< /hint >}}

---

## Quick Start Checklist

Follow these steps to create a policy assignment:

| Step | Action | Details |
|:----:|--------|---------|
| 1️⃣ | **Create assignment file** | Add a `.alz_policy_assignment.json` file to your library |
| 2️⃣ | **Create archetype override** | Include the assignment in an archetype |
| 3️⃣ | **Update architecture definition** | Reference the override archetype |

---

## File Naming and Location

For Policy Assignments to be discovered by the ALZ provider, follow the following:

| Component | Requirement |
|-----------|-------------|
| **File extension** | `*.alz_policy_assignment.json` (or `.yaml`) |
| **Location** | `lib/policy_assignments/` folder in your custom library |

{{< hint type=note >}}
So it's easier to manage your custom library, try to keep the file name related to the name of the assignment. 

💡 **Example:** An assignment named `Require-Tag-Environment` should be in a file called `Require-Tag-Environment.alz_policy_assignment.json`
{{< /hint >}}

---

## Assigning a Built-in Policy

Built-in policies are provided by Microsoft and available at all scopes -- no policy definition file is needed, only an assignment file.

{{< hint type=important >}}
**Check policy parameters first!** Some policies have **fixed effects** (e.g., always Deny) and don't accept an `effect` parameter. Others require specific parameters. Always verify before creating assignments.
{{< /hint >}}

### Step-by-Step: Require a Tag on Resources

This example assigns the built-in policy `871b6d14-10aa-478d-b590-94f262ecfa99` (Require a tag on resources).

{{< hint type=tip >}}
**How to find policy IDs:** Use [AzAdvertizer](https://www.azadvertizer.net/azpolicyadvertizer_all.html) or the Azure Portal to look up `policyDefinitionId` values for built-in policies.
{{< /hint >}}

**1. Create the assignment file**

Create `Require-Tag-Environment.alz_policy_assignment.json` in your `lib/policy_assignments/` folder:

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

## Assigning a Custom Policy

For custom policies, you must first create the policy definition (see [Creating a Custom Azure Policy Definition]({{< relref "createCustomAzurePolicy" >}})), then create an assignment that references it.

{{< hint type=important >}}
**Custom policy resource ID format:**

For custom policies, use a placeholder management group in the `policyDefinitionId`:

```text
/providers/Microsoft.Management/managementGroups/placeholder/providers/Microsoft.Authorization/policyDefinitions/<PolicyName>
```

The ALZ provider automatically resolves the correct resource ID for each management group. This is done based on which archetype the management group references, and what policy assignments are referenced in that archetype.
{{< /hint >}}

### Step-by-Step: Deny Specific Resource Types

This example creates an assignment that prevents deployment of specific resource types (like classic compute resources).

**1. Create the assignment file**

Create `Deny-Resource-Types.alz_policy_assignment.json` in your `lib/policy_assignments/` folder:

```json
{
  "type": "Microsoft.Authorization/policyAssignments",
  "apiVersion": "2024-04-01",
  "name": "Deny-Resource-Types",
  "dependsOn": [],
  "properties": {
    "displayName": "Deny specific resource types",
    "description": "This policy restricts which resource types can be deployed, ensuring only approved Azure services are available.",
    "policyDefinitionId": "/providers/Microsoft.Management/managementGroups/placeholder/providers/Microsoft.Authorization/policyDefinitions/Deny-Resource-Types",
    "enforcementMode": "Default",
    "nonComplianceMessages": [
      {
        "message": "This resource type is not allowed. Only approved resource types can be deployed."
      }
    ],
    "parameters": {
      "effect": {
        "value": "Deny"
      },
      "deniedResourceTypes": {
        "value": [
          "Microsoft.ClassicCompute/virtualMachines",
          "Microsoft.ClassicStorage/storageAccounts",
          "Microsoft.ClassicNetwork/virtualNetworks"
        ]
      }
    },
    "scope": "/providers/Microsoft.Management/managementGroups/placeholder",
    "notScopes": []
  },
  "location": "${default_location}"
}
```

## Assigning a Built-in Initiative

Initiatives (also called policy sets) group multiple related policies together. Assigning them works the same as individual policies.

### Step-by-Step: Allowed Locations

This example restricts which Azure regions resources can be deployed to using Microsoft's built-in "Allowed locations" initiative.

**1. Create the assignment file**

Create `Allowed-Locations.alz_policy_assignment.json` in your `lib/policy_assignments/` folder:

{{< hint type=note >}}
For initiatives, use `policySetDefinitions` instead of `policyDefinitions` in the `policyDefinitionId` resource ID.
{{< /hint >}}

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

## Assigning a Custom Initiative

For custom initiatives, first create the initiative definition (see [Creating an Azure Policy Initiative]({{< relref "createAzurePolicyInitiative" >}})), then create an assignment.

### Step-by-Step: Enforce Mandatory Tags

This example assigns a custom initiative that enforces multiple mandatory tags on resources.

**1. Create the assignment file**

Create `Enforce-Mandatory-Tags.alz_policy_assignment.json` in your `lib/policy_assignments/` folder:

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

---

## Policy Assignment Schema Reference

Use this table as a quick reference when building your assignment files:

| Field | Required | Description |
|-------|:--------:|-------------|
| `name` | ✅ | Unique identifier. ALZ provider uses this for indexing |
| `type` | ✅ | Always `Microsoft.Authorization/policyAssignments` |
| `apiVersion` | ✅ | API version, typically `2024-04-01` |
| `properties.displayName` | ✅ | Human-readable name shown in Azure Portal |
| `properties.description` | ✅ | Detailed description of the assignment's purpose |
| `properties.policyDefinitionId` | ✅ | Resource ID of the policy/initiative to assign |
| `properties.enforcementMode` | ⚪ | `Default` (enforced) or `DoNotEnforce` (audit only). See [`policy_assignments_to_modify`]({{< relref "modifyingPolicyAssignments" >}}) |
| `properties.nonComplianceMessages` | ⚪ | Messages shown when resources are non-compliant. See [`policy_assignments_to_modify`]({{< relref "modifyingPolicyAssignments" >}}) |
| `properties.parameters` | ⚪ | Parameter values for the policy. See [`policy_assignments_to_modify`]({{< relref "modifyingPolicyAssignments" >}}) |
| `properties.scope` | ✅ | Use `/providers/Microsoft.Management/managementGroups/placeholder` |
| `properties.notScopes` | ⚪ | Array of scopes to exclude from the assignment |
| `location` | ✅ | Use `${default_location}` for deployment location |

## Best Practices

Follow these recommendations for successful policy assignments:

### 🎯 Deployment Strategy

| Practice | Why It Matters |
|----------|----------------|
| **Start with `DoNotEnforce`** | Audit the impact of new deny policies before enforcing them |
| **Test** | Validate assignments before applying to production management groups |

### 📝 Configuration Tips

| Practice | Why It Matters |
|----------|----------------|
| **Use clear non-compliance messages** | Help users understand what they need to fix |
| **Use `notScopes` sparingly** | Exclusions should be exceptions. Document why they're needed |

## Additional Resources

### Official Documentation

- [Azure Landing Zones Library](https://azure.github.io/Azure-Landing-Zones-Library/) – Complete ALZ library documentation
- [ALZ Policy Assignments](https://github.com/Azure/Azure-Landing-Zones-Library/tree/main/platform/alz/policy_assignments) – Example policy assignments in the ALZ library
- [Azure Policy Assignment Structure](https://learn.microsoft.com/en-us/azure/governance/policy/concepts/assignment-structure) – Microsoft's official assignment schema documentation

### Policy Discovery Tools

- [AzAdvertizer - Policies](https://www.azadvertizer.net/azpolicyadvertizer_all.html) – Browse all Azure built-in policies
- [AzAdvertizer - Initiatives](https://www.azadvertizer.net/azpolicyinitiativesadvertizer_all.html) – Browse all Azure built-in initiatives

### Related Guides

- [Creating a Custom Azure Policy Definition]({{< relref "createCustomAzurePolicy" >}}) – Before assigning custom policies
- [Creating an Azure Policy Initiative]({{< relref "createAzurePolicyInitiative" >}}) – Before assigning custom initiatives
- [Modifying Policy Assignments]({{< relref "modifyingPolicyAssignments" >}}) – To customize parameters and enforcement
