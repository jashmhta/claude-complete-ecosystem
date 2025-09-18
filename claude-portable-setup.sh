#!/bin/bash

# Claude Code Portable Setup Script
# This script recreates the complete Claude Code ecosystem on any new system

echo "🚀 Claude Code Portable Setup - Starting Installation..."

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

# Check if running as root
if [[ $EUID -eq 0 ]]; then
   print_error "This script should not be run as root"
   exit 1
fi

# Get current user and home directory
CURRENT_USER=$(whoami)
USER_HOME="/home/$CURRENT_USER"

print_status "Setting up Claude Code ecosystem for user: $CURRENT_USER"

# Step 1: Install Claude Code
print_status "Step 1: Installing Claude Code..."
if ! command -v claude &> /dev/null; then
    npm install -g @anthropic/claude-code
    print_success "Claude Code installed"
else
    print_warning "Claude Code already installed"
fi

# Step 2: Install required dependencies
print_status "Step 2: Installing system dependencies..."
sudo apt update
sudo apt install -y python3 python3-pip python3-venv nodejs npm git curl wget

# Step 3: Create directory structure
print_status "Step 3: Creating directory structure..."
mkdir -p "$USER_HOME/mcp-servers"
mkdir -p "$USER_HOME/mcp-analysis"
mkdir -p "$USER_HOME/claude-dev-tools"
mkdir -p "$USER_HOME/docs"

# Step 4: Install core MCP servers
print_status "Step 4: Installing core MCP servers..."

# Claude Flow
print_status "Installing Claude Flow..."
npm install -g claude-flow@alpha

# RUV Swarm
print_status "Installing RUV Swarm..."
npm install -g ruv-swarm

# Flow Nexus
print_status "Installing Flow Nexus..."
npm install -g flow-nexus@latest

# Step 5: Clone and setup MCP servers
print_status "Step 5: Setting up MCP server repositories..."

# MCP Servers Official
if [ ! -d "$USER_HOME/mcp-servers/mcp-servers-official" ]; then
    git clone https://github.com/modelcontextprotocol/servers.git "$USER_HOME/mcp-servers/mcp-servers-official"
    cd "$USER_HOME/mcp-servers/mcp-servers-official"
    npm install
fi

# Git MCP Server
if [ ! -d "$USER_HOME/mcp-servers/git-mcp-server" ]; then
    git clone https://github.com/modelcontextprotocol/git-mcp-server.git "$USER_HOME/mcp-servers/git-mcp-server"
    cd "$USER_HOME/mcp-servers/git-mcp-server"
    python3 -m venv venv
    source venv/bin/activate
    pip install -r requirements.txt
fi

# Playwright MCP
if [ ! -d "$USER_HOME/mcp-servers/mcp-playwright" ]; then
    git clone https://github.com/executeautomation/mcp-playwright.git "$USER_HOME/mcp-servers/mcp-playwright"
    cd "$USER_HOME/mcp-servers/mcp-playwright"
    npm install
    npm run build
fi

# Step 6: Setup Byterover MCP
print_status "Step 6: Setting up Byterover MCP..."
if [ ! -d "$USER_HOME/mcp-analysis/byterover-mcp" ]; then
    git clone https://github.com/ruvnet/byterover-mcp.git "$USER_HOME/mcp-analysis/byterover-mcp"
    cd "$USER_HOME/mcp-analysis/byterover-mcp"
    python3 -m venv venv
    source venv/bin/activate
    pip install -r requirements.txt
fi

# Step 7: Setup Claude Dev Tools
print_status "Step 7: Setting up Claude Dev Tools..."
if [ ! -d "$USER_HOME/claude-dev-tools/claude-code-workflows" ]; then
    mkdir -p "$USER_HOME/claude-dev-tools"
    git clone https://github.com/ruvnet/claude-code-workflows.git "$USER_HOME/claude-dev-tools/claude-code-workflows"
fi

# Step 8: Configure MCP servers in Claude
print_status "Step 8: Configuring MCP servers..."

