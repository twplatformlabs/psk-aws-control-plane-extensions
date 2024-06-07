#!/usr/bin/env bash
set -eo pipefail

export toggle=$1
export cluster_name=$2

echo "toggle $toggle httpbin test instance on $cluster_name"

cat <<EOF > test/httpbin/virtual-service.yaml
---
apiVersion: networking.istio.io/v1beta1
kind: VirtualService
metadata:
  name: httpbin
  namespace: default-mtls
spec:
  hosts:
  - "httpbin.$cluster_name.twdps.io"
  gateways:
  - istio-system/$cluster_name-twdps-io-gateway
  http:
    - route:
      - destination:
          host: httpbin.default-mtls.svc.cluster.local
          port:
            number: 80
EOF

if [[ $toggle == "on" ]]; then
  echo "deploy httpbin to default-mtls"

  kubectl apply -f test/httpbin --recursive
  sleep 180

  # this doesn't work, not sure why
  # if only the management node is running then pause for a karpenter-node to spin up
  nodeCount=$(kubectl get nodes -l kubernetes.io/arch=amd64 | tail -n +2 | wc -l | xargs)
  # if [[ $nodeCount == "1" ]]; then
  #   echo "cluster scaled to zero nodes, wiating for instance to come up"
  #   sleep 180
  # fi
fi

if [[ $toggle == "off" ]]; then
  echo "delete httpbin from default-mtls"

  kubectl delete -f test/httpbin --recursive
fi
