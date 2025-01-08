---
title: Modifying Policy Assignments
weight: 10
---

To modify a policy assignment, use the [`policy_assignments_to_modify`](https://github.com/Azure/terraform-azurerm-avm-ptn-alz?tab=readme-ov-file#-policy_assignments_to_modify) variable.
Please familiarize yourself with the variable documentation section before continuing.

This input is a map of maps.
The first key is the management group name as defined in the architecture definition file, and the second key is the policy assignment name.

The value then contains the items you can modify, refer to the module documentation for the full list.
You only need to specify the values you want to modify, you can leave the others out.

{{< hint type=important >}}
When supplying a value for `parameters`, you must use `jsonencode({Value = "foo"})` to convert the value to a JSON string. This is to avoid issues with the Terraform type system.
{{< /hint >}}

e.g. to modify a policy assignment called `my-assignment` at the `corp` management group:

```terraform
module "alz" {
  source  = "Azure/avm-ptn-alz/azurerm"
  version = "~> 0.10"

  # other variable inputs...

  policy_assignments_to_modify = {
    corp = {
      my-assignment = {
        # Disable a policy assignment by changing the enforcement mode...
        enforcement_mode = "DoNotEnforce"

        non_compliance_message = [{
          message = "This is a non-compliance message"
        }]

        # Modifying a policy parameter...
        parameters = {
          effect = jsonencode({Value = "Audit"})
        }

        # How to use resource selectors
        resource_selectors = [{
          name = "franceonly"
          kind = "resourceLocation"
          selectors = [{
            in = ["francecentral"]
          }]
        }]
      }
    }
  }
}
```

{{< hint type=warning >}}
Due to constraints in Terraform, you should not supply computed valued as inputs into the module.
Instead use string interpolation to supply the values from the original inputs and use `var.dependencies` to ensure that resources are only created after the dependencies are created.
See the [module documentation](https://github.com/Azure/terraform-azurerm-avm-ptn-alz?tab=readme-ov-file#unknown-values--depends-on).
{{< /hint >}}
