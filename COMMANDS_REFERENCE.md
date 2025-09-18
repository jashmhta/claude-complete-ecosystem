# Claude Code Commands Reference

## Overview

This document provides a comprehensive reference for all commands available in the Claude Code ecosystem, including their syntax, parameters, examples, and use cases.

## Table of Contents

- [Core Commands](#core-commands)
- [Agent Commands](#agent-commands)
- [MCP Server Commands](#mcp-server-commands)
- [Workflow Commands](#workflow-commands)
- [Development Commands](#development-commands)
- [Configuration Commands](#configuration-commands)
- [Utility Commands](#utility-commands)

---

## Core Commands

### `/help`
**Description:** Display help information for Claude Code commands

**Syntax:**
```
/help [command]
```

**Parameters:**
- `command` (optional): Specific command to get help for

**Examples:**
```bash
/help                    # Show all available commands
/help agent             # Show help for agent commands
/help workflow          # Show help for workflow commands
```

**Output:**
```
Available commands:
- /help: Show help information
- /agent: Work with AI agents
- /workflow: Manage workflows
- /config: Configuration management
- /status: Show system status
- /memory: Memory management
- /todo: Task management
```

### `/status`
**Description:** Display the current status of Claude Code and connected systems

**Syntax:**
```
/status [component]
```

**Parameters:**
- `component` (optional): Specific component to check (mcp, agents, workflows)

**Examples:**
```bash
/status                 # Show overall status
/status mcp            # Show MCP server status
/status agents         # Show agent status
/status workflows      # Show workflow status
```

**Output:**
```
Claude Code Status Report
========================
MCP Servers: 13/13 Running
Agents: 54/54 Active
Workflows: 15/15 Available
Memory Usage: 256MB
Uptime: 2h 30m
```

### `/memory`
**Description:** Manage Claude's memory and context

**Syntax:**
```
/memory <action> [parameters]
```

**Actions:**
- `show`: Display current memory contents
- `clear`: Clear all memory
- `save`: Save current memory to file
- `load`: Load memory from file
- `search`: Search memory contents

**Examples:**
```bash
/memory show           # Show current memory
/memory clear          # Clear all memory
/memory save my-session # Save to file
/memory load my-session # Load from file
/memory search "api"   # Search for API-related content
```

**Output:**
```
Memory Contents:
- Project: E-commerce Platform
- Technologies: React, Node.js, PostgreSQL
- Last Action: Database schema design
- Context Size: 2.3MB
```

### `/todo`
**Description:** Manage task lists and project planning

**Syntax:**
```
/todo <action> [parameters]
```

**Actions:**
- `list`: Show all tasks
- `add`: Add new task
- `complete`: Mark task as complete
- `delete`: Remove task
- `priority`: Set task priority
- `assign`: Assign task to agent

**Examples:**
```bash
/todo list                    # Show all tasks
/todo add "Implement user auth" high # Add high priority task
/todo complete 1              # Mark task 1 as complete
/todo priority 2 low          # Set task 2 to low priority
/todo assign 3 code-reviewer  # Assign to code reviewer
```

**Output:**
```
Task List:
1. [✓] Set up project structure (High)
2. [ ] Implement user authentication (High)
3. [ ] Create database schema (Medium)
4. [ ] Build API endpoints (Medium)
5. [ ] Add frontend components (Low)
```

---

## Agent Commands

### `/agent`
**Description:** Work with AI agents in the Claude Code ecosystem

**Syntax:**
```
/agent <action> [parameters]
```

**Actions:**
- `list`: List all available agents
- `info`: Get detailed information about an agent
- `run`: Execute an agent with specific task
- `status`: Check agent status
- `config`: Configure agent settings
- `create`: Create custom agent
- `delete`: Remove agent

**Examples:**
```bash
/agent list                          # List all agents
/agent info code-reviewer           # Get code reviewer details
/agent run frontend-developer "Build login component"
/agent status performance-engineer  # Check agent status
/agent config code-reviewer --strict # Configure agent
```

**Agent Categories:**

#### Code & Development Agents
```bash
/agent run code-reviewer "Review pull request #123"
/agent run frontend-developer "Create responsive navbar"
/agent run backend-developer "Implement REST API"
/agent run python-pro "Optimize data processing script"
/agent run typescript-pro "Add type definitions"
/agent run java-pro "Implement microservice"
/agent run go-pro "Build CLI tool"
/agent run rust-pro "Implement memory-safe algorithm"
```

#### DevOps & Infrastructure Agents
```bash
/agent run devops-engineer "Set up CI/CD pipeline"
/agent run kubernetes-architect "Design cluster architecture"
/agent run terraform-specialist "Create infrastructure as code"
/agent run deployment-engineer "Deploy to production"
/agent run performance-engineer "Optimize application performance"
/agent run security-auditor "Audit codebase security"
/agent run network-engineer "Configure load balancer"
```

#### Data & Analytics Agents
```bash
/agent run data-engineer "Design ETL pipeline"
/agent run data-scientist "Analyze user behavior data"
/agent run database-admin "Optimize query performance"
/agent run ml-engineer "Deploy machine learning model"
/agent run business-analyst "Create requirements document"
/agent run quant-analyst "Perform risk analysis"
```

#### Design & UX Agents
```bash
/agent run ui-ux-designer "Design mobile app interface"
/agent run frontend-security-coder "Implement secure authentication"
/agent run backend-security-coder "Add API security layers"
/agent run mobile-security-coder "Secure mobile application"
```

#### Specialized Domain Agents
```bash
/agent run blockchain-developer "Implement smart contract"
/agent run unity-developer "Create 3D game level"
/agent run minecraft-developer "Build custom Minecraft plugin"
/agent run ios-developer "Develop iOS application"
/agent run android-developer "Create Android app"
/agent run flutter-expert "Build cross-platform mobile app"
```

#### Content & Marketing Agents
```bash
/agent run content-marketer "Create content strategy"
/agent run seo-content-writer "Write SEO-optimized article"
/agent run seo-keyword-strategist "Research target keywords"
/agent run seo-content-auditor "Audit content performance"
/agent run seo-meta-optimizer "Optimize meta tags"
/agent run seo-structure-architect "Design site structure"
/agent run seo-authority-builder "Build domain authority"
/agent run seo-snippet-hunter "Target featured snippets"
/agent run seo-cannibalization-detector "Find keyword conflicts"
/agent run seo-content-refresher "Update outdated content"
```

#### Operational & Support Agents
```bash
/agent run customer-support "Handle user inquiry"
/agent run hr-pro "Create employee handbook"
/agent run legal-advisor "Review terms of service"
/agent run risk-manager "Assess project risks"
/agent run sales-automator "Set up sales funnel"
/agent run payment-integration "Integrate payment gateway"
```

---

## MCP Server Commands

### `/mcp`
**Description:** Manage MCP (Model Context Protocol) servers

**Syntax:**
```
/mcp <action> [parameters]
```

**Actions:**
- `list`: List all MCP servers
- `start`: Start specific MCP server
- `stop`: Stop specific MCP server
- `restart`: Restart MCP server
- `status`: Check MCP server status
- `logs`: View MCP server logs
- `config`: Configure MCP server

**Examples:**
```bash
/mcp list                    # List all MCP servers
/mcp start commands         # Start commands server
/mcp stop playwright        # Stop playwright server
/mcp restart git-mcp        # Restart git MCP server
/mcp status                 # Show all server statuses
/mcp logs sequential-thinking # View server logs
/mcp config claude-flow --port 3001 # Configure server
```

### MCP Server Details

#### Commands Server
```bash
/mcp start commands
# Purpose: Execute commands and manage workflows
# Port: 3000
# Endpoints: /execute, /workflow, /status
```

#### Agents Server
```bash
/mcp start agents
# Purpose: Manage and coordinate AI agents
# Port: 3001
# Endpoints: /agents, /tasks, /coordination
```

#### Claude Flow Server
```bash
/mcp start claude-flow
# Purpose: Orchestrate complex workflows
# Port: 3002
# Endpoints: /flow, /pipeline, /orchestration
```

#### Playwright Server
```bash
/mcp start playwright
# Purpose: Browser automation and testing
# Port: 3003
# Endpoints: /browser, /test, /automation
```

#### Sequential Thinking Server
```bash
/mcp start sequential-thinking
# Purpose: Advanced reasoning and analysis
# Port: 3004
# Endpoints: /analyze, /reason, /conclude
```

#### Git MCP Server
```bash
/mcp start git-mcp
# Purpose: Git operations and version control
# Port: 3005
# Endpoints: /git, /repository, /branch
```

#### Apify MCP Server
```bash
/mcp start apify
# Purpose: Web scraping and data extraction
# Port: 3006
# Endpoints: /scrape, /extract, /data
```

#### Browser MCP Server
```bash
/mcp start browser
# Purpose: Browser control and interaction
# Port: 3007
# Endpoints: /navigate, /interact, /capture
```

#### Cipher MCP Server
```bash
/mcp start cipher
# Purpose: Encryption and security operations
# Port: 3008
# Endpoints: /encrypt, /decrypt, /secure
```

#### CLI MCP Server
```bash
/mcp start cli
# Purpose: Command-line interface operations
# Port: 3009
# Endpoints: /command, /execute, /output
```

#### Vercel MCP Server
```bash
/mcp start vercel
# Purpose: Serverless deployment and hosting
# Port: 3010
# Endpoints: /deploy, /function, /hosting
```

#### Supabase MCP Server
```bash
/mcp start supabase
# Purpose: Database operations and management
# Port: 3011
# Endpoints: /database, /query, /realtime
```

#### Official MCP Servers
```bash
/mcp start official
# Purpose: Standard MCP protocol implementation
# Port: 3012
# Endpoints: /protocol, /standard, /compliance
```

---

## Workflow Commands

### `/workflow`
**Description:** Manage and execute workflows in the Claude Code ecosystem

**Syntax:**
```
/workflow <action> [parameters]
```

**Actions:**
- `list`: List all available workflows
- `create`: Create new workflow
- `run`: Execute workflow
- `status`: Check workflow status
- `edit`: Modify existing workflow
- `delete`: Remove workflow
- `template`: Use workflow template

**Examples:**
```bash
/workflow list                          # List all workflows
/workflow create "api-development"     # Create new workflow
/workflow run "full-stack-feature"     # Execute workflow
/workflow status "api-development"     # Check workflow status
/workflow edit "user-auth"             # Edit existing workflow
/workflow template "tdd-cycle"         # Use TDD template
```

### SPARC Methodology Workflows

#### Specification Workflow
```bash
/workflow run specification "User authentication system"
# Steps:
# 1. Gather requirements
# 2. Define user stories
# 3. Create acceptance criteria
# 4. Document technical specifications
```

#### Pseudocode Workflow
```bash
/workflow run pseudocode "Payment processing algorithm"
# Steps:
# 1. Design high-level algorithm
# 2. Create flowcharts
# 3. Analyze complexity
# 4. Identify edge cases
```

#### Architecture Workflow
```bash
/workflow run architecture "Microservices platform"
# Steps:
# 1. Design system architecture
# 2. Select design patterns
# 3. Define component interfaces
# 4. Choose technology stack
```

#### Coding Workflow
```bash
/workflow run coding "Implement user registration"
# Steps:
# 1. Write clean code
# 2. Apply best practices
# 3. Add comprehensive tests
# 4. Document implementation
```

#### Review Workflow
```bash
/workflow run review "Code quality assessment"
# Steps:
# 1. Perform unit testing
# 2. Conduct integration testing
# 3. Execute performance testing
# 4. Complete security testing
```

### Specialized Workflows

#### TDD Cycle Workflow
```bash
/workflow template tdd-cycle "User login feature"
# Red: Write failing test
# Green: Make test pass
# Refactor: Improve code quality
```

#### Full-Stack Feature Workflow
```bash
/workflow template full-stack-feature "Shopping cart"
# Frontend: React components
# Backend: API endpoints
# Database: Schema design
# Testing: Integration tests
```

#### Incident Response Workflow
```bash
/workflow template incident-response "Server outage"
# Assessment: Problem analysis
# Containment: Stop the bleeding
# Recovery: Restore service
# Lessons: Post-mortem analysis
```

#### Performance Optimization Workflow
```bash
/workflow template performance-optimization "Slow API"
# Profiling: Identify bottlenecks
# Optimization: Improve performance
# Testing: Validate improvements
# Monitoring: Track performance
```

#### Legacy Modernization Workflow
```bash
/workflow template legacy-modernize "Old PHP application"
# Assessment: Code analysis
# Planning: Migration strategy
# Migration: Gradual modernization
# Testing: Compatibility validation
```

---

## Development Commands

### `/dev`
**Description:** Development and project management commands

**Syntax:**
```
/dev <action> [parameters]
```

**Actions:**
- `init`: Initialize new project
- `build`: Build project
- `test`: Run tests
- `lint`: Check code quality
- `deploy`: Deploy application
- `monitor`: Monitor application
- `debug`: Debug application

**Examples:**
```bash
/dev init react-app              # Initialize React project
/dev build production           # Build for production
/dev test unit                  # Run unit tests
/dev lint                       # Check code quality
/dev deploy staging            # Deploy to staging
/dev monitor                    # Start monitoring
/dev debug                      # Start debugging session
```

### Project Management
```bash
/dev project create "E-commerce Platform"
/dev project status
/dev project archive "Old Project"
/dev project clone "Template Project"
```

### Code Quality
```bash
/dev quality check              # Overall quality check
/dev quality coverage          # Test coverage report
/dev quality security          # Security scan
/dev quality performance       # Performance analysis
```

### Version Control
```bash
/dev git status                 # Git status
/dev git commit "Add new feature"
/dev git push origin main      # Push to main branch
/dev git pull                  # Pull latest changes
/dev git branch "feature/auth" # Create feature branch
```

---

## Configuration Commands

### `/config`
**Description:** Manage Claude Code configuration

**Syntax:**
```
/config <action> [parameters]
```

**Actions:**
- `show`: Display current configuration
- `set`: Set configuration value
- `get`: Get configuration value
- `reset`: Reset to default configuration
- `import`: Import configuration file
- `export`: Export configuration file

**Examples:**
```bash
/config show                    # Show all settings
/config set theme dark         # Set dark theme
/config get maxConcurrentTasks # Get specific setting
/config reset                  # Reset to defaults
/config import my-config.json  # Import configuration
/config export current-config.json # Export configuration
```

### Environment Configuration
```bash
/config env set NODE_ENV production
/config env set CLAUDE_LOG_LEVEL debug
/config env set CLAUDE_MAX_MEMORY 1GB
/config env list                # List all environment variables
```

### Agent Configuration
```bash
/config agent enable code-reviewer
/config agent disable performance-engineer
/config agent set code-reviewer.strict true
/config agent list              # List all agents
```

### MCP Server Configuration
```bash
/config mcp set commands.port 3000
/config mcp set playwright.headless true
/config mcp enable git-mcp
/config mcp disable browser-mcp
```

---

## Utility Commands

### `/utils`
**Description:** Utility commands for various tasks

**Syntax:**
```
/utils <category> <action> [parameters]
```

**Categories:**
- `file`: File operations
- `network`: Network utilities
- `system`: System information
- `data`: Data manipulation
- `format`: Code formatting

**Examples:**
```bash
/utils file size large-file.zip    # Check file size
/utils network ping google.com     # Test connectivity
/utils system info                 # System information
/utils data convert json csv       # Convert data format
/utils format code --language js   # Format JavaScript code
```

### File Operations
```bash
/utils file list /home/user        # List directory contents
/utils file copy source.txt dest.txt # Copy file
/utils file move old.txt new.txt   # Move file
/utils file delete temp.txt        # Delete file
/utils file compress archive.zip   # Create archive
```

### Network Utilities
```bash
/utils network ping 8.8.8.8       # Ping IP address
/utils network traceroute google.com # Trace network path
/utils network speedtest          # Test internet speed
/utils network ports              # Check open ports
```

### System Information
```bash
/utils system cpu                 # CPU information
/utils system memory              # Memory usage
/utils system disk                # Disk usage
/utils system processes           # Running processes
/utils system services            # System services
```

### Data Manipulation
```bash
/utils data format json           # Format JSON data
/utils data validate xml          # Validate XML structure
/utils data convert csv json      # Convert CSV to JSON
/utils data compress gzip         # Compress data
```

### Code Formatting
```bash
/utils format js                  # Format JavaScript
/utils format python              # Format Python code
/utils format sql                 # Format SQL queries
/utils format markdown            # Format Markdown
```

---

## Command Reference Summary

### Quick Command Reference

| Command | Description | Example |
|---------|-------------|---------|
| `/help` | Show help | `/help agent` |
| `/status` | System status | `/status mcp` |
| `/memory` | Memory management | `/memory show` |
| `/todo` | Task management | `/todo list` |
| `/agent` | Agent operations | `/agent run code-reviewer` |
| `/mcp` | MCP server management | `/mcp start commands` |
| `/workflow` | Workflow management | `/workflow run sparc` |
| `/dev` | Development tools | `/dev build` |
| `/config` | Configuration | `/config show` |
| `/utils` | Utilities | `/utils file size` |

### Advanced Usage Examples

#### Complete Development Workflow
```bash
# Initialize project
/dev init full-stack-app

# Set up agents
/agent config code-reviewer --strict
/agent config performance-engineer --threshold 1000

# Create workflow
/workflow create "user-auth-feature"

# Run SPARC methodology
/workflow run specification "User authentication"
/workflow run pseudocode "Auth algorithm"
/workflow run architecture "Auth system"
/workflow run coding "Implement auth"
/workflow run review "Test auth"

# Deploy and monitor
/dev deploy production
/dev monitor
```

#### Multi-Agent Collaboration
```bash
# Start multiple agents
/agent run frontend-developer "Build UI components" &
/agent run backend-developer "Create API endpoints" &
/agent run database-admin "Design schema" &

# Coordinate with workflow
/workflow run "full-stack-integration"

# Monitor progress
/status agents
/workflow status "integration"
```

#### Performance Optimization
```bash
# Analyze current performance
/agent run performance-engineer "Analyze app performance"
/workflow run "performance-audit"

# Implement optimizations
/dev build optimized
/agent run performance-engineer "Validate improvements"

# Monitor results
/dev monitor performance
/utils system performance
```

This comprehensive command reference covers all available commands in the Claude Code ecosystem. Each command includes detailed syntax, parameters, examples, and use cases to help you effectively utilize the full power of the Claude Code platform.