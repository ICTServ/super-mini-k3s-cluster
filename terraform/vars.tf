variable "proxmox_api_key" {
  description = "Proxmox API key"
  type        = string
  sensitive   = true
}


variable "proxmox_host" {
  description = "Proxmox host"
  type        = string
}

variable "proxmox_api_url" {
  type = string
}
variable "template_name" {
  type    = string
  default = "ubuntu-cloud"
}
variable "ansible_user" {
  type    = string
}

variable "private_key_path" {
  type = string
}

variable "public_key_path" {
  type = string
}

variable "admin_password" {
  type = string
}