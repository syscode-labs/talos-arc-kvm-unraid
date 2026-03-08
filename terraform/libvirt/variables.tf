variable "libvirt_uri" {
  type    = string
  default = "qemu:///system"
}

variable "pool_name" {
  type    = string
  default = "default"
}

variable "network_name" {
  type    = string
  default = "default"
}

variable "talos_image_path" {
  type        = string
  description = "Path to Talos nocloud image available to libvirt host"
}

variable "cluster_name" {
  type    = string
  default = "arc-talos"
}

variable "controlplane_count" {
  type    = number
  default = 1
}

variable "worker_count" {
  type    = number
  default = 2
}

variable "vcpu" {
  type    = number
  default = 2
}

variable "memory_mb" {
  type    = number
  default = 4096
}

variable "disk_size_bytes" {
  type    = number
  default = 42949672960
}
