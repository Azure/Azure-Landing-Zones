---
title: Bootstrap Customization FAQ
weight: 10
---

## How do I use my own naming convention for the resources that are deployed?

You can add any hidden variables to your inputs file, including the `resource_names` map. This map is used to set the names of the resources that are deployed. You can find the default values in the `variables.tf` file in the bootstrap module:

* Azure DevOps: [variables.tf](https://github.com/Azure/accelerator-bootstrap-modules/blob/6382aeaa184b9743dfbf13bcb4bad5ad0fcd714a/alz/azuredevops/variables.tf#L258)
* GitHub: [variables.hidden.tf](https://github.com/Azure/accelerator-bootstrap-modules/blob/6382aeaa184b9743dfbf13bcb4bad5ad0fcd714a/alz/github/variables.tf#L215)
* Local: [variables.hidden.tf](https://github.com/Azure/accelerator-bootstrap-modules/blob/6382aeaa184b9743dfbf13bcb4bad5ad0fcd714a/alz/local/variables.tf#L152)

For example adding this to the end of your bootstrap config file and updating to your naming standard:

```yaml
# Extra Inputs
resource_names:
  resource_group_state: "rg-my-custom-name" # Example of an updated resource name
```
