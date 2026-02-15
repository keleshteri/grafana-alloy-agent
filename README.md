# Grafana Alloy Agent

Production-ready Grafana Alloy Docker image with built-in health checks and flexible configuration via environment variables.

## Features

✅ Single universal image for all deployment scenarios  
✅ Built-in health checks  
✅ Fully configurable via environment variables  
✅ Node Exporter + cAdvisor + Docker logs  
✅ Resource optimized  
✅ Multi-arch support (amd64/arm64)  
✅ Automatic semantic versioning

## Available Tags

- `latest` - Latest stable build from main branch
- `v1.0.0`, `v1.0.1`, etc. - Semantic versioned releases (auto-generated on each push)
- `main` - Latest build from main branch
- `main-<sha>` - Specific commit from main branch

**Registries:**
- GitHub Container Registry: `ghcr.io/keleshteri/grafana-alloy-agent:<tag>`
- Docker Hub: `keleshteri/grafana-alloy-agent:<tag>`  

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

## Versioning

This project uses automatic semantic versioning. Every push to the `main` branch automatically:
1. **First push**: Creates `v1.0.0` automatically as the starting version
2. **Subsequent pushes**: Calculates the next version (e.g., v1.0.1, v1.0.2)
3. Creates a git tag
4. Builds and pushes Docker images with that version tag

**No manual setup needed!** Just push your changes and versioning happens automatically.

### Version Bumping (Commit Messages)

- **Patch bump** (v1.0.0 → v1.0.1): Normal commits
- **Minor bump** (v1.0.0 → v1.1.0): Include `(MINOR)` in commit message
  ```bash
  git commit -m "feat: Add new feature (MINOR)"
  ```
- **Major bump** (v1.0.0 → v2.0.0): Include `(MAJOR)` in commit message
  ```bash
  git commit -m "breaking: Major changes (MAJOR)"
  ```

### Using Specific Versions

```yaml
# Use latest stable
image: ghcr.io/keleshteri/grafana-alloy-agent:latest

# Pin to specific version (recommended for production)
image: ghcr.io/keleshteri/grafana-alloy-agent:v1.0.0

# Use latest from main branch
image: ghcr.io/keleshteri/grafana-alloy-agent:main
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