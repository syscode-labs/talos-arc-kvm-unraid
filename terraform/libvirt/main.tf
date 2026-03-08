locals {
  controlplane_names   = [for i in range(var.controlplane_count) : "${var.cluster_name}-cp-${i + 1}"]
  general_worker_names = [for i in range(var.general_worker_count) : "${var.cluster_name}-wk-${i + 1}"]
  kvm_worker_names     = [for i in range(var.kvm_worker_pool_size) : "${var.cluster_name}-kvm-${i + 1}"]

  node_names = concat(local.controlplane_names, local.general_worker_names, local.kvm_worker_names)
}

data "libvirt_pool" "pool" {
  name = var.pool_name
}

data "libvirt_network" "net" {
  name = var.network_name
}

resource "libvirt_volume" "talos_base" {
  name   = "${var.cluster_name}-talos-base.qcow2"
  pool   = data.libvirt_pool.pool.name
  source = var.talos_image_path
  format = "qcow2"
}

resource "libvirt_volume" "node_disk" {
  for_each       = toset(local.node_names)
  name           = "${each.key}.qcow2"
  pool           = data.libvirt_pool.pool.name
  base_volume_id = libvirt_volume.talos_base.id
  size           = var.disk_size_bytes
}

resource "libvirt_domain" "controlplane" {
  for_each = toset(local.controlplane_names)

  name   = each.key
  memory = var.memory_mb_controlplane
  vcpu   = var.vcpu_controlplane

  cpu {
    mode = "host-passthrough"
  }

  disk {
    volume_id = libvirt_volume.node_disk[each.key].id
  }

  network_interface {
    network_id = data.libvirt_network.net.id
  }

  console {
    type        = "pty"
    target_type = "serial"
    target_port = "0"
  }

  graphics {
    type        = "spice"
    listen_type = "none"
    autoport    = true
  }
}

resource "libvirt_domain" "general_worker" {
  for_each = toset(local.general_worker_names)

  name    = each.key
  memory  = var.memory_mb_worker
  vcpu    = var.vcpu_worker
  running = true

  cpu {
    mode = "host-passthrough"
  }

  disk {
    volume_id = libvirt_volume.node_disk[each.key].id
  }

  network_interface {
    network_id = data.libvirt_network.net.id
  }

  console {
    type        = "pty"
    target_type = "serial"
    target_port = "0"
  }

  graphics {
    type        = "spice"
    listen_type = "none"
    autoport    = true
  }
}

resource "libvirt_domain" "kvm_worker" {
  for_each = toset(local.kvm_worker_names)

  name      = each.key
  memory    = var.memory_mb_worker
  vcpu      = var.vcpu_worker
  running   = var.kvm_workers_start_running
  autostart = false

  cpu {
    mode = "host-passthrough"
  }

  disk {
    volume_id = libvirt_volume.node_disk[each.key].id
  }

  network_interface {
    network_id = data.libvirt_network.net.id
  }

  console {
    type        = "pty"
    target_type = "serial"
    target_port = "0"
  }

  graphics {
    type        = "spice"
    listen_type = "none"
    autoport    = true
  }
}
