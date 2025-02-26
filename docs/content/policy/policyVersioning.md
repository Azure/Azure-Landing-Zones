---
title: ALZ and Policy Versioning
weight: 10
---

In mid-2024 the Azure Policy product group released a new versioning scheme for Azure Policy definitions. This new versioning scheme is designed to provide a more consistent and predictable way to manage policy definitions and initiatives, making it easier for organizations to adopt and implement Azure Policy.

In the context of Azure Policy, versioning refers to the practice of managing and maintaining different versions of policy definitions and initiatives. This is important for several reasons:

- **Backward Compatibility**: As Azure Policy evolves, new features and capabilities are introduced. Versioning ensures that existing policies continue to work as expected, even as new versions are released.
- **Change Management**: Versioning allows organizations to track changes made to policies over time. This is crucial for auditing and compliance purposes.
- **Testing and Validation**: When a new version of a policy is released, organizations can test it in a controlled environment before deploying it to production. This helps identify any potential issues or conflicts with existing policies.
- **Documentation**: Versioning provides a clear history of changes made to policies, making it easier for teams to understand the evolution of their policy landscape.
- **Rollback Capability**: If a new version of a policy causes issues, versioning allows organizations to revert to a previous version quickly.
- **Feature Deprecation**: As Azure Policy matures, certain features may be deprecated or replaced with better alternatives. Versioning allows organizations to manage the transition to new features while maintaining support for older versions.
- **Community Contributions**: In open-source or community-driven environments, versioning allows contributors to submit changes and improvements without disrupting existing policies.
- **Integration with CI/CD**: Versioning policies can be integrated into continuous integration and continuous deployment (CI/CD) pipelines, allowing for automated testing and deployment of policy changes.

{{< hint type=note >}}
As of March 2025, Azure Policy version only supports built-in policies and initiatives. Custom policies and initiatives are not supported.
{{< /hint >}}

## How it works

The new versioning scheme for Azure Policy is based on semantic versioning, which consists of three components: major, minor, and patch versions. Each component serves a specific purpose:

- **Major Version**: Indicates significant changes or breaking changes to the policy definition. A change in the major version number signifies that the new version may not be backward compatible with previous versions.
- **Minor Version**: Indicates the addition of new features or enhancements that are backward compatible. A change in the minor version number signifies that the new version includes improvements but does not introduce breaking changes.
- **Patch Version**: Indicates bug fixes or minor changes that do not affect the policy's functionality. A change in the patch version number signifies that the new version includes fixes but does not introduce new features or breaking changes.

The most important thing to note is that the major version number is incremented when there are breaking changes. This means that if you are using a policy definition with a specific major version, you should be aware that upgrading to a new major version may require changes to your implementation. 

Built-in policies and initiatives are now versioned using the new scheme. The version number is included in the policy definition's metadata, making it easy to identify the version being used and is tyipcally formatted as `X.Y.Z` where `X` is the major version, `Y` is the minor version, and `Z` is the patch version, e.g. 1.*.*. The `*` are used for minor and patch version as wildcards, as changes to these versions are backward compatible and will used automatically.

{{< figure src="../img/policyWithVersion.png" title="Policy with version example">}}

The above example highlights the new property `version` in the policy definition. The version number is included in the policy definition's metadata, making it easy to identify the version being used.

{{< hint type=note >}}
The `version` attribute under `metadata` is not used for Azure Policy versioning. It is used for other purposes, such as tracking changes to the policy definition over time, and should not be confused with the new versioning scheme. It serves no functional purpose in the Azure Policy engine.
{{< /hint >}}

## Policy Versioning in ALZ

While the benefits are clear on why Azure Policy versioning was introduced, this also means that ALZ had to adapt to this new versioning scheme. The ALZ team has implemeted the new versioning scheme for built-in policies and initiatives used by ALZ by pinning to the current major version of the policy or initiative definition in our custom initiatives and any assignments of built-in policies/initiatives. This means that ALZ will always use the latest minor and patch version of the policy or initiative definition for the currently pinned major version (e.g. 1.*.*), ensuring that you are always using the latest and greatest version of the validated pinned major version of the policy or initiative. This effort was published as part of the Q2 FY25 Policy Refresh, where all custom initiatives and assignments rerencing built-in policies/initiatives were updated to pin to the current major version of the policy or initiative definition.

Pinning to the current (at time of publishing the policy refresh) major version of the policy or initiative definition means that ALZ will not automatically upgrade to a new major version of the policy or initiative definition when published. This is to ensure that the ALZ team have time to review the breaking change in the new major version of the policy or initiative definition before upgrading.

The ALZ team will monitor for new major versions of built-in policies and initiatives used by ALZ and will publish updates as part of the regular policy refresh cadence when a new major version is released, once changes have been accomodated and tested.

## Updating



## Tools

To help navigate the impact of policy versioning you can use the following tools:

- AzAdvertizer: [ALZ Initiatives](https://www.azadvertizer.net/azpolicyinitiativesadvertizer_all.html#%7B%22col_12%22%3A%7B%22flt%22%3A%22ALZ%22%7D%7D)


## Official Links

- [Azure Policy versioning](https://learn.microsoft.com/en-us/azure/governance/policy/concepts/definition-structure-basics#version-preview)
- [Public Preview Announcement: Azure Policy Built-in Versioning](https://techcommunity.microsoft.com/blog/azuregovernanceandmanagementblog/public-preview-announcement-azure-policy-built-in-versioning/4186105)