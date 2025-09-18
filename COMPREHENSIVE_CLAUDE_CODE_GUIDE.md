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
- **File operations**: Batch ALL reads/writes/edits in ONE message
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
