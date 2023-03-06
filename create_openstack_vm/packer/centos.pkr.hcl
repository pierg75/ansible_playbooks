variable "boot_command" {
  type    = list(string)
  default = [""]
}
variable "cpus" {
  type    = number
  default = 4
}
variable "format" {
  type    = string
  default = "qcow2"
}
variable "http_directory" {
  type    = string
  default = "packer/http"
}
variable "iso_checksum" {
  type    = string
  default = ""
}
variable "iso_url" {
  type    = list(string)
  default = [""]
}
variable "password" {
  type    = string
  default = ""
}
variable "ssh_username" {
  type    = string
  default = ""
}
variable "vm_name" {
  type    = string
  default = ""
}
variable "disk_size" {
  type    = string
  default = ""
}

source "qemu" "centos" {
  boot_command     = "${var.boot_command}"
  boot_wait        = "30s"
  cpus             = "${var.cpus}"
  disk_cache       = "none"
  disk_compression = true
  disk_discard     = "unmap"
  disk_image       = false
  disk_interface   = "virtio"
  disk_size        = "${var.disk_size}"
  format           = "${var.format}"
  headless         = true
  host_port_max    = 2240
  host_port_min    = 2222
  http_directory   = "${var.http_directory}"
  iso_checksum     = "${var.iso_checksum}"
  iso_urls         = "${var.iso_url}"
  memory           = 2048
  output_directory = "output"
  qemuargs         = [["-cpu", "host"], ["-chardev", "stdio,id=char0,logfile=serial.log,signal=off"], ["-serial", "chardev:char0"]]
  shutdown_command = "echo '${var.password}' | sudo -S /sbin/halt -h -p"
  ssh_password     = "${var.password}"
  ssh_port         = 22
  ssh_timeout      = "70m"
  ssh_username     = "${var.ssh_username}"
  vm_name          = "${var.vm_name}.${var.format}"
}

build {
  sources = ["source.qemu.centos"]

}
