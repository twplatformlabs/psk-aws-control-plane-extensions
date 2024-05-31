#!/usr/bin/env bash
set -eo pipefail

cluster_name=$1
CHART_VERSION=$(jq -er .cert_manager_chart_version $cluster_name.auto-tfvars.json)
AWS_ACCOUNT_ID=$(jq -er .aws_account_id $cluster_name.auto-tfvars.json)
AWS_ASSUME_ROLE=$(jq -er .aws_assume_role $cluster_name.auto-tfvars.json)

echo "cert-manager chart version $CHART_VERSION"
helm repo add jetstack https://charts.jetstack.io --force-update
helm repo update
helm upgrade --install cert-manager jetstack/cert-manager \
             --version v$CHART_VERSION \
             --namespace cert-manager --create-namespace \
             --set serviceAccount.annotations."eks\.amazonaws\.com/role-arn"=arn:aws:iam::${AWS_ACCOUNT_ID}:role/PSKRoles/${CLUSTER}-cert-manager-sa \
             --values cert-manager/$cluster_name-values.yaml