# Add core servers
claude mcp add claude-flow npx claude-flow@alpha mcp start
claude mcp add ruv-swarm npx ruv-swarm mcp start
claude mcp add flow-nexus npx flow-nexus@latest mcp start

# Add development servers
claude mcp add playwright-server "node $USER_HOME/mcp-servers/mcp-playwright/dist/index.js"
claude mcp add filesystem-server "npx mcp-server-filesystem $USER_HOME"
claude mcp add git-server "$USER_HOME/mcp-servers/git-mcp-server/venv/bin/python -m mcp_server_git"
claude mcp add byterover-mcp "python $USER_HOME/mcp-analysis/byterover-mcp/mcp_server.py"
claude mcp add browser-mcp npx mcp-server-browsermcp
claude mcp add fetch npx mcp-server-fetch
claude mcp add time npx mcp-server-time
claude mcp add everything npx mcp-server-everything
claude mcp add memory npx mcp-server-memory
claude mcp add sequentialthinking npx mcp-server-sequential-thinking

# Step 9: Copy configuration files
print_status "Step 9: Setting up configuration files..."

# Copy CLAUDE.md if it exists
if [ -f "$USER_HOME/CLAUDE.md" ]; then
    cp "$USER_HOME/CLAUDE.md" "$USER_HOME/CLAUDE.md.backup"
fi

# Create CLAUDE.md with current configuration
cat > "$USER_HOME/CLAUDE.md" << 'EOF'
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

### 🎯 CRITICAL: Claude Code Task Tool for Agent Execution

**Claude Code's Task tool is the PRIMARY way to spawn agents:**
```javascript
// ✅ CORRECT: Use Claude Code's Task tool for parallel agent execution
[Single Message]:
  Task("Research agent", "Analyze requirements and patterns...", "researcher")
  Task("Coder agent", "Implement core features...", "coder")
  Task("Tester agent", "Create comprehensive tests...", "tester")
  Task("Reviewer agent", "Review code quality...", "reviewer")
  Task("Architect agent", "Design system architecture...", "system-architect")
```

**MCP tools are ONLY for coordination setup:**
- `mcp__claude-flow__swarm_init` - Initialize coordination topology
- `mcp__claude-flow__agent_spawn` - Define agent types for coordination
- `mcp__claude-flow__task_orchestrate` - Orchestrate high-level workflows

### 📁 File Organization Rules

**NEVER save to root folder. Use these directories:**
- `/src` - Source code files
- `/tests` - Test files
- `/docs` - Documentation and markdown files
- `/config` - Configuration files
- `/scripts` - Utility scripts
- `/examples` - Example code

## Project Overview

This project uses SPARC (Specification, Pseudocode, Architecture, Refinement, Completion) methodology with Claude-Flow orchestration for systematic Test-Driven Development.

## SPARC Commands

### Core Commands
- `npx claude-flow sparc modes` - List available modes
- `npx claude-flow sparc run <mode> "<task>"` - Execute specific mode
- `npx claude-flow sparc tdd "<feature>"` - Run complete TDD workflow
- `npx claude-flow sparc info <mode>` - Get mode details

### Batchtools Commands
- `npx claude-flow sparc batch <modes> "<task>"` - Parallel execution
- `npx claude-flow sparc pipeline "<task>"` - Full pipeline processing
- `npx claude-flow sparc concurrent <mode> "<tasks-file>"` - Multi-task processing

### Build Commands
- `npm run build` - Build project
- `npm run test` - Run tests
- `npm run lint` - Linting
- `npm run typecheck` - Type checking

## SPARC Workflow Phases

1. **Specification** - Requirements analysis (`sparc run spec-pseudocode`)
2. **Pseudocode** - Algorithm design (`sparc run spec-pseudocode`)
3. **Architecture** - System design (`sparc run architect`)
4. **Refinement** - TDD implementation (`sparc tdd`)
5. **Completion** - Integration (`sparc run integration`)

## Code Style & Best Practices

