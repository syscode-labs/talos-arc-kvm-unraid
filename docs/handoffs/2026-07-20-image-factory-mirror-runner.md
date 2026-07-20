# Handoff — self-hosted runner for the Image Factory → GHCR mirror

**Date:** 2026-07-20
**From:** `image-factory-registry` project (Harbor backing store + PAT-free GHCR mirror)
**To:** this repo (ARC self-hosted runners)
**Plan:** `syscode-ai-internal-plans/projects/image-factory-registry/plans/2026-07-19-harbor-ghcr-mirror.md`

## What the other project needs from here

A new repo `syscode-labs/image-factory` will hold a scheduled GitHub Actions workflow that mirrors installer images from an intranet **Harbor** registry to the public **GHCR** copy (`crane copy`, authenticated to GHCR with the per-run `GITHUB_TOKEN` — no PAT). That workflow must run on a **self-hosted ARC runner managed by this repo**, because it needs to reach Harbor, which is intranet/tailnet-only.

Concretely, this repo needs to provide:

1. **A runner the `image-factory` repo can target** — `runs-on: arc-runners-container` (the container/kubernetes-mode scale set; `crane` is a static binary, so **no dind** is required).
2. **Network reach from runner pods to Harbor** at `harbor.<tailnet>.ts.net`.
3. **A Harbor pull credential injected into the runner pod** (not stored as a GitHub secret — see below).

## Action items

- [ ] **Confirm / stand up the target cluster.** The `image-factory-registry` plan targets the Omni-managed **`unraid-lab`** cluster (the only Unraid Talos cluster today). This repo's ARC values assume an ARC-hosting cluster exists; confirm ARC is actually deployed, and where. If ARC lives in a different cluster than Harbor, verify the runner→Harbor network path (tailnet route) rather than in-cluster DNS.
- [ ] **Make the runners available to `syscode-labs/image-factory`.** `githubConfigUrl` is org-scoped, so an org repo can target `arc-runners-container` once the repo exists and (if a runner group restricts repos) the group allows it. Confirm the runner group / permissions.
- [ ] **Inject the Harbor pull-robot credential via the pod template** (decision **3b** in the plan: the intranet credential must NOT be uploaded to GitHub as a repo secret). Create a k8s `Secret` in the runners namespace and mount it into the runner container in `k8s/arc/runner-container-values.yaml`:

  ```yaml
  # k8s/arc/runner-container-values.yaml — under template.spec.containers[name=runner]
  template:
    spec:
      containers:
        - name: runner
          image: ghcr.io/actions/actions-runner:latest
          envFrom:
            - secretRef:
                name: harbor-mirror-robot   # keys: HARBOR_USERNAME, HARBOR_PASSWORD
  ```

  The `image-factory` mirror workflow then reads `HARBOR_USERNAME`/`HARBOR_PASSWORD` from the runner environment (never from GitHub secrets) and does `crane auth login harbor.<tailnet>.ts.net -u "$HARBOR_USERNAME" -p "$HARBOR_PASSWORD"`.

- [ ] **Provision the `harbor-mirror-robot` Secret.** A Harbor **read-only** robot account scoped to the `image-factory` project. Populate the k8s Secret out-of-band (the same way `arc-gha-secret` is provisioned; add it to `SECRETS.md`). Pull-only, project-scoped, expirable, revocable.

## What this repo does NOT own

- The mirror workflow itself (lives in `syscode-labs/image-factory`).
- Harbor deployment, robot-account creation, and the GHCR side (owned by the `image-factory-registry` plan).
- Node install-image pulls — those go node → factory frontend → Harbor, not through any runner.

## Notes / future

- The plan records a **v1.1 cross-project option**: mint the Harbor robot credential on demand from **tessera** (a Harbor `create-then-delete` Source) instead of a static k8s Secret, so nothing holds a standing Harbor credential. If/when that lands, the `harbor-mirror-robot` Secret above is replaced by a tessera call from the workflow. Static Secret is the ship-now approach.
- Scale set names are `arc-runners-container` and `arc-runners-dind` (see `docs/user-manual/arc-runners.md`). Use `arc-runners-container` for this workload.
