# Versioning Guide

This repository uses **automatic semantic versioning** for Docker images. Every push to the `main` branch automatically generates a new version.

## Initial Setup

On your **first push to main**, the workflow will automatically create `v1.0.0` as the starting version. From there, all subsequent commits will increment the version automatically.

**You don't need to do anything manually!** Just push your code and the versioning happens automatically.

## How It Works

1. **Automatic Version Generation**: The GitHub Actions workflow calculates the next version based on your commits
2. **Git Tag Creation**: A new git tag is automatically created (e.g., v1.0.0, v1.0.1)
3. **Docker Build**: Images are built and pushed with multiple tags
4. **Multiple Registries**: Published to both GitHub Container Registry and Docker Hub

## Version Numbering

Semantic versioning follows the format: `vMAJOR.MINOR.PATCH`

### Default Behavior (Patch Bump)
Every commit increments the patch version by default:
- v1.0.0 → v1.0.1 → v1.0.2

Example:
```bash
git commit -m "fix: Fixed a bug"
git push origin main
# Creates: v1.0.1
```

### Minor Version Bump
Include `(MINOR)` in your commit message for new features:
```bash
git commit -m "feat: Add new monitoring feature (MINOR)"
git push origin main
# v1.0.5 → v1.1.0
```

### Major Version Bump
Include `(MAJOR)` in your commit message for breaking changes:
```bash
git commit -m "breaking: Changed API structure (MAJOR)"
git push origin main
# v1.5.0 → v2.0.0
```

## Available Tags After Each Push

When you push to `main`, multiple tags are created:

| Tag | Description | Example |
|-----|-------------|---------|
| `vX.Y.Z` | Exact version | `v1.0.5` |
| `X.Y.Z` | Version without v | `1.0.5` |
| `latest` | Latest stable | `latest` |
| `main` | Main branch latest | `main` |
| `main-<sha>` | Commit-specific | `main-abc1234` |

## Using Versions in Production

### Recommended: Pin to Specific Version
```yaml
image: ghcr.io/keleshteri/grafana-alloy-agent:v1.0.0
```

### Auto-update to Latest
```yaml
image: ghcr.io/keleshteri/grafana-alloy-agent:latest
```

### Development/Testing
```yaml
image: ghcr.io/keleshteri/grafana-alloy-agent:main
```

## Checking Available Versions

### GitHub Container Registry
```bash
# List all tags
docker pull ghcr.io/keleshteri/grafana-alloy-agent:v1.0.0
```

### Git Tags
```bash
# List all version tags
git tag -l "v*"

# Show latest tag
git describe --tags --abbrev=0
```

## Starting Fresh

The initial version is `v1.0.0` (defined in the VERSION file). The system automatically increments from there.

## Example Workflow

```bash
# Make a fix
git add .
git commit -m "fix: Corrected health check endpoint"
git push origin main
# → Creates v1.0.1

# Add a feature
git add .
git commit -m "feat: Added custom metrics support (MINOR)"
git push origin main
# → Creates v1.1.0

# Breaking change
git add .
git commit -m "breaking: Changed config file format (MAJOR)"
git push origin main
# → Creates v2.0.0
```

## Troubleshooting

### Version Not Incrementing
- Ensure your push is to the `main` branch
- Check GitHub Actions logs for any errors
- The workflow needs `contents: write` permission

### Tag Already Exists
The workflow will skip creating duplicate tags gracefully.

### Manual Tag Creation
You can still create manual tags:
```bash
git tag -a v1.5.0 -m "Manual release v1.5.0"
git push origin v1.5.0
```
This will trigger a build with the manual version.
