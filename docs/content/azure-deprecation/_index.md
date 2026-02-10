---
title: Azure Deprecation Support
geekdocCollapseSection: true
weight: 100
---

Azure landing zone is committed to providing our customers with the best possible experience when deploying and managing their Azure landing zones. As part of this commitment, we continuously evaluate our reference implementations and make updates as necessary to ensure they align with the latest Azure best practices and product capabilities.

Azure services and features are regularly updated, and occasionally, certain services or features may be deprecated. When this happens, we assess the impact on our reference implementations and make necessary adjustments to ensure continued support and compatibility. To help surface potential impact to our customers, we provide Azure policies to identify resources that may be impacted by these deprecations.

{{<expand "Azure Key Vault - RBAC" ">">}}
On 27 February 2027, all Azure Key Vault API versions prior to 2026-02-01 will be retired.

Azure Key Vault API version 2026-02-01—releasing in February 2026—introduces [an important security update](https://learn.microsoft.com/en-us/azure/key-vault/general/access-control-default?tabs=azure-cli): Azure role-based access control (RBAC) will be the default access control model for all newly created vaults. Existing key vaults will continue using their current access control model. Azure portal behavior will remain unchanged.

If you’re using legacy access policies for new and existing vaults, we recommend [migrating to Azure RBAC](https://learn.microsoft.com/en-us/azure/key-vault/general/rbac-migration?tabs=cli) before transitioning to API version 2026-02-01.

To help identify any Azure Key Vaults that may be impacted by this change, we have provided the following Azure Policy definition in our Azure Policy library:

**Initiative:** [Enforce-Guardrails-KeyVault](https://www.azadvertizer.net/azpolicyinitiativesadvertizer/Enforce-Guardrails-KeyVault_20260203.html)

**Policy:** [Azure Key Vault should use RBAC permission model](https://www.azadvertizer.net/azpolicyadvertizer/12d4fa5e-1f9f-4c21-97a9-b99b3c6611b5.html)

{{< /expand >}}

{{<expand "Azure Kubernetes Service - kubenet" ">">}}
Text
{{< /expand >}}
