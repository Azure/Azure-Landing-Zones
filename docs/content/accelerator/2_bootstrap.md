---
title: Phase 2 - Bootstrap
weight: 30
---

Follow these instructions to bootstrap your Version Control System and Azure ready to deploy your Platform landing zone.

1. Run the following command, updating it for your chosen Infrastructure as Code, Version Control System and scenario number:

    ```pwsh
    $iacType = "terraform"  # Must be one of: "bicep", "bicep-classic", "terraform"
    $versionControl = "github"  # Must be one of: "azure-devops", "github", "local"
    $scenarioNumber = 1  # Must be a number between 1 and 9 for Terraform only. Ignored for Bicep.
    $targetFolderPath = "~/accelerator" # Choose your target folder for the cached files

    $alzModule = Get-InstalledPSResource -Name ALZ
    if (-not $alzModule) {
        Install-PSResource -Name ALZ
    } else {
        Update-PSResource -Name ALZ
    }

    New-AcceleratorFolderStructure `
        -iacType $iacType `
        -versionControl $versionControl `
        -scenarioNumber $scenarioNumber `
        -targetFolderPath $targetFolderPath

    ```

    {{< hint type=tip >}}
Terraform scenarios can be found in the [scenarios docs]({{< relref "startermodules/terraform-platform-landing-zone/scenarios" >}}) section.
    {{< /hint >}}

2. Open your `inputs.yaml` bootstrap configuration file in Visual Studio Code and provide values for each input in the required section.

    ```pwsh
    code "$targetFolderPath/config"
    ```

    {{< hint type=tip >}}
More details about the configuration files can be found in the [configuration files]({{< relref "configuration-files" >}}) section.
    {{< /hint >}}

1. Review and update the Platform landing zone configuration file.

    The `starter_locations` input is required and must be updated in this file to include at least one Azure region for your Platform landing zone.

    More details can be found in the relevant section for your chosen Infrastructure as Code tool:

    - Terraform: `platform-landing-zones.tfvars` - [Terraform Azure Verified Modules for Platform landing zone (ALZ)]({{< relref "startermodules/terraform-platform-landing-zone" >}})
    - Bicep: `platform-landing-zone.yaml` - [Bicep Azure Verified Modules for Platform landing zone (ALZ)]({{< relref "startermodules/bicep-platform-landing-zone" >}})

    {{< hint type=tip >}}
Terraform options can be found in the [options docs]({{< relref "startermodules/terraform-platform-landing-zone/options" >}}) section.
    {{< /hint >}}

1. Login to Azure CLI replacing the tenant and subscription IDs with your own to target you bootstrap subscription:

    ```pwsh
    az login --tenant 00000000-0000-0000-0000-000000000000 --use-device-code
    az account set --subscription 00000000-0000-0000-0000-000000000000
    ```

2. In your terminal install and run the ALZ bootstrap module:

    {{< hint type=important title="JSON instead of YAML">}}
If you are unable to install the [`powershell-yaml` module](https://www.powershellgallery.com/packages/powershell-yaml) (the ALZ module tries to install this automatically for you when invoked), you **can** use `.json` files instead; see [Configuration Files]({{< relref "configuration-files" >}}) for more information.
    {{< /hint >}}

    ```pwsh
    if($iacType -eq "terraform") {
        Deploy-Accelerator `
        -inputs "$targetFolderPath/config/inputs.yaml", "$targetFolderPath/config/platform-landing-zone.tfvars" `
        -starterAdditionalFiles "$targetFolderPath/config/lib" `
        -output "$targetFolderPath/output"
    }

    if($iacType -eq "bicep") {
        Deploy-Accelerator `
        -inputs "$targetFolderPath/config/inputs.yaml", "$targetFolderPath/config/platform-landing-zone.yaml" `
        -output "$targetFolderPath/output"
    }

    if($iacType -eq "bicep-classic") {
        Deploy-Accelerator `
        -inputs "$targetFolderPath/config/inputs.yaml" `
        -output "$targetFolderPath/output"
    }

    ```

1. Once it generates the plan, hit enter to deploy the bootstrap.

    {{< hint type=tip >}}
You can now update your `Azure Landing Zone Terraform Accelerator Runner Registration` GitHub PAT (`token-2`) to restrict it to the main repository created by the bootstrap.
    {{< /hint >}}

1. For Bicep only, clone your newly created repository to your local machine and make any changes required to the parameter files. See the [Bicep getting started guide]({{< relref "../bicep/gettingStarted" >}}) for more information on customizing the parameter files. Commit and push any changes to your repository. For the local file system option, you can make changes directly in the output folder.

## Next Steps

Now head to [Phase 3]({{< relref "3_run" >}}).
