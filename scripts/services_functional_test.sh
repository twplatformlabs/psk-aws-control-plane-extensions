#!/usr/bin/env bash
set -eo pipefail

export cluster_name=$1

# launch test app in istio-managed namespace
bash scripts/toggle_httpbin.sh on $cluster_name

# all istio, external-dns, and cert-manager extensions must be healthy for this response to succeed
jsonResponse=$(curl -X GET "https://httpbin.$cluster_name.twplatformlabs.org/json" -H "accept: application/json")
echo "response $jsonResponse"
if [[ ! $jsonResponse =~ "slideshow" ]]; then
  echo "httpbin not responding"
  exit 1
fi

# remove test app
bash scripts/toggle_httpbin.sh off $cluster_name