- **Modular Design**: Files under 500 lines
- **Environment Safety**: Never hardcode secrets
- **Test-First**: Write tests before implementation
- **Clean Architecture**: Separate concerns
- **Documentation**: Keep updated

## 🚀 Available Agents (54 Total)

### Core Development
`coder`, `reviewer`, `tester`, `planner`, `researcher`

### Swarm Coordination
`hierarchical-coordinator`, `mesh-coordinator`, `adaptive-coordinator`, `collective-intelligence-coordinator`, `swarm-memory-manager`

### Consensus & Distributed
`byzantine-coordinator`, `raft-manager`, `gossip-coordinator`, `consensus-builder`, `crdt-synchronizer`, `quorum-manager`, `security-manager`

### Performance & Optimization
`perf-analyzer`, `performance-benchmarker`, `task-orchestrator`, `memory-coordinator`, `smart-agent`

### GitHub & Repository
`github-modes`, `pr-manager`, `code-review-swarm`, `issue-tracker`, `release-manager`, `workflow-automation`, `project-board-sync`, `repo-architect`, `multi-repo-swarm`

### SPARC Methodology
`sparc-coord`, `sparc-coder`, `specification`, `pseudocode`, `architecture`, `refinement`

### Specialized Development
`backend-dev`, `mobile-dev`, `ml-developer`, `cicd-engineer`, `api-docs`, `system-architect`, `code-analyzer`, `base-template-generator`

### Testing & Validation
`tdd-london-swarm`, `production-validator`

### Migration & Planning
`migration-planner`, `swarm-init`

## 🎯 Claude Code vs MCP Tools

### Claude Code Handles ALL EXECUTION:
- **Task tool**: Spawn and run agents concurrently for actual work
- File operations (Read, Write, Edit, MultiEdit, Glob, Grep)
- Code generation and programming
- Bash commands and system operations
- Implementation work
- Project navigation and analysis
- TodoWrite and task management
- Git operations
- Package management
- Testing and debugging

### MCP Tools ONLY COORDINATE:
- Swarm initialization (topology setup)
- Agent type definitions (coordination patterns)
- Task orchestration (high-level planning)
- Memory management
- Neural features
- Performance tracking
- GitHub integration

**KEY**: MCP coordinates the strategy, Claude Code's Task tool executes with real agents.

## 🚀 Quick Setup

```bash
# Add MCP servers (Claude Flow required, others optional)
claude mcp add claude-flow npx claude-flow@alpha mcp start
claude mcp add ruv-swarm npx ruv-swarm mcp start  # Optional: Enhanced coordination
claude mcp add flow-nexus npx flow-nexus@latest mcp start  # Optional: Cloud features
```

## MCP Tool Categories

### Coordination
`swarm_init`, `agent_spawn`, `task_orchestrate`

### Monitoring
`swarm_status`, `agent_list`, `agent_metrics`, `task_status`, `task_results`

### Memory & Neural
`memory_usage`, `neural_status`, `neural_train`, `neural_patterns`

### GitHub Integration
`github_swarm`, `repo_analyze`, `pr_enhance`, `issue_triage`, `code_review`

### System
`benchmark_run`, `features_detect`, `swarm_monitor`

### Flow-Nexus MCP Tools (Optional Advanced Features)
Flow-Nexus extends MCP capabilities with 70+ cloud-based orchestration tools:

**Key MCP Tool Categories:**
- **Swarm & Agents**: `swarm_init`, `swarm_scale`, `agent_spawn`, `task_orchestrate`
- **Sandboxes**: `sandbox_create`, `sandbox_execute`, `sandbox_upload` (cloud execution)
- **Templates**: `template_list`, `template_deploy` (pre-built project templates)
- **Neural AI**: `neural_train`, `neural_patterns`, `seraphina_chat` (AI assistant)
- **GitHub**: `github_repo_analyze`, `github_pr_manage` (repository management)
- **Real-time**: `execution_stream_subscribe`, `realtime_subscribe` (live monitoring)
- **Storage**: `storage_upload`, `storage_list` (cloud file management)

