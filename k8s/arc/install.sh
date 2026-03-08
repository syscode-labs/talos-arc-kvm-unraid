#!/usr/bin/env bash
set -euo pipefail

NAMESPACE="${ARC_NAMESPACE:-arc-systems}"
CONTROLLER_NS="${ARC_CONTROLLER_NS:-arc-controller}"

helm repo add actions-runner-controller https://actions-runner-controller.github.io/actions-runner-controller
helm repo update

kubectl create namespace "$CONTROLLER_NS" --dry-run=client -o yaml | kubectl apply -f -
kubectl create namespace "$NAMESPACE" --dry-run=client -o yaml | kubectl apply -f -

helm upgrade --install arc-controller actions-runner-controller/gha-runner-scale-set-controller \
  -n "$CONTROLLER_NS" \
  -f k8s/arc/controller-values.yaml

helm upgrade --install arc-runners actions-runner-controller/gha-runner-scale-set \
  -n "$NAMESPACE" \
  -f k8s/arc/runner-values.yaml
