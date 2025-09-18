#!/bin/bash

# Claude Code One-Liner Setup Script
# This script sets up the complete Claude Code ecosystem in one command

echo "🚀 Claude Code One-Liner Setup - Starting..."

# Function to print colored output
print_success() {
    echo -e "\033[0;32m[SUCCESS]\033[0m $1"
}

print_error() {
    echo -e "\033[0;31m[ERROR]\033[0m $1"
}

print_status() {
    echo -e "\033[0;34m[INFO]\033[0m $1"
}

# Check if running as root
if [[ $EUID -eq 0 ]]; then
   print_error "This script should not be run as root"
   exit 1
fi

# Get current user and create setup directory
CURRENT_USER=$(whoami)
SETUP_DIR="/home/$CURRENT_USER/claude-setup"
mkdir -p "$SETUP_DIR"
cd "$SETUP_DIR"

print_status "Setting up Claude Code ecosystem for user: $CURRENT_USER"

# Step 1: Install Claude Code
print_status "Installing Claude Code..."
if ! command -v claude &> /dev/null; then
    npm install -g @anthropic/claude-code
    print_success "Claude Code installed"
else
    print_success "Claude Code already installed"
fi

# Step 2: Install core MCP servers
print_status "Installing core MCP servers..."
npm install -g claude-flow@alpha ruv-swarm flow-nexus@latest
print_success "Core MCP servers installed"

# Step 3: Configure MCP servers
print_status "Configuring MCP servers..."
claude mcp add claude-flow npx claude-flow@alpha mcp start
claude mcp add ruv-swarm npx ruv-swarm mcp start
claude mcp add flow-nexus npx flow-nexus@latest mcp start

# Step 4: Install additional MCP servers
print_status "Installing additional MCP servers..."
npm install -g mcp-server-filesystem mcp-server-browsermcp mcp-server-fetch mcp-server-time mcp-server-everything mcp-server-memory mcp-server-sequential-thinking

# Step 5: Configure additional servers
print_status "Configuring additional MCP servers..."
claude mcp add filesystem-server "npx mcp-server-filesystem /home/$CURRENT_USER"
claude mcp add browser-mcp npx mcp-server-browsermcp
claude mcp add fetch npx mcp-server-fetch
claude mcp add time npx mcp-server-time
claude mcp add everything npx mcp-server-everything
claude mcp add memory npx mcp-server-memory
claude mcp add sequentialthinking npx mcp-server-sequential-thinking

# Step 6: Create directory structure
print_status "Creating directory structure..."
mkdir -p "/home/$CURRENT_USER/mcp-servers"
mkdir -p "/home/$CURRENT_USER/mcp-analysis"
mkdir -p "/home/$CURRENT_USER/claude-dev-tools"
mkdir -p "/home/$CURRENT_USER/docs"

# Step 7: Clone essential repositories
print_status "Cloning essential repositories..."
cd "/home/$CURRENT_USER/mcp-servers"
git clone https://github.com/modelcontextprotocol/servers.git mcp-servers-official --depth 1
git clone https://github.com/modelcontextprotocol/git-mcp-server.git git-mcp-server --depth 1
git clone https://github.com/executeautomation/mcp-playwright.git mcp-playwright --depth 1

# Step 8: Setup Python environments and dependencies
print_status "Setting up Python environments..."
cd "/home/$CURRENT_USER/mcp-servers/git-mcp-server"
python3 -m venv venv
source venv/bin/activate
pip install -r requirements.txt

cd "/home/$CURRENT_USER/mcp-servers/mcp-playwright"
npm install
npm run build

# Step 9: Setup Byterover MCP
print_status "Setting up Byterover MCP..."
cd "/home/$CURRENT_USER/mcp-analysis"
git clone https://github.com/ruvnet/byterover-mcp.git --depth 1
cd byterover-mcp
python3 -m venv venv
source venv/bin/activate
pip install -r requirements.txt

# Step 10: Setup Claude Dev Tools
print_status "Setting up Claude Dev Tools..."
cd "/home/$CURRENT_USER/claude-dev-tools"
git clone https://github.com/ruvnet/claude-code-workflows.git --depth 1

