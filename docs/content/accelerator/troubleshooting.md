---
title: Troubleshooting
weight: 15
---
Having trouble using the module and unable to find a solution in the Wiki?

If it isn't listed below, let us know about it in our [Issues](https://aka.ms/alz/acc/issues) log. We'll do our best to help and you may find your issue documented here.

## PowerShell ALZ Module Failing for non-obvious reasons

For example, when running `Deploy-Accelerator` you may see an error like:

- `Parameter cannot be processed because the parameter name 'i' is ambiguous. Possible matches include: -InformationAction -InformationVariable -alzIacProvider -userInputOverridePath.`

This is most likely because you are not using the most recent release of the PowerShell module. Update the module and try again. If that doesn't work, follow on below.

We have noted that some users have issues when they install the module in PowerShell 5.X instead of PowerShell 7.X. When you install a module in PowerShell 5.X (PS) it appears to override any modules installed with PowerShell 7.X (`pwsh`). In this scenario you need to uninstall the module from PS in order to be able to install it in `pwsh`.

Follow these steps to ensure you have a working environment:

1. Update the latest PowerShell Core / 7.X (`pwsh`) version.
2. Open a PS (PowerShell 5.1) terminal. You may need to be an administrator to do this.
3. Run `Uninstall-PSResource -Name ALZ`, then run `Get-InstalledPSResource -Name ALZ`
4. If the previous command shows a version of the module is still installed, then repeat the previous step until you no longer see an installed version.
5. Open a `pwsh` (PowerShell 7.X) terminal.
6. Run `Uninstall-PSResource -Name ALZ`, then run `Get-InstalledPSResource -Name ALZ`
7. If the previous command shows a version of the module is still installed, then repeat the previous step until you no longer see an installed version.
8. Run `Install-PSResource -Name ALZ`

You should now be able to successfully run the `Deploy-Accelerator` command and continue.

## 422 Error when deleting Runner Group

When trying to destroy a GitHub environment with a runner group you may see an error like:

`Error: DELETE https://api.github.com/orgs/<org>/actions/runner-groups/3: 422 This group cannot be deleted because it contains runners. Please remove or move them to another group before proceeding. []`

Unfortunately, this requires manual intervention at the moment. The runners do not delete themselves when the container instance is delete, so they will show in the offline state for 14 days prior to being deleted.

To resolve this, you can manually delete the runners from Runner Group in the GitHub UI. You can then re-run the destroy to complete the clean up.

This only affects you if you have Enterprise licensing and have chosen to use a Runner Group. More details can be found here: <https://docs.github.com/en/actions/hosting-your-own-runners/managing-self-hosted-runners/removing-self-hosted-runners>

## Error: creating Container Group

If you see the following error, it is due to region (e.g. swedencentral) stating it supports availability zones, but it does not support them for Azure Container Instance. There is no way to detect this with automation, so requires a manual workaround at this time.

In order to work around this issue, add the following setting to your input config file:

```yaml
# GitHub
runner_container_zone_support: false

# Azure DevOps
agent_container_zone_support: false
```

```text
╷
│ Error: creating Container Group (Subscription: "**754f66-****-4f64-****-221f0174ad4**"
│ Resource Group Name: "rg-alz-r14c67r424-agents-swedencentral-001"
│ Container Group Name: "aci-alz-r14c67r424-swedencentral-002"): polling after ContainerGroupsCreateOrUpdate: polling failed: the Azure API returned the following error:
│
│ Status: "Failed"
│ Code: "Failed"
│ Message: "The requested resource is not available in the location 'swedencentral' at this moment. Please retry with a different resource request or in another location. Resource requested: '2' CPU '4' GB memory 'Linux' OS"
│ Activity Id: ""
│
│ ---
│
│ API Response:
│
│ ----[start]----
│ {"id":"/subscriptions/**754f66-****-4f64-****-221f0174ad4**/resourceGroups/rg-alz-r14c67r424-agents-swedencentral-001/providers/Microsoft.ContainerInstance/containerGroups/aci-alz-r14c67r424-swedencentral-002","status":"Failed","startTime":"2024-11-29T11:15:39.9940663Z","properties":{"events":[{"count":1,"firstTimestamp":"2024-11-29T11:15:41.1163736Z","lastTimestamp":"2024-11-29T11:15:41.1163736Z","name":"InsufficientCapacity.","message":"The requested resource is not available in the location 'swedencentral' at this moment. Please retry with a different resource request or in another location. Resource requested: '2' CPU '4' GB memory 'Linux' OS","type":"Warning"}]},"error":{"message":"The requested resource is not available in the location 'swedencentral' at this moment. Please retry with a different resource request or in another location. Resource requested: '2' CPU '4' GB memory 'Linux' OS"}}
│ -----[end]-----
│
│
│   with module.azure.azurerm_container_group.alz["agent_02"],
│   on ../../modules/azure/container_instances.tf line 1, in resource "azurerm_container_group" "alz":
│    1: resource "azurerm_container_group" "alz" {
│
╵
```

## Error: Failed to delete resource - when destroying the platform landing zone on the module.management_groups.module.management_groups.azapi_resource.subscription_(platform subscription) resource

If you are trying to destroy your platform landing zone and you see three errors like the below, it is because you don't have permissions on the management group that it is trying to move the subscriptions to.

This is the default management group, in most cases `Tenant Root Group`. If you didn't use `Tenant Root Group` as your root parent management group for the deployment, you will recall that you had to move the platform subscriptions under the management group you defined. The bootstrap only applied permissions to that management group and therefore has no permissions on your default management group.

You have two options to resolve this:

1. Manually move the subscriptions back to the default management group or your chosen root management group before destroying the platform landing zone.
2. Change the default management group for your tenant to the management group you used for the platform landing zone.

```text
╷
│ Error: Failed to delete resource
│
│ deleting Resource: (ResourceId
│ "/providers/Microsoft.Management/managementGroups/levelup-identity/subscriptions/**754f66-****-4f64-****-221f0174ad4**"
│ / Api Version "2023-04-01"): DELETE
│ https://management.azure.com/providers/Microsoft.Management/managementGroups/levelup-identity/subscriptions/**754f66-****-4f64-****-221f0174ad4**
│ --------------------------------------------------------------------------------
│ RESPONSE 400: 400 Bad Request
│ ERROR CODE: BadRequest
│ --------------------------------------------------------------------------------
│ {
│   "error": {
│     "code": "BadRequest",
│     "message": "Permission to write and delete on resources of type 'Microsoft.Authorization/roleAssignments' is required on the subscription or its ancestors.",
│     "details": "Subscription ID: '/subscriptions/**754f66-****-4f64-****-221f0174ad4**'"
│   }
│ }
│ --------------------------------------------------------------------------------
│
╵
```