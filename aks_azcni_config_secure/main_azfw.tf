resource "azurerm_resource_group" "hubrg" {
  name     = "${var.PROJECT}${var.INSTANCE}${var.ENVIRONMENT}${random_integer.uuid.result}-hub-rg"
  location = "${var.REGION}"
}

resource "azurerm_virtual_network" "hubvnet" {
  name                = "hubvnet"
  address_space       = ["10.0.0.0/16"]
  location            = "${azurerm_resource_group.hubrg.location}"
  resource_group_name = "${azurerm_resource_group.hubrg.name}"
}

resource "azurerm_subnet" "azfwsubnet" {
  name                 = "AzureFirewallSubnet"
  resource_group_name  = "${azurerm_resource_group.hubrg.name}"
  virtual_network_name = "${azurerm_virtual_network.hubvnet.name}"
  address_prefix       = "10.0.1.0/24"
}

resource "azurerm_public_ip" "azfwpip" {
  name                = "azfwpip"
  location            = "${azurerm_resource_group.hubrg.location}"
  resource_group_name = "${azurerm_resource_group.hubrg.name}"
  allocation_method   = "Static"
  sku                 = "Standard"
}

resource "azurerm_firewall" "hubazfw" {
  name                = "hubazfw"
  location            = "${azurerm_resource_group.hubrg.location}"
  resource_group_name = "${azurerm_resource_group.hubrg.name}"

  ip_configuration {
    name                          = "configuration"
    subnet_id                     = "${azurerm_subnet.azfwsubnet.id}"
    public_ip_address_id          = "${azurerm_public_ip.azfwpip.id}"
  }
}

resource "azurerm_firewall_application_rule_collection" "appruleazfw" {
  name                = "AzureFirewallAppCollection"
  azure_firewall_name = "${azurerm_firewall.hubazfw.name}"
  resource_group_name = "${azurerm_resource_group.hubrg.name}"
  priority            = 100
  action              = "Allow"

  rule {
    name = "hcp_rules"

    source_addresses = [
      "*",
    ]

    target_fqdns = [
      "*.hcp.${var.REGION}.azmk8s.io",
      "*.tun.${var.REGION}.azmk8s.io",
      "aksrepos.azurecr.io",
      "*.blob.core.windows.net",
      "mcr.microsoft.com",
      "*.cdn.mscr.io",
      "management.azure.com",
      "login.microsoftonline.com",
      "api.snapcraft.io"
      ]

    protocol {
        port = "443"
        type = "Https"
    }

    protocol {
        port = "80"
        type = "Http"
    }
  }
  rule {
    name = "dockerReg_rules"

    source_addresses = [
      "*",
    ]

    target_fqdns = [
      "${var.DOCKER_REGISTRY}",
      "*.docker.io"
    ]

    protocol {
        port = "443"
        type = "Https"
    }

    protocol {
        port = "80"
        type = "Http"
    }
  }
  rule {
    name = "aks_support_rules"

    source_addresses = [
      "*",
    ]

    target_fqdns = [
      "*.ubuntu.com",
      "packages.microsoft.com",
      "dc.services.visualstudio.com",
      "*.opinsights.azure.com",
      "*.monitoring.azure.com",
      "gov-prod-policy-data.trafficmanager.net"
    ]

    protocol {
        port = "443"
        type = "Https"
    }

    protocol {
        port = "80"
        type = "Http"
    }
  }
  
}

# resource "azurerm_firewall_application_rule_collection" "appruleazfw2" {
#   name                = "AzureFirewallAppCollection2"
#   azure_firewall_name = "${azurerm_firewall.hubazfw.name}"
#   resource_group_name = "${azurerm_resource_group.hubrg.name}"
#   priority            = 101
#   action              = "Allow"

#   rule {
#     name = "aks_support_rules"

#     source_addresses = [
#       "*",
#     ]

#     target_fqdns = [
#       "*.ubuntu.com",
#       "packages.microsoft.com",
#       "dc.services.visualstudio.com",
#       "*.opinsights.azure.com",
#       "*.monitoring.azure.com",
#       "gov-prod-policy-data.trafficmanager.net"
#     ]

#     protocol {
#         port = "443"
#         type = "Https"
#     }

#     protocol {
#         port = "80"
#         type = "Http"
#     }
#   }
# }
# resource "azurerm_firewall_nat_rule_collection" "test" {
#   name                = "testcollection"
#   azure_firewall_name = "${azurerm_firewall.test.name}"
#   resource_group_name = "${azurerm_resource_group.test.name}"
#   priority            = 100
#   action              = "Dnat"

#   rule {
#     name = "testrule"

#     source_addresses = [
#       "10.0.0.0/16",
#     ]

#     destination_ports = [
#       "53",
#     ]

#     destination_addresses = [
#       "8.8.8.8",
#       "8.8.4.4",
#     ]

#     protocols = [
#       "TCP",
#       "UDP",
#     ]
#   }
# }

resource "azurerm_firewall_network_rule_collection" "netruleasfw" {
  name                = "AzureFirewallNetCollection"
  azure_firewall_name = "${azurerm_firewall.hubazfw.name}"
  resource_group_name = "${azurerm_resource_group.hubrg.name}"
  priority            = 200
  action              = "Allow"

  rule {
    name = "AllowTCP_UDPOutbound"

    source_addresses = [
      "*",
    ]

    destination_ports = [
      "53",
      "123",
      "22",
      "9000"
    ]

    destination_addresses = [
      "*"
    ]

    protocols = [
      "TCP",
      "UDP"
    ]
  }
}