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
New-Item -ItemType "file" c:\accelerator\config\lib\architecture_definitions\alz.alz_architecture_definition.json -Force
```
{{< /tab >}}
{{< tab "Linux / macOS" >}}
```pwsh
New-Item -ItemType "file" /accelerator/config/lib/architecture_definitions/alz.alz_architecture_definition.json -Force 
```
{{< /tab >}}
{{< /tabs >}}

```plaintext
📂accelerator
┣ 📂config
┃ ┣ 📂lib
┃ ┃ ┗ 📂architecture_definitions
┃ ┃   ┗ 📜alz.alz_architecture_definition.json
┃ ┗ 📜inputs.yaml
┗ 📂output
```
{{< hint type=warning >}}
The `lib` folder must be named `lib`, any other name will not work
{{< /hint >}}

The `alz.alz_architecture_definition.json` file content should be copied from [here](https://github.com/Azure/Azure-Landing-Zones-Library/blob/main/platform/alz/architecture_definitions/alz.alz_architecture_definition.json).

You can then edit this configuration file to update the management group names and IDs. 

For example to prefix all the management group display names with `Contoso` and update the management group IDs to have the `contoso-` prefix they can update the file to look like this:

{{< include file="/static/examples/tf/accelerator/config/lib/architecture_definitions/alz.alz_architecture_definition.json" language="json" >}}

{{< hint type=tip >}}
When updating the management group `id`, you also need to consider any child management groups that refer to it by the `parent_id`
{{< /hint >}}

Now, when deploying the accelerator you need to supply the lib folder as an argument with `-starterAdditionalFiles`.
