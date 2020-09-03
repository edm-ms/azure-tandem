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