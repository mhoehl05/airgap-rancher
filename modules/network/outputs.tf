output "node_subnet" {
  value = azurerm_subnet.default_subnet.id
}

output "vnet_id" {
  value = azurerm_virtual_network.k8s_vnet.id
}
