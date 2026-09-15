---
title: 13 - Turn off Defender Plans
geekdocCollapseSection: true
weight: 13
---

The Defender Plan policy is enabled by default. If you want to turn off individual Defender plans, you can follow these steps:

1. Update the `parPolicyAssignmentParameterOverrides` section in the appropriate management group's `.bicepparam` file.
1. Find the `Deploy-MDFC-Config-H224` block setting and set the desired Defender plan parameters to `Disabled`. See the following example to turn off a subset of the Defender plans:

    {{< hint type=warning >}}
    Update the correct management group's `.bicepparam` file where the `Deploy-MDFC-Config-H224` policy assignment is deployed.
    {{< /hint >}}

    {{< highlight bicep "linenos=table" >}}
    param parPolicyAssignmentParameterOverrides = {
      'Deploy-MDFC-Config-H224': {
        parameters: {
          ascExportResourceGroupName: {
            value: '<rg_name>'
          }
          ascExportResourceGroupLocation: {
            value: '<location>'
          }
          emailSecurityContact: {
            value: 'security_contact@replace_me'
          }
          enableAscForServers: {
            value: 'Disabled'
          }
          enableAscForServersVulnerabilityAssessments: {
            value: 'DeployIfNotExists'
          }
          enableAscForSql: {
            value: 'DeployIfNotExists'
          }
          enableAscForAppServices: {
            value: 'DeployIfNotExists'
          }
          enableAscForStorage: {
            value: 'DeployIfNotExists'
          }
          enableAscForContainers: {
            value: 'DeployIfNotExists'
          }
          enableAscForKeyVault: {
            value: 'DeployIfNotExists'
          }
          enableAscForSqlOnVm: {
            value: 'Disabled'
          }
          enableAscForArm: {
            value: 'DeployIfNotExists'
          }
          enableAscForOssDb: {
            value: 'Disabled'
          }
          enableAscForCosmosDbs: {
            value: 'DeployIfNotExists'
          }
          enableAscForCspm: {
            value: 'DeployIfNotExists'
          }
        }
      }
    }
    {{< /highlight >}}

{{< hint type=tip >}}
You can find the full list of parameters in the policy assignment
[Deploy-MDFC-Config-H224](https://github.com/Azure/Azure-Landing-Zones-Library/blob/main/platform/alz/policy_assignments/Deploy-MDFC-Config-H224.alz_policy_assignment.json)
in the Azure Landing Zones Library.
{{< /hint >}}

## Exclude the MDFC Policy Assignment

To prevent the `Deploy-MDFC-Config-H224` policy assignment from being deployed, add it to the `managementGroupExcludedPolicyAssignments` array.

{{< highlight bicep "linenos=table" >}}
param landingZonesConfig = {
  managementGroupExcludedPolicyAssignments: [
    'Deploy-MDFC-Config-H224'
  ]
}
{{< /highlight >}}

## Configure the MDFC Policy Assignment in DoNotEnforce Mode

To deploy the policy assignment without enforcing it, add it to the `managementGroupDoNotEnforcePolicyAssignments` array.

{{< highlight bicep "linenos=table" >}}
param landingZonesConfig = {
  managementGroupDoNotEnforcePolicyAssignments: [
    'Deploy-MDFC-Config-H224'
  ]
}
{{< /highlight >}}

## Validate the Configuration

After deployment:

1. Verify the `Deploy-MDFC-Config-H224` policy assignment exists at the expected management group scope.
2. Verify the policy assignment parameters contain the expected values.
3. Review Microsoft Defender for Cloud and confirm the desired Defender plans are enabled or disabled as expected.
4. Review policy compliance results to confirm the deployment completed successfully.