#!/usr/bin/env bash

function usage() {
    echo "USAGE:"
    echo
    echo "$1 <distro> <version> [disk size]"
    echo
    echo "Example: $1 centos 9"
    echo "Example: $1 centos 9 100G"
    echo
    echo "Default disk size is 20G if nothing is specified"
    echo "NOTE: the script will delete any VM running with the same name as this (osp1)"
    exit 1
}

if [ "$#" -lt 2 ] || [ "$#" -gt 3 ]; then
    usage $0
fi

DISTRO="${1@L}"
VERSION="${2}"
DSIZE="${3:-20G}"

if [[ ! -e packer/"$DISTRO"-"$VERSION".pkrvars.hcl ]]; then
    echo "The packer variable file \"packer/"$DISTRO"-"$VERSION".pkrvars.hcl\" does not exists"
    exit 1
fi

if [[ ! -e packer/"$DISTRO".pkr.hcl ]]; then
    echo "The packer file \"packer/"$DISTRO".pkr.hcl\" file does not exists"
    exit 1
fi

# Build packer image
echo "=== Building packer image ==="
packer build -var-file=packer/"$DISTRO"-"$VERSION".pkrvars.hcl -var "disk_size=100G" packer/"$DISTRO".pkr.hcl

# Install ansible required collections
echo "=== Install ansible requirements ==="
ansible-galaxy collection install -r ansible/requirements.yml

# Install the vm
echo "=== Run ansible tasks to install the VM ==="
ANSIBLE_CONFIG=ansible/ansible.cfg ansible-playbook -i ansible/inventory --extra-vars "distro=${DISTRO} version=${VERSION} packer_output_dir=${PWD}/output" ansible/install_vm.yml

# Install OSP
echo "=== Run ansible tasks to install OSP ==="
ANSIBLE_CONFIG=ansible/ansible.cfg ansible-playbook -i ansible/inventory --extra-vars "distro=${DISTRO} version=${VERSION} packer_output_dir=${PWD}/output" ansible/install_osp.yml
