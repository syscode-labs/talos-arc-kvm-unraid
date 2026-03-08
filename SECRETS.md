# Secrets

Required repository secrets for `.github/workflows/apply.yml`:

- `LIBVIRT_URI`: libvirt URI (for example `qemu+ssh://user@host/system`)
- `TALOSCONFIG_B64`: base64-encoded Talos config file content
- `KUBECONFIG_B64`: base64-encoded kubeconfig file content
- `ARC_GITHUB_CONFIG_URL`: org or repo URL for ARC runners
- `ARC_GITHUB_APP_ID`: GitHub App ID
- `ARC_GITHUB_APP_INSTALLATION_ID`: GitHub App installation ID
- `ARC_GITHUB_APP_PRIVATE_KEY`: GitHub App private key (multiline PEM)

Optional:
- `ARC_MAX_RUNNERS`
- `ARC_MIN_RUNNERS`

## Encoding examples

```bash
base64 -i ~/.talos/config | tr -d '\n'
base64 -i ~/.kube/config | tr -d '\n'
```

## Notes

- Keep runner scope tight (org/repo) via `ARC_GITHUB_CONFIG_URL`.
- Prefer dedicated GitHub App for ARC automation.
