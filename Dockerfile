# Claude Code Complete Ecosystem - Production Dockerfile
FROM node:18-alpine AS base

# Install system dependencies
RUN apk add --no-cache \
    bash \
    curl \
    git \
    python3 \
    py3-pip \
    jq \
    vim \
    nano \
    sudo \
    shadow \
    dos2unix \
    && rm -rf /var/lib/apt/lists/*

# Create a non-root user for security
RUN addgroup -g 1001 -S claude && \
    adduser -S claude -u 1001 -G claude

# Set working directory
WORKDIR /workspace

# Copy package files first for better caching
COPY package*.json ./

# Install Node.js dependencies (if package.json exists)
RUN if [ -f "package.json" ]; then npm ci --only=production && npm cache clean --force; fi

# Copy application files
COPY . .

# Make scripts executable
RUN chmod +x *.sh

# Create necessary directories and fix line endings
RUN mkdir -p /home/claude/.claude && \
    chown -R claude:claude /workspace /home/claude && \
    dos2unix *.sh 2>/dev/null || true

# Switch to non-root user
USER claude

# Expose ports
EXPOSE 3000-3100
EXPOSE 8000-8100

# Health check
HEALTHCHECK --interval=30s --timeout=10s --start-period=5s --retries=3 \
    CMD node --version || exit 1

# Default command
CMD ["./install-and-run-claude.sh"]

# ================================
# Development Stage (optional)
# ================================
FROM base AS development

# Install development dependencies
USER root
RUN if [ -f "package.json" ]; then npm install; fi && \
    pip3 install --no-cache-dir \
        pytest \
        black \
        flake8 \
        mypy

# Switch back to non-root user
USER claude

# Development command
CMD ["./install-and-run-claude.sh"]

# ================================
# Production Stage (default)
# ================================
FROM base AS production

# Production optimizations
ENV NODE_ENV=production
ENV PYTHONUNBUFFERED=1

# Clean up unnecessary files
USER root
RUN apk del --no-cache shadow dos2unix 2>/dev/null || true && \
    rm -rf /tmp/* /var/cache/apk/*

USER claude

# Production command
CMD ["./install-and-run-claude.sh"]