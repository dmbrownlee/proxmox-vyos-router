variable "pm_api_url" {
  description = ""
  type        = string
}

variable "pm_api_token_secret" {
  description = ""
  type        = string
}

variable "pm_api_token_id" {
  description = ""
  type        = string
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
  description = "JSON encoded list of interface attributes (bridge and vlan)"
  type        = string
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
