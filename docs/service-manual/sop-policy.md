# SOP Policy

## Rule

Any manual operational process must have a written SOP in this docs site before it is used in production.

## Scope

This includes (non-exhaustive):

- Creating or rotating secrets
- Running workflow dispatches with privileged effects
- Terraform applies
- Cluster upgrades
- Incident mitigations
- Manual VM start/stop operations

## Minimum SOP template

Each SOP must contain:

1. **Purpose**: what outcome this procedure achieves
2. **Prerequisites**: required permissions, tools, and environment
3. **Exact steps**: numbered, deterministic actions
4. **Validation**: commands/checks proving success
5. **Rollback/Recovery**: how to back out safely
6. **Audit note**: where to record that the action happened

## Enforcement

- PRs introducing new manual operations must include/update an SOP page.
- If no SOP exists, operation is considered non-compliant and should be blocked.
