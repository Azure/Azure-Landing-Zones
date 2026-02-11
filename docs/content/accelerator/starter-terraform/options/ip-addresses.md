---
title: 8 - IP Address Ranges
geekdocCollapseSection: true
weight: 8
---

The example configuration files that include connectivity include an out of the box set of ip address ranges. These ranges have been chosen to support a real world scenario with optimal use to avoid ip exhaustion as you scale. However you may not want to use these ranges if they may overlap with their existing ranges or they are planning to scale beyond the /16 per region we cater for.

In order to update the IP ranges, you can update the `custom_replacements` > `names` block setting that includes the IP ranges. For example if you prefer to use `172.16` or `192.168`, they could update the ranges as follows:

{{< include file="/static/examples/tf/accelerator/config/custom_replacements.names.ip_ranges.tfvars" language="terraform" >}}