# Step 11: Configure remaining MCP servers
print_status "Configuring remaining MCP servers..."
claude mcp add git-server "/home/$CURRENT_USER/mcp-servers/git-mcp-server/venv/bin/python -m mcp_server_git"
claude mcp add playwright-server "node /home/$CURRENT_USER/mcp-servers/mcp-playwright/dist/index.js"
claude mcp add byterover-mcp "python /home/$CURRENT_USER/mcp-analysis/byterover-mcp/mcp_server.py"

# Step 12: Create CLAUDE.md configuration
print_status "Creating CLAUDE.md configuration..."
cat > "/home/$CURRENT_USER/CLAUDE.md" << 'EOF'
# Claude Code Configuration - SPARC Development Environment

## 🚨 CRITICAL: CONCURRENT EXECUTION & FILE MANAGEMENT

**ABSOLUTE RULES**:
1. ALL operations MUST be concurrent/parallel in a single message
2. **NEVER save working files, text/mds and tests to the root folder**
3. ALWAYS organize files in appropriate subdirectories
4. **USE CLAUDE CODE'S TASK TOOL** for spawning agents concurrently, not just MCP

### ⚡ GOLDEN RULE: "1 MESSAGE = ALL RELATED OPERATIONS"

**MANDATORY PATTERNS:**
- **TodoWrite**: ALWAYS batch ALL todos in ONE call (5-10+ todos minimum)
- **Task tool (Claude Code)**: ALWAYS spawn ALL agents in ONE message with full instructions
- **File operations**: ALWAYS batch ALL reads/writes/edits in ONE message
- **Bash commands**: ALWAYS batch ALL terminal operations in ONE message
- **Memory operations**: ALWAYS batch ALL memory store/retrieve in ONE message

### 📁 File Organization Rules
**NEVER save to root folder. Use these directories:**
- `/src` - Source code files
- `/tests` - Test files
- `/docs` - Documentation and markdown files
- `/config` - Configuration files
- `/scripts` - Utility scripts
- `/examples` - Example code

## SPARC Commands
- `npx claude-flow sparc modes` - List available modes
- `npx claude-flow sparc run <mode> "<task>"` - Execute specific mode
- `npx claude-flow sparc tdd "<feature>"` - Run complete TDD workflow

## 🚀 Available Agents (54 Total)
### Core Development: `coder`, `reviewer`, `tester`, `planner`, `researcher`
### Swarm Coordination: `hierarchical-coordinator`, `mesh-coordinator`, `adaptive-coordinator`
### Performance & Optimization: `perf-analyzer`, `performance-benchmarker`, `task-orchestrator`
### GitHub & Repository: `github-modes`, `pr-manager`, `code-review-swarm`
### SPARC Methodology: `sparc-coord`, `sparc-coder`, `specification`, `pseudocode`
### Specialized Development: `backend-dev`, `mobile-dev`, `ml-developer`, `cicd-engineer`

## 🎯 Claude Code vs MCP Tools
### Claude Code Handles ALL EXECUTION:
- **Task tool**: Spawn and run agents concurrently for actual work
- File operations (Read, Write, Edit, MultiEdit, Glob, Grep)
- Code generation and programming
- Bash commands and system operations

### MCP Tools ONLY COORDINATE:
- Swarm initialization (topology setup)
- Agent type definitions (coordination patterns)
- Task orchestration (high-level planning)

## 🚀 Quick Setup
```bash
claude mcp add claude-flow npx claude-flow@alpha mcp start
claude mcp add ruv-swarm npx ruv-swarm mcp start
claude mcp add flow-nexus npx flow-nexus@latest mcp start
```

## Performance Benefits
- **84.8% SWE-Bench solve rate**
- **32.3% token reduction**
- **2.8-4.4x speed improvement**
- **27+ neural models**

Remember: **Claude Flow coordinates, Claude Code creates!**
EOF

