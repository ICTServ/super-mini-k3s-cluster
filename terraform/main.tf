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

resource "proxmox_vm_qemu" "vm" {
  count       = 1
  target_node = var.proxmox_host
  name        = "k3s-node-${count.index}"

  agent = 1 # is the qemu agent installed?

  os_type  = "cloud-init" # The OS type of the image clone
  cores    = 2 # number of CPU cores
  sockets  = 1 # number of CPU sockets
  cpu      = "host" # The CPU type
  memory   = 4096 # Amount of memory to allocate
  onboot   = true # start the VM on host startup
  scsihw   = "virtio-scsi-pci" # Scsi hardware type
  bootdisk = "scsi0" # The boot disk scsi

  # disk
  disk {
    size    = "30G"
    storage = "local-lvm"
    type    = "scsi"
  }

  network {
    model  = "virtio"
    bridge = "vmbr0"
  }

  ipconfig0 = "ip=192.168.8.11${count.index}/24,gw=192.168.8.1"

  # provisision
  provisioner "remote-exec" {
    inline = ["sudo apt update", "sudo apt upgrade -y"]
    connection {
      host        = "192.168.8.11${count.index}"
      type        = "ssh"
      user        = "admin"
      private_key = file(var.private_key_path)
    }
  }

}

