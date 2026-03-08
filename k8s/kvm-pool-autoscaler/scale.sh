#!/usr/bin/env bash
set -euo pipefail

NAMESPACE="${ARC_NAMESPACE:-arc-systems}"
DIND_RELEASE="${ARC_DIND_RELEASE_NAME:-arc-runners-dind}"
NODES_CSV="${KVM_NODE_NAMES:?set KVM_NODE_NAMES}"
SSH_TARGET="${UNRAID_SSH_TARGET:?set UNRAID_SSH_TARGET}"
SSH_KEY_PATH="${SSH_KEY_PATH:-/etc/ssh/id_ed25519}"
RUNNERS_PER_NODE="${RUNNERS_PER_NODE:-2}"
MIN_NODES="${MIN_KVM_NODES:-0}"
MAX_NODES="${MAX_KVM_NODES:-3}"

mapfile -t NODES < <(echo "$NODES_CSV" | tr ',' '\n' | sed 's/^ *//;s/ *$//' | sed '/^$/d')

if [ "${#NODES[@]}" -eq 0 ]; then
  echo "No nodes provided in KVM_NODE_NAMES" >&2
  exit 1
fi

if [ "$MAX_NODES" -gt "${#NODES[@]}" ]; then
  MAX_NODES="${#NODES[@]}"
fi

pending_or_running="$(kubectl -n "$NAMESPACE" get pods -l actions.github.com/scale-set-name="$DIND_RELEASE" -o json \
  | jq '[.items[] | select(.status.phase == "Pending" or .status.phase == "Running")] | length')"

desired="$(( (pending_or_running + RUNNERS_PER_NODE - 1) / RUNNERS_PER_NODE ))"

if [ "$desired" -lt "$MIN_NODES" ]; then
  desired="$MIN_NODES"
fi
if [ "$desired" -gt "$MAX_NODES" ]; then
  desired="$MAX_NODES"
fi

active=0
for node in "${NODES[@]}"; do
  active=$((active + 1))
  if [ "$active" -le "$desired" ]; then
    echo "Ensuring VM is running: ${node}"
    ssh -i "$SSH_KEY_PATH" -o StrictHostKeyChecking=no "$SSH_TARGET" "virsh start '${node}' >/dev/null 2>&1 || true"
  else
    echo "Ensuring VM is stopped: ${node}"
    ssh -i "$SSH_KEY_PATH" -o StrictHostKeyChecking=no "$SSH_TARGET" "virsh shutdown '${node}' >/dev/null 2>&1 || true"
  fi
done

echo "KVM autoscaler finished: pending_or_running=${pending_or_running} desired_nodes=${desired}"
