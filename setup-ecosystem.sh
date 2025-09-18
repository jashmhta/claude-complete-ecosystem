#!/bin/bash

# Claude Code Complete Ecosystem Setup Script
# This script sets up the entire Claude Code ecosystem

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Function to print colored output
print_status() {
    echo -e "${BLUE}[INFO]${NC} $1"
}

print_success() {
    echo -e "${GREEN}[SUCCESS]${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

print_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

# Function to check if command exists
command_exists() {
    command -v "$1" >/dev/null 2>&1
}

# Function to detect OS
detect_os() {
    if [[ "$OSTYPE" == "linux-gnu"* ]]; then
        if command_exists apk; then
            echo "alpine"
        elif command_exists apt-get; then
            echo "ubuntu"
        elif command_exists yum; then
            echo "centos"
        else
            echo "linux"
        fi
    elif [[ "$OSTYPE" == "darwin"* ]]; then
        echo "macos"
    elif [[ "$OSTYPE" == "msys" ]] || [[ "$OSTYPE" == "win32" ]]; then
        echo "windows"
    else
        echo "unknown"
    fi
}

# Function to install Docker
install_docker() {
    print_status "Installing Docker..."

    OS=$(detect_os)

    case $OS in
        "ubuntu")
            # Ubuntu/Debian
            sudo apt-get update
            sudo apt-get install -y ca-certificates curl gnupg lsb-release
            sudo mkdir -p /etc/apt/keyrings
            curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg
            echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
            sudo apt-get update
            sudo apt-get install -y docker-ce docker-ce-cli containerd.io docker-compose-plugin
            ;;
        "centos")
            # CentOS/RHEL
            sudo yum install -y yum-utils
            sudo yum-config-manager --add-repo https://download.docker.com/linux/centos/docker-ce.repo
            sudo yum install -y docker-ce docker-ce-cli containerd.io docker-compose-plugin
            ;;
        "alpine")
            # Alpine (already handled in Dockerfile)
            print_warning "Docker installation in Alpine should be handled by Dockerfile"
            ;;
        "macos")
            print_error "Please install Docker Desktop for Mac manually from https://docs.docker.com/desktop/install/mac-install/"
            exit 1
            ;;
        *)
            print_error "Unsupported OS for automatic Docker installation. Please install Docker manually."
            exit 1
            ;;
    esac

    # Start Docker service
    if command_exists systemctl; then
        sudo systemctl start docker
        sudo systemctl enable docker
    elif command_exists service; then
        sudo service docker start
    fi

    print_success "Docker installed successfully"
}

# Function to setup Docker user permissions
setup_docker_permissions() {
    if [ "$EUID" -ne 0 ] && ! groups | grep -q docker; then
        print_status "Setting up Docker user permissions..."
        sudo usermod -aG docker $USER
        print_warning "Please log out and log back in for Docker permissions to take effect"
        print_warning "Alternatively, run: 'sudo chmod 666 /var/run/docker.sock'"
    fi
}

# Function to build Docker images
build_docker_images() {
    print_status "Building Docker images..."

    # Build production image
    docker build -t claude-code-ecosystem:latest .

    # Build development image
    docker build --target development -t claude-code-ecosystem:dev .

    # Build minimal image
    if [ -f "Dockerfile.minimal" ]; then
        docker build -f Dockerfile.minimal -t claude-code-ecosystem:minimal .
    fi

    print_success "Docker images built successfully"
}

# Function to create environment file
create_env_file() {
    if [ ! -f ".env" ]; then
        print_status "Creating environment configuration file..."

        cat > .env << EOF
# Claude Code Ecosystem Environment Configuration

# Anthropic API Key (required)
# Get your API key from: https://console.anthropic.com/
ANTHROPIC_API_KEY=your_api_key_here

# Node.js Environment
NODE_ENV=development

# Python Environment
PYTHONPATH=/workspace

# Claude Configuration
CLAUDE_WORKSPACE=/workspace

# Docker Configuration
COMPOSE_PROJECT_NAME=claude-ecosystem

# Development Settings
CLAUDE_HEADLESS=false
ALLOW_ROOT=false

# Port Configuration
CLAUDE_PORT_START=3000
CLAUDE_PORT_END=3100
MCP_PORT_START=8000
MCP_PORT_END=8100
EOF

        print_success "Environment file created: .env"
        print_warning "Please edit .env and set your ANTHROPIC_API_KEY"
    else
        print_status "Environment file already exists"
    fi
}

