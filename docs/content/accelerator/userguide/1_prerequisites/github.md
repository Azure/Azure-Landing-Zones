---
title: GitHub
geekdocCollapseSection: true
weight: 7
---

This section details the prerequisites for GitHub.

## GitHub Prerequisites

The accelerator does not support GitHub personal accounts, since they don't support all the features required for security. You must have a GitHub organization account or the accelerator will fail on apply. You can create a free organization [here](https://github.com/organizations/plan). Learn more about account types [here](https://docs.github.com/en/get-started/learning-about-github/types-of-github-accounts).

{{< hint type=note >}}
If you choose to use a `free` organization account the accelerator bootstrap will make your repositories public. It must do this to support the functionality required by the accelerator. This is not recommended for production environments.
{{< /hint >}}

## GitHub Personal Access Token (PAT)

This first PAT is referred to as `token-1`.

1. Navigate to [github.com](https://github.com).
1. Click on your user icon in the top right and select `Settings`.
1. Scroll down and click on `Developer Settings` in the left navigation.
1. Click `Personal access tokens` in the left navigation and select `Fine-grained tokens`.
1. Click `Generate new token` at the top.
1. Enter `Azure Landing Zone Terraform Accelerator` in the `Token name` field.
1. Alter the `Resource owner` drop down and select your organization.
1. Alter the `Expiration` drop down and select `Custom`.
1. Choose tomorrows date in the date picker.
1. Alter the `Repository access` radio button and select `All repositories`.
1. Add the following `Repository` permissions:
    1. `Actions`: `Read and write`
    1. `Administration`: `Read and write`
    1. `Contents`: `Read and write`
    1. `Environments`: `Read and write`
    1. `Secrets`: `Read and write`
    1. `Variables`: `Read and write`
    1. `Workflows`: `Read and write`
1. Add the following `Organization` permissions:
    1. `Members`: `Read and write`
    1. `Self-hosted runners`: `Read and write`  Only required if you plan to use Runner Groups at the organization level.
1. Click `Generate token`.
1. Copy the token and save it somewhere safe.

If you are using self-hosted runners, you will need to create a second PAT that we'll refer to as `token-2` for them. You can do this by following these steps:

1. Select `No expiration` for the `Expiration` field.

    {{< hint type=note >}}
You may want to set a shorter expiration date for security reasons. In either case, you will need to have a process in place to extend expiration the token before it expires.
    {{< /hint >}}

1. Navigate to [github.com](https://github.com).
1. Click on your user icon in the top right and select `Settings`.
1. Scroll down and click on `Developer Settings` in the left navigation.
1. Click `Personal access tokens` in the left navigation and select `Fine-grained tokens`.
1. Click `Generate new token` at the top.
1. Enter `Azure Landing Zone Terraform Accelerator Runner Registration` in the `Token name` field.
1. Alter the `Resource owner` drop down and select your organization.
1. Alter the `Expiration` drop down and select `Custom`.
1. Choose tomorrows date in the date picker.
1. Alter the `Repository access` radio button and select `All repositories`.
    {{< hint type=note >}}
You can should this post bootstrap deployment to limit access to only the repository where you will be using self-hosted runner. We'll remind you to do this in the next steps after the bootstrap is complete.
    {{< /hint >}}
1. Add the following `Repository` permissions:
    1. `Administration`: `Read and write`
1. Add the following `Organization` permissions:
    1. `Self-hosted runners`: `Read and write`  Only required if you plan to use Runner Groups at the organization level.
1. Click `Generate token`.
1. Copy the token and save it somewhere safe.
