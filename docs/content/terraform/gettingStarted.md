---
title: Getting started
weight: 10
---

## Add `.alzlib` to your gitignore

The Azure Landing Zones provider uses a local cache to store the library references.
This cache is stored in a directory called `.alzlib` in your working directory.
You should add this directory to your gitignore file to prevent it from being committed to your repository.

{{< tabs "set environment" >}}
{{< tab "Bash" >}}

```bash
echo ".alzlib" >> .gitignore
```

{{< /tab >}}
{{< tab "PowerShell" >}}

```pwsh
Add-Content -Path .gitignore -Value ".alzlib"
```

{{< /tab >}}
{{< /tabs >}}

## Decide if you need a custom library

If you want to do any of the following, you will need a custom library:

- [Modify the management group hierarchy]({{< relref "modifyingMgHierarchy" >}}) (including re-naming management groups)
- [Modifying policy assets (archetypes)]({{< relref "modifyingPolicyAssets" >}})

Please follow the [custom library]({{< relref "customLibrary" >}}) guide if you need to create a custom library.

## Supply Policy Assignment Default Values

The input variable [`policy_default_values`](https://github.com/Azure/terraform-azurerm-avm-ptn-alz?tab=readme-ov-file#input_policy_default_values) is used to supply the same input values to multiple policy assignment parameters.

The available default values are documented in the Library, e.g. [ALZ policy default values](https://github.com/Azure/Azure-Landing-Zones-Library/tree/main/platform/alz#policy-default-values).

For each default, consider if you want to supply a value.

{{< hint type=important >}}
When supplying a value for `parameters`, you must use `jsonencode({Value = "foo"})` to convert the value to a JSON string. This is to avoid issues with the Terraform type system.
{{< /hint >}}

E.g. to supply a default log analytics workspace id:

```terraform
locals {
  subscription_id            = data.azapi_client_config.current.subscription_id
  resource_group_name        = "my-log-analytics-rg"
  resource_type              = "Microsoft.OperationalInsights/workspaces"
  resource_names             = ["my-log-analytics-workspace"]
  log_analytics_workspace_id = provider::azapi::resource_group_resource_id(
    local.subscription_id,
    local.resource_group_name,
    local.resource_type,
    local.resource_names
  )
}

module "alz" {
  source  = "Azure/avm-ptn-alz/azurerm"
  version = "~> 0.10"

  # other variable inputs...

  policy_default_values = {
    log_analytics_workspace_id = jsonencode({ Value = local.log_analytics_workspace_id })
  }
}
```

{{< hint type=warning >}}
Due to constraints in Terraform, you should not supply computed valued as inputs into the module.
Instead use string interpolation to supply the values from the original inputs and use `var.dependencies` to ensure that resources are only created after the dependencies are created.
See the [module documentation](https://github.com/Azure/terraform-azurerm-avm-ptn-alz?tab=readme-ov-file#unknown-values--depends-on).
{{< /hint >}}

## Add Dependencies

Once you have supplied the default values, you can add dependencies to the module.
This is a workaround for the issue where we cannot specify computed values as inputs to the module.

The [`dependencies`](https://github.com/Azure/terraform-azurerm-avm-ptn-alz/tree/7259da7ffa9e88c35bf56f960ff0a71d5ccbc93b?tab=readme-ov-file#input_dependencies) variable is used to ensure that resources get created in the correct order.

E.g. to ensure that the log analytics workspace is created before the role assignments for policy:

```terraform
# We use the ALZ Management module to create the log analytics workspace
module "alz_management" {
  source  = "Azure/avm-ptn-alz-management/azurerm"
  version = "~> 0.5"

  # other variable inputs...
}

# We cannot add a depends_on to the ALZ module, so we use the dependencies variable instead.
module "alz" {
  source  = "Azure/avm-ptn-alz/azurerm"
  version = "~> 0.10"

  # other variable inputs (including the policy_default_values)...

  dependencies = {
    policy_role_assignments = [
      module.alz_management.resource_id
    ]
  }
}
```

## Review Policy Assignments

We recommend that you review the following policy assignments before deploying the module.
If you do not use certain features, you should disable the policy assignments.

To do this, please use the [`policy_assienments_to_modify`]({{< relref "howtos/modifyingPolicyAssignments" >}}) variable to disable the policy assignments:

e.g.

```terraform
module "alz" {
  source  = "Azure/avm-ptn-alz/azurerm"
  version = "~> 0.10"

  # other variable inputs...

  policy_assignments_to_modify = {
    management_group_id = {
      "Policy-Assignment-Name" = {
        enforcement_mode = "DoNotEnforce"
      }
    }
  }
}
```

### DDoS Protection

Azure Landing Zones has a policy assignment called `Enable-DDoS-VNET` that enables DDoS protection on all in-scope virtual networks.
It is assigned at the `platform` management group.

If you do not have a DDoS protection plan, you should disable this policy assignment.

### Private DNS Zones for Private Endpoints

If you do not use this feature in your environment, you should disable the policy assignment called `Deploy-Private-DNS-Zones` that is assigned at the `corp` management group.

### Azure Monitor Agent

If you use a third party monitoring solution, you should disable the following policy assignments at the `landing_zones` management group:

- `Deploy-VM-Monitoring`
- `Deploy-VMSS-Monitoring`
- `Deploy-VM-ChangeTrack`
- `Deploy-VMSS-ChangeTrack`
- `Deploy-MDFC-DefSQL-AMA`

## Additional Role Assignments

The Azure Landing Zones provider will correctly calculate the role assignments required for the policy assignments.
This includes supporting resources that require role assignments outside of the assignment scope.

We do this by looking at the [`assignPermissions`](https://learn.microsoft.com/azure/governance/policy/concepts/definition-structure-parameters?branch=main&branchFallbackFrom=pr-en-us-292127#parameter-properties) metadata property in the policy definition parameters.
This flag indicates that a role assignment is required for the resource id passed into a parameter, as well as at the policy assignment scope.

Every policy that has this property will have a role assignment created for the policy assignment scope as well as at the scope of the resource id passed into a parameter that contains the `assignPermissions` metadata value of `true`.

This approach has the following advantages:

1. Ensuring that role assignments are created at the most specific scope possible
1. Ensuring that role assignments are created for all resources that require them
1. Allowing these role assignments to be removed when the resource or the policy assignment is removed

However, there are some policies that do not have the `assignPermissions` metadata property set when it should be.
This causes the policy to not have the correct role assignments created.
In this case we must make manual role assignments, and we have listed these below:

> TODO: Add a list of policies that require manual role assignments
