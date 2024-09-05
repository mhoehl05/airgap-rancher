resource "azurerm_container_registry" "default_acr" {
  name                = "acrRancherDemo"
  resource_group_name = var.resource_group_name
  location            = var.location
  sku                 = "Premium"
  admin_enabled       = true

  network_rule_set {
    default_action = "Deny"
  }
}

resource "azurerm_private_endpoint" "pep" {
  name                = format("%s-pep", azurerm_container_registry.default_acr.name)
  location            = var.location
  resource_group_name = var.resource_group_name
  subnet_id           = var.subnet_id

  private_service_connection {
    name                           = format("%s-pep-connection", azurerm_container_registry.default_acr.name)
    private_connection_resource_id = azurerm_container_registry.default_acr.id
    subresource_names              = ["registry"]
    is_manual_connection           = false
  }
}

data "azurerm_network_interface" "nic" {
  name                = azurerm_private_endpoint.pep.network_interface[0].name
  resource_group_name = var.resource_group_name

  depends_on = [
    azurerm_private_endpoint.pep
  ]
}

resource "azurerm_private_dns_zone" "acr" {
  name                = "privatelink.azurecr.io"
  resource_group_name = var.resource_group_name
}

resource "azurerm_private_dns_zone_virtual_network_link" "dns_vnet_link" {
  name                  = "dns-vnet-link"
  resource_group_name   = var.resource_group_name
  private_dns_zone_name = azurerm_private_dns_zone.acr.name
  virtual_network_id    = azurerm_virtual_network.example.id
}

resource "azurerm_private_dns_a_record" "pep_dns_record_data" {
  name                = lower(format("%s.%s.data", azurerm_container_registry.default_acr.name, var.location))
  zone_name           = azurerm_private_dns_zone.acr.name
  resource_group_name = var.resource_group_name
  ttl                 = 3600
  records             = [data.azurerm_network_interface.nic.private_ip_addresses[0]]
}

resource "azurerm_private_dns_a_record" "pep_dns_record" {
  name                = lower(azurerm_container_registry.default_acr.name)
  zone_name           = azurerm_private_dns_zone.acr.name
  resource_group_name = var.resource_group_name
  ttl                 = 3600
  records             = [data.azurerm_network_interface.nic.private_ip_addresses[1]]
}