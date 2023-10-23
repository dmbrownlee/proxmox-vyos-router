variable "pm_api_url" {
  description = ""
  type        = string
}

variable "pm_api_token_id" {
  description = ""
  type        = string
}

variable "pm_api_token_secret" {
  description = ""
  type        = string
}

variable "hostname" {
  description = ""
  type        = string
}

variable "target_node" {
  description = ""
  type        = string
}

variable "interfaces" {
  description = ""
  type        = list(any)
}

variable "ssh_private_key" {
  description = ""
  type        = string
}

variable "template_name" {
  description = ""
  type        = string
}

variable "ssh_user" {
  description = ""
  type        = string
}

variable "nameserver" {
  description = ""
  type        = string
}

variable "timezone" {
  description = ""
  type        = string
}

variable "dns" {
  description = ""
  type        = map(any)
}

variable "dhcp" {
  description = ""
  type        = map(any)
}

variable "nat" {
  description = ""
  type        = map(any)
}

variable "cores" {
  description = ""
  type        = string
  default     = 2
}

variable "cpu" {
  description = ""
  type        = string
  default     = "x86-64-v2-AES"
}

variable "memory" {
  description = ""
  type        = string
  default     = 2048
}

variable "full_clone" {
  description = ""
  type        = string
  default     = false
}

variable "disk_size" {
  description = ""
  type        = string
  default     = "2G"
}

variable "disk_storage" {
  description = ""
  type        = string
  default     = "local-lvm"
}
