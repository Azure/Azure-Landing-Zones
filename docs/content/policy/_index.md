---
title: Azure Policy
geekdocCollapseSection: true
weight: 90
---

This section documents all the Azure landing zone specific Azure Policy details.

{{< hint type=note >}}
This section is a work in progress as we slowly move content from the [wiki](https://aka.ms/alz/policy).
{{< /hint >}}

Azure Policy and deployIfNotExist enables autonomy in the platform, and reduces operational burden as you scale your deployments and subscriptions in the Azure landing zone architecture. The primary purpose is to ensure that subscriptions and resources are compliant, while empowering application teams to use their own preferred tools/clients to deploy.

> Please refer to [Policy Driven Governance](https://learn.microsoft.com/en-gb/azure/cloud-adoption-framework/ready/landing-zone/design-principles#policy-driven-governance) for further information.

{{< hint type=important >}}
**IMPORTANT NOTE:** ALZ priority is to provide a secure by default, Zero Trust aligned, configuration, and occasionally we will rely on `-preview` policies in our default assignments to meet our core objective. These preview policies are maintained by the Azure product owners and versioning is not in our control, however, we feel they are sufficiently important to be included in our releases. If the inclusion of preview policies is of concern, please review all ALZ default initiative assignments and remove any `-preview` policies that you are not comfortable with.
{{< /hint >}}

## FAQ and Tips

We have added a dedicated [ALZ Policy FAQ and Tips]({{< relref "policyFAQ" >}}) based on common issues raised or questions asked by customers and partners.

## Why are there custom policy definitions as part of Azure landing zones?

We work with - and learn from our customers and partners to ensure that we evolve and enhance the reference implementations to meet customer requirements. The primary approach of the policies as part of Azure landing zones is to be proactive (deployIfNotExist, and modify), and preventive (deny). We are continuously moving these policies to built-ins.

## What Azure Policies does Azure landing zone provide additionally to those already built-in?

There are many custom Azure Policy Definitions and custom Azure Policy Initiatives included as part of the Azure Landing Zones implementation that add on to those already built-in within each Azure customers tenant.

For Azure landing zones, the custom Azure Policy Definitions and Initiatives are consistent across the three implementation options, unless otherwise noted; [Terraform Module](https://aka.ms/alz/tf), [Bicep Modules](https://aka.ms/alz/bicep), [Azure landing zone portal accelerator](https://aka.ms/alz#azure-landing-zone-accelerator).

> Our goal is always to try and use built-in policies where available and also work with product teams to adopt our custom policies and make them built-in, which takes time. This means there will always be a requirement for custom policies.

## Why are managed identities deployed as part of the ALZ policies?

Managed Identities provide an alternative way to access Azure resources without having to manage credentials. They are created as a part of the ALZ policies mainly for policies that have the deployIfNotExists (DINE) effect in this initiative. The managed identities are used in order to remediate resources that are not compliant with the policy. For further information on how remediation works with access control, please refer to the following documentation: [Remediate non-compliant resources - Azure Policy | Microsoft](https://learn.microsoft.com/en-us/azure/governance/policy/how-to/remediate-resources?tabs=azure-portal#how-remediation-access-control-works)

## AzAdvertizer Integration

We have worked with the creator of [AzAdvertizer](https://www.azadvertizer.net) to integrate all of the custom Azure Policy Definitions and Initiatives as part of Azure landing zones into it to help customers use the tool to look at the policies further in an easy to use tool that is popular in the community.

On either the [Policy](https://www.azadvertizer.net/azpolicyadvertizer_all.html#%7B%22col_10%22%3A%7B%22flt%22%3A%22ESLZ%22%7D%7D) or [Initiative](https://www.azadvertizer.net/azpolicyinitiativesadvertizer_all.html) section of the site, set the 'Type' column drop down (last one on the right hand side) to 'ALZ' and you will see all the policies as mentioned above in the tool for you to investigate further.

AzAdvertizer also updates once per day!

![AzAdvertizer ALZ Integration Slide](./img/alzPolicyAzAdvertizer.png)