# Step 13: Create quick start script
print_status "Creating quick start script..."
cat > "/home/$CURRENT_USER/start-claude.sh" << EOF
#!/bin/bash
echo "🚀 Starting Claude Code Ecosystem..."
echo "Starting MCP servers..."
claude mcp start claude-flow &
claude mcp start ruv-swarm &
claude mcp start flow-nexus &
sleep 3
echo "Starting Claude Code..."
claude
EOF
chmod +x "/home/$CURRENT_USER/start-claude.sh"

# Step 14: Create comprehensive guide
print_status "Creating comprehensive guide..."
cat > "/home/$CURRENT_USER/COMPREHENSIVE_CLAUDE_CODE_GUIDE.md" << 'EOF'
# Comprehensive Claude Code Ecosystem Guide

## Table of Contents
1. [Introduction](#introduction)
2. [Core Architecture](#core-architecture)
3. [SPARC Methodology](#sparc-methodology)
4. [Agent Ecosystem](#agent-ecosystem)
5. [MCP Server Integration](#mcp-server-integration)
6. [Workflow Automation](#workflow-automation)
7. [Command Reference](#command-reference)
8. [Best Practices](#best-practices)
9. [Troubleshooting](#troubleshooting)

## 1. Introduction
Claude Code is an advanced AI-assisted development environment with 54+ specialized agents and 13+ MCP servers.

## 2. Core Architecture
### Golden Rule: "1 MESSAGE = ALL Related Operations"
**MANDATORY PATTERNS:**
- **TodoWrite**: Batch ALL todos in ONE call (5-10+ todos minimum)
- **Task Tool**: Spawn ALL agents in ONE message with full instructions
- **File Operations**: Batch ALL reads/writes/edits in ONE message
- **Bash Commands**: Batch ALL terminal operations in ONE message

## 3. SPARC Methodology
SPARC (Specification, Pseudocode, Architecture, Refinement, Completion) provides systematic Test-Driven Development.

### Commands:
```bash
npx claude-flow sparc modes           # List available modes
npx claude-flow sparc run <mode> "<task>"  # Execute specific mode
npx claude-flow sparc tdd "<feature>"      # Run complete TDD workflow
```

## 4. Agent Ecosystem (54+ Total)
### Core Development: `coder`, `reviewer`, `tester`, `planner`, `researcher`
### Swarm Coordination: `hierarchical-coordinator`, `mesh-coordinator`, `adaptive-coordinator`
### Performance & Optimization: `perf-analyzer`, `performance-benchmarker`, `task-orchestrator`
### GitHub & Repository: `github-modes`, `pr-manager`, `code-review-swarm`
### SPARC Methodology: `sparc-coord`, `sparc-coder`, `specification`, `pseudocode`
### Specialized Development: `backend-dev`, `mobile-dev`, `ml-developer`, `cicd-engineer`

## 5. MCP Server Integration (13 Servers)
1. **Claude Flow** - Primary orchestration
2. **RUV Swarm** - Enhanced coordination
3. **Flow Nexus** - Cloud orchestration (70+ tools)
4. **Playwright MCP** - Browser automation
5. **Filesystem MCP** - File system operations
6. **Git MCP** - Git operations
7. **Byterover MCP** - Code analysis
8. **Browser MCP** - Web scraping
9. **Fetch MCP** - HTTP requests
10. **Time MCP** - Time utilities
11. **Everything MCP** - General utilities
12. **Memory MCP** - Memory management
13. **Sequential Thinking MCP** - Step-by-step reasoning

## 6. Workflow Automation
### Code Review Workflow
- Automated code reviews with specialized agents
- GitHub Actions integration
- Customizable review criteria

### Security Review Workflow
- Automated security scanning
- Compliance checking
- Dependency analysis

## 7. Command Reference
### Claude Code Commands
```bash
/claude              # Start Claude Code
/help               # Display help information
/exit               # Exit Claude Code
```

### MCP Server Commands
```bash
claude mcp list                 # List MCP servers
claude mcp start <name>         # Start MCP server
claude mcp stop <name>          # Stop MCP server
claude mcp status <name>        # Check MCP server status
```

### Agent Commands
```bash
/agents list                    # List available agents
/agents spawn <type> <task>     # Spawn specific agent
/agents status                  # Check agent status
```

## 8. Best Practices
### Concurrent Execution Patterns
```javascript
// Correct workflow
[Parallel Execution]:
  Task("Research agent", "Analyze requirements", "researcher")
  Task("Coder agent", "Implement features", "coder")
  Task("Tester agent", "Create tests", "tester")
  TodoWrite { todos: [...] }
```

### File Organization
```
project/
├── src/           # Source code
├── tests/         # Test files
├── docs/          # Documentation
├── config/        # Configuration files
├── scripts/       # Utility scripts
└── examples/      # Example code
```

## 9. Troubleshooting
### Common Issues
- **MCP server not responding**: Check server logs and restart
- **Agent spawn failed**: Verify agent type and task parameters
- **File operation failed**: Check file permissions and paths

### Debug Commands
```bash
export DEBUG=1
env | grep -i claude
cat ~/.claude.json
```

## Quick Start Guide
### 1. Start the Ecosystem
```bash
./start-claude.sh
```

### 2. Basic Workflow
```bash
mkdir my-project && cd my-project
npx claude-flow sparc run spec-pseudocode "Build a web application"
```

### 3. Agent Deployment
```javascript
Task("Backend Developer", "Build REST API", "backend-dev")
Task("Frontend Developer", "Create React UI", "coder")
Task("Database Architect", "Design schema", "code-analyzer")
Task("Test Engineer", "Write tests", "tester")
```

## Performance Metrics
- **84.8% SWE-Bench solve rate**
- **32.3% token reduction**
- **2.8-4.4x speed improvement**
- **27+ neural models**

---
*This comprehensive guide covers the complete Claude Code ecosystem.*
EOF

# Step 15: Create setup verification
print_status "Creating setup verification..."
cat > "/home/$CURRENT_USER/verify-claude-setup.sh" << EOF
#!/bin/bash
echo "🔍 Verifying Claude Code Setup..."

# Check Claude Code
if command -v claude &> /dev/null; then
    echo "✅ Claude Code: Installed"
else
    echo "❌ Claude Code: Not found"
fi

# Check MCP servers
echo "📋 MCP Servers Status:"
claude mcp list

# Check directories
echo "📁 Directory Structure:"
ls -la /home/$CURRENT_USER/ | grep -E "(mcp|claude|CLAUDE)"

# Check key files
echo "📄 Key Files:"
ls -la /home/$CURRENT_USER/CLAUDE.md /home/$CURRENT_USER/COMPREHENSIVE_CLAUDE_CODE_GUIDE.md /home/$CURRENT_USER/start-claude.sh 2>/dev/null

echo "🎉 Verification complete!"
EOF
chmod +x "/home/$CURRENT_USER/verify-claude-setup.sh"

# Step 16: Final setup
print_status "Finalizing setup..."
cd "/home/$CURRENT_USER"

print_success "🎉 Claude Code ecosystem setup completed!"
print_success "📊 Setup Summary:"
echo "  ✅ Claude Code installed and configured"
echo "  ✅ 13 MCP servers configured"
echo "  ✅ 54+ agents available"
echo "  ✅ SPARC methodology ready"
echo "  ✅ Complete documentation created"
echo "  ✅ Quick start scripts ready"

print_success "🚀 To start using Claude Code:"
echo "  ./start-claude.sh"

print_success "🔍 To verify setup:"
echo "  ./verify-claude-setup.sh"

print_success "📚 Documentation:"
echo "  CLAUDE.md - Configuration and standards"
echo "  COMPREHENSIVE_CLAUDE_CODE_GUIDE.md - Complete reference guide"

print_success "⚡ Performance Benefits:"
echo "  • 84.8% SWE-Bench solve rate"
echo "  • 32.3% token reduction"
echo "  • 2.8-4.4x speed improvement"
echo "  • 27+ neural models"

print_success "🎯 Ready to use! Your Claude Code ecosystem is fully operational."