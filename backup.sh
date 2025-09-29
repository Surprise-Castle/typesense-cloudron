#!/bin/bash

set -eu

# Ensure required env vars
if [ -z "${TYPESENSE_API_KEY:-}" ]; then
  echo "Error: TYPESENSE_API_KEY is not set."
  exit 1
fi

SNAPSHOT_PATH="${TYPESENSE_DATA_DIR}/snapshots/latest.tar"

# Trigger snapshot via API
curl -X POST "http://localhost:8108/operations/snapshot" \
     -H "X-TYPESENSE-API-KEY: ${TYPESENSE_API_KEY}" \
     -d "{\"snapshot_path\": \"${SNAPSHOT_PATH}\"}"

if [ $? -eq 0 ]; then
  echo "Snapshot created successfully at ${SNAPSHOT_PATH}"
else
  echo "Error creating snapshot."
  exit 1
fi
