#!/usr/bin/env bash

# Install libguestfs-tools (required only once before the first run)
sudo apt update -y
sudo apt install libguestfs-tools -y

# Download the latest Ubuntu LTS image
wget https://cloud-images.ubuntu.com/jammy/current/jammy-server-cloudimg-amd64.img

# Install qemu-guest-agent on the downloaded image
sudo virt-customize -a jammy-server-cloudimg-amd64.img --install qemu-guest-agent

# Create a new Proxmox virtual machine with specified configuration
qm create 8000 --memory 2048 --core 2 --name cloud-base-ubuntu --net0 virtio,bridge=vmbr0

# Import the downloaded disk image into the newly created VM
qm importdisk 8000 jammy-server-cloudimg-amd64.img local-lvm

# Configure the VM's hardware settings
qm set 8000 --scsihw virtio-scsi-pci --scsi0 local-lvm:vm-8000-disk-0
qm set 8000 --ide2 local-lvm:cloudinit
qm set 8000 --boot c --bootdisk scsi0
qm set 8000 --serial0 socket --vga serial0

# Enable qemu guest agent
sudo qm set 8000 --agent enabled=1

# At this point, use the Proxmox UI to configure cloud-init options for the VM:
# - Add a user (e.g., 'admin')
# - Add your public SSH key
# - Enable DHCP

# Once the above configuration is completed, convert the VM into a template
sudo qm template 8000

# Create user for terrform
pveum role add TerraformProv -privs "Datastore.AllocateSpace Datastore.Audit Pool.Allocate Sys.Audit Sys.Console Sys.Modify VM.Allocate VM.Audit VM.Clone VM.Config.CDROM VM.Config.Cloudinit VM.Config.CPU VM.Config.Disk VM.Config.HWType VM.Config.Memory VM.Config.Network VM.Config.Options VM.Migrate VM.Monitor VM.PowerMgmt"
pveum user add terraform-prov@pve --password <password>
pveum aclmod / -user terraform-prov@pve -role TerraformProv
