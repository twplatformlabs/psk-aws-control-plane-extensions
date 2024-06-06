#!/usr/bin/env bash
set -eo pipefail

export cluster_name=$1

bash scripts/toggle_httpbin.sh on $cluster_name

jsonResponse=$(curl -X GET "https://httpbin.$cluster_name.twdps.io/json" -H "accept: application/json")
echo "response $jsonResponse"
if [[ ! $jsonResponse =~ "slideshow" ]]; then
  echo "httpbin not responding"
  exit 1
fi

bash scripts/toggle_httpbin.sh off $cluster_name
