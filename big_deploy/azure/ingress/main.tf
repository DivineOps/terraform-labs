resource "azurerm_resource_group" "ingress" {
  name     = "${var.resource_group_name}"
  location = "${var.resource_group_location}"
}

# ingress ip
resource "azurerm_public_ip" "ingress_ip" {
  name                = "${var.prefix}-iip"
  location            = "${azurerm_resource_group.ingress.location}"
  resource_group_name = "${azurerm_resource_group.ingress.name}"

  public_ip_address_allocation = "static"
  domain_name_label            = "${var.prefix}-ing"
}
resource "local_file" "kube_config" {
  # kube config
  filename = "${var.kube_config_path}"
  content  = "${module.aks.azurerm_kubernetes_cluster.cluster.kube_config_raw}"
}
# helm provider
provider "helm" {
  debug = true
  home  = "${var.kube_config_path}"
  kubernetes {
    config_path = "${local_file.kube_config.filename}"
  }
}

# ingress
resource "helm_release" "ingress" {
  name      = "ingress"
  chart     = "stable/nginx-ingress"
  namespace = "ingress"
  timeout   = 1800

  set {
    name  = "controller.service.loadBalancerIP"
    value = "${azurerm_public_ip.ingress_ip.ip_address}"
  }
  set {
    name = "controller.service.annotations.\"service\\.beta\\.kubernetes\\.io/azure-load-balancer-resource-group\""
    value = "${azurerm_resource_group.ingress.name}"
  }
}

# cert-manager
resource "helm_release" "cert-manager" {
  name      = "cert-manager"
  chart     = "stable/cert-manager"
  namespace = "kube-system"
  timeout   = 1800
  depends_on = [ "helm_release.ingress" ]

  set {
    name  = "ingressShim.defaultIssuerName"
    value = "letsencrypt"
  }
  set {
    name  = "ingressShim.defaultIssuerKind"
    value = "ClusterIssuer"
  }
}

# letsencrypt
resource "helm_release" "letsencrypt" {
  name      = "letsencrypt"
  chart     = "./charts/letsencrypt/"
  namespace = "kube-system"
  timeout   = 1800
  depends_on = [ "helm_release.cert-manager" ]
}
