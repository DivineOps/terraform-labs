## Description:

My sample Terraform template to deploy an AKS cluster with Advanced Networking, Azure Monitoring and Kubernetes RBAC enabled.

## Usage

For best results ensure you have the latest Terraform for your workstation or use the [Azure Cloud Shell](https://shell.azure.com/) which has the latest tools installed including Azure CLI, kubectl and terraform.

You will need to get from your Azure CLI a few pieces of info to add to your [variables.tf](/aks_advnet_rbac/variables.tf) file. 
* Avaibale AKS locations your account has access to:
```
az account list-locations -o table
```
Use the output from the Name or DisplayName column in the variable locations in the [variables.tf](/aks_advnet_rbac/variables.tf) file

* VM Sizes Available
```
az vm list-sizes --location <region_you_plan_to_use> -o table
```
The result will be used in the variable nodeSize in [variables.tf](/aks_advnet_rbac/variables.tf)

* Kubenetes Versions available in AKS

```
az aks get-versions --location <region_you_plan_to_use> -o table
```

This will list the versions currently supported by AKS including Minor and Patch versions. Use your choise in the variabled named k8sVer in the [variables.tf](/aks_advnet_rbac/variables.tf) file.

