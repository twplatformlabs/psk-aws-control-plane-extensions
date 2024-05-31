#!/usr/bin/env bash
source bash-functions.sh
set -eo pipefail

export ENVIRONMENT=$1
export AWS_DEFAULT_REGION=$(cat ${ENVIRONMENT}.auto.tfvars.json | jq -r .aws_region)

awsAssumeRole $(cat ${ENVIRONMENT}.auto.tfvars.json | jq -r .aws_account_id) $(cat ${ENVIRONMENT}.auto.tfvars.json | jq -r .aws_assume_role)

rspec test/service_account_roles.rb --format documentation
