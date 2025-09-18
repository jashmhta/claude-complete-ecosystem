#!/bin/bash

# Claude Code Ecosystem - Download and Setup Script
# This script downloads the complete ecosystem from GitHub and sets it up

set -e  # Exit on any error

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Logging functions
log_info() {
    echo -e "${BLUE}[INFO]${NC} $1"
}

log_success() {
    echo -e "${GREEN}[SUCCESS]${NC} $1"
}

log_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

log_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

# Check if running as root
check_root() {
    if [[ $EUID -eq 0 ]]; then
        log_error "This script should not be run as root. Please run as a regular user."
        exit 1
    fi
}

# Download the repository
download_repository() {
    log_info "Downloading Claude Code Ecosystem from GitHub..."

    if command -v git &> /dev/null; then
        log_info "Using git clone for faster download..."
        git clone https://github.com/jashmhta/claude-complete-ecosystem.git claude-ecosystem-setup
        cd claude-ecosystem-setup
    else
        log_info "Git not found, using wget to download zip archive..."
        wget -O ecosystem.zip https://github.com/jashmhta/claude-complete-ecosystem/archive/refs/heads/master.zip
        unzip ecosystem.zip
        mv claude-complete-ecosystem-master claude-ecosystem-setup
        cd claude-ecosystem-setup
    fi

    log_success "Repository downloaded successfully"
}

# Make scripts executable and run deployment
setup_and_deploy() {
    log_info "Setting up and deploying the ecosystem..."

    # Make all scripts executable
    find . -name "*.sh" -type f -exec chmod +x {} \;

    # Run the deployment script
    if [ -f "./deploy-from-zip.sh" ]; then
        log_info "Running automated deployment..."
        ./deploy-from-zip.sh
    else
        log_error "Deployment script not found!"
        exit 1
    fi
}

# Main function
main() {
    echo "========================================"
    echo "  Claude Code Ecosystem Download & Setup"
    echo "========================================"
    echo ""

    check_root
    download_repository
    setup_and_deploy

    echo ""
    echo "========================================"
    log_success "Setup completed successfully!"
    echo ""
    echo "The Claude Code Ecosystem is now ready!"
    echo ""
    echo "Next steps:"
    echo "1. Start MCP servers: ./start-mcp-background.sh"
    echo "2. Launch Claude Code: ./start-claude.sh"
    echo "3. View documentation: cat README.md"
    echo ""
    echo "Repository: https://github.com/jashmhta/claude-complete-ecosystem"
    echo "========================================"
}

# Run main function
main "$@"