# Terraform Manual Apply

## Why manual-first

Infrastructure changes can be destructive and environment-specific. Manual apply keeps ownership explicit and avoids accidental CI drift.

## Procedure

```bash
make tf-init
make tf-plan
make tf-apply
```

## Recommended checklist

- Confirm current branch and commit.
- Inspect plan output for VM count/size deltas.
- Verify KVM pool settings:
  - `kvm_worker_pool_size`
  - `kvm_workers_start_running`
- Apply only when the change window is approved.

## Post-apply validation

- Verify libvirt domains exist.
- Verify Talos nodes are reachable.
- Confirm labels/taints on Kubernetes nodes.

## Rollback guidance

- Use prior Terraform state and variables.
- Reduce pool size or disable running state if overprovisioned.
- Do not force-delete VMs with active runner workloads.
