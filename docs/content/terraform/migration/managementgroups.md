---
title: 2 - Management Groups and Policy
description: Migration path 2 for management groups and policy from CAF Enterprise Scale to Azure Verified Modules for Platform Landing Zones (ALZ)
geekdocCollapseSection: true
weight: 10
---

This document provides step by step guidance for migrating from the CAF Enterprise Scale module management groups and policy to the Azure Verified Modules for Platform Landing Zones (ALZ) module.

The migration process relies on Terraform state migration using the Terraform [import](https://developer.hashicorp.com/terraform/language/import) block.

An alternative approach is to provision a new management group hierarchy. You can do that by following the accelerator guide to rename the management groups and then apply the Terraform module. Follow our [brownfield guidance](https://aka.ms/alz/brownfield) for more info on the approach.

## Introduction

The migration process follows a 3 stage approach:

1. **Setup**: identify management groups and prepare the target module.
2. **Resource ID Update and Mapping**: Update the resource IDs in the Terraform module to match the new ALZ module and generate the import blocks.
3. **Resource Attribute Update**: Update the resource attributes in the Terraform module to match the existing resources.

## Setup

1. Create a folder to store the migration tooling and metadata

    ```powershell
    New-Item -ItemType Directory "~/alz-migration"
    Set-Location -Path "~/alz-migration"
    ```

1. Download the migration tooling

    ```powershell
    # Get OS and Architecture
    $os = "windows"
    if($IsLinux) { $os = "linux"}
    if($IsMacOS) { $os = "darwin" }
    $architecture = ([System.Runtime.InteropServices.RuntimeInformation]::OSArchitecture).ToString().ToLower()
    $architecture = $architecture -replace "x64", "amd64"
    $architecture = $architecture -replace "x86", "386"
    $osAndArchitecture = "$($os)_$($architecture)"

    # Find and download the latest release of the Terraform State Importer
    $repoReleaseUrl = "https://api.github.com/repos/Azure/terraform-state-importer/releases/latest"
    $releaseData = Invoke-RestMethod $repoReleaseUrl -SkipHttpErrorCheck -StatusCodeVariable "statusCode"
    if($statusCode -ne 200) {
        throw "Unable to query repository version..."
    }

    $version = $releaseData.tag_name
    Write-Host "Latest version: $version"
    $asset = $releaseData.assets | Where-Object { $_.name -like "*$osAndArchitecture*.zip" } | Select-Object -First 1
    $exeName = $asset.name
    $url = $asset.browser_download_url
    $installPath = "temp"

    # Download Archive File
    New-Item -Path $installPath -ItemType Directory -Force | Out-String | Write-Verbose
    $targetFile = Join-Path -Path $installPath -ChildPath $exeName
    Invoke-WebRequest -Uri $url -OutFile $targetFile

    # Expand Archive and Cleanup
    Expand-Archive -Path $targetFile -DestinationPath "." -Force | Out-String | Write-Verbose
    Remove-Item -Path $installPath -Recurse -Force | Out-String | Write-Verbose
    ```

1. Create a config yaml file, starting with one of our ALZ examples. You can find the examples in the [terraform-state-importer](https://github.com/Azure/terraform-state-importer/tree/main/.config) repository.

    ```powershell
    Invoke-WebRequest -Uri "https://raw.githubusercontent.com/Azure/terraform-state-importer/refs/heads/main/.config/alz.management-groups.config.yaml" -OutFile "config.yaml"
    ```

1. Open the config.yaml file and update the management group ID for your top level management group, then save the file.

    ```yaml
    managementGroupIDs:
    # ALZ Root Management Group ID
    - "alz"
    ```

1. Create and clone your target module. Follow the instructions in the [ALZ IaC Accelerator](https://aka.ms/alz/acc) up to the end of phase 2. You can skip this part if you are following on from our connectivity migration example as you will already have a target module.

    {{< hint type=tip >}}
You can build your own custom module leveraging our AVM modules at this stage if you prefer. Don't do this unless you have a very specific reason and know what you are doing. Even if you choose ignore this advice, we recommend using the ALZ Terraform Accelerator as a starting point anyway. You can find the module code [here](https://github.com/Azure/alz-terraform-accelerator/tree/main/templates/platform_landing_zone).
    {{< /hint >}}

1. At the end of phase 2, you will either have a code repository or a local folder with the target module

1. If you are using Azure DevOps or GitHub, you will need to clone the repository to your local machine. If you are using a local folder, you can skip this step.

    ```powershell
    New-Item -ItemType Directory "~/alz-migration-terraform-module"
    Set-Location -Path "~/alz-migration-terraform-module"
    git clone <your target module repo url> .
    Set-Location -Path "~/alz-migration"
    ```

1. You should already be logged into Azure CLI with an elevated account if you followed the accelerator instructions. If you are not, then you'll need to connection to Azure CLI with an account that has the same permissions as stated in the [accelerator guidance](https://azure.github.io/Azure-Landing-Zones/accelerator/userguide/1_prerequisites/platform-subscriptions/).

1. Great! You are now ready to start the migration process.

## Resource ID Update and Mapping

1. Run the migration tool to get the initial set of issues to look at.

    ```powershell
    ./terraform-state-importer.exe run `
        --config "~/alz-migration/config.yaml" `
        --terraformModulePath "~/alz-migration-terraform-module" `
        --workingFolderPath "~/alz-migration"
    ```

1. The tool will generate a file called `issues.csv` in the `~/alz-migration` folder. Open the file in Excel.

1. Open your terraform module in your IDE

    ```powershell
    Set-Location -Path "~/alz-migration-terraform-module"
    code .
    Set-Location -Path "~/alz-migration"
    ```

1. Open the `platform-landing-zone.auto.tfvars` file in your IDE. This file contains the variables that are used to configure the module. You will need to update the values in this file to match the Azure resources.

1. Turn on the management group and policy resources in the `platform-landing-zone.auto.tfvars` file. This is only relevant if you followed our connectivity guidance. You can do this by setting the `management_group_settings` `enabled` variable to `true`.

    ```terraform
    management_group_settings = {
      enabled            = true
      ...
    }
    ```

1. Take a look at each issue in the `issues.csv` file, starting with the issues of `Issue Type` `NoResourceID`. This includes all the resources that require an update to your Terraform module variables.

1. For each issue, find the relevant setting in the `platform-landing-zone.auto.tfvars` file and update the value to match the Azure resource name. To make this easier, we have created two example files that have been updated to match the default settings in the CAF module.

    - [hub-and-spoke.auto.tfvars](https://raw.githubusercontent.com/Azure/alz-terraform-accelerator/refs/heads/main/templates/platform_landing_zone/examples/migration/hub-and-spoke-vnet.tfvars)
    - [virtual-wan.auto.tfvars](https://raw.githubusercontent.com/Azure/alz-terraform-accelerator/refs/heads/main/templates/platform_landing_zone/examples/migration/virtual-wan.tfvars)

    You should have already taken the important settings from these files while migrating your connectivity resources, but it is worth reviewing the comments starting with `# MIGRATION:` in these files as they highlight important settings that you may need to update in your own `platform-landing-zone.auto.tfvars` file.

1. In some cases, you will need to update the `lib` folder in order to match the configuration. Again, we have provided an example of the changes required to match the standard CAF module settings. It can be found here: [lib](https://github.com/Azure/Azure-Landing-Zones/tree/docs-migration-management-groups/docs/static/examples/tf/migration/lib).

1. You may also need to update your `terraform.tf` file in order to match role definition IDs. Add the `role_definitions_use_supplied_names_enabled = true` setting to the `alz` `provider` block:

    ```terraform
    provider "alz" {
      role_definitions_use_supplied_names_enabled = true
      library_overwrite_enabled                   = true
      library_references = [
        {
          custom_url = "${path.root}/lib"
        }
      ]
    }
    ```

1. Once you have updated every resource name to match, then you can run the command again to get the final set of issues.

    ```powershell
    ./terraform-state-importer.exe run `
        --config "~/alz-migration/config.yaml" `
        --terraformModulePath "~/alz-migration-terraform-module" `
        --workingFolderPath "~/alz-migration"
    ```

1. This will be the list of issues that you cannot resolve by updating the Terraform module inputs and you'll need to provide a specific resolution for each issue in the `issues.csv` file.

    1. `MultipleResourceID`: This is a resource that has multiple IDs in the CAF module and needs to be updated to a single ID in the ALZ module. You will need to update the `platform-landing-zone.auto.tfvars` file to match the new resource ID.

        To resolve this issue you need to choose which resource ID is the correct match.

        1. For the correct row, enter `Use` into the `Action` column. An import block will be generated for this resource ID.
        1. For each incorrect row, enter `Ignore` into the `Action` column.

    1. `NoResourceID`: This is a Terraform resource that does not have a resource ID in the AVM module. Normally this is because it is a new resource that wasn't previously deployed by the CAF module, but in rare cases it may be that you are unable to update your Terraform module to match the existing resource ID.

        To resolve this issue you need to choose what to do.

        1. For each new resource, enter `Ignore` into the `Action` column. This will allow Terraform to create the new resource.
        1. For each existing resource:
            1. Enter `Replace` into the `Action` column,
            1. Find the matching resource ID in the `UnusedResourceID` section and enter `Replace` into the `Action` column.
            1. Take note of the `Issue ID` and enter it into the `Action ID` column of the `NoResourceID` row.`

            This will allow Terraform to create the resource again and the old resource will be destroyed.

    1. `UnusedResourceID`: This is an resource that is not used in the AVM module.

        Any resources that are actually used will have been handled in the `NoResourceID` section. For the rest, you need to confirm you are aware they won't be managed by Terraform or that you want to destroy them.

        1. You will see a lot of issues of type `microsoft.authorization/roleassignments`. These are the role assignments created for policy remediation. These all need to be set to `Destroy` as there is no way we can map them and they will cause a conflict if not removed and recreated.

        1. For each remaining resource, enter `Ignore` or `Destroy` into the `Action` column if it doesn't already have `Replace` in there.

1. Save the `issues.csv` file as `resolved-issues.csv` and close the file.

1. Now we need to run the tool again for the final time to generate the import blocks for the resources that we need to import into Terraform.

    ```powershell
    ./terraform-state-importer.exe run `
        --config "~/alz-migration/config.yaml" `
        --terraformModulePath "~/alz-migration-terraform-module" `
        --workingFolderPath "~/alz-migration" `
        --issuesCsv "~/resolved-issues.csv"
    ```

1. This time the tool will generate a files called `imports.tf` and `destroy.tf` in the `~/alz-migration-terraform-module` folder.

1. Great! You have now completed the first part of the migration process. You can now move on to the next step, which is to update the resource attributes in the Terraform module to match the existing resources.

## Resource Attribute Updates

We have now matched all of our resource IDs, but there may be some resource attributes that don't match the existing resources. To find these, we will run a Terraform plan and look for any changes that are flagged.

1. We will run the tool again to generate the plan file for us to examine.

    ```powershell
    ./terraform-state-importer.exe run `
        --config "~/alz-migration/config.yaml" `
        --terraformModulePath "~/alz-migration-terraform-module" `
        --workingFolderPath "~/alz-migration" `
        --planAsTextOnly
    ```

1. Open the `plan_updates.txt` file in your IDE and search (<kbd>Ctrl</kbd>+<kbd>F</kbd>) for any changes that are flagged as `~` (tilde). These are the changes that will be made to the resources.

        {{< hint type=tip >}}
The `plan_updates.txt` file contains only resources that are imported and then updated, which is the focus of this phase. However, the full plan is also available in the `plan.txt` file, if you prefer to see the full plan.
        {{< /hint >}}

1. For each change, you will need to update the `platform-landing-zone.auto.tfvars` file to match the existing resource.

    In some cases it will not be possible to update or the change is expected, so you can ignore it. There will be many cases where azapi resources have changes to `replace_triggers_external_values`, `retry`, `timeouts`, and `outputs` attributes, which is expected and can be safely ignored. It is up to you to determine which changes need rectifying and which don't. The example file we already reference provides examples of the updates required for the standard CAF module.

1. Re-run the command to generate the plan file again and check for any changes that are still flagged as `~` (tilde) and repeat until you are happy with the plan.

    ```powershell
    ./terraform-state-importer.exe run `
        --config "~/alz-migration/config.yaml" `
        --terraformModulePath "~/alz-migration-terraform-module" `
        --workingFolderPath "~/alz-migration" `
        --planAsTextOnly
    ```

## Final Steps

{{< hint type="danger" title="Danger - No Rollback from Terraform Apply" >}}
When you run the `terraform apply`, resources may be mutated, created, and destroyed. As such, **there is no guarantee that you will be able to roll back** to your original module state file after you run an apply. Therefore it is your responsibility to carefully review the plan to ensure there are no changes that you are not expecting.
{{< /hint >}}

1. You should now have a fully updated Terraform module that matches the existing resources in Azure and has import blocks ready to go.

1. If you are using Azure DevOps or GitHub, you will need to create a new branch, commit, and push your changes.

    1. Create and push your branch

        ```powershell
        git checkout -b "migration"
        git add .
        git commit -m "Migration from CAF Enterprise Scale to ALZ"
        git push origin migration
        ```

    1. Then open a pull request and review the plan generated by the CI pipeline.

    1. Once you are happy, merge the pull request to trigger the CD pipeline.

    1. Review the plan again and approve the apply

1. If you are using a local folder (or if you wish to run the VCS version locally), you will need to clean up the Terraform module folder and run an apply locally.

    1. Clean up the Terraform module folder

        ```powershell
        Remove-Item -Path "~/alz-migration-terraform-module/.terraform" -Recurse -Force
        Remove-Item -Path "~/alz-migration-terraform-module/.alzlib" -Recurse -Force
        Remove-Item -Path "~/alz-migration-terraform-module/.terraform.lock.hcl" -Force
        ```

    1. Run the command as shown in the [accelerator](https://azure.github.io/Azure-Landing-Zones/accelerator/userguide/3_deploy/#terraform) local instructions to init and apply the module.

        ```powershell
        ./scripts/deploy-local.ps1
        ```

        {{< hint type=warning >}}
If you are using a VCS and you should not attempt to run the apply locally, as you would need to make your storage account public and apply permissions for your user account to it. Otherwise you will end up with an error or a local state file that cannot easily be used moving forward.
        {{< /hint >}}

1. We recommend that you now run a second plan and apply, as we have seen some edge cases where the plan with import does not yield the expected results and the second plan will correct them.

1. If you see any errors, you can refer to our [FAQ]({{< relref "migration-faq" >}}) for help, but in most cases running the pipeline again will resolve any issues.

1. Great! You have now completed the migration process and your management and connectivity resources are now managed by the AVM modules.

1. We recommend that you remove the `imports.tf` file and `destroy.tf` file from your Terraform module, as these are not needed anymore. Create another branch and PR to complete this.

