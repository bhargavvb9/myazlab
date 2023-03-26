resource "azurerm_resource_group" "Testing" {
  name     = "Testing"
  location = "East US"
}

resource "azurerm_virtual_network" "Testing" {
  name                = "Testing"
  address_space       = ["10.0.0.0/16"]
  location            = azurerm_resource_group.Testing.location
  resource_group_name = azurerm_resource_group.Testing.name
}

resource "azurerm_subnet" "Testing" {
  name                 = "internal"
  resource_group_name  = azurerm_resource_group.Testing.name
  virtual_network_name = azurerm_virtual_network.Testing.name
  address_prefixes     = ["10.0.2.0/24"]
}

resource "azurerm_network_interface" "Nic" {
  name                = "Nic"
  location            = azurerm_resource_group.Testing.location
  resource_group_name = azurerm_resource_group.Testing.name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.Testing.id
    private_ip_address_allocation = "Dynamic"
  }
}

resource "azurerm_windows_virtual_machine" "Runbook" {
  name                = "Runbook"
  resource_group_name = azurerm_resource_group.Testing.name
  location            = azurerm_resource_group.Testing.location
  size                = "Standard_F2"
  admin_username      = "adminuser"
  admin_password      = "P@$$w0rd1234!"
  network_interface_ids = [
    azurerm_network_interface.Nic.id,
  ]

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "MicrosoftWindowsServer"
    offer     = "WindowsServer"
    sku       = "2016-Datacenter"
    version   = "latest"
  }
}