**Authentication Required:**
- Register: `mcp__flow-nexus__user_register` or `npx flow-nexus@latest register`
- Login: `mcp__flow-nexus__user_login` or `npx flow-nexus@latest login`
- Access 70+ specialized MCP tools for advanced orchestration

## 🚀 Agent Execution Flow with Claude Code

### The Correct Pattern:

1. **Optional**: Use MCP tools to set up coordination topology
2. **REQUIRED**: Use Claude Code's Task tool to spawn agents that do actual work
3. **REQUIRED**: Each agent runs hooks for coordination
4. **REQUIRED**: Batch all operations in single messages

### Example Full-Stack Development:

```javascript
// Single message with all agent spawning via Claude Code's Task tool
[Parallel Agent Execution]:
  Task("Backend Developer", "Build REST API with Express. Use hooks for coordination.", "backend-dev")
  Task("Frontend Developer", "Create React UI. Coordinate with backend via memory.", "coder")
  Task("Database Architect", "Design PostgreSQL schema. Store schema in memory.", "code-analyzer")
  Task("Test Engineer", "Write Jest tests. Check memory for API contracts.", "tester")
  Task("DevOps Engineer", "Setup Docker and CI/CD. Document in memory.", "cicd-engineer")
  Task("Security Auditor", "Review authentication. Report findings via hooks.", "reviewer")

  // All todos batched together
  TodoWrite { todos: [...8-10 todos...] }

  // All file operations together
  Write "backend/server.js"
  Write "frontend/App.jsx"
  Write "database/schema.sql"
```

## 📋 Agent Coordination Protocol

### Every Agent Spawned via Task Tool MUST:

**1️⃣ BEFORE Work:**
```bash
npx claude-flow@alpha hooks pre-task --description "[task]"
npx claude-flow@alpha hooks session-restore --session-id "swarm-[id]"
```

**2️⃣ DURING Work:**
```bash
npx claude-flow@alpha hooks post-edit --file "[file]" --memory-key "swarm/[agent]/[step]"
npx claude-flow@alpha hooks notify --message "[what was done]"
```

**3️⃣ AFTER Work:**
```bash
npx claude-flow@alpha hooks post-task --task-id "[task]"
npx claude-flow@alpha hooks session-end --export-metrics true
```

## 🎯 Concurrent Execution Examples

### ✅ CORRECT WORKFLOW: MCP Coordinates, Claude Code Executes

```javascript
// Step 1: MCP tools set up coordination (optional, for complex tasks)
[Single Message - Coordination Setup]:
  mcp__claude-flow__swarm_init { topology: "mesh", maxAgents: 6 }
  mcp__claude-flow__agent_spawn { type: "researcher" }
  mcp__claude-flow__agent_spawn { type: "coder" }
  mcp__claude-flow__agent_spawn { type: "tester" }

// Step 2: Claude Code Task tool spawns ACTUAL agents that do the work
[Single Message - Parallel Agent Execution]:
  // Claude Code's Task tool spawns real agents concurrently
  Task("Research agent", "Analyze API requirements and best practices. Check memory for prior decisions.", "researcher")
  Task("Coder agent", "Implement REST endpoints with authentication. Coordinate via hooks.", "coder")
  Task("Database agent", "Design and implement database schema. Store decisions in memory.", "code-analyzer")
  Task("Tester agent", "Create comprehensive test suite with 90% coverage.", "tester")
  Task("Reviewer agent", "Review code quality and security. Document findings.", "reviewer")

  // Batch ALL todos in ONE call
  TodoWrite { todos: [
    {id: "1", content: "Research API patterns", status: "in_progress", priority: "high"},
    {id: "2", content: "Design database schema", status: "in_progress", priority: "high"},
    {id: "3", content: "Implement authentication", status: "pending", priority: "high"},
    {id: "4", content: "Build REST endpoints", status: "pending", priority: "high"},
    {id: "5", content: "Write unit tests", status: "pending", priority: "medium"},
    {id: "6", content: "Integration tests", status: "pending", priority: "medium"},
    {id: "7", content: "API documentation", status: "pending", priority: "low"},
    {id: "8", content: "Performance optimization", status: "pending", priority: "low"}
  ]}

  // Parallel file operations
  Bash "mkdir -p app/{src,tests,docs,config}"
  Write "app/package.json"
  Write "app/src/server.js"
  Write "app/tests/server.test.js"
  Write "app/docs/API.md"
```

