





resource "azurerm_resource_group" "Automation" {
  name     = "Automation"
  location = "East US"
}

resource "azurerm_virtual_network" "Myvnet" {
  name                = "Myvnet"
  address_space       = ["10.0.0.0/16"]
  location            = azurerm_resource_group.Automation.location
  resource_group_name = azurerm_resource_group.Automation.name
}

resource "azurerm_subnet" "Subnet1" {
  name                 = "frontend"
  resource_group_name  = azurerm_resource_group.Automation.name
  virtual_network_name = azurerm_virtual_network.Myvnet.name
  address_prefixes     = ["10.0.1.0/24"]
}

resource "azurerm_network_security_group" "Mynsg" {
  name                = "mynsg"
  location            = azurerm_resource_group.Automation.location
  resource_group_name = azurerm_resource_group.Automation.name

  security_rule {
    name                       = "test123"
    priority                   = 100
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "3389"
    destination_port_range     = "*"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
    
  }
}

resource "azurerm_subnet_network_security_group_association" "Mynsg" {
  subnet_id                 = azurerm_subnet.Subnet1.id
  network_security_group_id = azurerm_network_security_group.Mynsg.id
}

resource "azurerm_automation_account" "Automation1" {
  name                = "Automation1"
  location            = azurerm_resource_group.Automation.location
  resource_group_name = azurerm_resource_group.Automation.name
  sku_name            = "Basic"
 }


