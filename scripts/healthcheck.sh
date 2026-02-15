#!/bin/sh
set -e

# Function to check endpoint
check_endpoint() {
    local url="$1"
    
    # Try wget first
    if command -v wget >/dev/null 2>&1; then
        if wget --spider --quiet --timeout=5 --tries=1 "$url" 2>/dev/null; then
            return 0
        fi
    fi
    
    # Try curl as fallback
    if command -v curl >/dev/null 2>&1; then
        if curl -sf --max-time 5 "$url" >/dev/null 2>&1; then
            return 0
        fi
    fi
    
    # Try netcat as last resort (just check port)
    if command -v nc >/dev/null 2>&1; then
        if nc -z localhost 12345 2>/dev/null; then
            return 0
        fi
    fi
    
    return 1
}

# Check metrics endpoint
if check_endpoint "http://localhost:12345/metrics"; then
    exit 0
fi

# If metrics fails, try ready endpoint
if check_endpoint "http://localhost:12345/-/ready"; then
    exit 0
fi

# All checks failed
echo "Health check failed: Cannot reach Alloy endpoints"
exit 1