#!/bin/bash

set -eu

# Ensure required env vars
if [ -z "${TYPESENSE_API_KEY:-}" ]; then
  echo "Error: TYPESENSE_API_KEY is not set."
  exit 1
fi

SNAPSHOT_PATH="snapshots/latest.tar"

# Trigger snapshot via API
RESPONSE=$(curl -s -w "%{http_code}" -X POST "http://localhost:8108/operations/snapshot" \
     -H "X-TYPESENSE-API-KEY: ${TYPESENSE_API_KEY}" \
     -d "{\"snapshot_path\": \"${SNAPSHOT_PATH}\"}")

HTTP_CODE=${RESPONSE: -3}
BODY=${RESPONSE:0:${#RESPONSE}-3}

if [ "$HTTP_CODE" -eq 200 ] || [ "$HTTP_CODE" -eq 201 ] && echo "$BODY" | grep -q '"success":true'; then
  echo "Snapshot created successfully at ${SNAPSHOT_PATH}"
else
  echo "Error creating snapshot. HTTP $HTTP_CODE: $BODY"
  exit 1
fi
