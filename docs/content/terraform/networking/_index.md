---
Title: 2. Networking
---

The Azure Landing Zones platform provides two networking topologies: hub and spoke & Azure Virtual WAN.
FOr more information on defining the networking topology, see the [networking topology](https://learn.microsoft.comß/azure/cloud-adoption-framework/ready/azure-best-practices/define-an-azure-network-topology) section of the Cloud Adoption Framework documentation.

Follow the links to select the network topology that best fits your requirements:

- [Hub and spoke](a_hubnetworking)
- [Azure Virtual WAN](b_virtualwan)

We recommend that you also deploy the private DNS zones required for private link services:

- [Private DNS zones](c_privatedns)

Finally, we recommend that you deploy a DDoS protection plan to protect your core network:

- [DDoS protection plan](d_ddos)

## Repository Structure

Many customers have dedicated network teams that are responsible for the network infrastructure.
In this situation it often makes sense to host the networking code in a separate repository to that of Azure Landing Zones.
