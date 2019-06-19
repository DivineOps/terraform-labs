/*
 * Common
 */
variable "PROJECT" {
  description = "DNS-compatible Project Prefix"
}

variable "INSTANCE" {
  description = "DNS-compatible Instance Name"
}

variable "ENVIRONMENT" {
  description = "DNS-compatible Environment Name (dev, stag, prod)"
}

variable "REGION" {
  description = "Azure Region"
}
/*
 * VNET
 */
variable "VNET_NAME" {
  type = "string"
}
variable "VNET_ADDR_SPACE" {
  description = "The address space that is used by the virtual network."
  default     = "10.10.0.0/16"
}

variable "DNS_SERVERS" {
  description = "The DNS servers to be used with vNet."
  default     = []
}
variable "SUBNET_NAMES" {
  description = "A list of public subnets inside the vNet."
  default     = ["aks-subnet"]
}
variable "SUBNET_PREFIXES" {
  description = "The address prefix to use for the subnet."
  default     = ["10.10.1.0/24"]
}

/*
 * AKS
 */

variable "AKS_SSH_ADMIN_KEY" {
  description = "Admin SSH Public Key for AKS Agent VMs"
}
variable "K8S_VER" {
  type = "string"
}

variable "ADMIN_USER" {
  type = "string"
}
variable "NODE_COUNT" {
  type = "string"
}
variable "NODE_SIZE" {
  type = "string"
}
variable "SERVICE_CIDR" {
  default = "172.16.0.0/16"
  description ="Used to assign internal services in the AKS cluster an IP address. This IP address range should be an address space that isn't in use elsewhere in your network environment. This includes any on-premises network ranges if you connect, or plan to connect, your Azure virtual networks using Express Route or a Site-to-Site VPN connections."
  type = "string"
}
variable "DNS_IP" {
  default = "172.16.0.10"
  description = "should be the .10 address of your service IP address range"
  type = "string"
}
variable "DOCKER_CIDR" {
  default = "172.17.0.1/16"
  description = "IP address (in CIDR notation) used as the Docker bridge IP address on nodes. Default of 172.17.0.1/16."
}

variable "AAD_CLIENTAPP_ID" {
  type = "string"
}

variable "AAD_SERVERAPP_ID" {
  type = "string"
}

variable "AAD_SERVERAPP_SECRET" {
  type = "string"
}

variable "AUTH_IP_RANGES" {
  type="string"
}

/*
 * K8S
 */

variable "VDMZ_VNET_NAME" {
  type = "string"
  default = "vDMZ-Vnet-hub"
}

variable "DOCKER_REGISTRY" {
  type="string"
}
