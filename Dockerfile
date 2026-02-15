FROM grafana/alloy:latest

RUN apt-get update && apt-get install -y curl && rm -rf /var/lib/apt/lists/*

LABEL maintainer="Keleshteri"
LABEL description="Grafana Alloy Agent - Minimal Wrapper"
LABEL org.opencontainers.image.source="https://github.com/keleshteri/grafana-alloy-agent"


# That's it! No modifications, just a wrapper
# We'll add features step by step once this works
