# Docker Deployment Guide

## Claude Code Complete Ecosystem - Docker Deployment

This guide provides comprehensive instructions for deploying the Claude Code Complete Ecosystem using Docker and Docker Compose.

## 🚀 Quick Start

### Prerequisites

- Docker Engine 20.10+
- Docker Compose 2.0+
- 4GB RAM minimum
- Anthropic API key

### One-Command Setup

```bash
# Clone the repository
git clone https://github.com/jashmhta/claude-complete-ecosystem.git
cd claude-complete-ecosystem

# Run the automated setup
./setup-ecosystem.sh

# Edit environment file with your API key
nano .env

# Start the ecosystem
docker-compose up claude-ecosystem
```

## 📋 Detailed Setup

### Step 1: Clone Repository

```bash
git clone https://github.com/jashmhta/claude-complete-ecosystem.git
cd claude-complete-ecosystem
```

### Step 2: Automated Setup

```bash
# Run the complete setup script
./setup-ecosystem.sh
```

This script will:
- ✅ Install Docker (if not present)
- ✅ Configure Docker permissions
- ✅ Build Docker images
- ✅ Create environment configuration
- ✅ Setup Claude configuration

### Step 3: Configure Environment

Edit the `.env` file with your Anthropic API key:

```bash
nano .env
```

Set your API key:
```env
ANTHROPIC_API_KEY=sk-ant-api03-...
```

### Step 4: Start the Ecosystem

```bash
# Start production version
docker-compose up claude-ecosystem

# Start development version (with additional tools)
docker-compose --profile dev up claude-dev

# Start minimal version (for testing)
docker-compose --profile minimal up claude-minimal
```

## 🐳 Docker Images

### Available Images

| Image | Purpose | Size | Features |
|-------|---------|------|----------|
| `claude-code-ecosystem:latest` | Production | ~500MB | Full ecosystem, optimized |
| `claude-code-ecosystem:dev` | Development | ~800MB | Dev tools, debugging |
| `claude-code-ecosystem:minimal` | Testing | ~200MB | Minimal setup, fast |

### Image Architecture

```
claude-code-ecosystem:latest (Production)
├── Base Layer: Node.js 18 Alpine
├── System Dependencies: Python, Git, Bash
├── Claude Code Installation
├── MCP Servers Setup
├── Security Hardening (non-root user)
└── Health Checks

claude-code-ecosystem:dev (Development)
├── Production Image
├── Development Tools: pytest, black, flake8
├── Debug Tools: vim, nano
└── Extended Dependencies

claude-code-ecosystem:minimal (Testing)
├── Alpine Linux Base
├── Basic Tools Only
├── No Claude Installation
└── Fast Startup
```

## ⚙️ Configuration

### Environment Variables

| Variable | Description | Default | Required |
|----------|-------------|---------|----------|
| `ANTHROPIC_API_KEY` | Your Anthropic API key | - | Yes |
| `NODE_ENV` | Node.js environment | production | No |
| `CLAUDE_WORKSPACE` | Workspace directory | /workspace | No |
| `CLAUDE_HEADLESS` | Run in headless mode | false | No |
| `ALLOW_ROOT` | Allow root user | false | No |

### Docker Compose Configuration

```yaml
version: '3.8'

services:
  claude-ecosystem:
    build:
      context: .
      target: production  # or development
    environment:
      - ANTHROPIC_API_KEY=${ANTHROPIC_API_KEY}
    ports:
      - "3000-3100:3000-3100"  # Claude ports
      - "8000-8100:8000-8100"  # MCP ports
    volumes:
      - .:/workspace          # Mount workspace
      - claude-cache:/home/claude/.cache
```

## 🚀 Usage

### Starting the Ecosystem

```bash
# Production mode
docker-compose up claude-ecosystem

# Development mode
docker-compose --profile dev up claude-dev

# Background mode
docker-compose up -d claude-ecosystem
```

### Accessing the Container

```bash
# Interactive shell
docker-compose exec claude-ecosystem /bin/bash

# Run specific command
docker-compose exec claude-ecosystem ./verify-claude-setup.sh

# View logs
docker-compose logs claude-ecosystem
```

### Stopping the Ecosystem

```bash
# Stop containers
docker-compose down

# Stop and remove volumes
docker-compose down -v

# Stop specific service
docker-compose stop claude-ecosystem
```

## 🔧 Advanced Configuration

### Custom Dockerfile

Create a custom Dockerfile for specific requirements:

