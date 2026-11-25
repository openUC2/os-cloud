#!/bin/bash
module_root="$(dirname "$(realpath "$BASH_SOURCE")")"

file="/usr/lib/tmpfiles.d/chrony.conf"
cp "$module_root$file" "$file"

dnf -y install chrony
systemctl enable chronyd.service
