---
title: ALZ and Policy Versioning
weight: 10
---

{{< hint type=important >}}
Even though still in public preview, it is highly recommended to implement Azure Policy versioning and update policies/initiatives and assignments by pinning to known and tested major versions as soon as possible to avoid unintended consequences due to breaking changes being released in an uncontrolled manner.
{{< /hint >}}

In mid-2024 the Azure Policy product group released a new versioning JSON schema for Azure Policy definitions. This new versioning schema is designed to provide a more consistent and predictable way to manage policy definitions and initiatives, making it easier for organizations to adopt and implement Azure Policy.

In the context of Azure Policy, versioning refers to the practice of managing and maintaining different versions of policy definitions and initiatives. This is important for several reasons:

- **Backward Compatibility**: As Azure Policy evolves, new features and capabilities are introduced. Versioning ensures that existing policies continue to work as expected, even as new versions are released.
- **Change Management**: Versioning allows organizations to track changes made to policies over time. This is crucial for auditing and compliance purposes.
- **Testing and Validation**: When a new version of a policy is released, organizations can test them in a controlled environment before deploying it to production. This helps identify any potential issues or conflicts with existing policies.
- **Documentation**: Versioning provides a clear history of changes made to policies, making it easier for teams to understand the evolution of their policy landscape.
- **Rollback Capability**: If a new version of a policy causes issues, versioning allows organizations to revert to a previous version quickly.
- **Feature Deprecation**: As Azure Policy matures, certain features may be deprecated or replaced with better alternatives. Versioning allows organizations to manage the transition to new features while maintaining support for older versions.
- **Integration with CI/CD**: Versioning policies can be integrated into continuous integration and continuous deployment (CI/CD) pipelines, allowing for automated testing and deployment of policy changes.

{{< hint type=note >}}
As of March 2025, Azure Policy version only supports built-in policies and initiatives. Custom policies and initiatives are not supported but are planned.
{{< /hint >}}

## How it works

The new versioning scheme for Azure Policy is based on [semantic versioning](https://semver.org/), which consists of three components: major, minor, and patch versions. Each component serves a specific purpose:

- **Major Version**: Indicates significant changes or breaking changes to the policy definition. A change in the major version number signifies that the new version may not be backward compatible with previous versions.
- **Minor Version**: Indicates the addition of new features or enhancements that are backward compatible. A change in the minor version number signifies that the new version includes improvements but does not introduce breaking changes.
- **Patch Version**: Indicates bug fixes or minor changes that do not affect the policy's functionality. A change in the patch version number signifies that the new version includes fixes but does not introduce new features or breaking changes.

The most important thing to note is that the major version number is incremented when breaking changes are introduced. This means that if you are using a policy definition with a specific major version, you should be aware that upgrading to a new major version may require changes to your implementation.

All Azure built-in policies and initiatives are now versioned using the new scheme. The version number is included in the policy definition's metadata, making it easy to identify the version being used and is typically formatted as `X.Y.Z` where `X` is the major version, `Y` is the minor version, and `Z` is the patch version, e.g. `1.*.*`. The `*` are used for minor and patch version as wildcards in initiatives and assignments, as changes to these versions are backward compatible and will be used automatically.

{{< figure src="../img/policyWithVersion.png">}}

The above example highlights the new property `version` in the policy definition. The version number is included in the policy definition's metadata, making it easy to identify the version being used.

{{< hint type=note >}}
The `version` attribute under `metadata` is not used for Azure Policy versioning. It is used for other purposes, such as tracking changes to the policy definition over time, and should not be confused with the new versioning scheme. It serves no functional purpose in the Azure Policy engine.
{{< /hint >}}

## Policy Versioning in ALZ

Azure Policy versioning introduced several benefits but also required ALZ to adapt to the new framework. To align with this change, the ALZ team implemented versioning for built-in policies and initiatives by pinning them to their current major version within custom initiatives and assignments. This ensures ALZ consistently uses the latest minor and patch versions while maintaining a stable major version (e.g., 1.x). As a result, users benefit from the most up-to-date and validated version of the pinned major release.

This update was published as part of the **Q2 FY25 Policy Refresh (January 2025)**, during which all custom initiatives and assignments referencing built-in policies and initiatives were updated to align with the latest available major version.

By pinning to the current major version, ALZ does not automatically upgrade to newly released major versions. This approach allows the ALZ team time to review and assess any breaking changes before initiating an upgrade.

We do not recommend implementing updated major policy versions outside of the ALZ Policy Version Baseline. Updating to a major policy version outside of the scheduled policy refresh releases may require code or configuration changes due to breaking changes. Additionally, you would need to take extra steps to apply future policy refresh updates to stay aligned with ALZ.

Moving forward, the ALZ team will monitor new major versions of built-in policies and initiatives used by ALZ. Updates will be incorporated as part of the regular policy refresh cycle once the necessary changes have been reviewed, tested, and validated.

{{< hint type=note >}}
Due to upstream dependencies on product SDKs, Azure Policy versioning is not yet supported in Terraform Azure Verified Modules for Platform Landing Zone (ALZ) and Bicep accelerator.
{{< /hint >}}

## Updating

Depending on the accelerator you've used to deploy your Azure Landing Zones, you may need to update your policies/initiatives and assignments.

- **Portal**: If you have deployed your Azure Landing Zones using the portal, you will need to update your policies/initiatives and assignments manually. This is because the portal does not support automatic updates for policies/initiatives and assignments.
- **Bicep**: If you have deployed your Azure Landing Zones using Bicep, you will need to update your policies/initiatives and assignments manually. This is because Bicep does not support automatic updates for policies/initiatives and assignments.
- **Terraform**: If you have deployed your Azure Landing Zones using Terraform, you will need to update to the latest version of the policy library and apply the changes using your normal Terraform workflow - [more info](https://azure.github.io/Azure-Landing-Zones/terraform/howtos/update/).

For guidance on updating existing policies/initiatives and assignments, please refer to the following links:

- [Update ALZ Custom Policies to Latest](https://github.com/Azure/Enterprise-Scale/wiki/Update-ALZ-Custom-Policies-to-Latest)

If you are using the latest release of ALZ and have updated ALZ initiatives and assignments, you will automatically utilize the most recent minor and patch versions of the policy or initiative definition within the currently pinned major version. This ensures you benefit from the latest features and bug fixes.

However, when a new major version is released and published by the ALZ team, you must update your policies, initiatives, and assignments to adopt the new version. Since major version updates may introduce breaking changes, this process requires deleting the existing assignment and recreating it with the updated major version.

## Tools

To help navigate the impact of policy versioning you can use the following tools:

- AzAdvertizer: [ALZ Initiatives](https://www.azadvertizer.net/azpolicyinitiativesadvertizer_all.html#%7B%22col_12%22%3A%7B%22flt%22%3A%22ALZ%22%7D%7D) which links you directly to the ALZ initiatives ALZ deploys and identifies the versions of policies we're pinning to.
- Azure Governance Visualizer: [AzGovViz](https://github.com/Azure/Azure-Governance-Visualizer-Accelerator) which provides a visual representation of your Azure Landing Zone environment and provides tools to better understand the related Azure Policy landscape, including policy assignments, initiatives, and their versions.

## Official Links

- [Official Learn Docs: Azure Policy versioning](https://learn.microsoft.com/en-us/azure/governance/policy/concepts/definition-structure-basics#version-preview)
- [Blog: Public Preview Announcement: Azure Policy Built-in Versioning](https://techcommunity.microsoft.com/blog/azuregovernanceandmanagementblog/public-preview-announcement-azure-policy-built-in-versioning/4186105)