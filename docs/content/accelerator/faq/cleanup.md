---
title: Cleanup FAQ
weight: 20
---

There are two parts to cleaning up your accelerator bootstrap and Platform landing zone deployment:

1. Remove the Platform landing zone
1. Remove the bootstrap resources

For convenience we provide a PowerShell cmdlet called `Remove-PlatformLandingZone` to help with the Platform landing zone and the Microsoft Azure portion of these tasks. We recommend you use this cmdlet to clean up after testing as it is faster than using the Terraform destroy option of the Continuous Delivery Pipeline.

## Steps to clean up the Accelerator Bootstrap and Platform landing zone Microsoft Azure resources

1. Open a PowerShell terminal using PowerShell 7.
1. Ensure you have the latest version of the [ALZ PowerShell Module](https://www.powershellgallery.com/packages/ALZ) installed:

    ```pwsh
    $alzModule = Get-InstalledPSResource -Name ALZ 2>$null
    if (-not $alzModule) {
        Install-PSResource -Name ALZ
    } else {
        Update-PSResource -Name ALZ
    }

    ```

1. Login to Azure CLI and select your bootstrap subscription:

    ```pwsh
    az login --tenant "<tenant-id>" --use-device-code
    az account set --subscription "<bootstrap-subscription-id>"

    ```

1. Run the following command to prepare to remove the Platform landing zone:

    {{< hint type=tip >}}
If you are in a brownfield environment and your Management Groups or Platform subscriptions contain resource you do not wish to delete, you can use the `-ResourceGroupsToRetainNamePatterns` and `-ManagementGroupsToDeleteNamePatterns` parameters to be specific about what to delete / retain. See the [Remove-PlatformLandingZone documentation](https://github.com/Azure/ALZ-PowerShell-Module/blob/main/src/ALZ/Public/Remove-PlatformLandingZone.ps1) for more details on the available parameters.
    {{< /hint >}}

    The following describes the required parameters:

    - `-ManagementGroups`: (Required) The root parent management group ID under which the Platform landing zone management groups were created
    - `-Subscriptions`: (Recommended Optional) A comma-separated list of the Platform landing zone subscription IDs (management, connectivity, identity, security). We set this for scenarios where a full deployment wasn't completed and the subscriptions are not nested under the management group hierarchy.
    - `-AdditionalSubscriptions`: (Optional) A comma-separated list of any additional subscription IDs that were used during deployment that are outside of the Platform landing zone subscriptions (e.g. the bootstrap subscription in 5 subscription model)
    - `-SubscriptionsTargetManagementGroup`: (Optional) The management group ID under which the Platform landing zone subscriptions were moved to. Only required if this is not the Tenant Root Group.
    - `-PlanMode`: (Optional) Runs the cmdlet in plan mode to show what resources will be deleted without actually deleting them.

    ```pwsh
    Remove-PlatformLandingZone `
      -ManagementGroups "<root-parent-management-group-id>" `
      -Subscriptions "<management-subscription-id>", "<connectivity-subscription-id>", "<identity-subscription-id>", "<security-subscription-id>" `
      -AdditionalSubscriptions "<bootstrap-subscription-id>" `
      -SubscriptionsTargetManagementGroup "<root-parent-management-group-id>" `
      -PlanMode

    ```

1. Review the plan output to ensure it is going to delete the correct resources
1. If the plan looks correct, re-run the command without the `-PlanMode` parameter to delete the Platform landing zone

    ```pwsh
    Remove-PlatformLandingZone `
      -ManagementGroups "<root-parent-management-group-id>" `
      -Subscriptions "<management-subscription-id>", "<connectivity-subscription-id>", "<identity-subscription-id>", "<security-subscription-id>"  `
      -AdditionalSubscriptions "<bootstrap-subscription-id>" `
      -SubscriptionsTargetManagementGroup "<root-parent-management-group-id>"

    ```

1. You'll be prompted to confirm you want to proceed, follow the instructions to run the deletions

## Steps to clean up version control system resources

If you still have your folder structure created during bootstrap, you can re-run the `Deploy-Accelerator` cmdlet with the `-Destroy` parameter to remove any version control system resources created during bootstrap

{{< hint type=warning >}}
If you lost your folder structure, you'll need to manually delete the version control system resources such as projects or repositories, agent pools, and teams.
{{< /hint >}}

### Interactive mode

{{< hint type=tip >}}
Even if you deployed with advanced mode, you should still be able to use this method as long as you have the standard folder structure created during bootstrap.
{{< /hint >}}

If you deployed the using the [interactive]({{< ref "../2_bootstrap" >}}) deployment mode, follow these steps:

1. Open a PowerShell terminal using PowerShell 7.
1. Run the following command to prepare to remove the Platform landing zone and bootstrap resources:

    ```pwsh
    Deploy-Accelerator -Destroy
    ```

1. Follow the prompts and supply the values if needed.
1. Once it generates the plan, hit enter to destroy the bootstrap resources.

### Advanced mode

If you deployed the using the [advanced]({{< ref "../2_bootstrap/advanced" >}}) deployment mode, follow these steps:

1. Open a PowerShell terminal using PowerShell 7.

1. Set your variables for the Infrastructure as Code type and the target folder path where your folder structure is located:

    ```pwsh
    $iacType = "terraform" # Set to 'bicep', 'terraform', or 'bicep-classic'
    $targetFolderPath = "~/accelerator"

    ```

1. Login to Azure CLI and select your bootstrap subscription:

    This is required even though we already deleted our Azure resources as the Terraform provider needs valid credentials to query that they have been deleted.

    ```pwsh
    az login --tenant "<tenant-id>" --use-device-code
    az account set --subscription "<bootstrap-subscription-id>"

    ```

1. If you set your Version Control System personal access tokens (PATs) as environment variables during bootstrap, ensure they are still set in your current terminal session or set them again.

1. Run the following command to remove the version control system resources created during bootstrap:

    {{< hint type=warning >}}
If you are using GitHub and you deployed GitHub Actions Runner Groups, will need to manually delete any agents from the Runner Groups before running this command, due to limitation of the GitHub API. More details can be found in [here](<{{< ref "../troubleshooting" >}}>).
    {{< /hint >}}

    ```pwsh
    if(!$iacType) {
        throw "iacType variable is not set. Please set it to one of: 'bicep', 'terraform', or 'bicep-classic'."
    }

    if($iacType -eq "terraform") {
        Deploy-Accelerator `
            -inputs "$targetFolderPath/config/inputs.yaml", "$targetFolderPath/config/platform-landing-zone.tfvars" `
            -starterAdditionalFiles "$targetFolderPath/config/lib" `
            -output "$targetFolderPath/output" `
            -destroy
    }

    if($iacType -eq "bicep") {
        Deploy-Accelerator `
            -inputs "$targetFolderPath/config/inputs.yaml", "$targetFolderPath/config/platform-landing-zone.yaml" `
            -output "$targetFolderPath/output" `
            -destroy
    }

    if($iacType -eq "bicep-classic") {
        Deploy-Accelerator `
            -inputs "$targetFolderPath/config/inputs.yaml" `
            -output "$targetFolderPath/output" `
            -destroy
    }

    ```

1. Once it generates the plan, hit enter to destroy the bootstrap resources.
