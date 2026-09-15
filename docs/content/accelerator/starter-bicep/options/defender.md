\---

title: 13 - Turn off Defender Plans

geekdocCollapseSection: true

weight: 13

\---



Defender Plan policy is enabled by default. To turn off individual Defender plans, follow these steps:



1\. Update the `parPolicyAssignmentParameterOverrides` section in the appropriate management group's `.bicepparam` file.

2\. Find the `Deploy-MDFC-Config-H224` policy assignment block.

3\. Set the desired Defender plan parameters to `Disabled`.



{{< hint type="warning" >}}

Update the correct management group's `.bicepparam` file where the `Deploy-MDFC-Config-H224` policy assignment is deployed.

{{< /hint >}}



Example to turn off a subset of Defender plans:



{{< highlight bicep "linenos=table" >}}

param parPolicyAssignmentParameterOverrides = {

&#x20; 'Deploy-MDFC-Config-H224': {

&#x20;   parameters: {

&#x20;     ascExportResourceGroupName: {

&#x20;       value: '<rg\_name>'

&#x20;     }

&#x20;     ascExportResourceGroupLocation: {

&#x20;       value: '<location>'

&#x20;     }

&#x20;     emailSecurityContact: {

&#x20;       value: 'security\_contact@replace\_me'

&#x20;     }

&#x20;     enableAscForServers: {

&#x20;       value: 'Disabled'

&#x20;     }

&#x20;     enableAscForServersVulnerabilityAssessments: {

&#x20;       value: 'DeployIfNotExists'

&#x20;     }

&#x20;     enableAscForSql: {

&#x20;       value: 'DeployIfNotExists'

&#x20;     }

&#x20;     enableAscForAppServices: {

&#x20;       value: 'DeployIfNotExists'

&#x20;     }

&#x20;     enableAscForStorage: {

&#x20;       value: 'DeployIfNotExists'

&#x20;     }

&#x20;     enableAscForContainers: {

&#x20;       value: 'DeployIfNotExists'

&#x20;     }

&#x20;     enableAscForKeyVault: {

&#x20;       value: 'DeployIfNotExists'

&#x20;     }

&#x20;     enableAscForSqlOnVm: {

&#x20;       value: 'Disabled'

&#x20;     }

&#x20;     enableAscForArm: {

&#x20;       value: 'DeployIfNotExists'

&#x20;     }

&#x20;     enableAscForOssDb: {

&#x20;       value: 'Disabled'

&#x20;     }

&#x20;     enableAscForCosmosDbs: {

&#x20;       value: 'DeployIfNotExists'

&#x20;     }

&#x20;     enableAscForCspm: {

&#x20;       value: 'DeployIfNotExists'

&#x20;     }

&#x20;   }

&#x20; }

}

{{< /highlight >}}



{{< hint type="tip" >}}

A full list of available parameters can be found in the

\[Deploy-MDFC-Config-H224 policy assignment](https://github.com/Azure/Azure-Landing-Zones-Library/blob/main/platform/alz/policy\_assignments/Deploy-MDFC-Config-H224.alz\_policy\_assignment.json)

within the Azure Landing Zones Library.

{{< /hint >}}



\## Exclude MDFC Policy Assignment



To prevent the `Deploy-MDFC-Config-H224` policy assignment from being deployed, add it to the `managementGroupExcludedPolicyAssignments` array.



{{< highlight bicep "linenos=table" >}}

param landingZonesConfig = {

&#x20; managementGroupExcludedPolicyAssignments: \[

&#x20;   'Deploy-MDFC-Config-H224'

&#x20; ]

}

{{< /highlight >}}



\## Configure MDFC Policy Assignment in DoNotEnforce Mode



To deploy the policy assignment without enforcing it, add it to the `managementGroupDoNotEnforcePolicyAssignments` array.



{{< highlight bicep "linenos=table" >}}

param landingZonesConfig = {

&#x20; managementGroupDoNotEnforcePolicyAssignments: \[

&#x20;   'Deploy-MDFC-Config-H224'

&#x20; ]

}

{{< /highlight >}}



\## Validate Configuration



After deployment:



1\. Verify the `Deploy-MDFC-Config-H224` policy assignment exists at the expected management group scope.

2\. Verify the policy assignment parameters contain the expected values.

3\. Review Microsoft Defender for Cloud and confirm the desired Defender plans are enabled or disabled as expected.

4\. Review policy compliance results to confirm the deployment completed successfully.

