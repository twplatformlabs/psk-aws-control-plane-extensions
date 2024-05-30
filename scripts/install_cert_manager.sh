#!/usr/bin/env bash
set -eo pipefail
source bash-functions.sh

cluster_name=$1
CHART_VERSION=$(jq -er .cert_manager_chart_version $cluster_name.json)
AWS_ACCOUNT_ID=$(jq -er .aws_account_id $cluster_name.json)
AWS_ASSUME_ROLE=$(jq -er .aws_assume_role $cluster_name.json)
CLUSTER_OIDC_ISSUER_URL=$(jq -er .cluster_oidc_issuer_url $cluster_name.json)

# create cert-manager service account role
createOIDCAssumableRole cert-manager "" $AWS_ACCOUNT_ID $cluster_name $AWS_ASSUME_ROLE $CLUSTER_OIDC_ISSUER_URL cert-manager

# $1 = service name
# $2 = policy folder path; default = 'policies'
# $3 = aws account id
# $4 = cluster name
# $5 = aws role to assume to create Role
# $6 = eks cluster oidc provider url
# $7 = kubernetes namespace
# $8 = iam role path
# $9 = iam policy path

echo "cert-manager chart version $CHART_VERSION"
# helm repo add jetstack https://charts.jetstack.io --force-update
# helm repo update
# helm upgrade --install cert-manager jetstack/cert-manager \
#              --version v$CHART_VERSION \
#              --namespace cert-manager --create-namespace \
#              --set serviceAccount.annotations."eks\.amazonaws\.com/role-arn"=arn:aws:iam::${AWS_ACCOUNT_ID}:role/PSKRoles/${CLUSTER}-cert-manager-sa \
#              --values cert-manager/$cluster_name-values.yaml



#===============================================


# cat >my-service-account.yaml <<EOF
# apiVersion: v1
# kind: ServiceAccount
# metadata:
#   name: my-service-account
#   namespace: default
# EOF
# kubectl apply -f my-service-account.yaml



# confirm correct
# aws iam get-role --role-name my-role --query Role.AssumeRolePolicyDocument
# output:
# {
#   "Version": "2012-10-17",
#   "Statement": [
#       {
#           "Effect": "Allow",
#           "Principal": {
#               "Federated": "arn:aws:iam::111122223333:oidc-provider/oidc.eks.region-code.amazonaws.com/id/EXAMPLED539D4633E53DE1B71EXAMPLE"
#           },
#           "Action": "sts:AssumeRoleWithWebIdentity",
#           "Condition": {
#               "StringEquals": {
#                   "oidc.eks.region-code.amazonaws.com/id/EXAMPLED539D4633E53DE1B71EXAMPLE:sub": "system:serviceaccount:default:my-service-account",
#                   "oidc.eks.region-code.amazonaws.com/id/EXAMPLED539D4633E53DE1B71EXAMPLE:aud": "sts.amazonaws.com"
#               }
#           }
#       }
#   ]
# }

# confirm
# aws iam list-attached-role-policies --role-name my-role --query AttachedPolicies[].PolicyArn --output text

# output: arn:aws:iam::111122223333:policy/my-policy

# view
# aws iam get-policy --policy-arn $policy_arn

# output:
# {
#   "Policy": {
#       "PolicyName": "my-policy",
#       "PolicyId": "EXAMPLEBIOWGLDEXAMPLE",
#       "Arn": "arn:aws:iam::111122223333:policy/my-policy",
#       "Path": "/",
#       "DefaultVersionId": "v1",
#       [...]
#   }
# }

# aws iam get-policy-version --policy-arn $policy_arn --version-id v1

# output:
# {
#   "Version": "2012-10-17",
#   "Statement": [
#       {
#           "Effect": "Allow",
#           "Action": "s3:GetObject",
#           "Resource": "arn:aws:s3:::my-pod-secrets-bucket"
#       }
#   ]
# }

# confirm
# kubectl describe serviceaccount my-service-account -n default

# output:
# Name:                my-service-account
# Namespace:           default
# Annotations:         eks.amazonaws.com/role-arn: arn:aws:iam::111122223333:role/my-role
# Image pull secrets:  <none>
# Mountable secrets:   my-service-account-token-qqjfl
# Tokens:              my-service-account-token-qqjfl
# [...]






