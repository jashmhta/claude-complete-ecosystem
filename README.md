# Claude Code Complete Ecosystem

🚀 **Enterprise-Grade Claude Code Ecosystem** - The most comprehensive development environment with 13 MCP Servers, 54+ Specialized Agents, SPARC Methodology, and complete automation tooling.

[![Repository Size](https://img.shields.io/github/repo-size/jashmhta/claude-complete-ecosystem)](https://github.com/jashmhta/claude-complete-ecosystem)
[![License](https://img.shields.io/badge/license-MIT-blue.svg)](LICENSE)
[![Node.js Version](https://img.shields.io/badge/node-%3E%3D18.0.0-brightgreen)](https://nodejs.org/)
[![GitHub Issues](https://github.com/jashmhta/claude-complete-ecosystem)](https://github.com/jashmhta/claude-complete-ecosystem/issues)
[![Docker](https://img.shields.io/badge/docker-%230db7ed.svg?style=flat&logo=docker&logoColor=white)](https://docs.docker.com/)

## 📋 Table of Contents

- [Overview](#overview)
- [🚀 Docker Quick Start](#-docker-quick-start)
- [MCP Servers (13 Total)](#mcp-servers-13-total)
- [Specialized Agents (54+ Total)](#specialized-agents-54-total)
- [SPARC Methodology](#sparc-methodology)
- [Installation Options](#installation-options)
- [System Requirements](#system-requirements)
- [Directory Structure](#directory-structure)
- [Configuration](#configuration)
- [Usage Examples](#usage-examples)
- [API Reference](#api-reference)
- [Troubleshooting](#troubleshooting)
- [Contributing](#contributing)
- [License](#license)

## 🎯 Overview

This repository contains the **complete Claude Code ecosystem** - a comprehensive development environment that combines:

- **13 MCP Servers** for various development tasks
- **54+ Specialized Agents** for specific domains
- **SPARC Methodology** for structured development
- **Enterprise-grade tooling** and automation
- **Complete documentation** and setup guides
- **Multi-platform support** (Linux/macOS/Windows)
- **🐳 Docker Support** - Containerized deployment

### Key Features

- 🔧 **Automated Deployment** - One-click setup scripts
- 📊 **Performance Monitoring** - Built-in analytics and reporting
- 🔒 **Security Hardening** - Enterprise security configurations
- 🌐 **Multi-platform Support** - Cross-platform compatibility
- 📈 **Scalable Architecture** - Enterprise-ready design
- 🎯 **SPARC Methodology** - Structured development approach
- 🐳 **Docker Ready** - Containerized deployment with orchestration

---

## 🚀 Docker Quick Start

### Prerequisites
- Docker Engine 20.10+
- Docker Compose 2.0+
- Anthropic API key

### One-Command Setup

```bash
# Clone and setup
git clone https://github.com/jashmhta/claude-complete-ecosystem.git
cd claude-complete-ecosystem

# Automated Docker setup
./setup-ecosystem.sh

# Configure API key
echo "ANTHROPIC_API_KEY=your_api_key_here" > .env

# Start ecosystem
docker-compose up claude-ecosystem
```

### Available Docker Commands

```bash
# Production mode
docker-compose up claude-ecosystem

# Development mode (with dev tools)
docker-compose --profile dev up claude-dev

# Minimal testing mode
docker-compose --profile minimal up claude-minimal

# Background mode
docker-compose up -d claude-ecosystem

# View logs
docker-compose logs -f claude-ecosystem

# Access container
docker-compose exec claude-ecosystem /bin/bash

# Stop ecosystem
docker-compose down
```

### Docker Images

| Image | Purpose | Size | Features |
|-------|---------|------|----------|
| `claude-code-ecosystem:latest` | Production | ~500MB | Full ecosystem, optimized |
| `claude-code-ecosystem:dev` | Development | ~800MB | Dev tools, debugging |
| `claude-code-ecosystem:minimal` | Testing | ~200MB | Minimal setup, fast |

📖 **Detailed Docker Guide:** [DOCKER_DEPLOYMENT.md](DOCKER_DEPLOYMENT.md)

---

## 🛠️ MCP Servers (13 Total)