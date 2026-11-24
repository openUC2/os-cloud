#!/bin/bash
module_root="$(dirname "$(realpath "$BASH_SOURCE")")"

# Add override for ephemeral mutable mode systemd-confext, to make changes to `/etc` ephemeral
# TODO: replace this with a systemd config flag in CentOS Stream 12/systemd 259+
file="/usr/lib/systemd/system/systemd-confext.service.d"
mkdir -p "$(dirname "$file")"
cp -r "$module_root$file" "$file"

# Add fallback host-config.target unit
file="/usr/lib/systemd/system/host-config.target"
mkdir -p "$(dirname "$file")"
cp "$module_root$file" "$file"

# Add service to start uniuts added by host-config confext
file="/usr/lib/systemd/system/host-config-startup.service"
mkdir -p "$(dirname "$file")"
cp "$module_root$file" "$file"

# Add starter empty host-config confext, to force ephemeral `/etc` (so that soft-reboot won't leave
# the DNS `/etc/resolv.conf` in a dirty state from changes made by NetBird). We will use confexts
# anyways, so we don't want to use ostree's ephemeral-`/etc` functionality (which may conflict with
# confext: https://bootc.dev/bootc/bootc-filesystem.7.html#conflicts-with-transient-overlays)
file="/usr/lib/confexts/host-config"
mkdir -p "$(dirname "$file")"
cp -r "$module_root$file" "$file"

# Mask systemd-confext
# (we instead let cloud-init provisioning unmask it after making any base changes to `/etc`)
systemctl mask systemd-confext.service
