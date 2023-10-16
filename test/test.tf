terraform {
  required_version = "~> 1.6.0"
}

locals {
  hostname    = "test-router"
  target_node = "pve2-mgt"
  interfaces = [
    {
      name        = "eth0"
      description = "WAN"
      address     = "dhcp"
      firewall    = false
      bridge      = "vmbr0"
      vlan        = 30
    },
    {
      name        = "eth1"
      address     = "10.48.80.254/24"
      description = "LAN"
      firewall    = false
      bridge      = "vmbr0"
      vlan        = 1000
    }
  ]
  ansible_private_key = "~/keys/vyos"
  # Optional
  template_name = "vyos1.5"
  cores         = 2
  cpu           = "host"
  memory        = 2048
  full_clone    = false
  disk_size     = "4G"
  disk_storage  = "truenas1"
  ssh_user      = "vyos"
  nameserver    = "8.8.8.8"
  timezone      = "America/Los_Angeles"
  dns = {
    listen_address = "10.48.80.254"
    allow_from     = "10.48.80.0/24"
  }
  dhcp = {
    network_name   = "LAN"
    subnet         = "10.48.80.0/24"
    default_router = "10.48.80.254"
    name_server    = "10.48.80.254"
    domain_name    = "lab1.example.com"
    lease          = "86400"
    range = [
      {
        start = "10.48.80.100"
        stop  = "10.48.80.199"
      }
    ]
  }
  nat = {
    external_interface = "eth0"
    internal_network   = "10.48.80.0/24"
  }
}

# Only edit below if the module interface changed
module "test" {
  source              = "./.."
  hostname            = local.hostname
  target_node         = local.target_node
  interfaces          = local.interfaces
  ansible_private_key = local.ansible_private_key
  template_name       = local.template_name
  cores               = local.cores
  cpu                 = local.cpu
  memory              = local.memory
  full_clone          = local.full_clone
  disk_size           = local.disk_size
  disk_storage        = local.disk_storage
  ssh_user            = local.ssh_user
  dns                 = jsonencode(local.dns)
  dhcp                = jsonencode(local.dhcp)
  nat                 = jsonencode(local.nat)
}

output "output" {
  value     = module.test.output
  sensitive = true
}
