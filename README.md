# talos-arc-kvm-unraid

[![apply](https://github.com/syscode-labs/talos-arc-kvm-unraid/actions/workflows/apply.yml/badge.svg?event=workflow_dispatch)](https://github.com/syscode-labs/talos-arc-kvm-unraid/actions/workflows/apply.yml)
[![kvm-smoke](https://github.com/syscode-labs/talos-arc-kvm-unraid/actions/workflows/kvm-smoke.yml/badge.svg?event=workflow_dispatch)](https://github.com/syscode-labs/talos-arc-kvm-unraid/actions/workflows/kvm-smoke.yml)
[![docs-pages](https://github.com/syscode-labs/talos-arc-kvm-unraid/actions/workflows/docs-pages.yml/badge.svg?branch=main)](https://github.com/syscode-labs/talos-arc-kvm-unraid/actions/workflows/docs-pages.yml)
[![docs](https://img.shields.io/badge/docs-github_pages-3451b2)](https://syscode-labs.github.io/talos-arc-kvm-unraid/)

Declarative Talos + ARC on Unraid with a dedicated tainted KVM worker pool for heavy runtime jobs.

## Target Topology

- Unraid host: 1 physical machine with `/dev/kvm`
- Talos cluster: 1 control plane + 1 general worker + 3 KVM workers
- ARC: two runner classes
  - `arc-runners-container` for normal workflows
  - `arc-runners-dind` for runtime-real workloads on KVM nodes
- KVM worker pool: tainted and autoscaled to zero when idle

## Declarative Layers

- `terraform/libvirt`: VM infrastructure definitions
- `talos/`: Talos cluster node config
- `k8s/arc/`: ARC controller + dual scale set values
- `k8s/kvm-pool-autoscaler/`: in-cluster scaler that starts/stops KVM VMs over SSH
- `.github/workflows/`: workflow-dispatch operations over Tailscale

## Operating Model

- Terraform apply is manual-first (local operator action via `mise`/`.env`/`TF_VAR_*`).
- CI focuses on cluster-side installs and updates (ARC + autoscaler).
- Private infra access from CI is done via Tailscale.

## Quick Flow

1. Manually apply Terraform when infra changes are needed.
2. Bootstrap Talos and obtain kubeconfig/talosconfig.
3. Run workflow `apply` with `run_arc_install=true`.
4. Run workflow `kvm-smoke` on KVM-capable runner labels.

## ARC Runtime Split

- Container class (`arc-runners-container`): default low-cost jobs.
- DIND class (`arc-runners-dind`): KVM-specific runtime-real jobs, scheduled only on tainted KVM nodes.

## KVM Autoscaler Behavior

- Every 2 minutes, reads active dind runner pods.
- Computes desired KVM VM count with min/max caps.
- Starts/stops pre-provisioned KVM worker VMs via `virsh` over SSH.

## GitHub Secrets

See `SECRETS.md`.

## Documentation Site

Comprehensive operational docs are available via GitHub Pages (VitePress):

- Source: `docs/`
- Deploy workflow: `.github/workflows/docs-pages.yml`
- Expected URL: `https://syscode-labs.github.io/talos-arc-kvm-unraid/`

Manuals included:

- Architecture manual
- User manual (operator-focused)
- Service manual (SRE/runbook-focused)
