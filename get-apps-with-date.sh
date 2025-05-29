#!/bin/bash

# Replace with your Cloudways API email and key
API_EMAIL="your-email@example.com"
API_KEY="your-api-key"

# Fetch access token
TOKEN=$(curl -s -X POST https://api.cloudways.com/api/v1/oauth/access_token \
  -d "email=$API_EMAIL&api_key=$API_KEY" | jq -r '.access_token')

if [ -z "$TOKEN" ] || [ "$TOKEN" == "null" ]; then
  echo "Failed to get access token"
  exit 1
fi

# Fetch servers
SERVERS=$(curl -s -X GET https://api.cloudways.com/api/v1/server \
  -H "Authorization: Bearer $TOKEN")

# Loop through each server
echo "Application Label,Creation Date"
echo "$SERVERS" | jq -r '.servers[].id' | while read -r SERVER_ID; do
  APPS=$(curl -s -X GET https://api.cloudways.com/api/v1/server/"$SERVER_ID"/apps \
    -H "Authorization: Bearer $TOKEN")

  echo "$APPS" | jq -r '.apps[] | [.label, .created_at] | @csv'
done
