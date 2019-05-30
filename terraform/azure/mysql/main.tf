resource "azurerm_resource_group" "mysql" {
  name     = "${var.resource_group_name}"
  location = "${var.resource_group_location}"
}

resource "azurerm_mysql_server" "mysql" {
  name                = "${var.prefix}-mysqlsrvr"
  location            = "${azurerm_resource_group.mysql.location}"
  resource_group_name = "${azurerm_resource_group.mysql.name}"

  sku {
    name     = "${var.mysql_sku_name}"
    capacity = "${var.mysql_sku_capacity}"
    tier     = "${var.mysql_sku_tier}"
    family   = "${var.mysql_sku_gen}"
  }

  storage_profile {
    storage_mb            = "${var.mysql_stor_size}"
    backup_retention_days = "${var.mysql_stor_retention}"
    geo_redundant_backup  = "${var.mysql_stor_geobackup}"
  }

  administrator_login          = "${var.mysql_adminuser}"
  administrator_login_password = "${var.mysql_adminpass}"
  version                      = "${var.mysql_version}"
  ssl_enforcement              = "${var.mysql_sslenforce}"
}

resource "azurerm_mysql_database" "mysql" {
  name                = "${var.prefix}-db"
  resource_group_name = "${azurerm_resource_group.mysql.name}"
  server_name         = "${azurerm_mysql_server.mysql.name}"
  charset             = "${var.mysql_chartset}"
  collation           = "${var.mysql_collation}"
}

#UNCOMMENT IF MYSQL FIREWALL IS NEEDED

# resource "azurerm_mysql_firewall_rule" "mysql" {
#   name                = "${var.prefix}-fwrule"
#   resource_group_name = "${azurerm_resource_group.mysql.name}"
#   server_name         = "${azurerm_mysql_server.mysql.name}"
#   start_ip_address    = "${var.mysql_fw_startip}"
#   end_ip_address      = "${var.mysql_fw_endip}"
# }