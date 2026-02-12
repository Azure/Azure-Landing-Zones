---
title: ALZ support for service retirement/deprecation
geekdocCollapseSection: true
weight: 100
---

Azure landing zone is committed to providing our customers with the best possible experience when deploying and managing their Azure landing zones. As part of this commitment, we continuously evaluate our reference implementations and make updates as necessary to ensure they align with the latest Azure best practices and product capabilities.

Azure services and features are regularly updated, and occasionally, certain services or features may be deprecated. When this happens, we assess the impact on our reference implementations and make necessary adjustments to ensure continued support and compatibility. To help surface potential impact to our customers, we provide Azure policies to identify resources that may be impacted by these deprecations.

{{<expand "Azure Key Vault - API Retirement" ">">}}
[Prepare for Key Vault API version 2026-02-01: Azure RBAC as default access control](https://learn.microsoft.com/en-us/azure/key-vault/general/access-control-default?tabs=azure-cli)

To help identify any Azure Key Vaults that may be impacted by this change, we provide the following Azure Policy definition in our Azure Policy library:

**Initiative** [Enforce-Guardrails-KeyVault](https://www.azadvertizer.net/azpolicyinitiativesadvertizer/Enforce-Guardrails-KeyVault_20260203.html) includes the policy definition [Azure Key Vault should use RBAC permission model](https://www.azadvertizer.net/azpolicyadvertizer/12d4fa5e-1f9f-4c21-97a9-b99b3c6611b5.html).

{{< /expand >}}

{{<expand "Azure Kubernetes Service - kubenet" ">">}}
[Prepare for AKS kubenet deprecation](https://learn.microsoft.com/en-us/azure/aks/configure-kubenet)

To help identify any Azure Kubernetes Service instances that may be impacted by this change, we provide the following Azure Policy definition in our Azure Policy library:

**Initiative** [Enforce-Guardrails-Kubernetes](https://www.azadvertizer.net/azpolicyinitiativesadvertizer/Enforce-Guardrails-Kubernetes.html) includes the custom ALZ policy definition [Detect AKS clusters using kubenet network plugin](https://www.azadvertizer.net/azpolicyadvertizer/Audit-AKS-kubenet.html).

{{< /expand >}}
