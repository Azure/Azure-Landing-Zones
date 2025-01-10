---
title: Azure DevOps
geekdocCollapseSection: true
weight: 6
---

This section details the prerequisites for Azure DevOps.

## Azure DevOps Prerequisites

When you first create an Azure DevOps organization, it will not have any Microsoft-hosted agents available. If you intend to use Microsoft-hosted agents, you must either license your org or request a free pipeline.

1. Setup billing for your organization: [Set up billing for your organization](https://learn.microsoft.com/azure/devops/organizations/billing/set-up-billing-for-your-organization-vs?view=azure-devops)
2. Check for and request a free pipeline via the form here: [Configure and pay for parallel jobs](https://learn.microsoft.com/azure/devops/pipelines/licensing/concurrent-jobs?view=azure-devops&tabs=ms-hosted#how-much-do-parallel-jobs-cost)

If you choose the billing option, you'll then need to purchase at least one parallel pipeline. You can do this by following the instructions here: [Configure and pay for parallel jobs](https://learn.microsoft.com/azure/devops/pipelines/licensing/concurrent-jobs?view=azure-devops&tabs=ms-hosted#how-do-i-buy-more-parallel-jobs).

## Azure DevOps Personal Access Token (PAT)

This first PAT is referred to as `token-1`.

1. Navigate to [dev.azure.com](https://dev.azure.com) and sign in to your organization.
1. Ensure you navigate to the organization you want to deploy to.
1. Click the `User settings` icon in the top right and select `Personal access tokens`.
1. Click `+ New Token`.
1. Enter `Azure Landing Zone Terraform Accelerator` in the `Name` field.
1. Alter the `Expiration` drop down and select `Custom defined`.
1. Choose tomorrows date in the date picker.
1. Click the `Show all scopes` link at the bottom.
1. Check the following scopes:
    1. `Agent Pools`: `Read & manage`
    1. `Build`: `Read & execute`
    1. `Code`: `Full`
    1. `Environment`: `Read & manage`
    1. `Graph`: `Read & manage`
    1. `Pipeline Resources`: `Use & manage`
    1. `Project and Team`: `Read, write & manage`
    1. `Service Connections`: `Read, query & manage`
    1. `Variable Groups`: `Read, create & manage`
1. Click `Create`.
1. Copy the token and save it somewhere safe.
1. Click `Close`.

If you are using self-hosted runners, you will need to create a second PAT that we'll refer to as `token-2` for them. You can do this by following the steps above with the following differences:

1. Select the maximum value for the `Expiration` field (this allows up to 1 year). 

    {{< hint type=note >}}
You may want to set a shorter expiration date for security reasons. In either case, you will need to have a process in place to extend expiration the token before it expires.
    {{< /hint >}}

1. Select only the `Agent Pools`: `Read & manage` scope.