### ❌ WRONG (Multiple Messages):
```javascript
Message 1: mcp__claude-flow__swarm_init
Message 2: Task("agent 1")
Message 3: TodoWrite { todos: [single todo] }
Message 4: Write "file.js"
// This breaks parallel coordination!
```

## Performance Benefits

- **84.8% SWE-Bench solve rate**
- **32.3% token reduction**
- **2.8-4.4x speed improvement**
- **27+ neural models**

## Hooks Integration

### Pre-Operation
- Auto-assign agents by file type
- Validate commands for safety
- Prepare resources automatically
- Optimize topology by complexity
- Cache searches

### Post-Operation
- Auto-format code
- Train neural patterns
- Update memory
- Analyze performance
- Track token usage

### Session Management
- Generate summaries
- Persist state
- Track metrics
- Restore context
- Export workflows

## Advanced Features (v2.0.0)

- 🚀 Automatic Topology Selection
- ⚡ Parallel Execution (2.8-4.4x speed)
- 🧠 Neural Training
- 📊 Bottleneck Analysis
- 🤖 Smart Auto-Spawning
- 🛡️ Self-Healing Workflows
- 💾 Cross-Session Memory
- 🔗 GitHub Integration

## Integration Tips

1. Start with basic swarm init
2. Scale agents gradually
3. Use memory for context
4. Monitor progress regularly
5. Train patterns from success
6. Enable hooks automation
7. Use GitHub tools first

## Support

- Documentation: https://github.com/ruvnet/claude-flow
- Issues: https://github.com/ruvnet/claude-flow/issues
- Flow-Nexus Platform: https://flow-nexus.ruv.io (registration required for cloud features)

---

Remember: **Claude Flow coordinates, Claude Code creates!**
EOF

# Step 10: Create backup and export scripts
print_status "Step 10: Creating backup and export utilities..."

# Create backup script
cat > "$USER_HOME/backup-claude-setup.sh" << EOF
#!/bin/bash
# Backup Claude Code setup
BACKUP_DIR="\$HOME/claude-backup-\$(date +%Y%m%d-%H%M%S)"
mkdir -p "\$BACKUP_DIR"

echo "Backing up Claude Code setup to \$BACKUP_DIR..."

# Backup configurations
cp "\$HOME/.claude.json" "\$BACKUP_DIR/" 2>/dev/null
cp "\$HOME/CLAUDE.md" "\$BACKUP_DIR/" 2>/dev/null
cp "\$HOME/COMPREHENSIVE_CLAUDE_CODE_GUIDE.md" "\$BACKUP_DIR/" 2>/dev/null

# Backup MCP server configurations
cp -r "\$HOME/mcp-servers" "\$BACKUP_DIR/" 2>/dev/null
cp -r "\$HOME/mcp-analysis" "\$BACKUP_DIR/" 2>/dev/null
cp -r "\$HOME/claude-dev-tools" "\$BACKUP_DIR/" 2>/dev/null

echo "Backup completed: \$BACKUP_DIR"
echo "To restore: ./claude-portable-setup.sh"
EOF

chmod +x "$USER_HOME/backup-claude-setup.sh"

# Step 11: Create quick start script
print_status "Step 11: Creating quick start utilities..."

cat > "$USER_HOME/start-claude-ecosystem.sh" << EOF
#!/bin/bash
# Quick start script for Claude Code ecosystem

echo "🚀 Starting Claude Code Ecosystem..."

# Start MCP servers in background
echo "Starting MCP servers..."
claude mcp start claude-flow &
claude mcp start ruv-swarm &
claude mcp start flow-nexus &

