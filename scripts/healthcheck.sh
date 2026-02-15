#!/bin/sh

# Try wget first (faster)
if command -v wget > /dev/null 2>&1; then
    wget --quiet --tries=1 --spider http://localhost:12345/metrics 2>/dev/null
    exit $?
fi

# Fallback to curl
if command -v curl > /dev/null 2>&1; then
    curl -sf http://localhost:12345/metrics > /dev/null 2>&1
    exit $?
fi

# If neither available, fail
echo "Neither wget nor curl available for health check"
exit 1