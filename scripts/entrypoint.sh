#!/bin/bash
set -e

echo "================================================"
echo "Grafana Alloy Agent - Starting"
echo "================================================"
echo "Mode: ${ALLOY_MODE}"
echo "Hostname: ${HOSTNAME}"
echo "Prometheus: ${PROMETHEUS_URL}"
echo "Loki: ${LOKI_URL}"
echo "================================================"

# Generate config from template with environment variables
envsubst < /etc/alloy/config.alloy.template > /etc/alloy/config.alloy

# Validate configuration
echo "Validating Alloy configuration..."
if /bin/alloy fmt /etc/alloy/config.alloy > /dev/null 2>&1; then
    echo "✓ Configuration is valid"
else
    echo "✗ Configuration validation failed!"
    echo "Showing generated config for debugging:"
    cat /etc/alloy/config.alloy
    exit 1
fi

# Start Alloy
echo "Starting Alloy..."
exec /bin/alloy "$@"