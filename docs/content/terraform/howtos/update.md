---
title: Updating the module and library version
weight: 30
---

The [avm-ptn-alz](https://aka.ms/alz/module) Terraform module, and its associated [provider](https://aka.ms/alz/provider) will be updated from time to time.
Similarly, the policy library will also be updated with new features and bug fixes.
Unlike previously, the module and the policy library are now decoupled, and can be updated independently.

## Updating the policy library

To update the policy library, you must set the [`library_references`](https://registry.terraform.io/providers/Azure/alz/latest/docs#library_references-1) configuration in the provider.
Each provider release will have a default value, which will be the latest version of the ALZ policy library at the time of the release.
To find the default value, you can check the [provider documentation](https://registry.terraform.io/providers/Azure/alz/latest/docs#library_references-1).

To update the policy library, you can set the `library_references` configuration to the desired version:

```hcl
provider "alz" {
  library_references = [
    {
      path = "platform/alz",
      tag  = "2025.01.0"
    }
  ]
}
```

Then run a terraform plan to see the changes that will be applied.

### Local library

If you have a local library, you may have a [`alz_library_metadata.json`](https://azure.github.io/Azure-Landing-Zones-Library/assets/metadata/) file in the root.
If this file contains dependencies, you should update any dependent libraries here.

###  Breaking changes

In line with the library [versioning](https://azure.github.io/Azure-Landing-Zones-Library/versioning/) approach, there may be breaking changes on any year or month change.
Patch releases will not contain breaking changes.
We try to ensure that the changes are apply-able with Terraform, without manual intervention required.

## Updating the module

Over time, the module will be updated with additional features and bug fixes.
If you wish to update the module, you can simply update the version in the module source:

```hcl
module "alz" {
  source = "Azure/avm-prn-alz/azurerm"
  version = "0.10.0"

  # ... other configuration
}
```

Then run a terraform plan to see the changes that will be applied.

{{< hint type="warning" >}}
The module may require an update to the provider.
Ensure that the default value for [`library_references`](https://registry.terraform.io/providers/Azure/alz/latest/docs#library_references-1) hasn't changed and update it if necessary.
{{< /hint >}}
