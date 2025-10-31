# outputs.tf

output "azure_app_vm_public_ip" {
  description = "Public IP address of the Azure App VM"
  value       = azurerm_public_ip.app_vm_ip.ip_address
}

output "azure_ssh_key_filename" {
  description = "The filename of the generated private key for Azure SSH"
  value       = local_file.azure_private_key.filename
}
