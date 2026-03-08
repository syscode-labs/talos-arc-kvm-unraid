# Secrets Reference

This page mirrors the operational secret contract used by workflows.

## Tailscale credentials (required when any apply operation is selected)

Preferred:

- `TAILSCALE_OAUTH_CLIENT_ID`
- `TAILSCALE_OAUTH_SECRET`

Fallback:

- `TAILSCALE_AUTHKEY`

## Required for ARC install

- `ARC_GITHUB_CONFIG_URL`
- `ARC_GITHUB_APP_ID`
- `ARC_GITHUB_APP_INSTALLATION_ID`
- `ARC_GITHUB_APP_PRIVATE_KEY`
- `KUBECONFIG_B64`

## Required for autoscaler apply

- `KUBECONFIG_B64`
- `KVM_AUTOSCALER_UNRAID_SSH_TARGET`
- `KVM_AUTOSCALER_SSH_PRIVATE_KEY`

## Required for terraform apply

- `LIBVIRT_URI`

## Optional

- `TALOSCONFIG_B64`
- `ARC_CONTAINER_MAX_RUNNERS`
- `ARC_CONTAINER_MIN_RUNNERS`
- `ARC_DIND_MAX_RUNNERS`
- `ARC_DIND_MIN_RUNNERS`

## Source of truth

Also keep [SECRETS.md](https://github.com/syscode-labs/talos-arc-kvm-unraid/blob/main/SECRETS.md) updated when this contract changes.
