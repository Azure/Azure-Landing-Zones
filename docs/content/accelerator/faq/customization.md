---
title: Bootstrap Customization FAQ
weight: 10
---

## How do I use my own naming convention for the resources that are deployed?

You can add any hidden variables to your inputs file, including the `resource_names` map. This map is used to set the names of the resources that are deployed. You can find the default values in the `variables.tf` file in the bootstrap module:

* Azure DevOps: [variables.tf](https://github.com/Azure/accelerator-bootstrap-modules/blob/main/alz/azuredevops/variables.tf)
* GitHub: [variables.tf](https://github.com/Azure/accelerator-bootstrap-modules/blob/main/alz/github/variables.tf)
* Local: [variables.tf](https://github.com/Azure/accelerator-bootstrap-modules/blob/main/alz/local/variables.tf)

For example adding this to the end of your bootstrap config file and updating to your naming standard:

```yaml
# Extra Inputs
resource_names:
  resource_group_state: "rg-my-custom-name" # Example of an updated resource name
```
