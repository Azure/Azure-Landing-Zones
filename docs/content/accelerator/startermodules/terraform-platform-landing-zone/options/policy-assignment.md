---
title: 10 - Remove a policy assignment
geekdocCollapseSection: true
weight: 10
---

{{< hint type=tip >}}
It may be simpler to change the enforcement mode of policy assignments rather than removing them altogether. See [here]({{< relref "policy-enforcement" >}}) for more information.
{{< /hint >}}

You may want to remove some policy assignments altogether. In order to do this they need to supply a `lib` folder to the accelerator.

You can run the following script to setup the `lib` folder structure:

{{< tabs "1" >}}
{{< tab "Windows" >}}
```pwsh
$filePath = "c:\accelerator\config\lib\architecture_definitions\alz.alz_architecture_definition.json"
$skipArchitecture = $false
if(Test-Path $filePath) {
  $response = Read-Host "The file $filePath already exists, are you sure you want to overwrite it and lose your changes? Type 'yes' to overwrite it..."
  if($response -ne "yes") {
    $skipArchitecture = $true
  }
}

if(!($skipArchitecture)) {
  New-Item -ItemType "file" $filePath -Force
  (Invoke-WebRequest "https://raw.githubusercontent.com/Azure/Azure-Landing-Zones-Library/refs/heads/main/platform/alz/architecture_definitions/alz.alz_architecture_definition.json").Content | Out-File $filePath -Force
}

$archetypes = $("connectivity", "corp", "decommissioned", "identity", "management", "landing_zones", "platform", "root", "sandbox")
foreach($archetype in $archetypes){
    $filePath = "c:\accelerator\config\lib\archetype_definitions\$($archetype).alz_archetype_override.json"
    New-Item -ItemType "file" $filePath -Force
    $policy_assignments = ((Invoke-WebRequest "https://raw.githubusercontent.com/Azure/Azure-Landing-Zones-Library/refs/heads/main/platform/alz/archetype_definitions/$($archetype).alz_archetype_definition.json").Content | ConvertFrom-Json).policy_assignments
    $archetype_override = [ordered]@{
      name = "$($archetype)_override"
      base_archetype = $archetype
      policy_assignments_to_remove = $policy_assignments
    }
    ConvertTo-Json $archetype_override -Depth 10 | Out-File $filePath -Force
}
```
{{< /tab >}}
{{< tab "Linux / macOS" >}}
```pwsh
$filePath = "/accelerator/config/lib/architecture_definitions/alz.alz_architecture_definition.json"
$skipArchitecture = $false
if(Test-Path $filePath) {
  $response = Read-Host "The file $filePath already exists, are you sure you want to overwrite it and lose your changes? Type 'yes' to overwrite it..."
  if($response -ne "yes") {
    $skipArchitecture = $true
  }
}

if(!($skipArchitecture)) {
  New-Item -ItemType "file" $filePath -Force
  (Invoke-WebRequest "https://raw.githubusercontent.com/Azure/Azure-Landing-Zones-Library/refs/heads/main/platform/alz/architecture_definitions/alz.alz_architecture_definition.json").Content | Out-File $filePath -Force
}

$archetypes = $("connectivity", "corp", "decommissioned", "identity", "management", "landing_zones", "platform", "root", "sandbox")
foreach($archetype in $archetypes){
    $filePath = "/accelerator/config/lib/archetype_definitions/$($archetype).alz_archetype_override.json"
    New-Item -ItemType "file" $filePath -Force
    $policy_assignments = ((Invoke-WebRequest "https://raw.githubusercontent.com/Azure/Azure-Landing-Zones-Library/refs/heads/main/platform/alz/archetype_definitions/$($archetype).alz_archetype_definition.json").Content | ConvertFrom-Json).policy_assignments
    $archetype_override = [ordered]@{
      name = "$($archetype)_override"
      base_archetype = $archetype
      policy_assignments_to_remove = $policy_assignments
    }
    ConvertTo-Json $archetype_override -Depth 10 | Out-File $filePath -Force
}
```
{{< /tab >}}
{{< /tabs >}}

The `lib` folder should contain the following structure (we are showing it nested under the standard accelerator file structure here):

```plaintext
📂accelerator
┣ 📂config
┃ ┣ 📂lib
┃ ┃ ┣ 📂architecture_definitions
┃ ┃ ┃ ┗ 📜alz.alz_architecture_definition.json
┃ ┃ ┗ 📂archetype_definitions
┃ ┃   ┃ 📜connectivity.alz_archetype_override.json
┃ ┃   ┃ 📜corp.alz_archetype_override.json
┃ ┃   ┃ 📜decommissioned.alz_archetype_override.json
┃ ┃   ┃ 📜identity.alz_archetype_override.json
┃ ┃   ┃ 📜management.alz_archetype_override.json
┃ ┃   ┃ 📜landing_zones.alz_archetype_override.json
┃ ┃   ┃ 📜platform.alz_archetype_override.json
┃ ┃   ┃ 📜root.alz_archetype_override.json
┃ ┃   ┗ 📜sandboxes.alz_archetype_override.json
┃ ┃ 📜inputs.yaml
┃ ┗ 📜platform-landing-zone.tfvars
┗ 📂output
```
{{< hint type=warning >}}
The `lib` folder must be named `lib`, any other name will not work
{{< /hint >}}

The `*.alz_archetype_override.json` files content should be created based on the library archetypes found [here](https://github.com/Azure/Azure-Landing-Zones-Library/blob/main/platform/alz/archetype_definitions).

By default we have added all the library policy assignments to the `policy_assignments_to_remove` array.

1. You can now open each `alz_archetype_override.json` file in turn and delete any policy assignments you **DO NOT** wish to remove from the `policy_assignments_to_remove` array.
2. If you don't want to remove any policy assignments from a particular archetype, then you can just delete the whole file.

For example to remove just the `Deploy-ASC-Monitoring` policy assignment from the `root` management group archetype, the file would look like this:

```json
{
  "name": "root_override",
  "base_archetype": "root",
  "policy_assignments_to_remove": [
    "Deploy-ASC-Monitoring"
  ]
}
```

Now for each override file you need to update the `alz.alz_architecture_definition.json` to use the override archetype.

For example to use the override for root, you need to update the `archetypes` array and replace with the override archetype name from `root` to `root_override`:

```json
{
  "archetypes": [
    "root_override"
  ],
  "display_name": "Azure Landing Zones",
  "exists": false,
  "id": "alz",
  "parent_id": null
},

```

Now, when deploying the accelerator you need to supply the lib folder as an argument with `-starterAdditionalFiles`.
