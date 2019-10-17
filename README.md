# Terraforming PCF in Azure

## What Does This Do?

Will go from zero to having a deployed ops-manager. storage accounts, and a booted ops-manager VM. This work is based upon Pivotal's [template] (https://network.pivotal.io/api/v2/products/elastic-runtime/releases/467372/product_files/441941/download) for the same.

## Prerequisites

You need the Terraform CLI which you can pick up [here](https://www.terraform.io/downloads.html)
We are currently using 0.12.8 for pcf-prereqs and 0.11.13 for everything else.

You will also need:
- [OM] (https://github.com/pivotal-cf/om)
- [Texplate] (https://github.com/pivotal-cf/texplate)

## Creating A Service Principal

You should have a service principal to deploy anything (via Terraform) on top of Azure. The [Pivotal guide] (https://docs.pivotal.io/platform/2-7/om/azure/prepare-env-terraform.html) tells you how to create them, but we've done this for you automatically in the pcf-prereqs Terraform files if you have the rights to do this in your tenant.

## Environment Variables
1. ARM_ACCESS_KEY
1. ARM_CLIENT_ID
1. ARM_CLIENT_SECRET
1. ARM_SUBSCRIPTION_ID
1. ARM_TENANT_ID
1. TF_VAR_client_id
1. TF_VAR_client_secret
1. TF_VAR_storage_access_key

Most of this is material [documented] (https://www.terraform.io/docs/providers/azurerm/auth/service_principal_client_secret.html) on Terraform's site for authenticating to Azure using the AzureRM Provider. The crux of it is that you need to define some environment variables (one choice) in order for this to all work seamlessly. The above vars are the ones this series of scripts expects.

The exception to this rule is for the pcf-prereqs. That script creates the client ID and secret, so it's actually important that these values *not* be filled out when you run that plan. That plan should rely on your AZ CLI client configuration with your Azure user account association. See [here] (https://www.terraform.io/docs/providers/azurerm/auth/azure_cli.html) for more info.

## Deploying Ops Manager

Depending if you're deploying PAS or PKS you need to perform the following steps:

If it's your first time running this script, you'll need to run the prereqs first. This is currently handled inside a Terraform v.0.12.8 version plan in [pcf-prereqs/](pcf-prereqs). That plan requires permissions in your Azure account to create a service principal, resource group, and assign rights from a group in AAD to the resource group that's created in this step.

Once you've run this once, you shouldn't need to execute it every time. Just when you want to recreate everything or when you are updating the OpsMan image source (e.g. 2.5 --> 2.6). Permissions needed for the rest of the jobs are limited to the access-key you specify in your environment variables above and the service principal credentials created in the prereq step.

1. `cd` into the proper directory:
    - e.g. [terraforming-opsman_only/](terraforming-opsman_only/)
1. Check terraform.tfvars file for accuracy
1. Run terraform apply:
  ```bash
  terraform init
  terraform plan -out=plan
  terraform apply plan
  ```

### Var File
There are certain contracts we depend on to execute this script. Contracts are agreements made with other providers for resources we depend upon. These are indicated below.

These vars will be used when you run `terraform  apply`.
You should fill in the stub values with the correct content.

Code link: [terraforming-opsman_only/terraform.tfvars](terraform.tfvars)

*Each sub-directory may have its own terraform.tfvars files associated with it. Please look at each one to ensure you're filling in the pieces that define your environment.*

```hcl
env_short_name        = "banana"
location              = "Central US"
dns_suffix            = "dork.life"

# optional.
dns_subdomain         = ""

#################
##  CONTRACTS  ##
#################
env_name              = "banana"
ops_manager_image_uri = "url-to-opsman-image"
```

## Variables

- env_name: **(required)** An arbitrary unique name for namespacing resources - *think demo-uscentral-pcf*
- env_short_name: **(required)** Used for creating storage accounts. Must be a-z only, no longer than 10 characters
- ops_manager_image_uri: **(required)** Get it from PivNet
- location: **(required)** Azure location to stand up environment in
- dns_suffix: **(required)** Domain to add environment subdomain to

## Running

Note: please make sure you have created the `terraform.tfvars` file above as mentioned.

### Standing up environment

```bash
terraform init
terraform plan -out=plan
terraform apply plan
```

### Tearing down environment

**Don't do this, probably.**

```bash
terraform destroy
```