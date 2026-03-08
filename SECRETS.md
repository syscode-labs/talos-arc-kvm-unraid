# Secrets

Repository secrets for `.github/workflows/apply.yml` are mode-dependent.

## Tailscale credentials (required when any operation is selected)

Preferred:

- `TAILSCALE_OAUTH_CLIENT_ID`
- `TAILSCALE_OAUTH_SECRET`

Fallback (deprecated by Tailscale action):

- `TAILSCALE_AUTHKEY`

## Required for `run_arc_install=true`

- `ARC_GITHUB_CONFIG_URL`
- `ARC_GITHUB_APP_ID`
- `ARC_GITHUB_APP_INSTALLATION_ID`
- `ARC_GITHUB_APP_PRIVATE_KEY`
- `KUBECONFIG_B64`

## Required for `run_kvm_autoscaler_apply=true`

- `KUBECONFIG_B64`
- `KVM_AUTOSCALER_UNRAID_SSH_TARGET`: `user@host-or-tailnet-ip` for `virsh` commands
- `KVM_AUTOSCALER_SSH_PRIVATE_KEY`: SSH private key for the above target

## Required for `run_terraform=true`

- `LIBVIRT_URI`

## Optional

- `TALOSCONFIG_B64`: base64-encoded Talos config content
- `ARC_CONTAINER_MAX_RUNNERS`
- `ARC_CONTAINER_MIN_RUNNERS`
- `ARC_DIND_MAX_RUNNERS`
- `ARC_DIND_MIN_RUNNERS`

## Encoding example

```bash
base64 -i ~/.kube/config | tr -d '\n'
```

## Notes

- Use least-privilege GitHub App scope (repo-level where possible).
- Prefer Tailscale OAuth client credentials over auth keys.
- Keep Terraform as manual apply by default; CI Terraform is fallback only.
