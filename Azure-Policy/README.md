# Azure Policy Templates
---
### allowed-vm-skus

> This is a Blueprint policy template that contains the following JSON array of allowed VM SKU's.

| VM SKU | CPU | MEMORY (GB) | USE |
| --- | --- | --- | --- |
| Standard_B1ms | 1 | 2 | Burstable/Test |
| Standard_F2s_v2 | 2 | 4 | Production |
| Standard_B2s | 2 | 4 | Burstable/Test |
| Standard_B2ms | 2 | 8 | Burstable/Test |
| Standard_D2s_v3 | 2 | 8 | Production |
| Standard_B4ms | 4 | 16 | Burstable/Test |
| Standard_D4s_v3 | 4 | 16 | Production |
| Standard_F8s_v2 | 8 | 16 | Production |
| Standard_B8ms | 8 | 32 | Burstable/Test |
| Standard_D8s_v3 | 8 | 32 | Production |
| Standard_E8s_v3 | 8 | 64 | Production |
| Standard_F16s_v2 | 16 | 32 | Production | 
| Standard_E16s_v3 | 16 | 128 | Production |

---
### resource-group-tags

> This ARM template can be used to deploy a custom initiative based on 2 built-in Azure Policy definitions. This initiative combines tag enforcement on a resource group, and applies tag inheritence on all resources in the group. This template enforces the following tags.

- Application Name
- Application Owner
- Business Criticality
    - Tier0
    - Tier1
    - Tier2
    - Tier3
- Contact Email
- Cost Center
- Data Classification
    - Public
    - Internal
    - Restricted
    - Confidential
---
### audit-bp-assignment

> This is a policy assignment that can be used to audit a named Blueprint assignment. The default value looks for an assignment named subscription-governance to audit for the application of guardrails for an Azure subscription.