#!/usr/bin/env bash
set -euo pipefail

NAMESPACE="${ARC_NAMESPACE:-arc-systems}"
CONTROLLER_NS="${ARC_CONTROLLER_NS:-arc-controller}"
ARC_GITHUB_CONFIG_URL="${ARC_GITHUB_CONFIG_URL:?set ARC_GITHUB_CONFIG_URL}"
ARC_MAX_RUNNERS="${ARC_MAX_RUNNERS:-6}"
ARC_MIN_RUNNERS="${ARC_MIN_RUNNERS:-0}"

helm repo add actions-runner-controller https://actions-runner-controller.github.io/actions-runner-controller
helm repo update

kubectl create namespace "$CONTROLLER_NS" --dry-run=client -o yaml | kubectl apply -f -
kubectl create namespace "$NAMESPACE" --dry-run=client -o yaml | kubectl apply -f -

kubectl -n "$NAMESPACE" create secret generic arc-gha-secret \
  --from-literal=github_app_id="${ARC_GITHUB_APP_ID:?set ARC_GITHUB_APP_ID}" \
  --from-literal=github_app_installation_id="${ARC_GITHUB_APP_INSTALLATION_ID:?set ARC_GITHUB_APP_INSTALLATION_ID}" \
  --from-literal=github_app_private_key="${ARC_GITHUB_APP_PRIVATE_KEY:?set ARC_GITHUB_APP_PRIVATE_KEY}" \
  --dry-run=client -o yaml | kubectl apply -f -

helm upgrade --install arc-controller actions-runner-controller/gha-runner-scale-set-controller \
  -n "$CONTROLLER_NS" \
  -f k8s/arc/controller-values.yaml

tmp_values="$(mktemp)"
envsubst < k8s/arc/runner-values.yaml > "$tmp_values"

helm upgrade --install arc-runners actions-runner-controller/gha-runner-scale-set \
  -n "$NAMESPACE" \
  -f "$tmp_values"

rm -f "$tmp_values"
