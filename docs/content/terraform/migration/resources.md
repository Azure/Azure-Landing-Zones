---
title: 1 - Management and Connectivity Resources
description: Migration path 1 for management and connectivity resources from CAF Enterprise Scale to Azure Verified Modules for Platform Landing Zones (ALZ)
geekdocCollapseSection: true
weight: 5
---

This document provides step by step guidance for migrating from the CAF Enterprise Scale module connectivity and management resources to the Azure Verified Modules for Platform Landing Zones (ALZ) module.

The migration process relies on Terraform state migration using there Terraform [moved](https://developer.hashicorp.com/terraform/language/moved) block.

## Introduction

The migration process follows a 3 stage approach:

1. **Setup**: identify subscriptions and prepare the target module.
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

    Hub and Spoke example:

    ```powershell
    Invoke-WebRequest -Uri "https://raw.githubusercontent.com/Azure/terraform-state-importer/refs/heads/main/.config/alz.connectivity.hub-and-spoke.config.yaml" -OutFile "config.yaml"
    ```

    Virtual WAN example:

    ```powershell
    Invoke-WebRequest -Uri "https://raw.githubusercontent.com/Azure/terraform-state-importer/refs/heads/main/.config/alz.connectivity.virtual-wan.config.yaml" -OutFile "config.yaml"
    ```

1. Open the config.yaml file and update the subscription IDs for you management and connectivity subscriptions, then save the file.

    ```yaml
    subscriptionIDs:
    # Connectivity subscription ID
    - "00000000-0000-0000-0000-000000000000"
    # Management Subscription ID
    - "00000000-0000-0000-0000-000000000000"
    ```

1. Create and clone your target module. Follow the instructions in the [ALZ IaC Accelerator](https://aka.ms/alz/acc) up to the end of phase 2.

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

1. Turn off the management group and policy resources in the `platform-landing-zone.auto.tfvars` file. This is because we are not migrating these resources at this time and you likely don't want to deploy them when you run your apply. You can do this by setting the `management_group_settings` `enabled` variable to `false`.

    ```terraform
    management_group_settings = {
      enabled            = false
      ...
    }
    ```

1. Take a look at each issue in the `issues.csv` file, starting the issues of `Issue Type` `NoResourceID`. This includes all the resources that require an update to your Terraform module variables.

1. For each issue, find the relevant setting in the `platform-landing-zone.auto.tfvars` file and update the value to match the Azure resource name. To make this easier, we have created two example files that have been updated to match the default settings in the CAF module.

    - [hub-and-spoke.auto.tfvars](https://raw.githubusercontent.com/Azure/azure-landing-zones/refs/heads/main/docs/static/examples/tf/migration/platform-landing-zone.hub-and-spoke.auto.tfvars)
    - [virtual-wan.auto.tfvars](https://raw.githubusercontent.com/Azure/azure-landing-zones/refs/heads/main/docs/static/examples/tf/migration/platform-landing-zone.virtual-wan.auto.tfvars)

    You can cope the contents of these files into your `platform-landing-zone.auto.tfvars` file and look at the diff in VS Code as a starting point. If you customized the names of your resources, you will still need to update the values in the `platform-landing-zone.auto.tfvars` file to match your Azure resource names.

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

            This will allow Terraform to create the resource again and you will be responsible for deleting the old resource (more on this later).

    1. `UnusedResourceID`: This is an resource that is not used in the AVM module.

        Any resources that are actually used will have been handled in the `NoResourceID` section. For the rest, you need to confirm you are aware they won't be managed by Terraform.

        1. For each resource, enter `Ignore` into the `Action` column if it doesn't already have `Replace` in there.

1. Save the `issues.csv` file as `resolved-issues.csv` and close the file.

1. Now we need to run the tool again for the final time to generate the import blocks for the resources that we need to import into Terraform.

    ```powershell
    ./terraform-state-importer.exe run `
        --config "~/alz-migration/config.yaml" `
        --terraformModulePath "~/alz-migration-terraform-module" `
        --workingFolderPath "~/alz-migration" `
        --issuesCsv "~/resolved-issues.csv"
    ```

1. This time the tool will generate a file called `imports.tf` in the `~/alz-migration-terraform-module` folder.

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

    In some cases it will not be possible to update or the change is expected, so you can ignore it. That is fine and it is up to you to determine which changes need rectifying and which don't. The example file we already reference provides examples of the updates required for the standard CAF module.

1. Re-run the command to generate the plan file again and check for any changes that are still flagged as `~` (tilde) and repeat until you are happy with the plan.

    ```powershell
    ./terraform-state-importer.exe run `
        --config "~/alz-migration/config.yaml" `
        --terraformModulePath "~/alz-migration-terraform-module" `
        --workingFolderPath "~/alz-migration" `
        --planAsTextOnly
    ```

## Final Steps

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


1. If you see any errors, you can refer to our [FAQ]({{< relref "migration-faq" >}}) for help, but in most cases running the pipeline again will resolve any issues.

1. Great! You have now completed the migration process and your management and connectivity resources are now managed by the AVM modules.
