resource "libvirt_volume" "debian_image" {
  name = "debian_image"
  pool = "vm_disks"
  source = "https://cloud.debian.org/images/cloud/bullseye/latest/debian-11-genericcloud-amd64.raw"
  format = "raw"
}
