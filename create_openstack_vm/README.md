# Create and configure a single node Openstack installation 

Run the script below with the name of the distro you want to use.
For now it only uses Centos 9.


If you want to use another distro, make sure the filenames follow these rules:

* The main packer file is named as <DISTRO>.pkr.hcl
* The packer variable file is named as <DISTRO>-<VERSION>.pkrvars.hcl
* The kickstart file is placed into `packer/http` and has the name <DISTRO>.ks.cfg


If you want to modify the root password (yes, root is allowed to ssh), change it in the kickstart file
packer/centos.ks.cfg and in the centos-9.pkrvars.hcl packer variable file.
