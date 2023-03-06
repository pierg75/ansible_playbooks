boot_command = ["<up>", "<esc>", "<wait>", "<tab>", "<wait>", "linux inst.cmdline inst.ip=dhcp inst.text inst.ks=http://{{ .HTTPIP }}:{{ .HTTPPort }}/centos.ks.cfg", "<enter>", "<wait>"]
cpus         = 1
format       = "qcow2"
iso_checksum = "f18156975c15eade5f791cb9e2e9352c"
iso_url      = ["http://lon.mirror.rackspace.com/centos-stream/9-stream/BaseOS/x86_64/iso/CentOS-Stream-9-latest-x86_64-dvd1.iso"]
ssh_username = "root"
password     = "password"
vm_name      = "base-centos-9"
disk_size    = "20G"
