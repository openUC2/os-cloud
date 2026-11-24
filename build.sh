#!/bin/bash

set -xeuo pipefail

# Set up basic networking:
dnf -y install openssh-server NetworkManager

# Install cloud-init:
dnf -y install cloud-init
systemctl enable \
  cloud-init-local.service \
  cloud-init.service \
  cloud-config.service \
  cloud-final.service
rm /run/cloud-init

# Install QEMU Guest Agent:
dnf -y install qemu-guest-agent
systemctl enable qemu-guest-agent

# Install Docker:
dnf install -y yum-utils
dnf config-manager --add-repo https://download.docker.com/linux/centos/docker-ce.repo
dnf install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
systemctl enable docker

# Install Netbird:
/run/netbird/install.sh

# Set up host-config confext system:
/run/host-config/install.sh

# Set up sudo:
dnf -y install sudo

# Clean up:
dnf clean all
rm /var/{log,cache,lib}/* -rf
