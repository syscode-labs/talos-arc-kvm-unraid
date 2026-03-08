# User Manual

This manual is for day-to-day operators who run and validate this platform.

## Standard Operating Sequence

1. Confirm infra baseline (Talos nodes, kubeconfig validity).
2. Apply ARC changes through workflow dispatch.
3. Validate both runner classes.
4. Run runtime-real smoke checks on KVM path.
5. Monitor autoscaler behavior during load and idle periods.

## Entry Points

- [Terraform Manual Apply](./terraform-apply)
- [ARC and Runner Classes](./arc-runners)
- [GitHub Workflows](./workflows)
- [Validation and Smoke Tests](./validation)
