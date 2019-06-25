## Description:

My sample Terraform template to deploy an AKS cluster. The [aks_advnet_rbac](/aks_advnet_rbac/) directory has the terraform code to deploy an AKS cluster with AzureCNI into a custom network and enables Kubernetes RBAC control. The [aks_kubenet_custom](/aks_kubenet_custom/) directory deploys and AKS Cluster with kubenet networking, into a custom subnet, applies the UDR to the correct subnet and installs helm into the cluster with Kubernetes RBAC enabled.

For secure cluster implementations with Preview Security features please see readme file in [aks_azcni_config_secure](/aks_azcni_config_secure/) for azureCNI and Calico enabled cluster and [aks_kubenet_config_secure](/aks_kubenet_config_secure/) for a kubenet enabled cluster.

## Usage

For best results ensure you have the latest Terraform for your workstation or use the [Azure Cloud Shell](https://shell.azure.com/) which has the latest tools installed including Azure CLI, kubectl and terraform.

You will need to get from your Azure CLI a few pieces of info to add to your [variables.tf](/aks_advnet_rbac/variables.tf) file. 
* Available AKS locations your account has access to:
```
az account list-locations -o table
```
Use the output from the Name or DisplayName column in the variable locations in the [variables.tf](/aks_advnet_rbac/variables.tf) file

* VM Sizes Available
```
az vm list-sizes --location <region_you_plan_to_use> -o table
```
The result will be used in the variable nodeSize in [variables.tf](/aks_advnet_rbac/variables.tf)

* Kubernetes Versions available in AKS

```
az aks get-versions --location <region_you_plan_to_use> -o table
```

This will list the versions currently supported by AKS including Minor and Patch versions. Use your choice in the variable named k8sVer in the [variables.tf](/aks_advnet_rbac/variables.tf) file.

* Initialize your Terraform to get the latest plugins needed

CD into the cloned repo and then into the aks_advnet_rbac folder and run your terraform init to get the latest AzureRM providers
```
cd aks_advnet_rbac
terraform init
```


You will need to provide a Service Principal ClientID and Secret for the Cluster to use. If you have the proper permissions in your AAD you can run the following:
```
az ad sp create-for-rbac --skip-assignment
```

The output is similar to the following example. Make a note of your own `appId` and `password`. These values are used when run `terraform plan` or `terraform apply` when asked.

```json
{
  "appId": "559513bd-0c19-4c1a-87cd-851a26afd5fc",
  "displayName": "azure-cli-2018-09-25-21-10-19",
  "name": "http://azure-cli-2018-09-25-21-10-19",
  "password": "e763725a-5eee-40e8-a466-dc88d980f415",
  "tenant": "72f988bf-86f1-41af-91ab-2d7cd011db48"
}
```
Once you have the info needed then you can do either a `terraform plan` or `terraform apply`


### License
MIT License

Copyright (c) 2018 Eddie Villalba

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
