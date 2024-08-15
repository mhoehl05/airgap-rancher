resource "azurerm_network_interface" "master_nic" {
  name                = "master-nic"
  location            = var.location
  resource_group_name = var.resource_group_name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = var.subnet_id
    private_ip_address_allocation = "Dynamic"
  }
}

resource "azurerm_linux_virtual_machine" "master_node" {
  name                = "vm-master-rancher-demo"
  resource_group_name = var.resource_group_name
  location            = var.location
  size                = "Standard_B4ms"
  admin_username      = "adm_ubuntu"
  network_interface_ids = [
    azurerm_network_interface.master_nic.id,
  ]

  admin_ssh_key {
    username   = "adm_ubuntu"
    public_key = file("${path.module}/ssh_keys/id_rsa.pub")
  }

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "0001-com-ubuntu-server-jammy"
    sku       = "22_04-lts"
    version   = "latest"
  }
}