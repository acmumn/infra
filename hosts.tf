provider "libvirt" {
  uri = "qemu+ssh://root@160.94.179.162/system?sshauth=privkey&keyfile=$HOME/.ssh/id_ed25519"
}
