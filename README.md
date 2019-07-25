## Description:

A sample Terraform template to deploy an AKS cluster. The [aks_advnet_rbac](/aks_advnet_rbac/) directory has the terraform code to deploy an AKS cluster with AzureCNI into a custom network and enables Kubernetes RBAC control. 


## Usage

For best results ensure you have the latest Terraform for your workstation or use the [Azure Cloud Shell](https://shell.azure.com/) which has the latest tools installed including Azure CLI, kubectl and Terraform.


### Create the Service Principal
To run Terraform in Azure Pipelines (unless using the TODO task) you will need to provide the AAD Service Principal information. To create the Service Principal, run the following commands on your local machine:

```
az login
azure account set -s {SubscriptionId}
az ad sp create-for-rbac
```

The output is similar to the following example. Make a note of your own `appId`, `password` and `tenant`. These values are used for the environment variables.

```json
{
  "appId": "559513bd-0c19-4c1a-87cd-851a26afd5fc",
  "displayName": "azure-cli-2018-09-25-21-10-19",
  "name": "http://azure-cli-2018-09-25-21-10-19",
  "password": "e763725a-5eee-40e8-a466-dc88d980f415",
  "tenant": "72f988bf-86f1-41af-91ab-2d7cd011db48"
}
```

### Create the Storage Account for Terraform state

```
az group create -n MyResourceGroup -l MyLocation
az storage account create -n MyStorageAccount -g MyResourceGroup -l MyLocation --sku Standard_LRS
```

## Environment variables 
Expected in the [variables.tf](/aks_advnet_rbac/variables.tf) file:

### Reserved Terraform environment variable names:
ARM_ACCESS_KEY - the storage access key for the terraform state (used by the   backend "azurerm" block)

ARM_CLIENT_ID - The Client ID for the Service Principal to use for this Managed Kubernetes Cluster (used by the provider "azurerm" block)

ARM_CLIENT_SECRET - The Client Secret for the Service Principal to use for this Managed Kubernetes Cluster (used by the provider "azurerm" block) 

ARM_SUBSCRIPTION_ID - your Subscription ID (used by the provider "azurerm" block) 

ARM_TENANT_ID - your Tenant ID (used by the provider "azurerm" block) 


### TF_VAR_ environment variable names 
(The environment variable should be defined with the TF_VAR_ prefix, but used without the TF_VAR_ prefix in the variables.tf)

TF_VAR_ARM_CLIENT_ID - The Client ID for the Service Principal to use for this Managed Kubernetes Cluster (used by the service_principal block)

TF_VAR_ARM_CLIENT_SECRET - The Client Secret for the Service Principal to use for this Managed Kubernetes Cluster (used by the service_principal block)

TF_VAR_PREFIX - A prefix used for all resource names in this example

TF_VAR_LOCATION - The Azure Region in which all resources in this example should be provisioned

TF_VAR_ADMIN_SSH - Your SSH public key for the AKS cluster



## Running Terraform

Initialize your Terraform to get the latest plugins needed

To run the Terraform file on a local machine or in Azure Pipelines:

```
cd aks_advnet_rbac
terraform init
terraform plan
terraform apply -auto-approve
```


### License
MIT License

Copyright (c) 2019 Eddie Villalba, Sasha Rosenbaum

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
