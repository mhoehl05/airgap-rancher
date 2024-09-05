resource "azurerm_resource_group" "default" {
  name     = "rg-rancher-demo"
  location = "West Europe"
}

module "network" {
  source = "./modules/network"

  location            = azurerm_resource_group.default.location
  resource_group_name = azurerm_resource_group.default.name
}

module "nodes" {
  source = "./modules/nodes"

  location            = azurerm_resource_group.default.location
  resource_group_name = azurerm_resource_group.default.name
  subnet_id           = module.network.node_subnet
  worker_count        = 2
}

module "supply_chain" {
  source = "./modules/supply_chain"

  location            = azurerm_resource_group.default.location
  resource_group_name = azurerm_resource_group.default.name
  subnet_id           = module.network.node_subnet
}
