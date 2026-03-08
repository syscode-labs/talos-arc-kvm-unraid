# Secrets Reference

This page mirrors the operational secret contract used by workflows.

## Required

- `TAILSCALE_AUTHKEY`
- `ARC_GITHUB_CONFIG_URL`
- `ARC_GITHUB_APP_ID`
- `ARC_GITHUB_APP_INSTALLATION_ID`
- `ARC_GITHUB_APP_PRIVATE_KEY`
- `KUBECONFIG_B64`

## Optional

- `TALOSCONFIG_B64`
- `LIBVIRT_URI`
- `ARC_CONTAINER_MAX_RUNNERS`
- `ARC_CONTAINER_MIN_RUNNERS`
- `ARC_DIND_MAX_RUNNERS`
- `ARC_DIND_MIN_RUNNERS`
- `KVM_AUTOSCALER_UNRAID_SSH_TARGET`
- `KVM_AUTOSCALER_SSH_PRIVATE_KEY`

## Source of truth

Also keep [SECRETS.md](https://github.com/syscode-labs/talos-arc-kvm-unraid/blob/main/SECRETS.md) updated when this contract changes.
