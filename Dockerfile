FROM grafana/alloy:latest

RUN apk add --no-cache curl

LABEL maintainer="Keleshteri"
LABEL description="Grafana Alloy Agent - Minimal Wrapper"
LABEL org.opencontainers.image.source="https://github.com/keleshteri/grafana-alloy-agent"


# That's it! No modifications, just a wrapper
# We'll add features step by step once this works
