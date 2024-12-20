---
title: 2 - Customize Management Group Names and IDs
geekdocCollapseSection: true
weight: 2
---

You may want to customize the management groups names and IDs. In order to do this they need to supply a `lib` folder to the accelerator.

The `lib` folder should contain the following structure (we are showing it nested under the standard accelerator file structure here):

{{< tabs "1" >}}
{{< tab "Windows" >}}
```pwsh
$filePath = "c:\accelerator\config\lib\archetype_definitions\alz.alz_architecture_definition.json"
New-Item -ItemType "file" $filePath -Force
(Invoke-WebRequest https://raw.githubusercontent.com/Azure/Azure-Landing-Zones-Library/refs/heads/main/platform/alz/archetype_definitions/alz.alz_architecture_definition.json).Content | Out-File $filePath -Force
```
{{< /tab >}}
{{< tab "Linux / macOS" >}}
```pwsh
$filePath = "c/accelerator/config/lib/archetype_definitions/alz.alz_architecture_definition.json"
New-Item -ItemType "file" $filePath -Force
(Invoke-WebRequest https://raw.githubusercontent.com/Azure/Azure-Landing-Zones-Library/refs/heads/main/platform/alz/archetype_definitions/alz.alz_architecture_definition.json).Content | Out-File $filePath -Force
```
{{< /tab >}}
{{< /tabs >}}

```plaintext
📂accelerator
┣ 📂config
┃ ┣ 📂lib
┃ ┃ ┗ 📂architecture_definitions
┃ ┃   ┗ 📜alz.alz_architecture_definition.json
┃ ┃ 📜inputs.yaml
┃ ┗ 📜platform-landing-zone.tfvars
┗ 📂output
```
{{< hint type=warning >}}
The `lib` folder must be named `lib`, any other name will not work
{{< /hint >}}

The `alz.alz_architecture_definition.json` file content should have been copied from [here](https://github.com/Azure/Azure-Landing-Zones-Library/blob/main/platform/alz/architecture_definitions/alz.alz_architecture_definition.json).

You can then edit this configuration file to update the management group names and IDs. 

For example to prefix all the management group display names with `Contoso` and update the management group IDs to have the `contoso-` prefix they can update the file to look like this:

{{< include file="/static/examples/tf/accelerator/config/lib/architecture_definitions/alz.alz_architecture_definition.json" language="json" >}}

{{< hint type=tip >}}
When updating the management group `id`, you also need to consider any child management groups that refer to it by the `parent_id`
{{< /hint >}}

If you updated the `connectivity`, `management` or `identity` management group IDs, then you'll also need to update the `management_group_settings` in the `platform-landing-zone.tfvars` file to match.

For example:

{{< highlight terraform "linenos=table" >}}
management_group_settings = {
  ...
  subscription_placement = {
    identity = {
      subscription_id       = "$${subscription_id_identity}"
      management_group_name = "contoso-identity"
    }
    connectivity = {
      subscription_id       = "$${subscription_id_connectivity}"
      management_group_name = "contoso-connectivity"
    }
    management = {
      subscription_id       = "$${subscription_id_management}"
      management_group_name = "contoso-management"
    }
  }
  ...
}
{{< / highlight >}}

Now, when deploying the accelerator you need to supply the lib folder as an argument with `-starterAdditionalFiles`.
