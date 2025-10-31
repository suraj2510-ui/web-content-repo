# --- Public IP for the VM ---
resource "azurerm_public_ip" "app_vm_ip" {
  name                = "app-vm-public-ip"
  location            = azurerm_resource_group.main.location
  resource_group_name = azurerm_resource_group.main.name
  allocation_method   = "Static"
  sku                 = "Standard"
}

# --- Network Interface for the VM ---
resource "azurerm_network_interface" "app_vm_nic" {
  name                = "app-vm-nic"
  location            = azurerm_resource_group.main.location
  resource_group_name = azurerm_resource_group.main.name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.internal.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.app_vm_ip.id
  }
}

# --- Associate NSG with NIC ---
resource "azurerm_network_interface_security_group_association" "app_vm_nic_nsg_assoc" {
  network_interface_id      = azurerm_network_interface.app_vm_nic.id
  network_security_group_id = azurerm_network_security_group.web_ssh_nsg.id
}

# --- Generate SSH key for the VM ---
resource "tls_private_key" "azure_key" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

# Save the private key locally
resource "local_file" "azure_private_key" {
  content         = tls_private_key.azure_key.private_key_pem
  filename        = "${path.module}/my-azure-key.pem"
  file_permission = "0400"
}

# --- Azure Virtual Machine ---
resource "azurerm_linux_virtual_machine" "app_vm" {
  name                = "app-vm"
  resource_group_name = azurerm_resource_group.main.name
  location            = azurerm_resource_group.main.location
  size                = "Standard_B2ms"
  admin_username      = "azureuser"

  network_interface_ids = [
    azurerm_network_interface.app_vm_nic.id
  ]

  # Ubuntu 22.04 LTS image reference (valid in East US)
  source_image_reference {
    publisher = "Canonical"
    offer     = "0001-com-ubuntu-server-jammy"
    sku       = "22_04-lts-gen2"
    version   = "latest"
  }

  admin_ssh_key {
    username   = "azureuser"
    public_key = tls_private_key.azure_key.public_key_openssh
  }

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
    name                 = "appvm-osdisk"
  }

  computer_name  = "appvm"
  disable_password_authentication = true
}

# --- Outputs ---
output "public_ip" {
  value = azurerm_public_ip.app_vm_ip.ip_address
}

output "private_key_path" {
  value = local_file.azure_private_key.filename
}

