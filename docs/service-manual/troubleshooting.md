# Troubleshooting Matrix

| Symptom | Likely Cause | Verification | Fix |
|---|---|---|---|
| `apply` fails at tailscale step | invalid/expired auth key | workflow logs at tailnet join | rotate `TAILSCALE_AUTHKEY` |
| ARC pods healthy but no runners | wrong GitHub App credentials | `kubectl -n arc-systems describe secret arc-gha-secret` | update app secrets, rerun install |
| dind runners pending | no matching KVM nodes or bad toleration | `kubectl -n arc-systems describe pod <runner>` | fix labels/taints/tolerations |
| runner starts but no `/dev/kvm` | hostPath mount missing or wrong node | inspect pod spec and node | patch `runner-dind-values.yaml` |
| autoscaler logs SSH errors | bad SSH target/key | CronJob job logs | rotate `KVM_AUTOSCALER_*` secrets |
| VMs never scale down | active pods still counted | list runner pods and phases | tune ratio/min/max and verify completed pods cleanup |
| CI Terraform fails | libvirt URI unreachable from CI | terraform init/apply logs | keep manual apply or fix tailnet/libvirt path |

## Command bundle

```bash
kubectl get nodes -o wide
kubectl -n arc-controller get pods
kubectl -n arc-systems get pods -o wide
kubectl -n arc-systems get cronjob,job
kubectl -n arc-systems logs job/<latest-kvm-autoscaler-job>
```
