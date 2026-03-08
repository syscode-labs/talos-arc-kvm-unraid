locals {
  controlplane_names = [for i in range(var.controlplane_count) : "${var.cluster_name}-cp-${i + 1}"]
  worker_names       = [for i in range(var.worker_count) : "${var.cluster_name}-wk-${i + 1}"]
  node_names         = concat(local.controlplane_names, local.worker_names)
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

resource "libvirt_domain" "node" {
  for_each = toset(local.node_names)

  name   = each.key
  memory = var.memory_mb
  vcpu   = var.vcpu

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
