# Upgrade and Change Management

## Change classes

- Terraform/libvirt topology changes
- Talos version changes
- ARC chart/version changes
- Autoscaler logic changes
- Workflow and secret contract changes

## Standard upgrade workflow

1. Create branch and update target versions.
2. Build docs locally (`npm run docs:build`) and update impacted pages.
3. Run non-prod validation:
   - ARC install
   - kvm-smoke
   - sample runtime-real job
4. Apply in prod window with rollback plan.

## Rollback strategy

- Keep previous values and versions tagged.
- Re-run install with last-known-good values.
- For infra changes, use previous Terraform state/variables.

## Change safety checklist

- Are labels/taints unchanged or intentionally migrated?
- Does dind class still mount `/dev/kvm`?
- Are secrets compatible with new workflow logic?
- Does autoscaler still target the correct release name and node list?
