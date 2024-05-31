#!/usr/bin/env bash
set -eo pipefail

export cluster_name=$1
export AWS_DEFAULT_REGION=$(jq -er .aws_region "$cluster_name".auto.tfvars.json)

kubectl apply -f "$cluster_name-cluster-issuer.yaml"
