# Quick Start

## 1. Prepare prerequisites

- Unraid host with virtualization and `/dev/kvm`.
- Talos cluster reachable from your machine.
- GitHub App credentials for ARC.
- Tailscale tailnet available for CI.

## 2. Manual infrastructure apply (operator)

```bash
make tf-init
make tf-plan
make tf-apply
```

Use your local `.env`/`TF_VAR_*` process for sensitive values.

## 3. Bootstrap Talos and export configs

Ensure `~/.kube/config` and optional `~/.talos/config` are valid for this cluster.

```bash
base64 -i ~/.kube/config | tr -d '\n'
base64 -i ~/.talos/config | tr -d '\n'
```

Store these in repo secrets per [Secrets Reference](/reference/secrets).

## 4. Run apply workflow

Dispatch `.github/workflows/apply.yml` with:

- `run_terraform=false`
- `run_arc_install=true`
- `run_kvm_autoscaler_apply=true`

## 5. Validate runtime path

- Run `kvm-smoke` workflow.
- Confirm dind runner pods land on KVM nodes.
- Confirm `/dev/kvm` is visible in runner container.

## 6. Start using runner classes

- Route default jobs to container scale set.
- Route runtime-real jobs to dind/KVM scale set.
