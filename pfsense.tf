
# TODO
resource "proxmox_vm_qemu" "pfsense_vm" {
  count             = 2
  name              = "adminvm"
  target_node       = "node_1"
clone             = "debian-cloudinit"
os_type           = "cloud-init"
  cores             = 2
  sockets           = "1"
  cpu               = "host"
  memory            = 2048
  scsihw            = "virtio-scsi-pci"
  bootdisk          = "scsi0"
disk {
    id              = 0
    size            = 20
    type            = "scsi"
    storage         = "data2"
    storage_type    = "lvm"
    iothread        = true
  }
network {
    id              = 0
    model           = "virtio"
    bridge          = "vmbr0"
  }
lifecycle {
    ignore_changes  = [
      network,
    ]
  }

# Cloud Init Settings
  ipconfig0 = "ip=10.10.10.5/24,gw=10.10.10.1"
sshkeys = <<EOF
  ${var.ssh_key}
  EOF

 provisioner "file" {
    source      = "hosts"
    destination = "/atc/ansible/hosts"
  } 
  provisioner "remote-exec" {    
      inline = [
          "apt update && apt upgrade",      
          "apt install software-properties-common",
          "add-apt-repository --yes --update ppa:ansible/ansible",
          "apt install ansible",
 
      ]  
    }
}