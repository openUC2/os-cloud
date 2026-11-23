#!/bin/bash
tee /etc/yum.repos.d/netbird.repo <<EOF
[netbird]
name=netbird
baseurl=https://pkgs.netbird.io/yum/
enabled=1
gpgcheck=1
gpgkey=https://pkgs.netbird.io/yum/repodata/repomd.xml.key
repo_gpgcheck=1
EOF

# for CLI only
dnf --setopt=tsflags=noscripts install -y netbird

# SELinux policy module for NetBird SSH
tmpdir="$(mktemp -d)"
trap 'rm -rf "$tmpdir"' EXIT

checkmodule -M -m \
  -o "$tmpdir/netbird_ssh_login.mod" \
  "/run/netbird_ssh_login.te"

semodule_package \
  -o "$tmpdir/netbird_ssh_login.pp" \
  -m "$tmpdir/netbird_ssh_login.mod"

semodule -X 400 -i "$tmpdir/netbird_ssh_login.pp"
