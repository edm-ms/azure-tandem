### This repo contains pre-built Blueprints and Azure Devops Pipelines to streamline the deployment of a well-governed Azure environment. This repo builds off the work of the [Cloud Adoption Framework](https://docs.microsoft.com/en-us/azure/cloud-adoption-framework/) and [Enterprise Scale](https://docs.microsoft.com/en-us/azure/cloud-adoption-framework/ready/enterprise-scale/) architectures.

### Notes
> Name format, environment, and regions are hard-coded in templates. Region deployment is controlled in most instances by selecting the environment. A future update will automate naming, environment, and region selection.

- Regions
    - East US 2 / Central US
- Environments
    - prd (production) / East US 2
    - npd (non-production) / Central US
    - sbx (sandbox) / Central US
- Name Format
    - (region short name-environment-application-resource short name)
    - Example of a production deployment of a key vault for an application named "dataintel" 
        - eus2-prd-dataintel-kv
---
### Platform-Management (Step 1.)

> This blueprint is used to establish the landing zone for the platform management subscription. It is recommended to set the Blueprint assignment to "read-only" in order to prevent modification of the resources created by this Blueprint.

- User Assigned Managed Identity
- Storage Account
- Log Analytics Workspace (365 Day Retention)
- Azure Sentinel
- Key Vault
---

### Subscription-Governance (Step 2.)

> This blueprint is used to establish base governance for an Azure subscription. It is recommended to set the Blueprint assignment to "read-only" in order to prevent modification of the resources and policies created by this Blueprint.

- Centralize Activity Logging to Platform-Management Workspace
- Allowed Locations for Resources (East US 2/Central US)
- Allowed Locations for Resource Groups (East US 2/Central US)
- Audit Virtual Machines with Pending Reboot
- Enable Azure Security Center (Standard/Free) and Centralize to Platform-Management Workspace
- Enable Azure Security Policy
- Deploy Network Watcher for New Networks
- Audit IP Forwarding on Virtual Machines
- Audit Service Endpoints for Resources:
    - Azure Container Registry
    - App Service
    - CosmosDB
    - Event Hub
    - Key Vault
    - MariaDB
    - MySQL
    - PostgreSQL
    - Service Bus
    - SQL DB
    - Storage Accounts
- Enable Base Set of Azure Subscription Alerting
    - IAM Changes
    - NSG Modification
    - Policy Assignment Deletion
    - Public IP Creation
    - Resource Group Creation
    - Route Table Modification
    - VNet Modification
- Enable Base Tagging Policy
    - Deny Resource Group Creation Without Tags
    - Inherit Tags on Resources from Resource Group
        - Application Name
        - Application Owner
        - Business Criticality
        - Contact Email
        - Cost Center
        - Data Classification
- Allowed VM SKU's

| VM SKU | CPU | MEMORY (GB) | USE |
| --- | --- | --- | --- |
| Standard_B1ms | 1 | 2 | Burstable/Test |
| Standard_F2s_v2 | 2 | 4 | Production |
| Standard_B2s | 2 | 4 | Burstable/Test |
| Standard_B2ms | 2 | 8 | Burstable/Test |
| Standard_D2s_v4 | 2 | 8 | Production |
| Standard_B4ms | 4 | 16 | Burstable/Test |
| Standard_D4s_v4 | 4 | 16 | Production |
| Standard_F8s_v2 | 8 | 16 | Production |
| Standard_B8ms | 8 | 32 | Burstable/Test |
| Standard_D8s_v4 | 8 | 32 | Production |
| Standard_E8s_v3 | 8 | 64 | Production |
| Standard_F16s_v2 | 16 | 32 | Production | 
| Standard_E16s_v3 | 16 | 128 | Production |
---

### New-Project (Step 3.)

> This blueprint is used to establish the landing zone for new projects. It is recommended to set the Blueprint assignment to "read-only" in order to prevent modification of the resources created by this Blueprint.

- Resource Group with Required Tags
    - Application Name
    - Application Owner
    - Business Criticality: Allowed Values (Tier0, Tier1, Tier2, Tier3)
    - Contact Email
    - Cost Center
    - Data Classification Allowed Values (Public, Internal, Restricted, Confidential)
- RBAC Role
    - Contributor
    - Virtual Machine Contributor
    - Storage Account Contributor
    - Network Contributor
    - Key Vault Contributor
    - SQL DB Contributor