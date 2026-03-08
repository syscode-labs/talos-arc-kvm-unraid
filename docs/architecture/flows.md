# Control and Data Flows

## Provisioning Flow

1. Operator applies Terraform (`terraform/libvirt`) manually.
2. Libvirt creates Talos VM definitions.
3. KVM workers may be created in stopped state.
4. Operator boots/bootstraps Talos and validates kubeconfig.

## ARC Deployment Flow

1. GitHub workflow joins tailnet.
2. Workflow writes kubeconfig/talosconfig from secrets.
3. `k8s/arc/install.sh` deploys:
   - ARC controller
   - container scale set
   - dind scale set
4. Secrets for GitHub App auth are synced into cluster.

## Workload Scheduling Flow

1. Workflow job targets appropriate runner class.
2. ARC provisions runner pod.
3. Scheduler places pod based on nodeSelector and tolerations.
4. DIND pods requiring `/dev/kvm` land only on tainted KVM nodes.

## KVM Autoscaling Flow

1. CronJob queries dind runner pods in namespace.
2. Computes desired KVM VM count:
   - `ceil(active_runner_pods / RUNNERS_PER_NODE)`
   - bounded by `MIN_KVM_NODES` and `MAX_KVM_NODES`
3. Starts VMs up to desired count.
4. Shuts down remaining pre-provisioned VMs.
