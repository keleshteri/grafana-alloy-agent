FROM grafana/alloy:latest

LABEL maintainer="Keleshteri <mehdi.shaban.keleshteri@outlook.com>"
LABEL description="Production-ready Grafana Alloy with built-in health checks and flexible configuration"
LABEL org.opencontainers.image.source="https://github.com/keleshteri/grafana-alloy-agent"

# Install healthcheck dependencies
USER root
RUN apt-get update && apt-get install -y --no-install-recommends \
    curl \
    wget \
    bash \
    gettext-base \
    && rm -rf /var/lib/apt/lists/*

# Copy configuration template
COPY configs/alloy-config.template /etc/alloy/config.alloy.template

# Copy scripts
COPY scripts/healthcheck.sh /usr/local/bin/healthcheck.sh
COPY scripts/entrypoint.sh /usr/local/bin/entrypoint.sh

# Make scripts executable
RUN chmod +x /usr/local/bin/healthcheck.sh /usr/local/bin/entrypoint.sh

# Create data directory
RUN mkdir -p /var/lib/alloy/data && chown -R alloy:alloy /var/lib/alloy

# Switch back to alloy user
USER alloy

# Expose metrics port
EXPOSE 12345

# Environment variables with defaults
ENV ALLOY_HTTP_LISTEN_ADDR="0.0.0.0:12345" \
    ALLOY_STORAGE_PATH="/var/lib/alloy/data" \
    HOSTNAME="unknown" \
    PROMETHEUS_URL="http://localhost:9090" \
    LOKI_URL="http://localhost:3100" \
    NODE_SCRAPE_INTERVAL="30s" \
    CADVISOR_SCRAPE_INTERVAL="60s" \
    SKIP_MONITORING_LOGS="true" \
    ALLOY_MODE="worker"

# Health check
HEALTHCHECK --interval=30s --timeout=10s --retries=3 --start-period=40s \
  CMD /usr/local/bin/healthcheck.sh

# Use custom entrypoint
ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]
CMD ["run", "--server.http.listen-addr=${ALLOY_HTTP_LISTEN_ADDR}", "--storage.path=${ALLOY_STORAGE_PATH}", "/etc/alloy/config.alloy"]