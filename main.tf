
data "azurerm_resource_group" "rg305" {
  name = "AZ305"
}

resource "azurerm_windows_virtual_machine" "vm_name" {
  count = var.vm_count
  name                = format("vm%02d", count.index + 1)
  resource_group_name = data.azurerm_resource_group.rg305.name
  location            = data.azurerm_resource_group.rg305.location
  size                = var.vm_size
  admin_username      = var.admin_username
  admin_password      = var.admin_password
  network_interface_ids = [
    azurerm_network_interface.nic305[count.index].id,
  ]

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "MicrosoftWindowsServer"
    offer     = "WindowsServer"
    sku       = "2022-Datacenter"
    version   = "latest"
  }
}

# Virtual Network
resource "azurerm_virtual_network" "vrt305" {
  name                = var.virtual_network_name
  address_space       = ["10.0.0.0/16"]
  location            = data.azurerm_resource_group.rg305.location
  resource_group_name = data.azurerm_resource_group.rg305.name
}

# Subnet
resource "azurerm_subnet" "subnet305" {
  name                 = var.subnet_name
  resource_group_name  = data.azurerm_resource_group.rg305.name
  virtual_network_name = azurerm_virtual_network.vrt305.name
  address_prefixes     = ["10.0.1.0/24"]
}


# Network Interface
resource "azurerm_network_interface" "nic305" {
  count               = var.vm_count  
  name                = format("vm-nic%02d", count.index + 1)
  resource_group_name = data.azurerm_resource_group.rg305.name
  location            = data.azurerm_resource_group.rg305.location

  ip_configuration {
    name                          = "Subnet01"
    subnet_id                     = azurerm_subnet.subnet305.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.public_ip[count.index].id
  }
}

# Network Security Group
resource "azurerm_network_security_group" "vm_nsg" {
  name                = var.network_security_group_name
  resource_group_name = data.azurerm_resource_group.rg305.name
  location            = data.azurerm_resource_group.rg305.location

  security_rule {
    name                       = "RDP"
    priority                   = 100
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "3389"
    source_address_prefix      = "57.135.165.239"
    destination_address_prefix = "*"
  }
}

# Public IP Address
resource "azurerm_public_ip" "public_ip" {
  count               = var.vm_count  
  name                = format("vm-ip%02d", count.index + 1)
  resource_group_name = data.azurerm_resource_group.rg305.name
  location            = data.azurerm_resource_group.rg305.location
  allocation_method   = "Static"
  sku                 = "Basic"

  tags = {
    environment = "Production"
  }
}

# Network Interface Security Group Association
resource "azurerm_network_interface_security_group_association" "nsg-association" {
  count = var.vm_count
  network_interface_id      = azurerm_network_interface.nic305[count.index].id
  network_security_group_id = azurerm_network_security_group.vm_nsg.id
}
