# talos-arc-kvm-unraid

Declarative Talos + ARC on Unraid, with `/dev/kvm` available to selected GitHub runner jobs.

## Target Topology

- Unraid host: 1 physical machine with `/dev/kvm`
- Talos cluster: 3 virtual nodes (1 control plane, 2 workers)
- ARC: installed in Talos cluster
- Runner scale set: container mode by default, KVM-capable pod template for selected jobs

## Declarative Layers

- `terraform/libvirt`: VM infrastructure definitions
- `talos/`: Talos cluster config and patch files
- `k8s/arc/`: ARC Helm values and runner scale-set values
- `.github/workflows/`: smoke workflows for validation

## Prerequisites

- Unraid virtualization enabled (`/dev/kvm` present)
- libvirt available on host
- `terraform`, `talosctl`, `kubectl`, `helm`
- GitHub App credentials for ARC

## Quick Flow

1. Provision Talos VMs with Terraform.
2. Generate/apply Talos configs.
3. Bootstrap cluster and fetch kubeconfig.
4. Install ARC controller and runner scale set.
5. Run KVM smoke workflow against ARC runners.

## ARC Runtime Mode

Default in this repo: container mode (no dind).

If compatibility issues appear for Docker-dependent jobs, add a second runner class in dind mode and route only those workflows to it.

## KVM Notes

- `/dev/kvm` is a shared character device. Multiple VMs/processes can use it concurrently.
- Capacity limits are CPU/RAM/IO, not a one-device-per-VM restriction.
