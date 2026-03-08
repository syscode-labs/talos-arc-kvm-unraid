# Validation and Smoke Tests

## Control-plane checks

```bash
kubectl get nodes -o wide
kubectl -n arc-controller get pods
kubectl -n arc-systems get pods
```

## Node labeling/taint checks

```bash
kubectl get nodes --show-labels | grep nodepool.syscode.dev/type
kubectl describe node <kvm-node-name> | grep -A3 Taints
```

## Runner behavior checks

- Container runner pods should land on `type=general` nodes.
- DIND runner pods should land on tainted KVM nodes.

```bash
kubectl -n arc-systems get pods -o wide
```

## KVM checks inside runner

```bash
ls -l /dev/kvm
test -r /dev/kvm && test -w /dev/kvm
```

## Autoscaler checks

```bash
kubectl -n arc-systems get cronjob kvm-pool-autoscaler
kubectl -n arc-systems get jobs --sort-by=.metadata.creationTimestamp
kubectl -n arc-systems logs job/<latest-job>
```
