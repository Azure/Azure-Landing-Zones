---
title: Modifying the Management Group Hierarchy
---

Please make sure you have read and implemented the [using a custom library]({{< relref "customLibrary" >}}) documentation before continuing.

To modify the management group hierarchy you can declare your own [alz_architecture_definition](https://azure.github.io/Azure-Landing-Zones-Library/assets/architectures/) file in your custom library.
This file can be in either YAML or JSON format.

Here is an example architecture definition file in YAML format:

```yaml
name: my custom architecture
management_groups:
  - id: my-mg
    display_name: My Management Group
    archetypes:
      - root
    parent_id: null # this means that the mg will be created at the parent as defined in the module configuration.
    exists: false
  - id: my-mg-child
    display_name: My Management Group Child
    archetypes:
      - landing_zones
    parent_id: my-mg
    exists: false
```

## Renaming Management Groups

To rename a management groups, please copy the default ALZ architecture definition from the [Library](https://github.com/Azure/Azure-Landing-Zones-Library/tree/main/platform/alz/architecture_definitions) into your local library.

Then we recommend that you change the value of the `name` field to something unique, this will help you identify your custom architecture definition.

Then you can rename the management groups as you wish.

Finally, in your ALZ module configuration, you can specify the `architecture_definition` variable to point to your custom architecture definition.

```terraform
module "alz" {
  source  = "Azure/avm-ptn-alz/azurerm"
  version = "~> 0.10"

  architecture_name = "my custom architecture"

  # other variable inputs...
}
```
