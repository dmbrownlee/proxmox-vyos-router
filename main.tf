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

#======================================================
# You must define these values when using this module
#======================================================
variable "hostname" {
  description = "The hostname of the router"
  type        = string
}

variable "target_node" {
  description = "The Proxmox node on which to create the virtual machine"
  type        = string
}

variable "interfaces" {
  description = "List of interface attribute maps (bridge and vlan)"
  type        = list(any)
}

variable "ansible_private_key" {
  description = "The private SSH key ansible should use"
  type        = string
}

#======================================================
# These variables have defaults and are optional
#======================================================
variable "template_name" {
  description = "The name of the template to clone"
  type        = string
  #default     = "vyos-1.5R-202310090023"
  default = "vyos1.5"
}

variable "cores" {
  description = "The number of CPU cores per socket"
  type        = number
  default     = 1
}

variable "cpu" {
  description = "The type of virtual CPU"
  type        = string
  default     = "x86-64-v2-AES"
}

variable "memory" {
  description = "The amount of RAM memory (in MB)"
  type        = number
  default     = 512
}

variable "full_clone" {
  description = "This virtual machine should be independent of the template"
  type        = bool
  default     = false
}

variable "disk_size" {
  description = "The size of the hard disk"
  type        = string
  default     = "2G"
}

variable "disk_storage" {
  description = "Name of storage to use for the disks"
  type        = string
  default     = "local-lvm"
}

variable "ssh_user" {
  description = "Name of storage to use for the disks"
  type        = string
  default     = "vyos"
}

variable "nameserver" {
  description = "IP address of nameserver router will use"
  type        = string
  default     = "8.8.8.8"
}

variable "timezone" {
  description = "The router's timezone"
  type        = string
  default     = "America/Los_Angeles"
}

variable "dns" {
  description = "Map of DNS service attributes"
  type        = string
  default     = ""
}

variable "dhcp" {
  description = "Map of DHCP service attributes"
  type        = string
  default     = ""
}

variable "nat" {
  description = "JSON map of NAT service attributes"
  type        = string
  default     = ""
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
    for_each = var.interfaces
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
    interfaces                 = jsonencode(var.interfaces)
    timezone                   = var.timezone
    dns                        = var.dns
    dhcp                       = var.dhcp
    nat                        = var.nat
  }
  verbosity               = 1
  ignore_playbook_failure = true
}

output "output" {
  value = {
    proxmox_vm_qemu  = proxmox_vm_qemu.router
    ansible_playbook = ansible_playbook.playbook_run
    ansible_host     = ansible_host.router
    ansible_group    = ansible_group.vyosrouters
  }
}
