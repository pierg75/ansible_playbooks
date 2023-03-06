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
packer build -var-file=packer/"$DISTRO"-"$VERSION".pkrvars.hcl -var "disk_size=100G" packer/"$DISTRO".pkr.hcl

# Install ansible required collections
ansible-galaxy collection install -r ansible/requirements.yml

# Start ansible jobs
ansible-playbook --extra-vars "distro=${DISTRO} version=${VERSION} packer_output_dir=${PWD}/output" ansible/playbook.yml
