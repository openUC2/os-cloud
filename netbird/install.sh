#!/bin/bash
module_root="$(dirname "$(realpath "$BASH_SOURCE")")"

file="/etc/yum.repos.d/netbird.repo"
cp "$module_root$file" "$file"
dnf --setopt=tsflags=noscripts install -y netbird

# SELinux policy module for NetBird SSH

tmpdir="$(mktemp -d)"
trap 'rm -rf "$tmpdir"' EXIT

checkmodule -M -m \
  -o "$tmpdir/netbird_ssh_login.mod" \
  "$module_root/netbird_ssh_login.te"

semodule_package \
  -o "$tmpdir/netbird_ssh_login.pp" \
  -m "$tmpdir/netbird_ssh_login.mod"

semodule -X 400 -i "$tmpdir/netbird_ssh_login.pp"
