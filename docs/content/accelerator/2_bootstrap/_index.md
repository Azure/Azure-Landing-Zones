---
title: Phase 2 - Bootstrap
geekdocCollapseSection: true
weight: 30
---

{{< hint type=info >}}
If you prefer more control over the configuration process, see the [Advanced Usage]({{< relref "advanced" >}}) guide for manual configuration.
{{< /hint >}}

Follow these instructions to bootstrap your Version Control System and Azure ready to deploy your Platform landing zone.

## Interactive Mode

The simplest way to get started is to use the interactive wizard which guides you through all the required inputs.

1. Run the following command to install or update the ALZ PowerShell module:

    ```pwsh
    $alzModule = Get-InstalledPSResource -Name ALZ 2>$null
    if (-not $alzModule) {
        Install-PSResource -Name ALZ
    } else {
        Update-PSResource -Name ALZ
    }

    ```

1. Run the accelerator with no parameters to start the interactive wizard:

    ```pwsh
    Deploy-Accelerator

    ```

1. The wizard will guide you through a series of prompts to collect the necessary information for your bootstrap configuration. Provide the required inputs based on your preferences for infrastructure as code, version control system, and other settings.

    {{< hint type=info >}}
The interactive mode wizard only completes the bootstrap configuration file (`inputs.yaml`) for you. You will still need to review and update your platform landing zone configuration file with the required region values before proceeding with the deployment. The wizard will prompt you to do this after it completes the bootstrap configuration.
    {{< /hint >}}

1. After configuration, the wizard offers to open VS Code for final review of your configuration files. You MUST update your platform landing zone configuration file at this stage before proceeding.

    1. Open your bootstrap configuration file in VS Code. The file is located at `./config/inputs.yaml` in your target directory.
    1. Review the bootstrap configuration settings and ensure they are correct.
    1. Save any changes to the configuration file.
    1. Open the relevant section below for the platform landing zone configuration file:

    {{< expand "Terraform Platform Landing Zone Configuration File" "..." >}}
1. Open your platform landing zone configuration file in VS Code. The file is located at `./config/platform-landing-zone.tfvars` in your target directory.
1. Update the following settings in the platform landing zone configuration file:
    - `starter_locations`: you must update all the `<region-#>` placeholders with valid Azure regions for your Platform landing zone.
    - `defender_email_security_contact`: (Terraform only) this must be updated to include an email address for your security contact for Microsoft Defender for Cloud alerts.
1. Save any changes to the configuration file.
1. Now head over to the [Options documentation]({{< relref "../starter-terraform/options" >}}) to review any additional settings you may want to configure for your deployment.
    {{< /expand >}}

    {{< expand "Bicep Platform Landing Zone Configuration File" "..." >}}
1. Open your platform landing zone configuration file in VS Code. The file is located at `./config/platform-landing-zone.yaml` in your target directory.
1. Update the following settings in the platform landing zone configuration file:
    - `starter_locations`: you must update all the `<region-#>` placeholders with valid Azure regions for your Platform landing zone.
1. Save any changes to the configuration file.
    {{< /expand >}}

    {{< hint type=warning >}}
Do not continue until you have updated your platform landing zone configuration file with the required values. You must supply the regions for your platform landing zone deployment in this file before the bootstrap can proceed.
    {{< /hint >}}

1. Type `yes` when prompted to continue with deployment, or `no` to exit and configure later.

1. Once it generates the plan, hit enter to deploy the bootstrap.

    {{< hint type=tip >}}
You can now update your `Azure Landing Zone Terraform Accelerator Runner Registration` GitHub PAT (`token-2`) to restrict it to the main repository created by the bootstrap.
    {{< /hint >}}

1. For Bicep only, clone your newly created repository to your local machine and make any changes required to the parameter files. See the [Bicep getting started guide]({{< relref "../../bicep/gettingStarted" >}}) for more information on customizing the parameter files. Commit and push any changes to your repository. For the local file system option, you can make changes directly in the output folder.

---

## Next Steps

Now head to [Phase 3]({{< relref "../3_run" >}}).
