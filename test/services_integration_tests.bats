#!/usr/bin/env bats

@test "evaluate cert-manager pod status" {
  run bash -c "kubectl get pods -n cert-manager -o wide | grep 'cert-manager'"
  [[ "${output}" =~ "Running" ]]
}

@test "evaluate cert-manager-cainjector pod status" {
  run bash -c "kubectl get pods -n cert-manager -o wide | grep 'cert-manager-cainjector'"
  [[ "${output}" =~ "Running" ]]
}

@test "evaluate cert-manager-webhook pod status" {
  run bash -c "kubectl get pods -n cert-manager -o wide | grep 'cert-manager-webhook'"
  [[ "${output}" =~ "Running" ]]
}

@test "evaluate istiod pod status" {
  run bash -c "kubectl get pods -n istio-system -o wide | grep 'istiod'"
  [[ "${output}" =~ "Running" ]]
}

@test "evaluate istio-ingressgateway pod status" {
  run bash -c "kubectl get pods -n istio-system -o wide | grep 'ingressgateway'"
  [[ "${output}" =~ "Running" ]]
}
