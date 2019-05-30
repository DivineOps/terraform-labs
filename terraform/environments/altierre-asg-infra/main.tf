module "provider" {
  source = "../../azure/provider"
}

resource "azurerm_resource_group" "cluster_rg" {
  name     = "${var.resource_group_name}"
  location = "${var.resource_group_location}"
}

module "azurefiles" {
  source = "../../azure/azurefiles"
  
  resource_group_name     = "${var.resource_group_name}"
  resource_group_location = "${var.resource_group_location}"
  prefix   = "${var.eh_prefix}"
}

module "mysql" {
  source = "../../azure/mysql"
  
  resource_group_name     = "${var.resource_group_name}"
  resource_group_location = "${var.resource_group_location}"
  prefix   = "${var.mysql_prefix}"
  mysql_sku_name = "${var.mysql_sku_name}"
  mysql_sku_capacity = "${var.mysql_sku_capacity}"
  mysql_sku_tier = "${var.mysql_sku_tier}"
  mysql_sku_gen = "${var.mysql_sku_gen}"
  mysql_stor_size            = "${var.mysql_stor_size}"
  mysql_stor_retention = "${var.mysql_stor_retention}"
  mysql_stor_geobackup  = "${var.mysql_stor_geobackup}"
  mysql_adminuser          = "${var.mysql_adminuser}"
  mysql_adminpass = "${var.mysql_adminpass}"
  mysql_version                     = "${var.mysql_version}"
  mysql_sslenforce              = "${var.mysql_sslenforce}"
  mysql_chartset            = "${var.mysql_chartset}"
  mysql_collation           = "${var.mysql_collation}"
  # mysql_fw_startip    = "${var.mysql_fw_startip}"
  # mysql_fw_endip      = "${var.mysql_fw_endip}"
}

module "eventhubs" {
  source = "../../azure/eventhubs"
  
  resource_group_name     = "${var.resource_group_name}"
  resource_group_location = "${var.resource_group_location}"
  prefix   = "${var.azfiles_prefix}"
}


module "vnet" {
  source = "../../azure/vnet"

  vnet_name = "${var.vnet_name}"

  address_space   = "${var.address_space}"
  subnet_prefixes = ["${var.subnet_prefix}"]

  resource_group_name     = "${var.resource_group_name}"
  resource_group_location = "${var.resource_group_location}"
  subnet_names            = ["${var.cluster_name}-aks-subnet"]
  subnet_prefixes         = ["${var.subnet_prefixes}"]

  tags = {
    environment = "azure-simple"
  }
}

module "aks" {
  source = "../../azure/aks"

  agent_vm_count           = "${var.agent_vm_count}"
  agent_vm_size            = "${var.agent_vm_size}"
  cluster_name             = "${var.cluster_name}"
  dns_prefix               = "${var.dns_prefix}"
  ssh_public_key           = "${var.ssh_public_key}"
  resource_group_location  = "${var.resource_group_location}"
  resource_group_name      = "${azurerm_resource_group.cluster_rg.name}"
  service_principal_id     = "${var.service_principal_id}"
  service_principal_secret = "${var.service_principal_secret}"
  vnet_subnet_id           = "${module.vnet.vnet_subnet_ids[0]}"
  service_cidr             = "${var.service_cidr}"
  dns_ip                   = "${var.dns_ip}"
  docker_cidr              = "${var.docker_cidr}"
  enable_virtual_node_addon= false
}
