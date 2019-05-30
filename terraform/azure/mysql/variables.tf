variable "resource_group_location" {
    type = "string"
}
variable "resource_group_name" {
    type = "string"
}

variable "prefix" {
  type   = "string"
}

variable "mysql_sku_name" {
  type   = "string"
}

variable "mysql_sku_capacity" {
  type   = "string"
}

variable "mysql_sku_tier" {
  type   = "string"
}

variable "mysql_sku_gen" {
  type   = "string"
}

variable "mysql_stor_size" {
  type = "string"
}

variable "mysql_stor_retention" {
  type = "string"
}

variable "mysql_stor_geobackup" {
  type = "string"
}

variable "mysql_adminuser" {
  type = "string"
}

variable "mysql_adminpass" {
  type = "string"
}

variable "mysql_version" {
  type = "string"
}

variable "mysql_sslenforce" {
  type = "string"
}

variable "mysql_chartset" {
  type = "string"
}

variable "mysql_collation" {
  type = "string"
}

# variable "mysql_fw_startip" {
#   type = "string"
# }

# variable "mysql_fw_endip" {
#   type = "string"
# }