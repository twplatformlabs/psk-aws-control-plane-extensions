#!/usr/bin/env bash
set -eo pipefail

cluster_name=$1
istio_version=$(jq -er .istio_version $cluster_name.auto.tfvars.json)
echo "istio version $istio_version"

# istio namespaces
kubectl apply -f tpl/istio-namespaces.yaml

# fetch specified istio version
curl -L https://istio.io/downloadIstio | ISTIO_VERSION=$istio_version sh -

# install or upgrade depending on if istio is already running. This is an inplace upgrade
already_installed=$(kubectl get po --all-namespaces)
if [[ $already_installed == *"istiod"* ]]; then
  echo "inplace upgrade"
  istio-${istio_version}/bin/istioctl upgrade -y -f istio/values-$istio_version.yaml
  sleep 30
  kubectl rollout restart deployment
else
  echo "new install"
  istio-${istio_version}/bin/istioctl install -y -f istio/values-$istio_version.yaml
fi
