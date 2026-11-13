---
title: Known issues
geekdocCollapseSection: true
weight: 100
resources:
  - name: diagsetting-assignment
    src: img/diagsetting_assignment.png
    alt: Initiative assignment for diagnostic settings to Log Analytics
    title: ALZ Diag Setting Initiative Assignment
  - name: diagsetting-assignment-params
    src: img/diagsetting_assignment_parameters.png
    alt: The parameters in the assignment highlighting which needs to updated
    title: ALZ Diag Setting Initiative Assignment - Parameters
---

Azure landing zone is a set of reference implementations that provide guidance on how to deploy and manage Azure landing zone using the solutions we provide. These reference implementations are continuously updated to provide the best practices for deploying and managing Azure landing zone, and occasionally require the introduction of breaking changes to ensure the best possible experience for our customers.

This section lists known issues and workarounds for Azure landing zone.

## Policy: Diagnostic Settings to Log Analytics

Prior to May 2024, Azure landing zone provided custom policies and initiatives to enable diagnostic settings for all supported resources to send logs to Log Analytics. In May 2024, these policies and initiatives were deprecated and replaced with the product group published Azure Policy initiative definitions [Enable allLogs category group resource logging for supported resources to Log Analytics](https://www.azadvertizer.net/azpolicyinitiativesadvertizer/0884adba-2312-4468-abeb-5422caed1038.html) and [Enable audit category group resource logging for supported resources to Log Analytics](https://www.azadvertizer.net/azpolicyinitiativesadvertizer/f5b29bc4-feca-4cc6-a58a-772dd5e290a5.html).

With the transition to the built-in initiatives we made the decision to adopt the product group specified default values for parameters, which would simplify our ongoing management of assignments of these initiatives (and any future updates). This change has the following implications:

- In the ALZ custom policies and initiatives we had a parameters called `profileName` with a default value of `setbypolicy`. This parameter was used to register the Log Analytics sink for the diagnostic settings.
- The product group initiatives provide a more descriptive parameter called `diagnosticSettingName` with a default value of `setByPolicy-LogAnalytics`. Enhancing the parameter default value allows customers to configure additional sinks (targets) for diagnostic settings, currently including Event Hubs and Storage Accounts.
- Only a single sink type can be configured per resource, i.e. if you have a diagnostic setting that sends logs to Log Analytics, you cannot specify an additional Log Analytics sink in the same diagnostic setting.

This change has no impact on customers who have deployed an Azure Landing Zone after May 2024, as the new initiatives were already in use. However, customers who deployed Azure landing zone prior to May 2024 and have now updated their initiatives/assignments to use the built-in product group initiatives, will have issues remediating non-compliant resources because of the change in the name of the Log Analytics sink. Remediation will fail because the diagnostic setting is not found with the expected name, and will instead try a configure a new Log Analytics sink on resources with the new name.

The resulting error will contain text like `Data sink <resource id of your workspace> is already used in diagnostic settings 'setbypolicy' for category <category you configured previously>. Data sinks can't be reused in different settings on the same category for the same resource`.

### Workaround

To work around this issue, you can either:

- Delete the diagnostic setting that is non-compliant and let the initiative re-create it with the correct (updated) name. (Not recommended as it will take time for the diagnostic setting to be re-created and logs to start flowing again.)
- Update the initiative assignment to use the previous `profileName` parameter value of `setbypolicy` instead of the new `diagnosticSettingName` parameter value of `setByPolicy-LogAnalytics`. This will allow the initiative to remediate the non-compliant resources without issue.

Select the assignment:
{{< img name="diagsetting-assignment" size="origin" lazy=true >}}

Update the assignment parameter:
{{< img name="diagsetting-assignment-params" size="origin" lazy=true >}}

## Policy: Microsoft Defender for Cloud configuration remediation conflicts

The Deploy-MDFC-Config_20240319 initiative includes multiple DeployIfNotExists policies that configure Microsoft Defender for Cloud plans by deploying individual Microsoft.Security/pricings resources at subscription scope.

When multiple Defender for Cloud plans are non-compliant and remediated at the same time, the pricing updates can overlap. In this situation, some remediation deployments can succeed while others fail with a conflict similar to:

"Another update operation is in progress. Please retry in a few minutes"

As a result, not all selected Defender for Cloud plans might be enabled after the first remediation attempt. Policy compliance state and the Defender for Cloud configuration shown in the Azure portal might also take time to reflect completed changes.

### Workaround

If a remediation deployment fails with this conflict:

1. Allow the Defender for Cloud pricing operations that are already in progress to complete.
2. Re-evaluate policy compliance for the affected scope.
3. Identify the policy definitions in the initiative that remain non-compliant.
4. Create new remediation tasks for the remaining non-compliant policy definitions.
5. Verify the resulting Defender for Cloud pricing configuration after the remediation tasks complete.

Avoid starting multiple additional remediation attempts while Defender for Cloud pricing operations are still in progress, as this can result in further conflicts.

### Batch pricing alternative

The Azure built-in policy "Configure selected Microsoft Defender for Cloud plans with managed extensions" (27ac9ca0-9bc7-4f82-be36-a9023a132e01) configures selected Defender for Cloud plans through the Microsoft.Security/batchPricings resource. This reduces the need for separate pricing deployments when several supported Defender plans are enabled together.

The built-in policy is not a direct replacement for Deploy-MDFC-Config_20240319. For selected plans, it applies predefined subplans and managed extension settings. It does not currently expose the same level of fine-grained subplan and extension configuration available through the individual policies referenced by the Azure landing zone initiative.

Review the configuration requirements for each Defender for Cloud plan before deciding which approach is appropriate for your environment.
