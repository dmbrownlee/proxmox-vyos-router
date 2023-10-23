terraform {
  required_version = "~> 1.6.0"
  required_providers {
    proxmox = {
      source  = "telmate/proxmox"
      version = "2.9.14"
    }
    ansible = {
      source  = "ansible/ansible"
      version = "1.1.0"
    }
  }
}

resource "proxmox_vm_qemu" "router" {
  name                   = var.hostname
  target_node            = var.target_node
  clone                  = var.template_name
  cores                  = var.cores
  cpu                    = var.cpu
  memory                 = var.memory
  full_clone             = var.full_clone
  ssh_user               = var.ssh_user
  agent                  = 1
  qemu_os                = "l26"
  scsihw                 = "virtio-scsi-pci"
  define_connection_info = true
  disk {
    size    = var.disk_size
    storage = var.disk_storage
    type    = "scsi"
  }
  dynamic "network" {
    for_each = jsondecode(var.interfaces)
    content {
      bridge   = network.value.bridge
      model    = "virtio"
      tag      = network.value.vlan
      firewall = network.value.firewall
    }
  }
}

resource "ansible_host" "router" {
  name   = proxmox_vm_qemu.router.name
  groups = ["vyosrouters"]
}

resource "ansible_group" "vyosrouters" {
  name = "vyosrouters"
}

resource "ansible_playbook" "playbook_run" {
  playbook = "${path.module}/vyos-router-playbook.yml"
  name     = proxmox_vm_qemu.router.name
  extra_vars = {
    private_key_file           = var.ansible_private_key
    ansible_python_interpreter = "/usr/bin/python3"
    ansible_host               = proxmox_vm_qemu.router.default_ipv4_address
    ansible_user               = "vyos"
    ansible_network_os         = "vyos"
    ansible_connection         = "network_cli"
    nameserver                 = var.nameserver
    interfaces                 = var.interfaces
    timezone                   = var.timezone
    dns                        = var.dns
    dhcp                       = var.dhcp
    nat                        = var.nat
  }
  verbosity               = 1
  ignore_playbook_failure = true
}

output "resources" {
  value = {
    proxmox_vm_qemu  = [ proxmox_vm_qemu.router ]
    ansible_playbook = [ ansible_playbook.playbook_run ]
    ansible_host     = [ ansible_host.router ]
    ansible_group    = [ ansible_group.vyosrouters ]
  }
}
