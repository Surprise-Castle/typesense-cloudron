#!/bin/bash

set -eu

echo "Starting Typesense..."

# Generate a secure API key if not provided
if [ -z "${TYPESENSE_API_KEY:-}" ]; then
    export TYPESENSE_API_KEY=$(openssl rand -hex 32)
    echo "Generated API Key: ${TYPESENSE_API_KEY}"
    echo "IMPORTANT: Save this API key! You'll need it to access Typesense."
else
    echo "Using provided API Key: ${TYPESENSE_API_KEY}"
fi

# Set default values for environment variables - using /run for database files
export TYPESENSE_DATA_DIR=${TYPESENSE_DATA_DIR:-/app/data}
export TYPESENSE_LOG_LEVEL=${TYPESENSE_LOG_LEVEL:-INFO}
export TYPESENSE_ENABLE_CORS=${TYPESENSE_ENABLE_CORS:-true}

# Create necessary directories
mkdir -p /run/typesense
mkdir -p "${TYPESENSE_DATA_DIR}"
mkdir -p "${TYPESENSE_DATA_DIR}/db"
mkdir -p "${TYPESENSE_DATA_DIR}/meta"
mkdir -p "${TYPESENSE_DATA_DIR}/analytics"
mkdir -p "${TYPESENSE_DATA_DIR}/snapshots"  # New: For storing triggered snapshots

# Set ownership to cloudron user
chown -R cloudron:cloudron "${TYPESENSE_DATA_DIR}"
chown -R cloudron:cloudron /run/typesense

# Generate configuration file from template
envsubst < /app/code/typesense.ini.template > /run/typesense/typesense.ini

echo "=== Typesense Configuration ==="
echo "Data Directory: ${TYPESENSE_DATA_DIR}"
echo "Log Level: ${TYPESENSE_LOG_LEVEL}"
echo "CORS Enabled: ${TYPESENSE_ENABLE_CORS}"
echo "API Port: 8108"
echo "Health Check: http://localhost:8108/health"
echo "Debug Info: http://localhost:8108/debug"
echo "================================"

# Run restore if snapshot exists
/app/code/restore.sh

# Start Typesense as the cloudron user
exec /usr/local/bin/gosu cloudron:cloudron /app/code/typesense-server \
    --config=/run/typesense/typesense.ini