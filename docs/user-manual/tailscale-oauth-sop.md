# SOP: Add Tailscale OAuth Secrets for GitHub Actions

## Purpose

Configure repository secrets so the `apply` workflow authenticates to Tailscale using OAuth client credentials (preferred path).

## Prerequisites

- Tailscale admin access for your tailnet
- GitHub repository admin/maintainer access on `syscode-labs/talos-arc-kvm-unraid`

## Steps

1. Open Tailscale admin console OAuth page:
   - `https://login.tailscale.com/admin/settings/oauth`
2. Create or select an OAuth client.
3. Copy values:
   - **Client ID**
   - **Client Secret**
4. Open GitHub repository secrets:
   - `https://github.com/syscode-labs/talos-arc-kvm-unraid/settings/secrets/actions`
5. Add/update these repository secrets:
   - `TAILSCALE_OAUTH_CLIENT_ID` = Client ID
   - `TAILSCALE_OAUTH_SECRET` = Client Secret

## Validation

1. Dispatch `apply` workflow with all ops disabled (no-op):
   - `run_terraform=false`
   - `run_arc_install=false`
   - `run_kvm_autoscaler_apply=false`
2. Confirm run succeeds.
3. Dispatch `apply` with the real operation you need and confirm tailnet connection succeeds.

## Rollback/Recovery

- If OAuth credentials are invalid, rotate the OAuth client secret in Tailscale and update GitHub secret.
- Temporary fallback is `TAILSCALE_AUTHKEY`, but OAuth should remain the target state.

## Audit note

Record in your ops log:

- date/time
- operator
- OAuth client identifier used
- workflow run link for validation
