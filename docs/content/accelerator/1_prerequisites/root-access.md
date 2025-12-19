---
title: Root Access
weight: 200
---

## Root Access Configuration

In order to successfully deploy the Platform landing zone using AVM Bicep, you need to ensure that the account you are using has at least `User Access Administrator` permissions at the root (`/`) level.

### Assign Root Access to your User Account

Follow the steps in the [Microsoft Documentation](https://learn.microsoft.com/en-us/azure/role-based-access-control/elevate-access-global-admin) to elevate to root access. Once you have followed those steps you'll have the permissions required to proceed.

{{< hint type=warning >}}
Be sure to remove the elevated access once you have completed the bootstrap process to maintain security best practices.
{{< /hint >}}

### Assigning Root Access to a Service Principal or another User Account

If you want to assign the `User Access Administrator` role to a Service Principal or another User account, you can do that via Azure CLI. You'll need to have followed the previous steps to ensure you have the required permissions before running this command.

1. Open a PowerShell terminal using PowerShell 7.
1. Login to Azure CLI and select your tenant:

    ```pwsh
    az login --tenant "<tenant-id>" --use-device-code
    ```

1. Run the following command to assign the `User Access Administrator` role at the root level:

    ```pwsh
    az role assignment create `
      --assignee "<service-principal-or-user-object-id-or-name>" `
      --role "User Access Administrator" `
      --scope "/"
    ```
