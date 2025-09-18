#!/bin/bash

# Claude Code Complete Ecosystem - Install and Run Script
# This script installs Claude Code and sets up the complete ecosystem

set -e

echo "🚀 Claude Code Complete Ecosystem - Installation & Setup"
echo "======================================================"

# Function to check if command exists
command_exists() {
    command -v "$1" >/dev/null 2>&1
}

# Function to install Node.js if not present
install_nodejs() {
    echo "📦 Installing Node.js..."
    if command_exists apt-get; then
        # Ubuntu/Debian
        curl -fsSL https://deb.nodesource.com/setup_18.x | bash -
        apt-get install -y nodejs
    elif command_exists yum; then
        # CentOS/RHEL
        curl -fsSL https://rpm.nodesource.com/setup_18.x | bash -
        yum install -y nodejs
    elif command_exists apk; then
        # Alpine
        apk add --no-cache nodejs npm
    else
        echo "❌ Unsupported package manager. Please install Node.js 18+ manually."
        exit 1
    fi
}

# Function to install Claude Code
install_claude_code() {
    echo "🤖 Installing Claude Code..."

    # Check if npm is available
    if ! command_exists npm; then
        echo "❌ npm not found. Installing Node.js first..."
        install_nodejs
    fi

    # Check if we're running as root or have sudo
    if [ "$EUID" -eq 0 ]; then
        # Running as root
        npm install -g @anthropic-ai/claude-code
    elif command_exists sudo; then
        # Try with sudo
        sudo npm install -g @anthropic-ai/claude-code
    else
        # Try without sudo (may fail)
        echo "⚠️ Not running as root and sudo not available. Attempting installation..."
        npm install -g @anthropic-ai/claude-code || {
            echo "❌ Installation failed. Please run as root or with sudo."
            exit 1
        }
    fi

    # Verify installation
    if command_exists claude; then
        echo "✅ Claude Code installed successfully!"
        claude --version
    else
        echo "❌ Claude Code installation failed"
        exit 1
    fi
}

# Function to setup Claude configuration
setup_claude_config() {
    echo "⚙️ Setting up Claude configuration..."

    # Create Claude config directory if it doesn't exist
    mkdir -p ~/.claude

    # Copy configuration files if they exist
    if [ -f ".claude.json" ]; then
        cp .claude.json ~/.claude/config.json
        echo "✅ Claude configuration copied"
    fi

    # Set Claude API key if provided
    if [ -n "$CLAUDE_API_KEY" ]; then
        export ANTHROPIC_API_KEY="$CLAUDE_API_KEY"
        echo "✅ Claude API key configured"
    elif [ -n "$ANTHROPIC_API_KEY" ]; then
        echo "✅ Using existing Anthropic API key"
    else
        echo "⚠️ No Claude API key found. Please set ANTHROPIC_API_KEY environment variable"
        echo "   You can get an API key from: https://console.anthropic.com/"
    fi
}

# Function to install MCP servers
install_mcp_servers() {
    echo "🔧 Installing MCP servers..."

    # Install MCP servers from package.json if it exists
    if [ -f "package.json" ]; then
        echo "📦 Installing MCP server dependencies..."
        npm install

        # Check if specific MCP servers are available
        if command_exists npx; then
            echo "🔍 Checking available MCP servers..."

            # List of common MCP servers to check
            mcp_servers=(
                "@modelcontextprotocol/server-filesystem"
                "@modelcontextprotocol/server-git"
                "@modelcontextprotocol/server-everything"
                "@anthropic-ai/mcp-server-browser"
            )

            for server in "${mcp_servers[@]}"; do
                if npm list -g "$server" >/dev/null 2>&1 || npm list "$server" >/dev/null 2>&1; then
                    echo "✅ $server is available"
                else
                    echo "⚠️ $server not found (may need separate installation)"
                fi
            done
        fi
    else
        echo "⚠️ No package.json found. Skipping MCP server installation."
    fi
}

