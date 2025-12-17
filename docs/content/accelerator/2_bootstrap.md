---
title: Phase 2 - Bootstrap
weight: 30
---

Follow these instructions to bootstrap your Version Control System and Azure ready to deploy your Platform landing zone.

1. Copy the following variables to Notepad and edit them for your chosen settings:

     ```pwsh
    $iacType = "terraform"  # Must be one of: "bicep" (Recommended), "terraform" (Recommended), or "bicep-classic" (Not Recommended)
    $versionControl = "github"  # Must be one of: "azure-devops", "github", "local"
    $scenarioNumber = 1  # Must be a number between 1 and 9 for Terraform only. Ignored for Bicep.
    $targetFolderPath = "~/accelerator" # Choose your target folder for the cached files

    ```

    {{< hint type=tip >}}
Terraform scenarios can be found in the [scenarios docs]({{< relref "startermodules/terraform-platform-landing-zone/scenarios" >}}) section.
    {{< /hint >}}

1. Open a new PowerShell terminal and copy and paste it in there from Notepad to run it. You'll need these variables set for subsequent steps, so keep the terminal open or run this again if you open a new new terminal.

1. Run the following command to install or update the ALZ PowerShell module:

    ```pwsh
    $alzModule = Get-InstalledPSResource -Name ALZ 2>$null
    if (-not $alzModule) {
        Install-PSResource -Name ALZ
    } else {
        Update-PSResource -Name ALZ
    }

    ```

1. Run the following command to create the folder structure for your bootstrap:

    ```pwsh
    New-AcceleratorFolderStructure `
        -iacType $iacType `
        -versionControl $versionControl `
        -scenarioNumber $scenarioNumber `
        -targetFolderPath $targetFolderPath

    ```

1. Run this command to open your config folder in Visual Studio Code:

    ```pwsh
    code (Resolve-Path "$targetFolderPath/config").Path

    ```

    {{< hint type=tip >}}
If you don't have Visual Studio Code installed, you can navigate to the config folder using File Explorer or your preferred file manager.
    {{< /hint >}}

1. Open your `inputs.yaml` bootstrap configuration file in Visual Studio Code and provide values for each input in the required section.

    {{< hint type=tip >}}
More details about the configuration files can be found in the [configuration files]({{< relref "configuration-files" >}}) section.
    {{< /hint >}}

1. Open your Platform landing zone configuration file in Visual Studio Code and provide values for each required input.

    The file extension differs for each Infrastructure as Code tool. You can learn more about the specific settings for each tool in the relevant starter module documentation:

    - Terraform: `platform-landing-zones.tfvars` - [Terraform Azure Verified Modules for Platform landing zone (ALZ)]({{< relref "startermodules/terraform-platform-landing-zone" >}})
    - Bicep: `platform-landing-zone.yaml` - [Bicep Azure Verified Modules for Platform landing zone (ALZ)]({{< relref "startermodules/bicep-platform-landing-zone" >}})

    Update the following required inputs in the file:

    - `starter_locations`: you must update all the `<region-#>` placeholders with valid Azure regions for your Platform landing zone.
    - `defender_email_security_contact`: (Terraform only) this must be updated to include an email address for your security contact for Microsoft Defender for Cloud alerts.

    {{< hint type=tip >}}
Terraform options can be found in the [options docs]({{< relref "startermodules/terraform-platform-landing-zone/options" >}}) section.
    {{< /hint >}}

1. Login to Azure CLI replacing the tenant and subscription IDs with your own to target your desired bootstrap subscription:

    ```pwsh
    az login --tenant "<tenant-id>" --use-device-code
    az account set --subscription "<bootstrap-subscription-id>"

    ```

1. In your terminal run the ALZ module to bootstrap your environment:

    {{< hint type=important title="JSON instead of YAML">}}
If you are unable to install the [`powershell-yaml` module](https://www.powershellgallery.com/packages/powershell-yaml) (the ALZ module tries to install this automatically for you when invoked), you **can** use `.json` files instead; see [Configuration Files]({{< relref "configuration-files" >}}) for more information.
    {{< /hint >}}

    ```pwsh
    if(!$iacType) {
        throw "iacType variable is not set. Please set it to one of: 'bicep', 'terraform', or 'bicep-classic'."
    }

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
