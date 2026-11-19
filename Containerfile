# This starts from the default base image, which we reuse as a "builder" image.
FROM quay.io/centos-bootc/centos-bootc:stream10@sha256:0df2ed8fd881b36b34f559c59eb5c4a51992f69b1ce05203307ce29ed1a76f87 as builder

# Generate the minimal root filesystem
RUN /usr/libexec/bootc-base-imagectl build-rootfs --manifest=minimal /target-rootfs

# Now start building our image here, inheriting that minimal base.
FROM scratch
COPY --from=builder /target-rootfs/ /

RUN <<EORUN
set -xeuo pipefail

# Set up basic networking (TODO: replace NetworkManager with systemd-networkd):
dnf -y install openssh-server NetworkManager

# Install QEMU Guest Agent:
dnf -y install qemu-guest-agent
systemctl enable qemu-guest-agent

# Install Docker:
dnf install -y yum-utils
dnf config-manager --add-repo https://download.docker.com/linux/centos/docker-ce.repo
dnf install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
systemctl enable docker

# Clean up:
dnf clean all
rm /var/{log,cache,lib}/* -rf

# Validate container:
bootc container lint

EORUN

LABEL containers.bootc 1
# https://pagure.io/fedora-kiwi-descriptions/pull-request/52
ENV container=oci
STOPSIGNAL SIGRTMIN+3
CMD ["/sbin/init"]