# Function to start Claude Code
start_claude() {
    echo "🎯 Starting Claude Code..."

    # Set environment variables
    export CLAUDE_WORKSPACE="$(pwd)"
    export NODE_ENV="${NODE_ENV:-development}"

    # Check if we're in a Docker environment
    if [ -f "/.dockerenv" ] || [ -n "$DOCKER_CONTAINER" ]; then
        echo "🐳 Running in Docker environment"

        # In Docker, we might want to run in headless mode or with specific flags
        if [ -n "$CLAUDE_HEADLESS" ]; then
            echo "🔇 Running in headless mode..."
            # Headless mode would require additional setup
        fi
    fi

    # Start Claude Code with the current directory as workspace
    echo "📂 Workspace: $(pwd)"
    echo "🚀 Starting Claude Code..."
    echo ""
    echo "Available commands:"
    echo "  /help     - Show help"
    echo "  /exit     - Exit Claude Code"
    echo "  /config   - Show configuration"
    echo ""
    echo "Press Ctrl+C to exit"
    echo ""

    # Start Claude Code
    exec claude
}

# Function to show usage
show_usage() {
    echo "Claude Code Complete Ecosystem Setup Script"
    echo ""
    echo "Usage: $0 [OPTIONS]"
    echo ""
    echo "Options:"
    echo "  --install-only    Only install Claude Code, don't start it"
    echo "  --skip-mcp        Skip MCP server installation"
    echo "  --help           Show this help message"
    echo ""
    echo "Environment Variables:"
    echo "  ANTHROPIC_API_KEY    Your Anthropic API key"
    echo "  CLAUDE_API_KEY       Alternative API key variable"
    echo "  NODE_ENV            Node.js environment (default: development)"
    echo "  CLAUDE_HEADLESS     Run in headless mode (Docker only)"
    echo ""
    echo "Examples:"
    echo "  $0                          # Install and start Claude Code"
    echo "  $0 --install-only          # Only install, don't start"
    echo "  ANTHROPIC_API_KEY=sk-... $0  # Install with API key"
}

# Parse command line arguments
INSTALL_ONLY=false
SKIP_MCP=false

while [[ $# -gt 0 ]]; do
    case $1 in
        --install-only)
            INSTALL_ONLY=true
            shift
            ;;
        --skip-mcp)
            SKIP_MCP=true
            shift
            ;;
        --help)
            show_usage
            exit 0
            ;;
        *)
            echo "❌ Unknown option: $1"
            show_usage
            exit 1
            ;;
    esac
done

# Main execution
main() {
    echo "🔍 Checking system requirements..."

    # Check if we're running as root (not recommended for Claude Code)
    if [ "$EUID" -eq 0 ] && [ -z "$ALLOW_ROOT" ]; then
        echo "⚠️ Running as root is not recommended for Claude Code."
        echo "   Set ALLOW_ROOT=1 to override this warning."
        echo ""
    fi

    # Check Node.js version
    if command_exists node; then
        NODE_VERSION=$(node --version | sed 's/v//' | cut -d. -f1)
        if [ "$NODE_VERSION" -lt 18 ]; then
            echo "⚠️ Node.js version $NODE_VERSION detected. Claude Code requires Node.js 18+"
            echo "   Installing newer version..."
            install_nodejs
        else
            echo "✅ Node.js $(node --version) detected"
        fi
    else
        echo "❌ Node.js not found"
        install_nodejs
    fi

    # Install Claude Code
    if ! command_exists claude; then
        install_claude_code
    else
        echo "✅ Claude Code already installed"
        claude --version
    fi

    # Setup configuration
    setup_claude_config

    # Install MCP servers (unless skipped)
    if [ "$SKIP_MCP" = false ]; then
        install_mcp_servers
    else
        echo "⏭️ Skipping MCP server installation"
    fi

    # Start Claude Code (unless install-only mode)
    if [ "$INSTALL_ONLY" = false ]; then
        start_claude
    else
        echo "✅ Installation complete! Run '$0' to start Claude Code"
        echo ""
        echo "To start Claude Code manually:"
        echo "  claude"
        echo ""
        echo "To start with this workspace:"
        echo "  cd $(pwd) && claude"
    fi
}

# Run main function
main "$@"