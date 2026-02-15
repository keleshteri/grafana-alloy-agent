FROM grafana/alloy:latest

LABEL maintainer="Keleshteri"
LABEL description="Production-ready Grafana Alloy with flexible configuration"
LABEL org.opencontainers.image.source="https://github.com/keleshteri/grafana-alloy-agent"

# Install dependencies (Alpine uses apk, not apt-get!)
USER root
RUN apk add --no-cache \
    bash \
    gettext

# Copy configuration template
COPY configs/alloy-config.template /etc/alloy/config.alloy.template

# Copy scripts
COPY scripts/entrypoint.sh /usr/local/bin/entrypoint.sh
RUN chmod +x /usr/local/bin/entrypoint.sh

# Create data directory
RUN mkdir -p /var/lib/alloy/data && chown -R alloy:alloy /var/lib/alloy

# Switch back to alloy user
USER alloy

# Expose metrics port
EXPOSE 12345

# Environment variables
ENV ALLOY_HTTP_LISTEN_ADDR="0.0.0.0:12345" \
    ALLOY_STORAGE_PATH="/var/lib/alloy/data" \
    HOSTNAME="unknown" \
    PROMETHEUS_URL="http://localhost:9090" \
    LOKI_URL="http://localhost:3100" \
    NODE_SCRAPE_INTERVAL="30s" \
    CADVISOR_SCRAPE_INTERVAL="60s" \
    SKIP_MONITORING_LOGS="true" \
    ALLOY_MODE="worker"

# NO HEALTHCHECK - Coolify will just check if container is running

# Use custom entrypoint
ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]
CMD ["run", "--server.http.listen-addr=${ALLOY_HTTP_LISTEN_ADDR}", "--storage.path=${ALLOY_STORAGE_PATH}", "/etc/alloy/config.alloy"]
