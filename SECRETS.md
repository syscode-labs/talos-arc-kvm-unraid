# Secrets

Required repository secrets for `.github/workflows/apply.yml`:

- `TAILSCALE_AUTHKEY`: ephemeral auth key for CI runner tailnet join
- `ARC_GITHUB_CONFIG_URL`: org or repo URL for ARC runners
- `ARC_GITHUB_APP_ID`: GitHub App ID
- `ARC_GITHUB_APP_INSTALLATION_ID`: GitHub App installation ID
- `ARC_GITHUB_APP_PRIVATE_KEY`: GitHub App private key (multiline PEM)
- `KUBECONFIG_B64`: base64-encoded kubeconfig content

Optional repository secrets:

- `TALOSCONFIG_B64`: base64-encoded Talos config content
- `LIBVIRT_URI`: only needed when `run_terraform=true` in workflow dispatch
- `ARC_CONTAINER_MAX_RUNNERS`
- `ARC_CONTAINER_MIN_RUNNERS`
- `ARC_DIND_MAX_RUNNERS`
- `ARC_DIND_MIN_RUNNERS`
- `KVM_AUTOSCALER_UNRAID_SSH_TARGET`: `user@host-or-tailnet-ip` for virsh commands
- `KVM_AUTOSCALER_SSH_PRIVATE_KEY`: SSH private key for the above target

## Encoding example

```bash
base64 -i ~/.kube/config | tr -d '\n'
```

## Notes

- Use least-privilege GitHub App scope (repo-level where possible).
- Prefer short-lived Tailscale auth keys.
- Keep Terraform as manual apply by default; CI Terraform is fallback only.
