#!/usr/bin/env bash

function usage() {
    echo "USAGE:"
    echo
    echo "$1 <distro> <version>"
    echo
    echo "Example: $1 centos 9"
    exit 1
}

if [ "$#" -lt 2 ]; then
    usage $0
fi

DISTRO="${1@L}"
VERSION="${2}"

if [[ ! -e packer/"$DISTRO"-"$VERSION".pkrvars.hcl ]]; then
    echo "The packer variable file \"packer/"$DISTRO"-"$VERSION".pkrvars.hcl\" does not exists"
    exit 1
fi

if [[ ! -e packer/"$DISTRO".pkr.hcl ]]; then
    echo "The packer file \"packer/"$DISTRO".pkr.hcl\" file does not exists"
    exit 1
fi

# Build packer image
packer build -var-file=packer/"$DISTRO"-"$VERSION".pkrvars.hcl packer/"$DISTRO".pkr.hcl

# Install ansible required collections
ansible-galaxy collection install -r ansible/requirements.yml

# Start ansible jobs
ansible-playbook --extra-vars "ansible_user=root distro=${DISTRO} version=${VERSION} packer_output_dir=${PWD}/output" ansible/playbook.yml
