#!/bin/bash
module_root="$(dirname "$(realpath "$BASH_SOURCE")")"

# Add override for ephemeral mutable mode systemd-confext
# TODO: replace this with a systemd config flag in CentOS Stream 12/systemd 259+
file="/usr/lib/systemd/system/systemd-confext.service.d/override.conf"
mkdir -p "$(dirname "$file")"
cp "$module_root$file" "$file"

# Add fallback host-config.target unit
file="/usr/lib/systemd/system/host-config.target"
mkdir -p "$(dirname "$file")"
cp "$module_root$file" "$file"

# TODO: add starter empty host-config confext, to force ephemeral `/etc` (so that soft-reboot won't
# leave the DNS `/etc/resolv.conf` in a dirty state from changes made by NetBird)
