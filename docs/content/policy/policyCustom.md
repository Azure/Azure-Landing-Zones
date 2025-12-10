---
title: Custom Policy and ALZ
weight: 9
geekdocCollapseSection: true
---

<link rel="stylesheet" href="/Azure-Landing-Zones/css/dark-code.css">
<div class="dark-code-page">

This information documents considerations for creating and managing custom Azure Policy definitions within the Azure Landing Zones (ALZ) framework.

When implementing custom policies in ALZ, it is essential to ensure that they align with the overall governance strategy and do not conflict with existing built-in policies. Custom policies should be designed to address specific organizational requirements while adhering to best practices for policy management.

### Custom Policy Versioning

{{< hint type=important >}}
This section refers to versioning of custom policies within ALZ, which is separate from the Azure Policy versioning schema described in the [Policy Versioning]({{< relref "policyVersioning" >}}) document.
{{< /hint >}}

Each policy definition and initiative contains a version in its metadata section:
```json
"metadata": {
   "version": "1.0.0",
   "category": "{categoryName}",
   "source": "https://github.com/Azure/Enterprise-Scale/",
   "alzCloudEnvironments": [
      "AzureCloud",
      "AzureChinaCloud",
      "AzureUSGovernment"
   ]
}
```
To track and review policy and initiative versions, please refer to [AzAdvertizer](https://www.azadvertizer.net/index.html).

This version is incremented according to the following rules (subject to change):
   - **Major Version** (**1**.0.0)
      - Policy Definitions
         - Rule logic changes
         - ifNotExists existence condition changes
         - Major changes to the effect of the policy (i.e. adding a new resource to a deployment)
      - Policy Set Definitions
         - Addition or removal of a policy definition from the policy set
   - **Minor Version** (1.**0**.0)
      - Policy Definitions
         - Changes to effect details that don't meet the major version criteria
         - Adding new parameter allowed values
         - Adding new parameters (with default values)
         - Other minor changes to existing parameters
      - Policy Set Definitions
         - Adding new parameter allowed values
         - Adding new parameters (with default values)
         - Other minor changes to existing parameters
   - **Patch Version** (1.0.**0**)
      - Policy Definitions
         - String changes (displayName, description, etc…)
         - Other metadata changes
      - Policy Set Definitions
         - String changes (displayName, description, etc…)
         - Other metadata changes
   - **Suffix**
      - Append "-preview" to the version if the policy is in a preview state
         - Example:  1.3.2-preview
      - Append "-deprecated" to the version if the policy is in a deprecated state
         - Example:  1.3.2-deprecated

## Preview and deprecated policies

This section aims to explain what it means when a built-in policy has a state of ‘preview’ or ‘deprecated’.

Policies can be in preview because a property (alias) referenced in the policy definition is in preview, or the policy is newly introduced and would like additional customer feedback. A policy may get deprecated when the property (alias) becomes deprecated & not supported in the resource type's latest API version, or when there is manual migration needed by customers due to a breaking change in a resource type's latest API version.

When a policy gets deprecated or gets out of preview, there is no impact on existing assignments. Existing assignments continue to work as-is. The policy is still evaluated & enforced like normal and continues to produce compliance results.

Here are the changes that occur when a policy gets deprecated:

- Display name is appended with ‘[Deprecated]: ’ prefix, so that customers have awareness to migrate or delete the policy.
- Description gets updated to provide additional information regarding the deprecation with a link to the superseding policy.
- Add `supersededBy` metadata property to the policy definition with the name of the superseding policy.
- Add `deprecated` metadata property to the policy definition with value set to `true`.
- The version number is updated with ‘-deprecated’ suffix. (see [Policy Versioning](#custom-policy-versioning) above).

Example (policy snippet of deprecated policy):

```json
   "policyType": "Custom",
   "mode": "Indexed",
   "displayName": "[Deprecated]: Deploy SQL Database vulnerability Assessments",
   "description": "Deploy SQL Database vulnerability Assessments when it not exist in the deployment. Superseded by https://www.azadvertizer.net/azpolicyadvertizer/Deploy-Sql-vulnerabilityAssessments_20230706.html",
   "metadata": {
      "version": "1.0.1-deprecated",
      "category": "SQL",
      "source": "https://github.com/Azure/Enterprise-Scale/",
      "deprecated": true,
      "supersededBy": "Deploy-Sql-vulnerabilityAssessments_20230706",
      "alzCloudEnvironments": [
         "AzureCloud",
         "AzureChinaCloud",
         "AzureUSGovernment"
      ]
   }
```

{{< hint type=note >}}
The `name` value must not change in the file through deprecation or preview.
{{< /hint >}}

</div>
