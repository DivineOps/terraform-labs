# AKS Secure Template

This Terraform module will deploy the following resources:

1. Azure Resource Group for AKS with the following resources
  * AKS Object
  * VNet defaulting to 10.10.0.0/16 with a single subnet for AKS 10.10.1.0/24
  * VNet peered to hub vnet
  * 2 node Pools that can be named by using variables with Cluster Autoscaling enabled for each node pool based on true or false and min max for each pool
  * Service Principal scoped as Network Contributor to Vnet used by AKS
2. Resource Group for AZ Firewall and hub Vnet
  * Azure Firewall configured with allow rules for Restricted egress as outlined in https://docs.microsoft.com/en-us/azure/aks/limit-egress-traffic
  * Static Public IP for Azure Firewall with DNS name assigned
  * Vnet with 10.0.0.0/16 CDIR with subnet 10.0.1.0/24 for the internal interface of the Azure Firewall
  * Vnet peering to AKS VNet
3. AKS is deployed with the security features in preview
  * Pod Security Policy
  * Calico Network Policy Module
  * kubenet with POD CIDR of 172.18.0.0/16, Service CIDR of 172.16.0.0/16, DNS IP of 172.16.0.10 and Docker Bride CIDR of 172.17.0.1/16
  * Restricted Egress traffic as outlined in https://docs.microsoft.com/en-us/azure/aks/limit-egress-traffic
  * API server authorized IP Whitelisting as described in https://docs.microsoft.com/en-us/azure/aks/api-server-authorized-ip-ranges
  * Azure AD integrated RBAC as outlined in https://docs.microsoft.com/en-us/azure/aks/azure-ad-integration
  * The AKS Created UDR for kubenet is updated with a new route of 0.0.0.0/0 to the internal IP of the AZ Firewall in the peered hub Vnet and assigned to the AKS subnet
  
The module has a dependency that the deployment machine (the machine running terraform) has the azure CLI 2.0 installed and logged into target Subscription. This is do to preview API features are flagged only through Azure CLI

The following values can be used for a `terraform.tfvars`

```hcl
PROJECT="gbs"
INSTANCE="1"
ENVIRONMENT="dev"
REGION="southcentralUS"
AKS_SSH_ADMIN_KEY="ssh-rsa AIUGSJHG87GU75786JHGUY.......IMHF764NBHV me@mine.com"
ADMIN_USER="adminuser"
NODE_COUNT="1"
NODE_SIZE="Standard_D2s_v3"
K8S_VER="1.13.5"
VNET_NAME="aks-vnet"
AAD_CLIENTAPP_ID="<CLIENT_APP_ID"
AAD_SERVERAPP_ID="<SERVER_APP_ID>"
AAD_SERVERAPP_SECRET="<SERVER_APP_SECRET>"
AUTH_IP_RANGES="<COMMA_SEPARATED_LIST_OF_APPROVED_CIDRS/IPS>"
DOCKER_REGISTRY="myacr.azurecr.io"
POD_CIDR="172.18.0.0/16"
POOL1_NAME="ppol1"
POOL1_MIN="1"
POOL1_MAX="5"
POOL2_NAME="pool2"
POOL2_MIN="1"
POOL2_MAX="5"
ENABLE_CA_POOL1="true"
ENABLE_CA_POOL2="true"
```

The following Values can also be called in the `terraform.tfvars` but they are defaulted in the `variables.tf` file (default values shown):
```hcl
VNET_ADDR_SPACE="10.10.0.0/16"
DNS_SERVERS=[]
SUBNET_NAMES=["aks-subnet"]
SUBNET_PREFIXES=["10.10.1.0/24"]
SERVICE_CIDR="172.16.0.0/16" #Used to assign internal services in the AKS cluster an IP address. This IP address range should be an address space that isn't in use elsewhere in your network environment. This includes any on-premises network ranges if you connect, or plan to connect, your Azure virtual networks using Express Route or a Site-to-Site VPN connections
DNS_IP="172.16.0.10" #should be the .10 address of your service IP address range
DOCKER_CIDR="172.17.0.1/16" #IP address (in CIDR notation) used as the Docker bridge IP address on nodes. Default of 172.17.0.1/16.
VDMZ_VNET_NAME="vDMZ-Vnet-hub"
```
