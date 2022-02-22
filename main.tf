terraform {
  required_providers {
    proxmox = {
      source  = "telmate/proxmox"
      version = "7.2"
    }
  }
}

provider "proxmox" {
    pm_api_url = "https://192.168.0.5:8006/api2/json"
    pm_user = "terraform-prov@pve"
    pm_password = "catedractic2021"
    pm_tls_insecure = "true"
}

# Used in LXC to provide ssh login  
variable "ssh_key" {
  default = "#INSERTSSHHPUBLICKEYHERE"
}
