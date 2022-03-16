variable "member_vms" {
  type = map(object({
    /*
    memory = string
    disk = number
    vcpu = number

    netid = string
    */
    address = string
    mac = string
  }))
}

locals {
  default_vm = {
    memory = "2048"
    disk = 25 * 1024 * 1024 * 1024
    vcpu = 2
  }
  member_vms = { for netid, vm in var.member_vms : netid => merge(local.default_vm, vm) }
}
