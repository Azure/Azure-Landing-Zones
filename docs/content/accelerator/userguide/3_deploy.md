---
title: Phase 3 - Run
weight: 5
---

Phase 3 of the accelerator is to run pipeline. Follow the steps below to do that.

## Deploy the Landing Zone

Now that you have created your bootstrapped environment you can deploy you Azure landing zone by triggering the continuous delivery pipeline in your version control system.

{{< hint type=note >}}
If you encounter permission errors while running the pipelines, please note that it may take some time for permissions to fully propagate. Although the pipelines include retry logic to manage this, it can sometimes take up to 30 minutes for the permissions to take effect.
{{< /hint >}}

{{< hint type=note >}}
If you have questions regarding boostrap clean up, in the case you were testing or made a mistake, see the [FAQs - Questions about boostrap clean up]({{< relref "../faq/#questions-about-bootstrap-clean-up">}})
{{< /hint >}}

### Azure DevOps

1. Navigate to [dev.azure.com](https://dev.azure.com) and sign in to your organization.
1. Navigate to your project.
1. Click `Pipelines` in the left navigation.
1. Click the `02 Azure Landing Zones Continuous Delivery` pipeline.
1. Click `Run pipeline` in the top right.
1. Take the defaults and click `Run`.
1. Your pipeline will run a `plan`.
1. If you provided `apply_approvers` to the bootstrap, it will prompt you to approve the `apply` stage.
1. Your pipeline will run an `apply` and deploy an Azure landing zone based on the starter module you choose.

### GitHub

1. Navigate to [github.com](https://github.com).
1. Navigate to your repository.
1. Click `Actions` in the top navigation.
1. Click the `02 Azure Landing Zones Continuous Delivery` pipeline in the left navigation.
1. Click `Run workflow` in the top right, then keep the default branch and click `Run workflow`.
1. Your pipeline will run a `plan`.
1. If you provided `apply_approvers` to the bootstrap, it will prompt you to approve the `apply` job.
1. Your pipeline will run an `apply` and deploy an Azure landing zone based on the starter module you choose.

### Local file system

Follow the steps below to deploy the landing zone locally. If you want to hook it up to you custom version control system, follow their documentation on how to that.

#### Bicep

The Bicep option outputs a `deploy-local.ps1` file that you can use to deploy the ALZ.

{{< hint type=note >}}
If you set the `grant_permissions_to_current_user` input to `false` in the bootstrap, you will need to set permissions on your management group, subscriptions and storage account before the commands will succeed.
{{< /hint >}}

1. Ensure you have the latest versions of the [AZ PowerShell Module](https://learn.microsoft.com/powershell/azure/install-azure-powershell) and [Bicep](https://learn.microsoft.com/azure/azure-resource-manager/bicep/install) installed.
1. Open a new PowerShell Core (pwsh) terminal or use the one you already have open.
1. Navigate to the directory shown in the `module_output_directory_path` output from the bootstrap.
1. Login to Azure using `Connect-AzAccount -TenantId 00000000-0000-0000-0000-000000000000 -SubscriptionId 00000000-0000-0000-0000-000000000000`.
1. (Optional) Examine the `./scripts/deploy-local.ps1` to understand what it is doing.
1. Run `./scripts/deploy-local.ps1`.
1. A what if will run and then you'll be prompted to check it and run the deploy.
1. Type `yes` and hit enter to run the deploy.
1. The ALZ will now be deployed, this may take some time.

#### Terraform

The Terraform option outputs a `deploy-local.ps1` file that you can use to deploy the ALZ.

{{< hint type=note >}}
If you set the `grant_permissions_to_current_user` input to `false` in the bootstrap, you will need to set permissions on your management group, subscriptions and storage account before the commands will succeed.
{{< /hint >}}

1. Open a new PowerShell Core (pwsh) terminal or use the one you already have open.
1. Navigate to the directory shown in the `module_output_directory_path` output from the bootstrap.
1. (Optional) Ensure you are still logged in to Azure using `az login --tenant 00000000-0000-0000-0000-000000000000`.
1. (Optional) Connect to your target subscription using `az account set --subscription 00000000-0000-0000-0000-000000000000`.
1. (Optional) Examine the `./scripts/deploy-local.ps1` to understand what it is doing.
1. Run `./scripts/deploy-local.ps1`.
1. A plan will run and then you'll be prompted to check it and run the deploy.
1. Type `yes` and hit enter to run the deploy.
1. The ALZ will now be deployed, this may take some time.

## Fin

This concludes the accelerator. You now have a fully deployed Azure landing zone.
If you have any issues, please raise them in the [GitHub issues](https://aka.ms/alz/acc/issues).
