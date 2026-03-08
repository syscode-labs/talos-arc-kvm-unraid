# Autoscaler Operations

## Component

- Namespace: `arc-systems`
- CronJob: `kvm-pool-autoscaler`
- Script: `k8s/kvm-pool-autoscaler/scale.sh`

## Runtime knobs

- `RUNNERS_PER_NODE`
- `MIN_KVM_NODES`
- `MAX_KVM_NODES`
- `KVM_NODE_NAMES`
- `UNRAID_SSH_TARGET`

## How it decides scale

```text
desired = ceil(pending_or_running_dind_pods / RUNNERS_PER_NODE)
desired = clamp(desired, MIN_KVM_NODES, MAX_KVM_NODES)
```

## Operational checks

- Confirm CronJob is scheduled and successful.
- Inspect logs for `virsh start`/`virsh shutdown` behavior.
- Verify VM power state on libvirt host.

## Safe tuning pattern

1. Start with low `RUNNERS_PER_NODE` for conservative scaling.
2. Observe queue wait and VM churn.
3. Increase ratio if churn is too high.
4. Keep `MAX_KVM_NODES` aligned with physical capacity.

## Failure containment

- If SSH auth fails, autoscaler should fail without mutating VM state.
- If pod listing fails, job exits and retries on next schedule.
