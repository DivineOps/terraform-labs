variable "resource_group_location" {
    type = "string"
}
variable "resource_group_name" {
    type = "string"
}

variable "prefix" {
  type   = "string"
}
variable "kube_config_path" {
  description = "Path to copy kube-config for AKS built"
  default ="./output"
}
