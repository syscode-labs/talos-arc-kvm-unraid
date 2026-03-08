# talos-arc-kvm-unraid Docs

Practical, operator-grade documentation for running Talos + ARC + KVM workloads on Unraid.

## What This Repo Delivers

- **Talos cluster topology**: one control plane, one general worker, three tainted KVM workers.
- **ARC split runtimes**:
  - `arc-runners-container`: default workflows.
  - `arc-runners-dind`: runtime-real workflows that require Docker-in-Docker and `/dev/kvm`.
- **KVM pool autoscaler scaffold**: starts/stops pre-provisioned KVM VMs based on runner demand.
- **Tailscale-based CI access**: GitHub-hosted workflow joins your tailnet for private infra access.

## Read Order

1. [Quick Start](/quick-start)
2. [Architecture Overview](/architecture/)
3. [User Manual](/user-manual/)
4. [Service Manual](/service-manual/)

## Operational Stance

- Terraform infra changes are **manual-first**.
- CI is used for **cluster-side updates** (ARC, autoscaler manifests).
- Security model assumes least privilege, short-lived credentials, and isolated node pools.

## Scope Boundaries

This repo does not automate initial Unraid host provisioning. It assumes host prerequisites are completed.
