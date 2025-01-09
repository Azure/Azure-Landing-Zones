---
title: 2 - Customize Management Group Names and IDs
geekdocCollapseSection: true
weight: 2
---

You may want to customize the management groups names and IDs. In order to do this they need to supply a `lib` folder to the accelerator.

The `lib` folder should contain the following structure (we are showing it nested under the standard accelerator file structure here):

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

Follow these steps to customise the management group names and IDs:

1. Run the following script to create the `lib` folder and the `alz.alz_architecture_definition.json` under the standard accelerator file structure:

    {{< tabs "1" >}}
    {{< tab "Windows" >}}
```pwsh
$filePath = "c:\accelerator\config\lib\archetype_definitions\alz.alz_architecture_definition.json"
New-Item -ItemType "file" $filePath -Force
(Invoke-WebRequest "https://raw.githubusercontent.com/Azure/Azure-Landing-Zones-Library/refs/heads/main/platform/alz/archetype_definitions/alz.alz_architecture_definition.json").Content | Out-File $filePath -Force
```
    {{< /tab >}}
    {{< tab "Linux / macOS" >}}
```pwsh
$filePath = "/accelerator/config/lib/archetype_definitions/alz.alz_architecture_definition.json"
New-Item -ItemType "file" $filePath -Force
(Invoke-WebRequest "https://raw.githubusercontent.com/Azure/Azure-Landing-Zones-Library/refs/heads/main/platform/alz/archetype_definitions/alz.alz_architecture_definition.json").Content | Out-File $filePath -Force
```
    {{< /tab >}}
    {{< /tabs >}}

    {{< hint type=warning >}}
The `lib` folder must be named `lib`, any other name will not work
    {{< /hint >}}

1. The `alz.alz_architecture_definition.json` file content should have been copied from [here](https://github.com/Azure/Azure-Landing-Zones-Library/blob/main/platform/alz/architecture_definitions/alz.alz_architecture_definition.json). If the script did not work for you, copy the content from the link and create the file manually.

1. Edit the `alz.alz_architecture_definition.json` file to update the management group names and IDs. 

    For example to prefix all the management group display names with `Contoso` and update the management group IDs to have the `contoso-` prefix they can update the file to look like this:

    {{< hint type=tip >}}
When updating the management group `id`, you also need to consider any child management groups that refer to it by the `parent_id`
    {{< /hint >}}

    {{< highlight terraform "linenos=table" >}}
    {
      "$schema": "https://raw.githubusercontent.com/Azure/Azure-Landing-Zones-Library/main/schemas/architecture_definition.json",
      "name": "alz",
      "management_groups": [
        {
          "archetypes": [
            "root"
          ],
          "display_name": "Contoso",
          "exists": false,
          "id": "contoso-root",
          "parent_id": null
        },
        {
          "archetypes": [
            "platform"
          ],
          "display_name": "Contoso Platform",
          "exists": false,
          "id": "contoso-platform",
          "parent_id": "contoso-root"
        },
        {
          "archetypes": [
            "landing_zones"
          ],
          "display_name": "Contoso Landing zones",
          "exists": false,
          "id": "contoso-landingzones",
          "parent_id": "contoso-root"
        },
        {
          "archetypes": [
            "corp"
          ],
          "display_name": "Contoso Corp",
          "exists": false,
          "id": "contoso-corp",
          "parent_id": "contoso-landingzones"
        },
        {
          "archetypes": [
            "online"
          ],
          "display_name": "Contoso Online",
          "exists": false,
          "id": "contoso-online",
          "parent_id": "contoso-landingzones"
        },
        {
          "archetypes": [
            "sandboxes"
          ],
          "display_name": "Contoso Sandboxes",
          "exists": false,
          "id": "contoso-sandboxes",
          "parent_id": "contoso-root"
        },
        {
          "archetypes": [
            "management"
          ],
          "display_name": "Contoso Management",
          "exists": false,
          "id": "contoso-management",
          "parent_id": "contoso-platform"
        },
        {
          "archetypes": [
            "connectivity"
          ],
          "display_name": "Contoso Connectivity",
          "exists": false,
          "id": "contoso-connectivity",
          "parent_id": "contoso-platform"
        },
        {
          "archetypes": [
            "identity"
          ],
          "display_name": "Contoso Identity",
          "exists": false,
          "id": "contoso-identity",
          "parent_id": "contoso-platform"
        },
        {
          "archetypes": [
            "decommissioned"
          ],
          "display_name": "Contoso Decommissioned",
          "exists": false,
          "id": "contoso-decommissioned",
          "parent_id": "contoso-root"
        }
      ]
    }
    {{< / highlight >}}

1. If you updated the `connectivity`, `management` or `identity` management group IDs, then you'll also need to update the `management_group_settings` > `subscription_placement` block setting in the `platform-landing-zone.tfvars` file to match the management group IDs you changed them to.

    For example:

    {{< highlight terraform "linenos=table" >}}
    management_group_settings = {
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
    }
    {{< / highlight >}}

1. Now, when deploying the accelerator you need to supply the lib folder as an argument with `-starterAdditionalFiles`.
