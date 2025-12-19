---
title: Root Access
weight: 200
---

## Root Access Configuration

In order to successfully deploy the Azure Landing Zone using Bicep (AVM), you need to ensure that the account you are using has at least `User Access Administrator` permissions at the root (`/`) level.

You can read more about this access level in the [Microsoft Documentation](https://learn.microsoft.com/en-us/azure/role-based-access-control/elevate-access-global-admin).

Follow the steps below to assign the required permissions:

1. Navigate to the [Azure Portal](https://portal.azure.com) and sign in to your tenant.
1. You'll need to be in the `Global Administrator` role for the followings steps. If you don't have that role, request it from your Azure AD administrator or PIM elevate to it if you are able to.
1. Search for `Azure Entra ID` and click to navigate to the Entra ID view.
1. Click on `Properties` under the `Manage` section in the left navigation pane.
1. Under `Access management for Azure resources`, set the toggle to `Yes` to enable the setting `manage access to all Azure subscriptions and management groups in this tenant`.

That's it! You can now proceed with the bootstrap process.

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
