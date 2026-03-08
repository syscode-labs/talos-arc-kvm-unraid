# GitHub Workflows

## apply workflow

File: `.github/workflows/apply.yml`

Inputs:

- `run_terraform` (default `false`): CI fallback only.
- `run_arc_install` (default `true`): install/upgrade ARC.
- `run_kvm_autoscaler_apply` (default `true`): apply autoscaler manifests.

Behavior:

1. Checks out repo.
2. Connects to tailnet using Tailscale OAuth credentials (authkey fallback supported).
3. Validates required secrets for selected operation mode.
4. Installs helm/kubectl toolchain.
5. Optionally runs Terraform apply.
6. Deploys ARC scale sets.
7. Applies autoscaler and SSH secret.

Operational SOP:

- [SOP: Add Tailscale OAuth Secrets](./tailscale-oauth-sop)

## kvm-smoke workflow

File: `.github/workflows/kvm-smoke.yml`

Purpose:

- Verifies `/dev/kvm` exists and is RW on selected runner.
- Fast sanity check before runtime-real tests.

## Secret contract

Use [Secrets Reference](/reference/secrets) as the authoritative list.
