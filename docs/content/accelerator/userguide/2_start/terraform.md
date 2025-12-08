---
title: Bootstrap Terraform
---

Follow these instructions to bootstrap ready to deploy your platform landing zone with Terraform.

1. Run the following command, updating it for your chosen Version Control System and scenario number:

    ```pwsh
    $versionControl = "github"  # Must be one of: "azure-devops", "github", "local"
    $scenarioNumber = 1  # Must be number between 1 and 9
    $targetFolder = "~/accelerator" # Choose your target folder for the cached files

    ```

1. Run the following command to set up your folder structure and download the required files:

    ```pwsh
    New-Item -ItemType "directory" "$targetFolder/output"

    $tempFolderName = "$targetFolder/temp"
    New-Item -ItemType "directory" $tempFolderName
    $tempFolder = Resolve-Path -Path $tempFolderName
    git clone -n --depth=1 --filter=tree:0 "https://github.com/Azure/alz-terraform-accelerator" "$tempFolder"
    cd $tempFolder

    $templateFolderPath = "templates/platform_landing_zone"
    git sparse-checkout set --no-cone $templateFolderPath
    git checkout

    $libFolderPath = "$templateFolderPath/lib"

    cd ~
    Copy-Item -Path "$tempFolder/templates/platform_landing_zone/examples/bootstrap/inputs-$versionControl.yaml" -Destination "$targetFolder/config/inputs.yaml" -Force
    Copy-Item -Path "$tempFolder/$libFolderPath" -Destination "$targetFolder/config" -Recurse -Force

    $scenarios = @{
        1 = "full-multi-region/hub-and-spoke-vnet"
        2 = "full-multi-region/virtual-wan"
        3 = "full-multi-region-nva/hub-and-spoke-vnet"
        4 = "full-multi-region-nva/virtual-wan"
        5 = "management-only/management.tfvars"
        6 = "full-single-region/hub-and-spoke-vnet"
        7 = "full-single-region/virtual-wan"
        8 = "full-single-region-nva/hub-and-spoke-vnet"
        9 = "full-single-region-nva/virtual-wan"
    }

    Copy-Item -Path "$tempFolder/templates/platform_landing_zone/examples/$($scenarios[$scenarioNumber]).tfvars" -Destination "$targetFolder/config/platform-landing-zone.tfvars" -Force
    Remove-Item -Path $tempFolder -Recurse -Force

    ```

1. Open your `inputs.yaml` file in Visual Studio Code (or your preferred editor) and provide values for each input in the required section.

1. In your PowerShell Core (pwsh) terminal run the module:

    ```pwsh
    Install-PSResource -Name ALZ

    Deploy-Accelerator `
    -inputs "$targetFolder/config/inputs.yaml", "$targetFolder/config/platform-landing-zone.tfvars" `
    -starterAdditionalFiles "$targetFolder/config/lib" `
    -output "$targetFolder/output"

    ```

1. If you are happy with the plan, then hit enter to deploy the bootstrap.

## Next Steps

Now head to [Phase 3]({{< relref "3_deploy" >}}).
