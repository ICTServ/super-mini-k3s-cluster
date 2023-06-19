terraform {
  required_providers {
    proxmox = {
      source  = "telmate/proxmox"
      version = ">= 2.0.0"
    }
  }
}

provider "proxmox" {
  pm_api_url          = "https://tormenta.xmen.local:8006/api2/json"
  pm_tls_insecure     = true
  pm_api_token_id     = "root@pam!terraform_token_id"
  pm_api_token_secret = var.proxmox_api_key
}