```dockerfile
FROM claude-code-ecosystem:latest

# Add custom dependencies
RUN apk add --no-cache custom-package

# Add custom configuration
COPY custom-config.json /home/claude/.claude/

# Custom startup script
COPY custom-startup.sh /workspace/
RUN chmod +x /workspace/custom-startup.sh

CMD ["/workspace/custom-startup.sh"]
```

### Volume Mounts

```yaml
volumes:
  - ./my-workspace:/workspace
  - ./claude-config:/home/claude/.claude
  - ./node-cache:/home/claude/.npm
  - /var/run/docker.sock:/var/run/docker.sock
```

### Network Configuration

```yaml
networks:
  claude-network:
    driver: bridge
    ipam:
      config:
        - subnet: 172.20.0.0/16
```

## 🐛 Troubleshooting

### Common Issues

#### Permission Denied
```bash
# Fix Docker socket permissions
sudo chmod 666 /var/run/docker.sock

# Or add user to docker group
sudo usermod -aG docker $USER
```

#### API Key Issues
```bash
# Check API key in environment
docker-compose exec claude-ecosystem env | grep ANTHROPIC

# Verify API key format
echo $ANTHROPIC_API_KEY | head -c 20
```

#### Port Conflicts
```bash
# Check port usage
netstat -tlnp | grep :3000

# Change ports in docker-compose.yml
ports:
  - "3001:3000"
  - "8001:8000"
```

#### Build Failures
```bash
# Clean build cache
docker system prune -a

# Rebuild without cache
docker-compose build --no-cache
```

### Logs and Debugging

```bash
# View container logs
docker-compose logs claude-ecosystem

# Follow logs in real-time
docker-compose logs -f claude-ecosystem

# View specific service logs
docker-compose logs claude-ecosystem | grep ERROR

# Debug container
docker-compose exec claude-ecosystem /bin/bash
```

## 📊 Monitoring

### Health Checks

The containers include built-in health checks:

```bash
# Check container health
docker-compose ps

# View health status
docker inspect claude-ecosystem | grep -A 5 "Health"
```

### Resource Usage

```bash
# View resource usage
docker stats

# Specific container stats
docker stats claude-ecosystem
```

## 🔒 Security

### Best Practices

- ✅ Run as non-root user
- ✅ Use environment variables for secrets
- ✅ Mount volumes with appropriate permissions
- ✅ Keep images updated
- ✅ Use specific image tags

### Security Scanning

```bash
# Scan image for vulnerabilities
docker scan claude-code-ecosystem:latest

# Use security-focused base images
FROM node:18-alpine AS secure-base
```

## 📚 Additional Resources

### Official Documentation
- [Docker Documentation](https://docs.docker.com/)
- [Docker Compose Documentation](https://docs.docker.com/compose/)
- [Claude Code Documentation](https://docs.anthropic.com/claude/docs/)

### Community Resources
- [Docker Best Practices](https://docs.docker.com/develop/dev-best-practices/)
- [Claude Code GitHub](https://github.com/anthropic/claude-code)

## 🤝 Contributing

### Development Setup

```bash
# Clone repository
git clone https://github.com/jashmhta/claude-complete-ecosystem.git
cd claude-complete-ecosystem

# Start development environment
docker-compose --profile dev up claude-dev

# Make changes and test
docker-compose exec claude-dev ./verify-claude-setup.sh

# Build and test changes
docker-compose build claude-dev
```

### Testing Changes

```bash
# Run tests in container
docker-compose exec claude-dev npm test

# Lint code
docker-compose exec claude-dev npm run lint

# Format code
docker-compose exec claude-dev npm run format
```

## 📞 Support

### Getting Help

1. Check the [troubleshooting section](#-troubleshooting)
2. Review [Docker logs](#logs-and-debugging)
3. Check [GitHub Issues](https://github.com/jashmhta/claude-complete-ecosystem/issues)
4. Review [Claude Code documentation](https://docs.anthropic.com/claude/docs/)

### Reporting Issues

When reporting issues, please include:

```bash
# System information
docker --version
docker-compose --version
uname -a

# Container logs
docker-compose logs claude-ecosystem

# Environment info
docker-compose exec claude-ecosystem env
```

---

## 🎯 Quick Reference

```bash
# Start ecosystem
docker-compose up claude-ecosystem

# View logs
docker-compose logs -f

# Access container
docker-compose exec claude-ecosystem /bin/bash

# Stop ecosystem
docker-compose down

# Clean restart
docker-compose down -v && docker-compose up --build
```

**Happy coding with Claude Code! 🚀**