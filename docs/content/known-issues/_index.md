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

## Policy: Deploy-ASC-Monitoring version mismatch in Azure Government

When deploying ALZ Terraform (AVM) in Azure US Government (`AzureUSGovernment`), the `Deploy-ASC-Monitoring` policy assignment fails during the `alz_architecture` data source read with an error similar to the following:

```text
architectureDataSource.Read() Error creating architecture ...
Hierarchy.FromArchitecture: recursion error on architecture ...
Hierarchy.recurseAddManagementGroup: adding management group ...: Hierarchy.AddManagementGroup:
adding mg ...: error getting policy definitions from Azure:
Alzlib.GetDefinitionsFromAzure: error getting built-in policy set definitions:
Alzlib.getBuiltInPolicySets: error getting specific version '57.*.*' of built-in policy set definition
for '1f3afdf9-d0c9-4c3d-847f-89da613e70a8': no version found constraint 57.*.*
```

The root cause is that the ALZ Library pins the `Deploy-ASC-Monitoring` assignment to `definitionVersion: "57.*.*"` of the [Microsoft Cloud Security Benchmark](https://www.azadvertizer.net/azpolicyinitiativesadvertizer/1f3afdf9-d0c9-4c3d-847f-89da613e70a8.html) built-in policy set initiative (`1f3afdf9-d0c9-4c3d-847f-89da613e70a8`). Azure US Government typically carries an older major version of this initiative and the pinned version constraint cannot be satisfied.

{{< hint type=warning >}}
Using a `policy_assignment_override.json` file in your local library with a `definitionVersion` field will **not** resolve this issue. The ALZ Library override schema does not support overriding the `definitionVersion` property on an existing assignment.
{{< /hint >}}

### Workaround

Use the [library overwrite feature]({{< relref "customLibrary" >}}) to replace the `Deploy-ASC-Monitoring` assignment definition with one that specifies a `definitionVersion` that is available in your Azure US Government tenant.

**1. Find the version available in your Azure US Government tenant**

Set the Azure CLI to the Azure Government cloud and query the initiative:

```bash
az cloud set --name AzureUSGovernment
az login
az policy set-definition show \
  --name "1f3afdf9-d0c9-4c3d-847f-89da613e70a8" \
  --query "properties.version" \
  --output tsv
```

Note the version returned (e.g. `47.39.0`). Use its major version as the `definitionVersion` constraint in the next step (e.g. `47.*.*`).

**2. Enable library overwrites in the provider block**

```hcl
provider "alz" {
  library_overwrite_enabled = true

  library_references = [
    {
      path = "platform/alz"
      tag  = "2025.09.3" # replace with your pinned library version
    },
    {
      custom_url = "${path.root}/lib"
    }
  ]
}
```

**3. Create the replacement policy assignment file**

Create `lib/policy_assignments/Deploy-ASC-Monitoring.alz_policy_assignment.json` in your custom library, replacing `<MAJOR_VERSION>` with the major version you found in step 1 (e.g. `47`):

```json
{
  "type": "Microsoft.Authorization/policyAssignments",
  "apiVersion": "2024-04-01",
  "name": "Deploy-ASC-Monitoring",
  "location": "${default_location}",
  "dependsOn": [],
  "identity": {
    "type": "SystemAssigned"
  },
  "properties": {
    "description": "Microsoft Cloud Security Benchmark policy initiative.",
    "displayName": "Microsoft Cloud Security Benchmark",
    "policyDefinitionId": "/providers/Microsoft.Authorization/policySetDefinitions/1f3afdf9-d0c9-4c3d-847f-89da613e70a8",
    "definitionVersion": "<MAJOR_VERSION>.*.*",
    "enforcementMode": "Default",
    "nonComplianceMessages": [
      {
        "message": "Microsoft Cloud Security Benchmark {enforcementMode} be met."
      }
    ],
    "parameters": {},
    "scope": "/providers/Microsoft.Management/managementGroups/placeholder",
    "notScopes": []
  }
}
```

After adding the file, run `terraform init` and `terraform plan` to verify the assignment now resolves correctly.

{{< hint type=note >}}
The `definitionVersion` available in Azure Government may differ from the version in Azure Commercial and may be updated over time. Check periodically that the version constraint in your override file still satisfies a version available in your tenant.
{{< /hint >}}

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