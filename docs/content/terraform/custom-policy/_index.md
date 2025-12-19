---
title: Custom Policies
geekdocCollapseSection: true
weight: 50
---

Azure Policy is a powerful governance tool that helps you enforce organizational standards and assess compliance at scale. The Azure Landing Zones Terraform module provides full support for creating and managing custom policies, policy initiatives, and policy assignments through your custom library.

## Capabilities

With Azure Landing Zones Terraform module, you can:

- **Create custom policy definitions** - Define your own policies to enforce specific organizational requirements that aren't covered by built-in policies
- **Build policy initiatives (policy sets)** - Group multiple policies together for easier management, assignment, and compliance tracking
- **Assign policies and initiatives** - Apply policies to your management group hierarchy to enforce governance controls across your Azure estate

There are 5 high level combinations of policy resources you can create and assign:

- ALZ policy or policy initiative assignment
- Built-in policy or policy initiative assignment
- Single custom policy assignment
- Custom policy initiative (policy set) with built-in policies and associated assignment
- Custom policy initiative (policy set) custom policies (and built-in policies) and associated assignment

### ALZ Policy or Policy Initiative Assignment

This option allows you to assign a single built-in ALZ policy or policy initiative to a management group.

The high level steps to follow are:

1. Identify the ALZ [policy](https://github.com/Azure/Azure-Landing-Zones-Library/tree/main/platform/alz/policy_definitions) or [policy initiative](https://github.com/Azure/Azure-Landing-Zones-Library/tree/main/platform/alz/policy_set_definitions) you want to assign from the [ALZ Policy Library](https://azure.github.io/Azure-Landing-Zones-Library/).
1. Follow the steps in [Creating an Azure Policy Assignment]({{< relref "policy-assignment" >}}) to create and assign the policy or initiative.

### Built-in Policy or Policy Initiative Assignment

This option allows you to assign a single built-in Azure policy or policy initiative to a management group.

The high level steps to follow are:

1. Identify the built-in [policy](https://learn.microsoft.com/azure/governance/policy/samples/built-in-policies) or [policy initiative](https://learn.microsoft.com/azure/governance/policy/samples/built-in-policy-sets) you want to assign from the Azure documentation.
1. Follow the steps in [Creating an Azure Policy Assignment]({{< relref "policy-assignment" >}}) to create and assign the policy or initiative.

### Single Custom Policy Assignment

This option allows you to create a custom policy definition and assign it to a management group.

The high level steps to follow are:

1. Follow the steps in [Creating a Custom Azure Policy Definition]({{< relref "policy-definition" >}}) to create your custom policy definition.
1. Follow the steps in [Creating an Azure Policy Assignment]({{< relref "policy-assignment" >}}) to assign the custom policy to a management group.

### Custom Policy Initiative (Policy Set) with Built-in Policies and Associated Assignment

This option allows you to create a custom policy initiative that includes built-in policies, and assign it to a management group.

The high level steps to follow are:

1. Follow the steps in [Creating an Azure Policy Initiative]({{< relref "policy-initiative" >}}) to create your custom policy initiative that includes built-in policies.
1. Follow the steps in [Creating an Azure Policy Assignment]({{< relref "policy-assignment" >}}) to assign the custom policy initiative to a management group.

### Custom Policy Initiative (Policy Set) Custom Policies (and Built-in Policies) and Associated Assignment

This option allows you to create a custom policy initiative that includes both custom and built-in policies, and assign it to a management group.

The high level steps to follow are:

1. Follow the steps in [Creating a Custom Azure Policy Definition]({{< relref "policy-definition" >}}) to create your custom policy definitions.
1. Follow the steps in [Creating an Azure Policy Initiative]({{< relref "policy-initiative" >}}) to create your custom policy initiative that includes both custom and built-in policies.
1. Follow the steps in [Creating an Azure Policy Assignment]({{< relref "policy-assignment" >}}) to assign the custom policy initiative to a management group.

## Getting Started

Choose the guide that matches what you want to accomplish:

| Guide | Description |
|-------|-------------|
| [Creating an Azure Policy Assignment]({{< relref "policy-assignment" >}}) | Learn how to assign built-in or custom policies and initiatives to your management groups |
| [Creating a Custom Azure Policy Definition]({{< relref "policy-definition" >}}) | Create your own policy definitions for requirements not covered by built-in policies |
| [Creating an Azure Policy Initiative]({{< relref "policy-initiative" >}}) | Group multiple policies together into initiatives for simplified management |

{{< hint type=tip >}}
**Recommended reading order:** If you're new to custom policies, start with the policy definition guide, then learn about initiatives, and finally understand how to assign them.
{{< /hint >}}

## Prerequisites

Before creating custom policies, you need to have a [custom library]({{< relref "customLibrary" >}}) configured. The custom library is where you store your policy definitions, initiatives, and assignments.

