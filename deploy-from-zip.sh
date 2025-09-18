#!/bin/bash

# Claude Code Ecosystem - Complete Deployment Script
# This script deploys the entire Claude Code ecosystem from the zip file
# Run this script from within the extracted zip directory

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

# Check system requirements
check_requirements() {
    log_info "Checking system requirements..."

    # Check if Node.js is installed
    if ! command -v node &> /dev/null; then
        log_error "Node.js is not installed. Please install Node.js 18+ first."
        exit 1
    fi

    # Check Node.js version
    NODE_VERSION=$(node -v | sed 's/v//')
    if [[ $(echo "$NODE_VERSION 18" | awk '{print ($1 < $2)}') -eq 1 ]]; then
        log_error "Node.js version $NODE_VERSION is too old. Please upgrade to Node.js 18+."
        exit 1
    fi

    # Check if npm is installed
    if ! command -v npm &> /dev/null; then
        log_error "npm is not installed. Please install npm."
        exit 1
    fi

    # Check if git is installed
    if ! command -v git &> /dev/null; then
        log_error "Git is not installed. Please install git."
        exit 1
    fi

    log_success "System requirements check passed"
}

# Install MCP servers
install_mcp_servers() {
    log_info "Installing MCP servers..."

    # Create MCP servers directory if it doesn't exist
    mkdir -p ~/mcp-servers

    # Install claude-flow
    if [ ! -d "~/mcp-servers/claude-flow" ]; then
        log_info "Installing claude-flow..."
        npm install -g npx claude-flow@alpha
    fi

    # Install ruv-swarm
    if [ ! -d "~/mcp-servers/ruv-swarm" ]; then
        log_info "Installing ruv-swarm..."
        npm install -g npx ruv-swarm
    fi

    # Install flow-nexus
    if [ ! -d "~/mcp-servers/flow-nexus" ]; then
        log_info "Installing flow-nexus..."
        npm install -g npx flow-nexus@latest
    fi

    # Install additional MCP servers from the backup
    if [ -d "./mcp-servers" ]; then
        log_info "Installing additional MCP servers from backup..."
        cp -r ./mcp-servers/* ~/mcp-servers/ 2>/dev/null || true
    fi

    log_success "MCP servers installation completed"
}

# Setup Claude configuration
setup_claude_config() {
    log_info "Setting up Claude configuration..."

    # Create .claude directory if it doesn't exist
    mkdir -p ~/.claude

    # Copy configuration files
    if [ -f "./.claude.json" ]; then
        cp ./.claude.json ~/.claude/
        log_success "Claude configuration copied"
    fi

    # Copy MCP analysis files
    if [ -d "./mcp-analysis" ]; then
        cp -r ./mcp-analysis/* ~/.claude/ 2>/dev/null || true
        log_success "MCP analysis files copied"
    fi
}

# Setup scripts and executables
setup_scripts() {
    log_info "Setting up scripts and executables..."

    # Make all scripts executable
    find . -name "*.sh" -type f -exec chmod +x {} \;

    # Copy start scripts to ~/bin if it exists, otherwise to ~/.local/bin
    if [ -d "~/bin" ]; then
        SCRIPT_DIR="~/bin"
    else
        mkdir -p ~/.local/bin
        SCRIPT_DIR="~/.local/bin"
    fi

    # Copy start scripts
    for script in start-claude.sh start-mcp-*.sh; do
        if [ -f "$script" ]; then
            cp "$script" "$SCRIPT_DIR/"
            chmod +x "$SCRIPT_DIR/$script"
        fi
    done

    log_success "Scripts setup completed"
}

# Setup documentation
setup_documentation() {
    log_info "Setting up documentation..."

    # Create documentation directory
    mkdir -p ~/claude-docs

    # Copy all documentation files
    find . -name "*.md" -type f -exec cp {} ~/claude-docs/ \;

    log_success "Documentation setup completed"
}

# Create desktop shortcuts (optional)
create_shortcuts() {
    log_info "Creating desktop shortcuts..."

    # Create desktop directory if it doesn't exist
    mkdir -p ~/Desktop

    # Create Claude Code launcher
    cat > ~/Desktop/claude-code.desktop << EOF
[Desktop Entry]
Version=1.0
Type=Application
Name=Claude Code
Comment=Launch Claude Code with MCP servers
Exec=$HOME/.local/bin/start-claude.sh
Icon=terminal
Terminal=true
Categories=Development;
EOF

    chmod +x ~/Desktop/claude-code.desktop
    log_success "Desktop shortcuts created"
}

# Verify installation
verify_installation() {
    log_info "Verifying installation..."

    # Check if MCP servers are accessible
    if command -v claude-flow &> /dev/null; then
        log_success "claude-flow is accessible"
    else
        log_warning "claude-flow not found in PATH"
    fi

    # Check configuration files
    if [ -f ~/.claude/.claude.json ]; then
        log_success "Claude configuration file exists"
    else
        log_warning "Claude configuration file not found"
    fi

    # Check scripts
    if [ -x ~/.local/bin/start-claude.sh ]; then
        log_success "Start script is executable"
    else
        log_warning "Start script not found or not executable"
    fi

    log_success "Installation verification completed"
}

# Main deployment function
main() {
    echo "========================================"
    echo "  Claude Code Ecosystem Deployment"
    echo "========================================"
    echo ""

    check_root
    check_requirements
    install_mcp_servers
    setup_claude_config
    setup_scripts
    setup_documentation
    create_shortcuts
    verify_installation

    echo ""
    echo "========================================"
    log_success "Deployment completed successfully!"
    echo ""
    echo "Next steps:"
    echo "1. Restart your terminal or run: source ~/.bashrc"
    echo "2. Start Claude Code with: start-claude.sh"
    echo "3. Or use the desktop shortcut"
    echo ""
    echo "Documentation available at: ~/claude-docs/"
    echo "========================================"
}

# Run main function
main "$@"