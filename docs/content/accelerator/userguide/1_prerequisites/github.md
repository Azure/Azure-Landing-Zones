---
title: GitHub
geekdocCollapseSection: true
weight: 6
---

This section details the prerequisites for GitHub.

## GitHub Prerequisites

The accelerator does not support GitHub personal accounts, since they don't support all the features required for security. You must have a GitHub organization account or the accelerator will fail on apply. You can create a free organization [here](https://github.com/organizations/plan). Learn more about account types [here](https://docs.github.com/en/get-started/learning-about-github/types-of-github-accounts).

{{< hint type=note >}}
If you choose to use a `free` organization account the accelerator bootstrap will make your repositories public. It must do this to support the functionality required by the accelerator. This is not recommended for production environments.
{{< /hint >}}

## GitHub Personal Access Token (PAT)

{{< hint type=note >}}
The following instructions refer to `classic` personal access tokens. You can also use `fine-grained` access tokens which are still in beta to provide more granular permissions. These docs will be updated to reflect this in the future.
{{< /hint >}}

This first PAT is referred to as `token-1`.

1. Navigate to [github.com](https://github.com).
1. Click on your user icon in the top right and select `Settings`.
1. Scroll down and click on `Developer Settings` in the left navigation.
1. Click `Personal access tokens` in the left navigation and select `Tokens (classic)`.
1. Click `Generate new token` at the top and select `Generate new token (classic)`.
1. Enter `Azure Landing Zone Terraform Accelerator` in the `Note` field.
1. Alter the `Expiration` drop down and select `Custom`.
1. Choose tomorrows date in the date picker.
1. Check the following scopes:
    1. `repo`
    1. `workflow`
    1. `admin:org`
    1. `user`: `read:user`
    1. `user`: `user:email`
    1. `delete_repo`
1. Click `Generate token`.
1. Copy the token and save it somewhere safe.
1. If your organization uses single sign on, then click the `Configure SSO` link next to your new PAT.
1. Select your organization and click `Authorize`, then follow the prompts to allow SSO.

If you are using self-hosted runners, you will need to create a second PAT that we'll refer to as `token-2` for them. You can do this by following the steps above with the following differences:

1. Select `No expiration` for the `Expiration` field. NOTE: You may want to set an expiration date for security reasons, but you will need to have a process in place to regenerate the token in that scenario.
1. The scope required depends on the type of organization you are using:
    1. If you are using a Free organization or an Enterprise organization without a runner group, select only the `repo` scope.
    1. If you are using an Enterprise organization and a runner group, select the `admin:org` scope for classic tokens (or `organization_self_hosted_runners:write` for fine-grained tokens).
