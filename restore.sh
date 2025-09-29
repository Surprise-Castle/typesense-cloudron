#!/bin/bash

set -eu

SNAPSHOT_FILE="/app/data/snapshots/latest.tar"

if [ -f "$SNAPSHOT_FILE" ]; then
  echo "Restoring from snapshot..."
  tar -xvf "$SNAPSHOT_FILE" -C /app/data
  echo "Restore complete."
else
  echo "No snapshot found, skipping restore."
fi
