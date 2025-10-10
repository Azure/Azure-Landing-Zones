---
title: Using a custom library
weight: 7
---

You will need a custom library if you want to do any of the following:

- [Modify the management group hierarchy]({{< relref "modifyingMgHierarchy" >}}) (including naming)
- [Adding or removing policy assignments]({{< relref "modifyingPolicyAssets" >}})
- [Adding or removing policy or policy set definitions]({{< relref "modifyingPolicyAssets" >}})

We recommend reviewing the [ALZ Library](https://azure.github.io/Azure-Landing-Zones-Library/) documentation before continuing.

Typically this is achieved by creating a directory in your repo, idiomatically called `lib`.
If you don't want to use a filesystem, you may use a git reference, or any other reference supported by [go-getter](https://github.com/hashicorp/go-getter), however filesystem references are typical.

You can then use one of two approaches to tell the provider to use your custom library:

{{< hint type=tip >}}
The ALZ provider has a default value for the `library_references` attribute, which is the official Azure Landing Zones library.
Each release of the provider may update this value to a newer version.
The value is documented [here](https://registry.terraform.io/providers/Azure/alz/latest/docs#library_references-1).
{{< /hint >}}

## Method one - Using library references

This method is the simplest approach and is recommended for cases where the custom library is not shared with other projects.

Please be sure to read the [provider documentation](https://registry.terraform.io/providers/Azure/alz/latest/docs#nestedatt--library_references).

In this method you add your new custom library to the end of the library_references list in the `alz` provider block:

```terraform
provider "alz" {
  library_references = [
    {
      path = "platform/alz"
      ref  = "2024.11.0"
    },
    {
      custom_url = "${path.root}/lib"
    }
  ]
}
```

{{< hint type=note >}}
The library references are processed in order, so make sure to add your custom library at the end if there are dependencies.
{{< /hint >}}

## Method two - Using a library metadata file

In this scenario you create a file called `alz_library_metadata.json` in your custom library directory.
This can be beneficial if you want to share your custom library with other projects, or if you want to use the `alzlibtool` to generate documentation for your custom library.

Please be sure to read the Library [documentation on metadata files](https://azure.github.io/Azure-Landing-Zones-Library/assets/metadata/) before continuing.

In this method you only specify your custom library in the `alz` provider block and let the metadata file handle any dependencies:

First create the metadata file `alz_library_metadata.json` in your custom library directory:

```json
{
  "$schema": "https://raw.githubusercontent.com/Azure/Azure-Landing-Zones-Library/main/schemas/library_metadata.json",
  "name": "custom",
  "display_name": "My custom library",
  "description": "This library contains customizations to Azure Landing Zones.",
  "dependencies": [
    {
      "path": "platform/alz",
      "ref": "2024.11.0"
    }
  ]
}
```

Then change your provider configuration to the below, the provider will read the metadata file and automatically download the dependencies:

```terraform
provider "alz" {
  library_references = [
    {
      custom_url = "${path.root}/lib"
    }
  ]
}
```

## Replacing existing library assets

Everything in the combined library must be uniquely named.
If you want to replace something in the existing library with your own version, you can do so by creating an asset with the same name in your custom library and setting the following provider configuration:

```terraform
provider "alz" {
  library_overwrite_enabled = true
}
```

See the [provider docs](https://registry.terraform.io/providers/Azure/alz/latest/docs#library_overwrite_enabled-1) for more information.
