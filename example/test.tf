# Only edit below if the module interface changed
module "test" {
  source              = "git@github.com:dmbrownlee/proxmox-vyos-router"
  pm_api_token_id     = var.pm_api_token_id
  pm_api_url          = var.pm_api_url
  pm_api_token_secret = var.pm_api_token_secret
  hostname            = var.hostname
  target_node         = var.target_node
  interfaces          = jsonencode(var.interfaces)
  ansible_private_key = var.ansible_private_key
  template_name       = var.template_name
  cores               = var.cores
  cpu                 = var.cpu
  memory              = var.memory
  full_clone          = var.full_clone
  disk_size           = var.disk_size
  disk_storage        = var.disk_storage
  ssh_user            = var.ssh_user
  dns                 = jsonencode(var.dns)
  dhcp                = jsonencode(var.dhcp)
  nat                 = jsonencode(var.nat)
}

output "output" {
  value     = module.test.output
  sensitive = true
}