# Wait for servers to start
sleep 5

# Start Claude Code
echo "Starting Claude Code..."
claude

echo "✅ Claude Code ecosystem started!"
EOF

chmod +x "$USER_HOME/start-claude-ecosystem.sh"

# Step 12: Final verification
print_status "Step 12: Running final verification..."

# Check if Claude Code is installed
if command -v claude &> /dev/null; then
    print_success "Claude Code: Installed"
else
    print_error "Claude Code: Not found"
fi

# Check MCP servers
if claude mcp list &> /dev/null; then
    print_success "MCP servers: Configured"
else
    print_warning "MCP servers: May need manual configuration"
fi

# Step 13: Create README for the setup
print_status "Step 13: Creating setup documentation..."

cat > "$USER_HOME/CLAUDE_SETUP_README.md" << EOF
# Claude Code Ecosystem Setup

## 📦 What's Included

This setup includes:
- ✅ Claude Code (latest version)
- ✅ 13 MCP servers configured
- ✅ SPARC methodology tools
- ✅ 54+ specialized agents
- ✅ Workflow automation
- ✅ Development standards
- ✅ Comprehensive documentation

## 🚀 Quick Start

1. **Start the ecosystem:**
   \`\`\`bash
   ./start-claude-ecosystem.sh
   \`\`\`

2. **Begin development:**
   \`\`\`bash
   claude
   \`\`\`

## 📋 Available Commands

- \`./start-claude-ecosystem.sh\` - Start all MCP servers and Claude Code
- \`./backup-claude-setup.sh\` - Backup current setup
- \`./claude-portable-setup.sh\` - Reinstall on new system

## 🔧 Manual MCP Server Management

\`\`\`bash
# List servers
claude mcp list

# Start specific server
claude mcp start <server-name>

# Stop specific server
claude mcp stop <server-name>

# Check server status
claude mcp status <server-name>
\`\`\`

## 📚 Documentation

- \`COMPREHENSIVE_CLAUDE_CODE_GUIDE.md\` - Complete reference guide
- \`CLAUDE.md\` - Configuration and standards
- \`CLAUDE_SETUP_README.md\` - This file

## 🔄 Portability

To recreate this setup on any new system:

1. Copy these files to your new system:
   - \`claude-portable-setup.sh\`
   - \`COMPREHENSIVE_CLAUDE_CODE_GUIDE.md\`
   - \`CLAUDE.md\`

2. Run the setup script:
   \`\`\`bash
   chmod +x claude-portable-setup.sh
   ./claude-portable-setup.sh
   \`\`\`

## 🆘 Troubleshooting

If you encounter issues:

1. Check MCP server status: \`claude mcp status\`
2. Restart servers: \`claude mcp restart\`
3. Reinstall: \`./claude-portable-setup.sh\`
4. Check logs: \`claude mcp logs <server-name>\`

## 📞 Support

- Documentation: https://docs.anthropic.com/claude/docs/claude-code
- SPARC Guide: https://github.com/ruvnet/claude-flow
- MCP Protocol: https://modelcontextprotocol.io

---

**Setup completed on:** \$(date)
**System:** \$(uname -a)
**User:** \$(whoami)
EOF

print_success "Setup completed successfully!"
print_success "Created files:"
echo "  📄 claude-portable-setup.sh - Portable setup script"
echo "  📄 start-claude-ecosystem.sh - Quick start script"
echo "  📄 backup-claude-setup.sh - Backup utility"
echo "  📄 CLAUDE_SETUP_README.md - Setup documentation"
echo "  📄 COMPREHENSIVE_CLAUDE_CODE_GUIDE.md - Complete guide"

print_success "To start using Claude Code ecosystem:"
echo "  1. Run: ./start-claude-ecosystem.sh"
echo "  2. Or manually: claude"

print_warning "Important: Your Claude Code setup is now portable!"
print_warning "Use './claude-portable-setup.sh' to recreate on any new system."