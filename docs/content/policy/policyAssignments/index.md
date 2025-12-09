---
title: Policy Assignments
weight: 5
---

As part of a default deployment configuration, policy and policy set definitions are deployed at multiple levels within the Azure landing zone Management Group hierarchy as depicted within the below diagram.

{{< hint type=important >}}
As part of the ALZ portal deployment/configuration, policy and policy set definitions are created only at the intermediate management group, e.g. `contoso` that is a child of the tenant root management group, created during the ALZ deployment. Our automation does not assign any policies to the tenant root management group scope, only the ALZ hierarchy it deploys and its children, e.g. `contoso` and below. This approach aligns with the Cloud Adoption Framework's best practices for Azure Policy assignment, ensuring clear delineation of policy application and avoiding unintended policy inheritance across the entire tenant. By placing policies only at the intermediary root and its child management groups, we maintain compliance, flexibility, and alignment with organizational governance requirements. And also allow multiple management groups hierarchies to exist in a single tenant such as the [canary approach](https://aka.ms/alz/canary#example-scenarios-and-outcomes)
{{< /hint >}}

{{< figure src="../img/MgmtGroups_Policies_v0.1.svg">}}

> <a href=./data/ALZPolicyAssignments.xlsx>{{< figure src="../img/ef73.jpg">}}</a> For convenience, an Excel version of the below information is available [here](./data/ALZPolicyAssignments.xlsx) or click the icon.

## Default Policy Assignments

{{< csv-table file="data/ALZPolicyAssignments.csv" >}}

{{< hint type=note >}}
Be sure to also review the [Extra Policies and Information]({{< relref "policyExtras" >}}) document that describes additional ALZ custom policy definitions and initiatives that are not assigned by default in ALZ, but are provided as they may assist some consumers of ALZ in specific scenarios where they can assign these additional policies to help them meet their objectives.
{{< /hint >}}
