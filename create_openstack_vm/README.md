# Create and configure a single node Openstack installation 

Run the script below with the name of the distro you want to use.
For now it only uses Centos 9.

If you want to use another distro, make sure the filenames follow these rules:

* The main packer file is named as `<DISTRO>.pkr.hcl`
* The packer variable file is named as `<DISTRO>-<VERSION>.pkrvars.hcl`
* The kickstart file is placed into `packer/http` and has the name `<DISTRO>.ks.cfg`

## Steps:

1. Copy the whole tree on the hypervisor (KVM only)

2. There's a standard root password set. If you want to change it 
   (yes, root is allowed to ssh), change it in the kickstart file 
   `packer/centos.ks.cfg` and in the `centos-9.pkrvars.hcl` packer variable
   file.

3. Set the ssh key in `packer/http/<DISTRO>-<VERSION>.ks.cfg`

4. If you want to change the VM name and other details, change the variables in `ansible/playbook.yml`

5. run it:
```
# ./build.sh centos 9
```

