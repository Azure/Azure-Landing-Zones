---
title: Phase 2 - Bootstrap
weight: 30
---

Follow these instructions to bootstrap your Version Control System and Azure ready to deploy your platform landing zone.

1. Run the following command, updating it for your chosen Infrastructure as Code, Version Control System and scenario number:

    ```pwsh
    $iacType = "terraform"  # Must be one of: "bicep", "bicep-classic", "terraform"
    $versionControl = "github"  # Must be one of: "azure-devops", "github", "local"
    $scenarioNumber = 1  # Must be a number between 1 and 9 for Terraform only. Ignored for Bicep.
    $targetFolder = "~/accelerator" # Choose your target folder for the cached files

    ```

    {{< hint type=tip >}}
Terraform scenarios can be found in the [scenarios docs]({{< relref "startermodules/terraform-platform-landing-zone/scenarios" >}}) section.
    {{< /hint >}}

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

1. Open your `inputs.yaml` bootstrap configuration file in Visual Studio Code and provide values for each input in the required section.

    ```pwsh
    code "$targetFolder/config"
    ```

    {{< hint type=tip >}}
More details about the configuration files can be found in the [configuration files]({{< relref "configuration-files" >}}) section.
    {{< /hint >}}

1. Review and update the platform landing zone configuration file if required. More details can be found in the relevant section for your chosen Infrastructure as Code tool:

    - [Terraform Azure Verified Modules for Platform Landing Zone (ALZ)]({{< relref "startermodules/terraform-platform-landing-zone" >}})
    - [Bicep Azure Verified Modules for Platform Landing Zone (ALZ)]({{< relref "startermodules/bicep-platform-landing-zone" >}})

    {{< hint type=tip >}}
Terraform options can be found in the [options docs]({{< relref "startermodules/terraform-platform-landing-zone/options" >}}) section.
    {{< /hint >}}

1. Login to Azure CLI replacing the tenant and subscription IDs with your own to target you bootstrap subscription:

    ```pwsh
    az login --tenant 00000000-0000-0000-0000-000000000000 --use-device-code
    az account set --subscription 00000000-0000-0000-0000-000000000000
    ```

1. In your terminal install and run the ALZ bootstrap module:

    ```pwsh
    $alzModule = Get-InstalledPSResource -Name ALZ
    if (-not $alzModule) {
        Install-PSResource -Name ALZ
    } else {
        Update-PSResource -Name ALZ
    }

    if($iacType -eq "terraform") {
        Deploy-Accelerator `
        -inputs "$targetFolder/config/inputs.yaml", "$targetFolder/config/platform-landing-zone.tfvars" `
        -starterAdditionalFiles "$targetFolder/config/lib" `
        -output "$targetFolder/output"
    }

    if($iacType -eq "bicep") {
        Deploy-Accelerator `
        -inputs "$targetFolder/config/inputs.yaml", "$targetFolder/config/platform-landing-zone.yaml" `
        -starterAdditionalFiles "$targetFolder/config/lib" `
        -output "$targetFolder/output"
    }

    if($iacType -eq "bicep-classic") {
        Deploy-Accelerator `
        -inputs "$targetFolder/config/inputs.yaml" `
        -output "$targetFolder/output"
    }

    ```

1. Once it generates the plan, hit enter to deploy the bootstrap.

    {{< hint type=tip >}}
You can now update your `Azure Landing Zone Terraform Accelerator Runner Registration` GitHub PAT (`token-2`) to restrict it to the main repository created by the bootstrap.
    {{< /hint >}}

1. For Bicep only, clone your newly created repository to your local machine and make any changes required to the parameter files. See the [Bicep getting started guide]({{< relref "../bicep/gettingStarted" >}}) for more information on customizing the parameter files. Commit and push any changes to your repository. For the local file system option, you can make changes directly in the output folder.

## Next Steps

Now head to [Phase 3]({{< relref "3_run" >}}).
