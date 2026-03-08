# ARC and Runner Classes

## Scale Sets

- `arc-runners-container`
  - standard jobs
  - general worker nodeSelector
- `arc-runners-dind`
  - runtime-real jobs
  - KVM nodeSelector + taint toleration
  - mounts `/dev/kvm`

## Install/upgrade command

```bash
./k8s/arc/install.sh
```

## Expected state

```bash
kubectl -n arc-controller get pods
kubectl -n arc-systems get autoscalingrunnersets
kubectl -n arc-systems get pods
```

## Routing jobs to the right class

- Default CI jobs: target container runner class.
- Runtime-real/e2e jobs: target dind/KVM class.
- Keep heavy jobs isolated from general pool.

## Capacity tuning

Use secrets:

- `ARC_CONTAINER_MIN_RUNNERS`, `ARC_CONTAINER_MAX_RUNNERS`
- `ARC_DIND_MIN_RUNNERS`, `ARC_DIND_MAX_RUNNERS`

Tune conservatively, then increase after observing queue latency.
