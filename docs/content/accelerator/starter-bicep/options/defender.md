---
title: Turn off Defender Plans
geekdocCollapseSection: true
weight: 13
---

Defender plans are enabled by default. To turn off individual Defender plans, follow the steps below.

1. Update the `parPolicyAssignmentParameterOverrides` section in the appropriate management group's `.bicepparam` file.
2. Find the `Deploy-MDFC-Config-H224` policy assignment block.
3. Set the desired Defender plan parameters to `Disabled`.

{{< hint type="warning" >}}
Update the correct management group's `.bicepparam` file where the `Deploy-MDFC-Config-H224` policy assignment is deployed.
{{< /hint >}}

Example: turn off a subset of Defender plans.

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

{{< hint type="tip" >}}
The complete list of supported parameters can be found in the
[Deploy-MDFC-Config-H224 policy assignment](https://github.com/Azure/Azure-Landing-Zones-Library/blob/main/platform/alz/policy_assignments/Deploy-MDFC-Config-H224.alz_policy_assignment.json)
within the Azure Landing Zones Library.
{{< /hint >}}

## Exclude MDFC Policy Assignment

To prevent the `Deploy-MDFC-Config-H224` policy assignment from being deployed, add it to the `managementGroupExcludedPolicyAssignments` array.

{{< highlight bicep "linenos=table" >}}
param landingZonesConfig = {
  managementGroupExcludedPolicyAssignments: [
    'Deploy-MDFC-Config-H224'
  ]
}
{{< /highlight >}}

## Configure MDFC Policy Assignment in DoNotEnforce Mode

To deploy the policy assignment without enforcing it, add it to the `managementGroupDoNotEnforcePolicyAssignments` array.

{{< highlight bicep "linenos=table" >}}
param landingZonesConfig = {
  managementGroupDoNotEnforcePolicyAssignments: [
    'Deploy-MDFC-Config-H224'
  ]
}
{{< /highlight >}}

## Validate Configuration

After deployment:

1. Verify that the `Deploy-MDFC-Config-H224` policy assignment exists at the expected management group scope.
2. Verify that the policy assignment parameters contain the expected values.
3. Review Microsoft Defender for Cloud and confirm that the desired Defender plans are enabled or disabled as expected.
4. Review policy compliance results to confirm the deployment completed successfully.