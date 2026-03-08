# Service Manual (SRE/Platform)

This manual is the runbook counterpart to the user manual, aimed at on-call and platform maintainers.

## Responsibilities

- Maintain ARC availability and token/auth health.
- Keep KVM nodepool behavior predictable under load.
- Control blast radius for runtime-real workloads.
- Preserve reproducibility of infra + deployment path.

## On-call priorities

1. Restore runner availability for critical queues.
2. Protect control plane health.
3. Ensure KVM isolation boundaries are intact.
4. Communicate degraded modes and temporary routing.

## Runbook Index

- [Autoscaler Operations](./autoscaler)
- [Incidents and Recovery](./incidents)
- [Upgrade and Change Management](./upgrades)
- [Troubleshooting Matrix](./troubleshooting)
