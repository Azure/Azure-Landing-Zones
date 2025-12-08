---
title: Platform Landing Zone Cleanup FAQ
weight: 20
---

To remove and redeploy, follow these steps in order:

1. Remove the platform landing zone
1. Remove the bootstrap resources

If you've lost your bootstrap folder or encounter errors, see the fallback option at the end of this section.

## How do I remove the bootstrap resources and start again?

Follow these steps to teardown the bootstrap environment.

1. If you already ran the CD pipeline / action in phase 3 to deploy the ALZ, then review the [How do I remove the platform landing zones]({{< relref "#how-do-i-remove-the-platform-landing-zone-and-start-again">}}) guidance.
1. Wait for the destroy run to complete before moving to the next step, you will need to approve it if you configured approvals.
1. Now run `Deploy-Accelerator` with the `-destroy` flag, for example:

    ```pwsh
    Deploy-Accelerator `
      -inputs "~/accelerator/config/inputs.yaml", "~/accelerator/config/platform-landing-zone.tfvars" `
      -output "~/accelerator/output" `
      -destroy

    ```

1. You can confirm the destroy by hitting enter when prompted.
1. To fully clean up, you should now delete the folder that was created for the accelerator.
1. You'll now be able to run the `Deploy-Accelerator` command again to start fresh.

## How do I remove the platform landing zone and start again?

{{< hint type=note >}}
The following guidance is for Terraform, if you're using Bicep and wish to destroy your landing zone, please refer to the [destroy-landing-zone.ps1](https://github.com/Azure/ALZ-Bicep/blob/main/accelerator/scripts/destroy-landing-zone.ps1) script.
{{< /hint >}}

### Azure DevOps or GitHub

1. Run the CD pipeline / action in phase 3, but this time select the `destroy` option. This will delete the landing zone resources; you will need to approve it if you configured approvals.

### Local

1. Navigate to the directory shown in the `module_output_directory_path` output from the bootstrap.
1. Run `./scripts/deploy-local.ps1 -destroy`.
1. A plan will run and then you’ll be prompted to check it and run the deploy.
1. Type yes and hit enter to run the deploy.
1. The ALZ will now be destroyed, this may take some time.

## I can't find my original bootstrap folder or I am getting errors, how do I clean up?

If you have lost your original bootstrap folder or are getting errors when trying to destroy the landing zone, you can follow these steps to clean up the resources manually.

1. Open a PowerShell terminal using PowerShell 7.
1. Ensure you have the latest version of the [ALZ PowerShell Module](https://www.powershellgallery.com/packages/ALZ) installed:

    ```powershell
    Install-PSResource -Name ALZ -Force -AllowClobber
    ```

1. Login to Azure CLI and select your bootstrap subscription:

    ```powershell
    az login --tenant "<tenant-id>" --use-device-code
    az account set --subscription "<subscription-id>"
    ```

1. Run one of the following commands to prepare to remove the platform landing zone:

    1. If you used a specific management group as the parent management group during bootstrap, you can specify that management group to delete the landing zone. For example:

        ```powershell
        Remove-PlatformLandingZone `
          -ManagementGroups = "<root-parent-management-group-id>" `
          -PlanMode
        ```

    1. If you choose to use the Tenant Root Group as the parent management group and you are brownfield, you may need to avoid deleting other management group structures. In that case, you can specify the top level management groups to delete. For example:

        ```powershell
        Remove-PlatformLandingZone `
          -ManagementGroups = "alz" `
          -DeleteTargetManagementGroups `
          -PlanMode
        ```

1. Review the plan output to ensure it is going to delete the correct resources.
1. If the plan looks correct, re-run the command without the `-PlanMode` parameter to delete the platform landing zone.
1. If you chose the second option, you'll still need to clean up the custom role definitions on Tenant Root Group before you can re-run the accelerator bootstrap.
    1. Navigate to the Azure Portal and go to the `Management Groups` pane.
    1. Select the `Tenant Root Group`.
    1. Go to the `Access control (IAM)` section.
    1. Select the `Roles` tab.
    1. Find and delete any custom roles that were created by the accelerator. These will likely have `alz` in the name. Delete all 4 of them. If they are still assigned anywhere, you will need to remove the assignments first.
