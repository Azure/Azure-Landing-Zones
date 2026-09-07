---
title: Implement Sovereign Landing Zone (SLZ) controls
weight: 1
---

The Sovereign Landing Zone (SLZ) implementation is available for the Azure landing zone accelerator Bicep starter module.

The SLZ deployment using the Bicep accelerator follows the same overall pattern as the Terraform accelerator:

1. Bootstrap the delivery environment.
1. Overlay the SLZ-specific configuration.
1. Update deployment inputs.
1. Deploy through the generated CI/CD workflow.

The Bicep implementation uses a compact SLZ package containing only the files required to add the sovereign management groups and policies.

Follow the Azure landing zone accelerator [user guide](https://azure.github.io/Azure-Landing-Zones/accelerator/):

1. Complete [Phase 0 - Planning]({{< relref "../../0_planning" >}}) and choose Bicep as the IaC type and GitHub or Azure DevOps as the CI/CD platform.
1. Complete [Phase 1 - Prerequisites]({{< relref "../../1_prerequisites" >}}).
1. Complete [Phase 2 - Bootstrap]({{< relref "../../2_bootstrap" >}}).
1. Apply the SLZ Bicep deployment package.
1. Complete [Phase 3 - Run]({{< relref "../../3_run" >}}).
1. Iterate, customize, and extend your landing zone through your chosen version control system and CI/CD pipelines.

## Apply the SLZ Bicep deployment package

To apply the SLZ package, run the following PowerShell script after the bootstrap process creates your accelerator configuration:

```pwsh
$tempFolderName = "~/accelerator/temp"
New-Item -ItemType "directory" $tempFolderName
$tempFolder = Resolve-Path -Path $tempFolderName
git clone -n --depth=1 --filter=tree:0 "https://github.com/Azure/alz-bicep-accelerator" "$tempFolder"
cd $tempFolder

$configFolderPath = "examples/slz/.config"
$templatesFolderPath = "examples/slz/templates"
git sparse-checkout set --no-cone $configFolderPath $templatesFolderPath
git checkout

cd ~
Copy-Item `
  -Path "$tempFolder/$configFolderPath" `
  -Destination "~/accelerator/config" `
  -Recurse `
  -Force
Copy-Item `
  -Path "$tempFolder/$templatesFolderPath" `
  -Destination "~/accelerator/config" `
  -Recurse `
  -Force
Remove-Item -Path $tempFolder -Recurse -Force
```

The SLZ package is sourced from:

1. [`examples/slz/.config`](https://github.com/Azure/alz-bicep-accelerator/tree/main/examples/slz/.config)
1. [`examples/slz/templates`](https://github.com/Azure/alz-bicep-accelerator/tree/main/examples/slz/templates)

You can also copy or replace starter module files during the bootstrap process, like the Terraform accelerator approach. This allows the SLZ-specific files to be applied directly while the starter module is being prepared.
