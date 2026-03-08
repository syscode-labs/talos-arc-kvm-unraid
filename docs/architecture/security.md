# Security Model

## Core Principles

- Least-privilege GitHub App credentials.
- Tailscale as private network transport for CI.
- Segregated node pools by workload trust and hardware access.
- Secrets only in GitHub secrets or Kubernetes secrets, never in git.

## Trust Boundaries

- **GitHub-hosted runner**: ephemeral, joins tailnet for scoped operations.
- **Talos cluster**: control plane for ARC and workloads.
- **Unraid host/libvirt**: privileged substrate controlling VMs.

## Sensitive Assets

- GitHub App private key
- Tailscale auth key
- SSH private key used by KVM autoscaler
- kubeconfig/talosconfig blobs

## Controls

- Tight repository permissions for workflows.
- Keep ARC scope minimal via `ARC_GITHUB_CONFIG_URL`.
- Use short-lived Tailscale auth keys where possible.
- Rotate SSH and GitHub App keys on schedule.

## Risk Notes

- KVM access implies elevated compute capability. Keep it isolated to dedicated nodes.
- DIND workloads are higher risk than container-mode workloads.
- Autoscaler SSH credentials should be constrained to virsh-only command rights if feasible.
