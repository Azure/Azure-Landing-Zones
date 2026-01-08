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

1. The wizard will guide you through:
    - **Target folder path**: Where to store configuration files (default: `~/accelerator`)
    - **Azure login**: If not already logged in, you'll be prompted to enter your Tenant ID and authenticate via device code
    - **Infrastructure as Code type**: Choose between Terraform or Bicep
    - **Version Control System**: Choose GitHub, Azure DevOps, or Local
    - **Terraform scenario**: If using Terraform, select from available scenarios (1-9)
    - **Configuration values**: Interactive prompts for bootstrap settings with:
        - Descriptions and help links for each input
        - Selection lists for Azure regions (with `[AZ]` indicator for Availability Zone support)
        - Selection lists for management groups and subscriptions
        - GUID validation for subscription and tenant IDs

1. After configuration, the wizard offers to open VS Code for final review of your configuration files.

1. Type `yes` when prompted to continue with deployment, or `no` to exit and configure later.

1. Once it generates the plan, hit enter to deploy the bootstrap.

    {{< hint type=tip >}}
You can now update your `Azure Landing Zone Terraform Accelerator Runner Registration` GitHub PAT (`token-2`) to restrict it to the main repository created by the bootstrap.
    {{< /hint >}}

1. For Bicep only, clone your newly created repository to your local machine and make any changes required to the parameter files. See the [Bicep getting started guide]({{< relref "../../bicep/gettingStarted" >}}) for more information on customizing the parameter files. Commit and push any changes to your repository. For the local file system option, you can make changes directly in the output folder.

---

## Next Steps

Now head to [Phase 3]({{< relref "../3_run" >}}).