# Function to setup Claude configuration
setup_claude_config() {
    print_status "Setting up Claude configuration..."

    # Create Claude config directory
    mkdir -p ~/.claude

    # Copy configuration if it exists
    if [ -f ".claude.json" ]; then
        cp .claude.json ~/.claude/config.json
        print_success "Claude configuration copied"
    fi
}

# Function to show usage
show_usage() {
    echo "Claude Code Complete Ecosystem Setup Script"
    echo ""
    echo "Usage: $0 [OPTIONS]"
    echo ""
    echo "Options:"
    echo "  --docker-only     Only setup Docker components"
    echo "  --build-only      Only build Docker images"
    echo "  --env-only        Only create environment file"
    echo "  --help           Show this help message"
    echo ""
    echo "Examples:"
    echo "  $0                 # Complete setup"
    echo "  $0 --docker-only  # Docker setup only"
    echo "  $0 --build-only   # Build images only"
    echo ""
    echo "Prerequisites:"
    echo "  - Linux/macOS/Windows with Docker support"
    echo "  - Anthropic API key (https://console.anthropic.com/)"
    echo ""
}

# Parse command line arguments
DOCKER_ONLY=false
BUILD_ONLY=false
ENV_ONLY=false

while [[ $# -gt 0 ]]; do
    case $1 in
        --docker-only)
            DOCKER_ONLY=true
            shift
            ;;
        --build-only)
            BUILD_ONLY=true
            shift
            ;;
        --env-only)
            ENV_ONLY=true
            shift
            ;;
        --help)
            show_usage
            exit 0
            ;;
        *)
            print_error "Unknown option: $1"
            show_usage
            exit 1
            ;;
    esac
done

# Main execution
main() {
    print_status "Starting Claude Code Ecosystem Setup"
    echo "=========================================="

    # Detect OS
    OS=$(detect_os)
    print_status "Detected OS: $OS"

    # Check if running in Docker
    if [ -f "/.dockerenv" ]; then
        print_status "Running inside Docker container"
        DOCKER_SETUP=false
    else
        DOCKER_SETUP=true
    fi

    # Environment file only
    if [ "$ENV_ONLY" = true ]; then
        create_env_file
        exit 0
    fi

    # Docker setup
    if [ "$DOCKER_SETUP" = true ]; then
        # Check if Docker is installed
        if ! command_exists docker; then
            print_warning "Docker not found. Installing Docker..."
            install_docker
        else
            print_success "Docker is already installed"
        fi

        # Setup Docker permissions
        setup_docker_permissions

        # Build images
        if [ "$BUILD_ONLY" = true ] || [ "$DOCKER_ONLY" = true ]; then
            build_docker_images
            if [ "$BUILD_ONLY" = true ]; then
                exit 0
            fi
        fi
    fi

    # Docker-only mode
    if [ "$DOCKER_ONLY" = true ]; then
        print_success "Docker setup completed!"
        echo ""
        echo "To start the ecosystem:"
        echo "  docker-compose up claude-ecosystem"
        echo ""
        echo "To start development version:"
        echo "  docker-compose --profile dev up claude-dev"
        echo ""
        echo "To start minimal version:"
        echo "  docker-compose --profile minimal up claude-minimal"
        exit 0
    fi

    # Create environment file
    create_env_file

    # Setup Claude configuration
    setup_claude_config

    # Build Docker images if not already done
    if [ "$DOCKER_SETUP" = true ] && [ "$BUILD_ONLY" = false ]; then
        build_docker_images
    fi

    print_success "Claude Code Ecosystem setup completed!"
    echo ""
    echo "Next steps:"
    echo "1. Edit .env file and set your ANTHROPIC_API_KEY"
    echo "2. Start the ecosystem:"
    echo "   docker-compose up claude-ecosystem"
    echo "3. Or run the installation script:"
    echo "   docker-compose run --rm claude-ecosystem ./install-and-run-claude.sh"
    echo ""
    echo "For development:"
    echo "   docker-compose --profile dev up claude-dev"
    echo ""
    echo "For testing:"
    echo "   docker-compose --profile minimal up claude-minimal"
}

# Run main function
main "$@"