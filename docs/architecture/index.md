# Architecture Overview

## Topology

```mermaid
flowchart LR
  GH[GitHub Actions] --> TS[Tailscale Tunnel]
  TS --> U[Unraid Host]
  U --> LV[libvirt]
  LV --> CP[Talos CP]
  LV --> WG[Talos General Worker]
  LV --> WK1[Talos KVM-1]
  LV --> WK2[Talos KVM-2]
  LV --> WK3[Talos KVM-3]

  CP --> ARC[ARC Controller]
  ARC --> RS1[Scale Set: container]
  ARC --> RS2[Scale Set: dind+kvm]

  RS2 --> KVM[/dev/kvm/]
```

## Node Pools

- **General pool**: `nodepool.syscode.dev/type=general`
  - default ARC runners
  - no KVM taint
- **KVM pool**: `nodepool.syscode.dev/type=kvm`, `arc.example.dev/kvm=true`
  - taint: `arc.example.dev/kvm=true:NoSchedule`
  - accepts only explicitly tolerant workloads

## ARC Runtime Split

- Container scale set optimizes cost and simplicity.
- DIND scale set isolates heavier runtime-real jobs.
- Routing is explicit through workflow `runs-on` labels and scale set configuration.

## Autoscaler Design

- Cluster CronJob inspects dind runner pod demand.
- Desired KVM VM count is computed by a deterministic ratio.
- Script executes `virsh start` / `virsh shutdown` over SSH.
- Pool can shrink to zero when idle.
