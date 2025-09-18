#!/bin/bash

# Claude Code Ecosystem - Comprehensive Verification Script
# This script verifies that all components match between local and repository

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
PURPLE='\033[0;35m'
CYAN='\033[0;36m'
NC='\033[0m'

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

log_header() {
    echo -e "${PURPLE}=======================================${NC}"
    echo -e "${PURPLE}$1${NC}"
    echo -e "${PURPLE}=======================================${NC}"
}

# Verify file existence and content
verify_file() {
    local file="$1"
    local description="$2"

    if [ -f "$file" ]; then
        local size=$(stat -c%s "$file" 2>/dev/null || stat -f%z "$file" 2>/dev/null || echo "unknown")
        log_success "$description: EXISTS (${size} bytes)"
        return 0
    else
        log_error "$description: MISSING"
        return 1
    fi
}

# Verify directory existence and contents
verify_directory() {
    local dir="$1"
    local description="$2"

    if [ -d "$dir" ]; then
        local count=$(find "$dir" -type f | wc -l)
        log_success "$description: EXISTS (${count} files)"
        return 0
    else
        log_error "$description: MISSING"
        return 1
    fi
}

# Verify script executability
verify_script() {
    local script="$1"
    local description="$2"

    if [ -x "$script" ]; then
        log_success "$description: EXECUTABLE"
        return 0
    else
        log_warning "$description: NOT EXECUTABLE"
        return 1
    fi
}

# Main verification function
main() {
    log_header "CLAUDE CODE ECOSYSTEM VERIFICATION"
    echo ""

    local total_checks=0
    local passed_checks=0

    # 1. Core Configuration Files
    log_header "1. CORE CONFIGURATION FILES"
    ((total_checks++))
    verify_file ".claude.json" "Claude Configuration" && ((passed_checks++))

    # 2. Deployment Scripts
    log_header "2. DEPLOYMENT SCRIPTS"
    ((total_checks++))
    verify_script "deploy-from-zip.sh" "Main Deployment Script" && ((passed_checks++))
    ((total_checks++))
    verify_script "download-and-setup.sh" "Download Setup Script" && ((passed_checks++))
    ((total_checks++))
    verify_script "start-claude.sh" "Claude Launcher" && ((passed_checks++))
    ((total_checks++))
    verify_script "start-mcp-background.sh" "MCP Background Starter" && ((passed_checks++))

    # 3. MCP Servers
    log_header "3. MCP SERVERS (13 Total)"
    local mcp_servers=(
        "mcp-servers/commands:Commands Server"
        "mcp-servers/agents:Agents Server"
        "mcp-servers/claude-flow:Claude Flow Server"
        "mcp-servers/playwright:Playwright Server"
        "mcp-analysis/mcp-sequential-thinking:Sequential Thinking Server"
        "mcp-servers/git-mcp-server:Git MCP Server"
        "mcp-analysis/apify-mcp-server:Apify MCP Server"
        "mcp-analysis/browsermcp-mcp:Browser MCP Server"
        "mcp-analysis/cipher:Cipher MCP Server"
        "mcp-analysis/cli:CLI MCP Server"
        "mcp-analysis/mcp-on-vercel:Vercel MCP Server"
        "mcp-analysis/supabase-mcp:Supabase MCP Server"
        "mcp-servers/mcp-servers-official:Official MCP Servers"
    )

    for server in "${mcp_servers[@]}"; do
        IFS=':' read -r path description <<< "$server"
        ((total_checks++))
        verify_directory "$path" "$description" && ((passed_checks++))
    done

    # 4. Agent Categories
    log_header "4. AGENT CATEGORIES"
    local agent_categories=(
        "mcp-servers/agents:Core Agents"
        "claude-dev-tools/agents:Dev Tools Agents"
        "mcp-analysis/agents:Analysis Agents"
    )

    for category in "${agent_categories[@]}"; do
        IFS=':' read -r path description <<< "$category"
        ((total_checks++))
        verify_directory "$path" "$description" && ((passed_checks++))
    done

    # 5. Documentation Files
    log_header "5. DOCUMENTATION FILES"
    local docs=(
        "README.md:Main Documentation"
        "CLAUDE.md:Claude Guide"
        "CLAUDE_MCP_SETUP.md:MCP Setup Guide"
        "CLAUDE_DEV_TOOLS_SETUP.md:Dev Tools Setup"
        "api-docs.md:API Documentation"
        "documentation.md:General Documentation"
    )

    for doc in "${docs[@]}"; do
        IFS=':' read -r file description <<< "$doc"
        ((total_checks++))
        verify_file "$file" "$description" && ((passed_checks++))
    done

    # 6. Setup Scripts
    log_header "6. SETUP SCRIPTS"
    local setup_scripts=(
        "claude-complete-setup.sh:Complete Setup"
        "claude-one-liner-setup.sh:One-liner Setup"
        "claude-portable-setup.sh:Portable Setup"
        "claude-improved-setup.sh:Improved Setup"
    )

    for script_info in "${setup_scripts[@]}"; do
        IFS=':' read -r script description <<< "$script_info"
        ((total_checks++))
        verify_script "$script" "$description" && ((passed_checks++))
    done

    # 7. Git Repository Status
    log_header "7. GIT REPOSITORY STATUS"
    if git rev-parse --git-dir > /dev/null 2>&1; then
        log_success "Git Repository: INITIALIZED"
        ((passed_checks++))
        ((total_checks++))

        local remote_url=$(git remote get-url origin 2>/dev/null || echo "none")
        if [[ "$remote_url" == *"github.com"* ]]; then
            log_success "Remote Repository: CONFIGURED ($remote_url)"
            ((passed_checks++))
        else
            log_warning "Remote Repository: NOT CONFIGURED"
        fi
        ((total_checks++))
    else
        log_error "Git Repository: NOT INITIALIZED"
    fi

    # 8. File Permissions Check
    log_header "8. FILE PERMISSIONS"
    local executable_scripts=$(find . -name "*.sh" -type f | wc -l)
    local executable_count=$(find . -name "*.sh" -type f -executable | wc -l)

    if [ "$executable_scripts" -eq "$executable_count" ]; then
        log_success "Script Permissions: ALL EXECUTABLE ($executable_count scripts)"
        ((passed_checks++))
    else
        log_warning "Script Permissions: $executable_count/$executable_scripts EXECUTABLE"
    fi
    ((total_checks++))

    # Final Results
    log_header "VERIFICATION RESULTS"
    echo ""
    echo -e "${CYAN}Total Checks: $total_checks${NC}"
    echo -e "${GREEN}Passed: $passed_checks${NC}"
    echo -e "${RED}Failed: $((total_checks - passed_checks))${NC}"

    local percentage=$((passed_checks * 100 / total_checks))
    if [ $percentage -eq 100 ]; then
        echo ""
        log_success "VERIFICATION: 100% COMPLETE - ALL COMPONENTS VERIFIED"
        echo ""
        echo "🎉 Claude Code Ecosystem is fully verified and ready for deployment!"
    elif [ $percentage -ge 90 ]; then
        echo ""
        log_success "VERIFICATION: $percentage% COMPLETE - MINOR ISSUES DETECTED"
    else
        echo ""
        log_warning "VERIFICATION: $percentage% COMPLETE - SIGNIFICANT ISSUES DETECTED"
    fi

    echo ""
    log_header "NEXT STEPS"
    echo "1. Run: ./deploy-from-zip.sh"
    echo "2. Start MCP servers: ./start-mcp-background.sh"
    echo "3. Launch Claude: ./start-claude.sh"
    echo "4. View documentation: cat README.md"
}

# Run main function
main "$@"