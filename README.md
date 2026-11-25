# os-cloud
Base OS image for our cloud VMs, packaged &amp; delivered via bootc

## Features

This is meant to be used with [openUC2/infra-cloud](https://github.com/openUC2/infra-cloud):

Capabilities:
- Private network connectivity (including SSH) via NetBird (must be activated in day-1 provisioning), to
  remove the need for a public SSH port.
- Support for a systemd-confext named `host-config` (must be activated in day-1 provisioning), which
  can be deployed from OpenTofu (e.g. as in openUC2/infra-cloud).
- cloud-init for Day-1 provisioning.

Provisioning flow (e.g. as in openUC2/infra-cloud):

- Install the bootc image into a VM.
- Use cloud-init to bootstrap provisioning up to enablement of `systemd-confext.service` and
  activation of NetBird.
- Deploy a systemd-confext image (e.g. a confext file tree) named `host-config`. This confext can
  have, for example, Doco-CD as app platform infrastructure on the VM. It is independently
  deployable (because it may need to change more frequently than the base OS) and can be deployed
  without rebooting.

## Scope

- The bootc image (provided by this repo) provides the base OS and the generic mechanisms needed to
bootstrap the VM.
- cloud-init is responsible for initial bootstrapping, not ongoing configuration management.
- The `host-config` confext (provided by openUC2/infra-cloud) provides host-specific configuration
  and infrastructure. In other words, configuration management is done in a roughly immutable style
  using systemd-confext.

## Release channels

- `edge`: for development VMs
- `beta`: for staging & beta testing VMs
- `stable`: for production VMs running production deployments
