variable "proxmox_api_key" {
  description = "Proxmox API key"
  type        = string
  sensitive   = true
}

variable "proxmox_host" {
  description = "Proxmox host"
  type        = string
  default     = "tormenta.xmen.local"
}

variable "proxmox_api_url" {
  type = string
}
variable "template_name" {
  type    = string
  default = "cloud-base-ubuntu"
}
variable "ansible_user" {
  default = "admin"
  type    = string
}

variable "private_key_path" {
  type = string
}

variable "public_key_path" {
  type = string
}