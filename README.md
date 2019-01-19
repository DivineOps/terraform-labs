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
