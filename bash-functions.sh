#!/usr/bin/env bash
set -eo pipefail

# awsAssumeRole ()  ================================================================================
#
# Assume AWS role.
# Expects parameters
# $1 = aws accounts id
# $2 = aws role to assume
# Expects IAM credentials to be defined as ENV variables

awsAssumeRole () {
    aws sts assume-role --output json --role-arn arn:aws:iam::"$1":role/"$2" --role-session-name aws-assume-role > credentials

    export AWS_ACCESS_KEY_ID=$(cat credentials | jq -r ".Credentials.AccessKeyId")
    export AWS_SECRET_ACCESS_KEY=$(cat credentials | jq -r ".Credentials.SecretAccessKey")
    export AWS_SESSION_TOKEN=$(cat credentials | jq -r ".Credentials.SessionToken")
}

# createOIDCAssumableRole ()  ================================================================================
#
# Kubernetes ServiceAccount role for interacting with AWS API
# Expects parameters
# $1 = service name
# $2 = policy folder path; default = 'policies'
# $3 = aws account id
# $4 = cluster name
# $5 = aws role to assume to create Role
# $6 = eks cluster oidc provider url
# $7 = kubernetes namespace
# $8 = iam role path
# $9 = iam policy path

createOIDCAssumableRole () {
  service_name="$1"
  policy_path="${2:-policies}"
  aws_account_id="$3"
  cluster_name="$4"
  aws_assume_role="$5"
  cluster_oidc_issuer_url="$6"
  namespace="$7"
  iam_role_path="${8:-PSKRoles}"
  iam_policy_path="${9:-PSKPolicies}"

 # log INFO
  echo "INFO:"
  echo "service_name = $service_name"
  echo "policy_path = $policy_path"
  echo "aws_account_id = $aws_account_id"
  echo "cluster_name = $cluster_name"
  echo "namespace = $namespace"
  echo "aws_assume_role = $aws_assume_role"
  echo "cluster_oidc_issuer_url = $cluster_oidc_issuer_url"
  echo "iam_role_path = $iam_role_path"
  echo "iam_policy_path = $iam_policy_path"
  echo "role policy filepath = $policy_path/$service_name-role-policy.json"
  echo "trust policy filepath = $policy_path/$service_name-trust-policy.json"
  echo "sa arn = system:serviceaccount:$namespace:$cluster_name-$service_name-sa"

  # validate role policy file
  if [[ ! -f "$policy_path/$service_name-role-policy.json" ]]; then
    echo "$policy_path/$service_name-role-policy.json not found"
    exit 1
  fi

  # generate cert-manager role trust policy
  cat <<EOF > "$policy_path/$service_name-trust-policy.json" 
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Federated": "arn:aws:iam::$aws_account_id:oidc-provider/$cluster_oidc_issuer_url"
      },
      "Action": "sts:AssumeRoleWithWebIdentity",
      "Condition": {
        "StringEquals": {
          "$cluster_oidc_issuer_url:aud": "sts.amazonaws.com",
          "$cluster_oidc_issuer_url:sub": "system:serviceaccount:$namespace:$cluster_name-$service_name-sa"
        }
      }
    }
  ]
}
EOF

  awsAssumeRole "$aws_account_id" "$aws_assume_role"
}

  # ASSUMEROLE
  # # create the service account role policy
  # aws iam create-policy --path $iam_policy_path --policy-name "$cluster_name-$service_name-role-policy" --policy-document "file://$policy_path/$service_name-role-policy.json"

  # # create the service account role
  # aws iam create-role --path $iami_role_path --role-name "$cluster_name-$service_name-sa" --assume-role-policy-document "file://$policy_path/$service_name-trust-policy.json" --description "oidc assumable role $cluster_name-$service_name"

  # # attach role policy to role
  # aws iam attach-role-policy --role-name "$cluster_name-$service_name-sa" --policy-arn "arn:aws:iam::$aws_account_id:policy/$iam_policy_path/$cluster_name-$service_name-role-policy"
