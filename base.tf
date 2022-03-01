resource "proxmox_lxc" "base_lxc" {
  count = 6
  target_node  = format("node_%s", count)
  hostname     = format("lxc_%s", count.index)
  ostemplate   = "local:vztmpl/ubuntu-20.04-standard_20.04-1_amd64.tar.gz"
  unprivileged = true

  ssh_public_keys = <<-EOT
    ssh-rsa ${var.ssh_key} user@example.com
  EOT
  
  features {
    fuse    = true
    nesting = true
    mount   = "nfs;cifs"
  }

  // Terraform will crash without rootfs defined
  rootfs {
    storage = "local-zfs"
    size    = "8G"
  }

  // NFS mount
  mountpoint {
    slot    = "0"
    storage = "/mnt/nfs" # Volume to mount
    mp      = "/mnt/nfs" # Where is goint to mount nfs
    size    = "250G"
  }

  network {
    name   = "eth2"
    ip     = format("10.0.0.10%s", count.index )
  }

}
