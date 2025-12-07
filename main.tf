terraform {
  required_version = ">= 1.0"
  required_providers {
    libvirt = {
      source  = "dmacvicar/libvirt"
      version = "0.7.6"
    }
  }
}

provider "libvirt" {
  uri = "qemu:///system"
}

variable "hostname" { default = "k3s-server" }
variable "memoryMB" { default = 1024 * 4 }
variable "cpu" { default = 2 }
variable "serverCount" { default = 4 }
variable "network" { default = "kvmnet" }
variable "bridge" { default = "bridge0" }

resource "libvirt_volume" "os_image" {
  name   = "os_image"
  pool   = "default"
  # Suggestion is to download the image and then call locally to save from download timeout"
  #source = "https://dl.fedoraproject.org/pub/fedora/linux/releases/41/Cloud/x86_64/images/Fedora-Cloud-Base-Generic-41-1.4.x86_64.qcow2"
  source = "file:///vm/Fedora-Cloud-Base-Generic-43-1.6.x86_64.qcow2"
}

resource "libvirt_volume" "server_volume" {
  count          = var.serverCount
  pool           = "default" #Use the default storage pool for vm
  name           = "server_volume-${count.index}"
  base_volume_id = libvirt_volume.os_image.id
  format         = "qcow2"
}

resource "libvirt_volume" "spare_volume" {
  count  = var.serverCount
  pool   = "vmdata" # Use data storage pool
  name   = "spare_volume-${count.index}"
  format = "qcow2"
  size   = 107374182400
}

resource "libvirt_cloudinit_disk" "commoninit" {
  count     = var.serverCount
  name      = "${var.hostname}-commoninit-${count.index}.iso"
  user_data = templatefile("${path.module}/cloud_init.cfg", {
    hostname = "${var.hostname}-${count.index}"
  })
}

resource "libvirt_network" "network" {
  name      = var.network
  mode      = "bridge"
  autostart = true
  addresses = ["192.168.10.0/24"]
  bridge    = var.bridge
}

resource "libvirt_domain" "domain" {
  count      = var.serverCount
  name       = "k3s-${count.index}"
  memory     = var.memoryMB
  vcpu       = var.cpu
  qemu_agent = true
  autostart  = true

  cpu {
    mode = "host-passthrough"
  }

  disk {
    volume_id = element(libvirt_volume.server_volume.*.id, count.index)
  }

  disk {
    volume_id = element(libvirt_volume.spare_volume.*.id, count.index)
  }

  network_interface {
    network_name   = var.network
    bridge         = var.bridge
    addresses      = ["192.168.10.20${count.index + 1}"]
    mac            = "52:54:00:00:00:a${count.index + 1}"
    wait_for_lease = true
  }

  console {
    type        = "pty"
    target_port = "0"
    target_type = "serial"
  }

  console {
    type        = "pty"
    target_type = "virtio"
    target_port = "1"
  }

  depends_on = [
    libvirt_network.network,
  ]

  cloudinit = libvirt_cloudinit_disk.commoninit[count.index].id
}

output "ips" {
  value = [for domain in libvirt_domain.domain : domain.network_interface[0].addresses]
}
