variable "prefix" {
  description = "A prefix used for all resources in this example"
}

variable "location" {
  default     = "East US"
  description = "The Azure Region in which all resources in this example should be provisioned"
}

variable "k8sVer" {
  default     = "1.11.5"
  description = "The version of Kubernetes you want deployed to your cluster. Please reference the command: az aks get-versions --location eastus -o table"
}

variable "kubernetes_client_id" {
  description = "The Client ID for the Service Principal to use for this Managed Kubernetes Cluster"
}

variable "kubernetes_client_secret" {
  description = "The Client Secret for the Service Principal to use for this Managed Kubernetes Cluster"
}

variable "public_ssh_key_path" {
  description = "The Path at which your Public SSH Key is located. Defaults to ~/.ssh/id_rsa.pub"
  default     = "~/.ssh/id_rsa.pub"
}

variable "vnetIPCIDR" {
  default = "172.20.0.0/16"
  description = "The IP address CIDR block to be assigned to the entride Azure Virtual Network. If connecting to another peer or to you On-Premises netwokr this CIDR block MUST NOT overlap with existing BGP learned routes"
}

variable "subnetIPCIDR" {
  default = "172.20.0.0/20"
  description = "The IP address CIDR block to be assigned to the subnet that AKS nodes and Pods will ge their IP addresses from. This is a subset CIDR of the vnetIPCIDR"
}

variable "osAdminUser" {
  default = "aksadmin"
  description = "The username assigned to the admin user on the OS of the AKS nodes if SSH access is ever needed"
}

variable "nodeCount" {
  default = "1"
  description = "The starting number of Nodes in the AKS cluster"
}

variable "nodeSize" {
  default = "Standard_DS2_v2"
  description = "The Node type and size based on Azure VM SKUs Reference: az vm list-sizes --location eastus -o table"
}
variable "netPlugin" {
  default = "azure"
  description = "Can either be azure or kubenet. azure will use Azure subnet IPs for Pod IPs. Kubenet you need to use the pod-cidr variable below"
}

variable "pod-cidr" {
  default = "172.23.0.0/16"
  description = "Only use if kubenet is assigned as the network plugin. It will be divided into a /24 for each node and will be the space assigned for POD IPs on each node. A Rout Table will be created by Azure, but it must be assigned to the AKS subnet upon completion of deployment to complete install"
}

variable "svc-cidr" {
  default = "172.21.0.0/16"
  description = "The IP address CIDR block to be assigned to the service created inside the Kubernetes cluster. If connecting to another peer or to you On-Premises network this CIDR block MUST NOT overlap with existing BGP learned routes"
}

variable "dns-ip" {
  default = "172.20.0.10"
  description = "The IP address that will be assigned to the CoreDNS or KubeDNS service inside of Kubernetes for Service Discovery. Must start at the .10 or higher of the svc-cidr range"
}

variable "dockerbridge-cidr" {
  default = "172.22.0.1/16"
  description = "The IP address CIDR block to be assigned to the Docker container bridge on each node. If connecting to another peer or to you On-Premises network this CIDR block SHOULD NOT overlap with existing BGP learned routes"
}


