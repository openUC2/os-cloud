# This starts from the default base image, which we reuse as a "builder" image.
FROM quay.io/centos-bootc/centos-bootc:stream10@sha256:0df2ed8fd881b36b34f559c59eb5c4a51992f69b1ce05203307ce29ed1a76f87 as builder

# Generate the minimal root filesystem
RUN /usr/libexec/bootc-base-imagectl build-rootfs --manifest=minimal /target-rootfs

# Now start building our image here, inheriting that minimal base.
FROM scratch
COPY --from=builder /target-rootfs/ /

RUN \
  --mount=type=bind,source=build.sh,target=/run/build.sh \
  --mount=type=bind,source=install-netbird.sh,target=/run/install-netbird.sh \
  --mount=type=bind,source=netbird_ssh_login.te,target=/run/netbird_ssh_login.te \
  --mount=type=bind,source=systemd-confext-service-override.conf,target=/run/systemd-confext-service-override.conf \
  /run/build.sh

LABEL containers.bootc 1
# https://pagure.io/fedora-kiwi-descriptions/pull-request/52
ENV container=oci
STOPSIGNAL SIGRTMIN+3
CMD ["/sbin/init"]
