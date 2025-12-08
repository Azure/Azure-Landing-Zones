---
title: Bootstrap
---

Follow these instructions to bootstrap ready to deploy your platform landing zone with Terraform.

1. Run the following command, updating it for your chosen Version Control System and scenario number:

    ```pwsh
    $iacType = "terraform"  # Must be one of: "bicep", "bicep-classic", "terraform"
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

    $repos = @{
        "terraform" = @{
            repoName = "alz-terraform-accelerator"
            folderToClone = "templates/platform_landing_zone"
            libraryFolderPath = "lib"
            exampleFolderPath = "examples"
            bootstrapExampleFolderPath = "bootstrap"
            hasScenarios = $true
            hasLibrary = $true
        }
        "bicep" = @{
            repoName = "alz-bicep-accelerator"
            folderToClone = ""
            libraryFolderPath = ""
            exampleFolderPath = "examples"
            bootstrapExampleFolderPath = "bootstrap"
            hasScenarios = $false
            hasLibrary = $false
            platformLandingZoneFilePath = "platform-landing-zone.yaml"
        }
        "bicep-classic" = @{
            repoName = "alz-bicep"
            folderToClone = "accelerator"
            libraryFolderPath = ""
            exampleFolderPath = "examples"
            bootstrapExampleFolderPath = "bootstrap"
            hasScenarios = $false
            hasLibrary = $false
            platformLandingZoneFilePath = ""
        }
    }

    $repo = $repos[$iacType]

    git clone -n --depth=1 --filter=tree:0 "https://github.com/Azure/$($repo.repoName)" "$tempFolder"
    cd $tempFolder

    git sparse-checkout set --no-cone $repo.folderToClone
    git checkout

    cd ~
    $exampleFolderPath = "$($repo.folderToClone)/$($repo.exampleFolderPath)"
    $bootstrapExampleFolderPath = "$exampleFolderPath/$($repo.bootstrapExampleFolderPath)"

    $targetFolder = Resolve-Path -Path $targetFolder
    New-Item -ItemType "directory" "$targetFolder/config" -Force

    Copy-Item -Path "$tempFolder/$bootstrapExampleFolderPath/inputs-$versionControl.yaml" -Destination "$targetFolder/config/inputs.yaml" -Force

    if($repo.hasLibrary) {
        $libFolderPath = "$($repo.folderToClone)/$($repo.libraryFolderPath)"
        Copy-Item -Path "$tempFolder/$libFolderPath" -Destination "$targetFolder/config" -Recurse -Force
    }

    if($repo.hasScenarios) {
        $scenarios = @{
            1 = "full-multi-region/hub-and-spoke-vnet"
            2 = "full-multi-region/virtual-wan"
            3 = "full-multi-region-nva/hub-and-spoke-vnet"
            4 = "full-multi-region-nva/virtual-wan"
            5 = "management-only/management"
            6 = "full-single-region/hub-and-spoke-vnet"
            7 = "full-single-region/virtual-wan"
            8 = "full-single-region-nva/hub-and-spoke-vnet"
            9 = "full-single-region-nva/virtual-wan"
        }

        Copy-Item -Path "$tempFolder/templates/platform_landing_zone/examples/$($scenarios[$scenarioNumber]).tfvars" -Destination "$targetFolder/config/platform-landing-zone.tfvars" -Force
    } elseif ($repo.platformLandingZoneFilePath -ne "") {
        Copy-Item -Path "$tempFolder/$($repo.platformLandingZoneFilePath)" -Destination "$targetFolder/config/platform-landing-zone.yaml" -Force
    }
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
