# Grafana Alloy Agent

Production-ready Grafana Alloy Docker image with built-in health checks and flexible configuration via environment variables.

## Features

✅ Single universal image for all deployment scenarios  
✅ Built-in health checks  
✅ Fully configurable via environment variables  
✅ Node Exporter + cAdvisor + Docker logs  
✅ Resource optimized  
✅ Multi-arch support (amd64/arm64)  

## Quick Start

### Worker VM (Forward to Remote Prometheus/Loki)
```yaml
version: '3.8'
services:
  alloy:
    image: ghcr.io/keleshteri/grafana-alloy-agent:latest
    container_name: alloy-agent
    volumes:
      - '/var/run/docker.sock:/var/run/docker.sock:ro'
      - '/var/log:/var/log:ro'
      - '/proc:/host/proc:ro'
      - '/sys:/host/sys:ro'
    environment:
      - HOSTNAME=my-server-name
      - PROMETHEUS_URL=http://0.0.0.0:9090
      - LOKI_URL=http://0.0.0.0:3100
      - ALLOY_MODE=worker
    restart: unless-stopped
    network_mode: host
    mem_limit: 384m
    cpus: 0.3
```

### Management Server (Local Prometheus/Loki)
```yaml
version: '3.8'
services:
  alloy:
    image: ghcr.io/keleshteri/grafana-alloy-agent:latest
    container_name: alloy-management
    volumes:
      - '/var/run/docker.sock:/var/run/docker.sock:ro'
      - '/var/log:/var/log:ro'
      - '/proc:/host/proc:ro'
      - '/sys:/host/sys:ro'
    environment:
      - HOSTNAME=management-server
      - PROMETHEUS_URL=http://localhost:9090
      - LOKI_URL=http://localhost:3100
      - ALLOY_MODE=management
    restart: unless-stopped
    network_mode: host
    mem_limit: 384m
    cpus: 0.3
```

## Environment Variables

| Variable | Default | Description |
|----------|---------|-------------|
| `HOSTNAME` | `unknown` | Server hostname for labeling |
| `PROMETHEUS_URL` | `http://localhost:9090` | Prometheus endpoint |
| `LOKI_URL` | `http://localhost:3100` | Loki endpoint |
| `ALLOY_MODE` | `worker` | Deployment mode (worker/management) |
| `NODE_SCRAPE_INTERVAL` | `30s` | Node Exporter scrape interval |
| `CADVISOR_SCRAPE_INTERVAL` | `60s` | cAdvisor scrape interval |
| `SKIP_MONITORING_LOGS` | `true` | Skip Prometheus/Grafana/Loki logs |
| `ALLOY_HTTP_LISTEN_ADDR` | `0.0.0.0:12345` | HTTP listen address |
| `ALLOY_STORAGE_PATH` | `/var/lib/alloy/data` | Storage path |

## Advanced Configuration

### With Authentication
```yaml
environment:
  - PROMETHEUS_USERNAME=myuser
  - PROMETHEUS_PASSWORD=mypass
  - LOKI_USERNAME=myuser
  - LOKI_PASSWORD=mypass
```

### Custom Scrape Intervals
```yaml
environment:
  - NODE_SCRAPE_INTERVAL=15s
  - CADVISOR_SCRAPE_INTERVAL=30s
```

### Include Monitoring Stack Logs
```yaml
environment:
  - SKIP_MONITORING_LOGS=false
```

## Building Locally
```bash
docker build -t grafana-alloy-agent:local .
```

## Health Check

Built-in health check runs every 30 seconds:
- Checks `/metrics` endpoint
- 3 retries before marking unhealthy
- 40s start period for initial setup

## Resource Usage

Expected resource consumption:
- Memory: ~200-300MB
- CPU: ~10-20% of 1 core
- Network: ~50KB/s

## License

MIT

## Contributing

Pull requests welcome!