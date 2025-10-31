# main.tf

# Configure the Azure provider
provider "azurerm" {
  features {}
  subscription_id = "68269eb7-3f3b-42b1-86fe-6dadcc847d71"
}

# --- Resource Group ---
resource "azurerm_resource_group" "main" {
  name     = "MyAzureResourceGroup"
  location = "East US 2" # You can change your preferred region
}

# --- Virtual Network (VNet) ---
resource "azurerm_virtual_network" "main" {
  name                = "MyVNet"
  address_space       = ["10.0.0.0/16"]
  location            = azurerm_resource_group.main.location
  resource_group_name = azurerm_resource_group.main.name
}

# --- Subnet ---
resource "azurerm_subnet" "internal" {
  name                 = "internal-subnet"
  resource_group_name  = azurerm_resource_group.main.name
  virtual_network_name = azurerm_virtual_network.main.name
  address_prefixes     = ["10.0.1.0/24"]
}

# --- Network Security Group (NSG) ---
resource "azurerm_network_security_group" "web_ssh_nsg" {
  name                = "WebSSHSecurityGroup"
  location            = azurerm_resource_group.main.location
  resource_group_name = azurerm_resource_group.main.name

  security_rule {
    name                       = "SSH"
    priority                   = 100
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "22"
    source_address_prefix      = "*" # WARNING: * for SSH is not recommended for production.
    destination_address_prefix = "*" # Restrict to your specific IP range if possible.
  }

  security_rule {
    name                       = "HTTP"
    priority                   = 101
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "80"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }
}
