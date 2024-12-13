---
Title: 2.d DDoS Protection
draft: true
---

{{< hint type=warning title="Cost Warning" >}}
Azure DDoS Protection Standard is a paid service that can result in significant costs.
Review the [Azure DDoS Protection pricing](https://azure.microsoft.com/pricing/details/ddos-protection/) before deploying.
{{< /hint >}}

Use the Azure Verified Module to deploy the Azure DDoS Network Protection Standard Plan.
Add the following code into your `main.tf` file:

{{< include file="/static/examples/tf/2_network/d_ddos/main.tf" language="terraform" >}}

## Next steps

Now, return to the [networking section]({{< relref "2_networking" >}}) and evaluate the next headings.
