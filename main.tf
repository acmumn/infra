terraform {
  required_version = ">= 0.13"
  required_providers {
    libvirt = {
      source = "nixpkgs/libvirt"
      //source = "dmacvicar/libvirt"
      version = "0.6.11"
    }
  }
}

resource "libvirt_pool" "os_images" {
  name = "os_images"
  type = "dir"
  path = "/tmp/terraform-provider-libvirt-pool-images"
}

/*
resource "libvirt_pool" "vm_disks" {
  name = "vm_disks"
  type = "dir"
  path = "/dev/sdb1"
}
*/


data "template_file" "user_data" {
  template = file("${path.module}/user_data.yml")
}

data "template_file" "network_config" {
  template = file("${path.module}/network_config.yml")
}

resource "libvirt_cloudinit_disk" "commoninit" {
  name           = "commoninit.iso"
  user_data      = data.template_file.user_data.rendered
  //network_config = data.template_file.network_config.rendered
  pool           = libvirt_pool.os_images.name
}

resource "libvirt_network_v2" "vm_bridge" {
  name = "vm_bridge"

  forward {
    mode = "route"
  }
/*  bridge {
    name = "guestbr0"
  }*/
  autostart = true

  ip {
    address = "160.94.179.162"
    dhcp {
      dynamic "host" {
        for_each = local.member_vms
        /*
        content {
          mac = host.value.network_interface.0.mac
          ip = host.value.network_interface.0.addresses.0
        }*/
        content {
          mac = host.value.mac
          ip = host.value.address
        }
      }
    }
  }
}

resource "libvirt_volume" "member_disk" {
  for_each = local.member_vms
  name = "${each.key}_disk"
  //pool = libvirt_pool.vm_disks.name
  pool = "vm_disks"
  base_volume_copy = true
  base_volume_id = libvirt_volume.debian_image.id
  //base_volume_pool = libvirt_pool.os_images.name
  base_volume_pool = "vm_disks"
  size = each.value.disk
}


resource "libvirt_domain" "member_vm" {
  for_each = local.member_vms

  name = each.key
  memory = "2048"
  vcpu = 2

  cloudinit = libvirt_cloudinit_disk.commoninit.id

  network_interface {
    network_id = libvirt_network_v2.vm_bridge.id # TODO(tny): causes a cycle
    mac = each.value.mac
    # network_name = "guestbr0"
    addresses = [ each.value.address ]
    hostname = each.key
    wait_for_lease = true
  }

  # depends_on = [ libvirt_network_v2.vm_bridge ]

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

  disk {
    volume_id = libvirt_volume.member_disk[each.key].id
  }
}

/*
resource "libvirt_volume" "member_disk" {
  name = "alexa818_disk"
  //pool = libvirt_pool.vm_disks.name
  pool = "vm_disks"
  base_volume_copy = true
  base_volume_id = libvirt_volume.debian_image.id
  //base_volume_pool = libvirt_pool.os_images.name
  base_volume_pool = "vm_disks"
  size = 25 * 1024 * 1024 * 1024
}

resource "libvirt_domain" "member_vm" {
  name = "alexa818"
  memory = "2048"
  vcpu = 2

  cloudinit = libvirt_cloudinit_disk.commoninit.id

  network_interface {
    network_id = libvirt_network_v2.vm_bridge.id
    addresses = [ "160.94.179.174" ]
    hostname = "alexa818"
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

  disk {
    volume_id = libvirt_volume.alexa818_disk.id
  }
}
*/

/*
resource "libvirt_domain" "pan00111" {
  name = "andrew"
}
*/
