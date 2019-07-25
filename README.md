## Description:

A sample Terraform template to deploy an AKS cluster. The [aks_advnet_rbac](/aks_advnet_rbac/) directory has the terraform code to deploy an AKS cluster with AzureCNI into a custom network and enables Kubernetes RBAC control. 


## Usage

For best results ensure you have the latest Terraform for your workstation or use the [Azure Cloud Shell](https://shell.azure.com/) which has the latest tools installed including Azure CLI, kubectl and Terraform.


### Create the Service Principal
To run Terraform in Azure Pipelines (unless using the new [Terraform CLI](https://marketplace.visualstudio.com/items?itemName=jlorich.TerraformCli) task) you will need to provide the AAD Service Principal information. To create the Service Principal, run the following commands on your local machine:

```
az login
azure account set -s MySubscriptionId
az ad sp create-for-rbac
```

The output is similar to the following example. Make a note of your own `appId`, `password` and `tenant`. These values are used for the environment variables.

```json
{
  "appId": "XXXXXXXX-0c19-4c1a-87cd-851a26afd5fc",
  "displayName": "azure-cli-2018-09-25-21-10-19",
  "name": "http://azure-cli-2018-09-25-21-10-19",
  "password": "XXXXXXXX-5eee-40e8-a466-dc88d980f415",
  "tenant": "XXXXXXXX-86f1-41af-91ab-2d7cd011db48"
}
```

### Create the Storage Account for Terraform state

Terraform persists a state file, allowing it to update . The backend "azurerm" block is used to configure the storage account target. 

Use the following commands to create the storage account for the Terraform state. Use a *different* resource group than the one the AKS resources will be deployed to. 

```
az group create -n MyResourceGroup -l MyLocation
az storage account create -n MyStorageAccount -g MyResourceGroup -l MyLocation --sku Standard_LRS
az storage account keys list -n MyStorageAccount
```

After the account has been created, update the storage_account_name attribute in backend "azurerm" block in [main.tf](/aks_advnet_rbac/main.tf) to the new storage account name. Update the ARM_ACCESS_KEY environment variable to the new account access key. 

## Environment variables 
Expected in the [variables.tf](/aks_advnet_rbac/variables.tf) file:

### Reserved Terraform environment variable names:
ARM_ACCESS_KEY - the storage access key for the terraform state (used by the   backend "azurerm" block)

ARM_CLIENT_ID - The Client ID (appId) for the Service Principal to use for this Managed Kubernetes Cluster (used by the provider "azurerm" block)

ARM_CLIENT_SECRET - The Client Secret (password) for the Service Principal to use for this Managed Kubernetes Cluster (used by the provider "azurerm" block) 

ARM_SUBSCRIPTION_ID - your Subscription ID (used by the provider "azurerm" block) 

ARM_TENANT_ID - your Tenant ID (tenant) (used by the provider "azurerm" block) 


### TF_VAR_ environment variable names 
(The environment variable should be defined with the TF_VAR_ prefix, but used without the TF_VAR_ prefix in the variables.tf)

TF_VAR_PREFIX - A prefix used for all resource names in this example

TF_VAR_LOCATION - The Azure Region in which all resources in this example should be provisioned

TF_VAR_ADMIN_SSH - Your SSH public key for the AKS cluster

### Pipeline variable
TFSTATE_STORAGE - The name of the storage account where the Terraform state is kept (passed as an input into `terraform init`)


## Running Terraform

To run the Terraform file on a local machine or in Azure Pipelines:

```      
# Output all commands run and fail if any fail
set -e -x

cd aks_advnet_rbac

# Init terraform using the defined storage account 
terraform init \
  -backend-config="storage_account_name=${TFSTATE_STORAGE}"
  
# Generate a terraform plan file
terraform plan \
  -input=false \
  -var="ARM_CLIENT_ID=${ARM_CLIENT_ID}" \
  -var="ARM_CLIENT_SECRET=${ARM_CLIENT_SECRET}" \
  -out=plan.tfplan
  
# Apply the terraform plan
terraform apply plan.tfplan
```

