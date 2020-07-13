### naming-template

> This template can be used as a starting point for building resources with a specific name format. Deploying this template by passing in values will allow you to preview resource names.

---
### network-stand-alone

> This template builds a stand-alone VNet with a single subnet of size "small", "medium", or "large". The sizes add 1 to the CIDR. A VNet with the CIDR 10.0.0.0/21 (2046 addresses) would have a large subnet of 10.0.0.0/22 (1022 addresses), a medium subnet of 10.0.0.0/23 (510 addresses), or a small subnet of 10.0.0.0/24 (254 addresses). The subscription ID and CIDR range are delivered as output to be used for a future VNet peering relationship.