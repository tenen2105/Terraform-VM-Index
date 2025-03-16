

variable "vm_count" {
  type    = number
  default = 5
}

variable "vm_size" {
  type = string
  description = "Size of the Azure VM"
  default = "Standard_B2s"
}

variable "admin_username" {
  type = string
  description = "VM admin username"
}

variable "admin_password" {
  type = string
  description = "VM admin password"
  sensitive   = true
}


variable "virtual_network_name" {
  type = string
  description = "Name for the virtual network"
  default = "vm-vnet305"
}

variable "subnet_name" {
  type = string
  description = "Name for the subnet"
  default = "internal"
}

variable "network_interface_name" {
  type = string
  description = "Name for the network interface"
  default = "vmnic305"
}

variable "network_security_group_name" {
  type = string
  description = "Name for the network security group"
  default = "vm-nsg305"
}

variable "ip_configuration_name" {
  type = string
  description = "Name for the IP configuration"
  default = "public"
}