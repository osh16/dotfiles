#!/usr/bin/env bash

full_path=$(echo $1 | grep ".onmicrosoft.com")

if [[ -z ${full_path} ]] ; then
  url="https://login.microsoftonline.com/${1}.onmicrosoft.com/.well-known/openid-configuration"
else
  url="https://login.microsoftonline.com/${1}/.well-known/openid-configuration"
fi

response=$(curl -s $url)

if echo "$response" | jq -e '.error' > /dev/null; then
    echo "Error in response"
    exit 1
else
    # Extract the tenant ID from the issuer field
    tenant_id=$(echo "$response" | jq -r '.issuer' | awk -F'/' '{print $4}')
    echo $tenant_id
fi
