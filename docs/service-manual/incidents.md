# Incidents and Recovery

## Incident classes

1. ARC control-plane unavailable
2. Runners not registering
3. DIND jobs pending indefinitely
4. `/dev/kvm` missing on runtime-real jobs
5. Autoscaler not converging VM count

## Immediate triage

```bash
kubectl -n arc-controller get pods
kubectl -n arc-systems get pods -o wide
kubectl -n arc-systems get events --sort-by=.lastTimestamp | tail -n 50
```

## Recovery patterns

### ARC controller failure

- Restart controller deployment.
- Re-apply `k8s/arc/install.sh`.

### DIND queue backlog

- Verify KVM worker nodes are Ready.
- Verify taints/tolerations match current values.
- Temporarily increase `ARC_DIND_MAX_RUNNERS`.

### KVM missing in runner

- Validate hostPath mount in dind values.
- Verify node selected is in KVM pool.
- Run `kvm-smoke` workflow to isolate path issue.

### Autoscaler stalled

- Check CronJob history and logs.
- Validate SSH secret and target.
- Manually start critical KVM VMs to restore service.

## Post-incident actions

- Record timeline and root cause.
- Add or update automated check.
- Adjust thresholds, limits, or routing rules.
