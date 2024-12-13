---
Title: 2. Networking
geekdocCollapseSection: true
draft: true
---

Firstly select a network topology.
For guidance see the [documentation on learn](https://learn.microsoft.com/azure/cloud-adoption-framework/ready/azure-best-practices/define-an-azure-network-topology).

## Network Topology

If you choose a hub network architecture, go here [Hub Networking]({{< relref "a_hubnetworking" >}}).

If you choose a Virtual WAN network architecture, go here [Virtual WAN]({{< relref "b_virtualwan" >}}).

## Private Link DNS Zones

You should consider using Private Link DNS Zones to resolve the FQDN of a private endpoints in your virtual network.

Jump to [private link DNS zones]({{< relref "c_privatedns" >}}).

## DDoS Network Protection

Azure DDoS Network Protection, combined with application design best practices, provides enhanced DDoS mitigation features to defend against DDoS attacks.
It's automatically tuned to help protect your specific Azure resources in a virtual network.

Jump to [DDoS Protection]({{< relref "d_ddosprotection" >}}).

## Next steps

You are now ready to deploy the [Management Groups and Policy]({{< relref "3_managementgroup" >}}).
