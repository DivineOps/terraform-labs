resource "azurerm_mysql_server" "mysql" {
  name                = "${var.PROJECT}${var.INSTANCE}${var.ENVIRONMENT}${random_integer.uuid.result}-mysqlsrvr"
  location            = "${azurerm_resource_group.main.location}"
  resource_group_name = "${azurerm_resource_group.main.name}"

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
  name                = "${var.PROJECT}${var.INSTANCE}${var.ENVIRONMENT}${random_integer.uuid.result}db"
  resource_group_name = "${azurerm_resource_group.main.name}"
  server_name         = "${azurerm_mysql_server.mysql.name}"
  charset             = "${var.mysql_chartset}"
  collation           = "${var.mysql_collation}"
}