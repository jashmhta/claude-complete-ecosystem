# Claude Development Tools Setup

This document provides a comprehensive guide to all the Claude development tools configured in your environment.

## Overview

Your development environment now includes:

1. **82 Specialized AI Agents** - Domain-specific expertise across software development
2. **Claude Code Workflows** - Automated code review, security review, and design review systems
3. **Pocket Server** - Mobile OS for AI agents with HTTP/WebSocket APIs
4. **Microsoft Playwright MCP** - Browser automation capabilities
5. **Codex CLI** - OpenAI's command-line interface with MCP support
6. **Claude Code Guide** - Best practices and patterns

## Directory Structure

```
/home/azureuser/
├── .claude/
│   ├── agents/           # 82 specialized AI agents
│   ├── workflows/        # Automated review workflows
│   └── guides/           # Claude Code best practices
├── .codex/
│   └── config.toml       # Codex CLI configuration
├── claude-dev-tools/     # Source repositories
│   ├── agents/
│   ├── claude-code-workflows/
│   ├── pocket-server/
│   ├── claude-code-guide/
│   └── playwright-mcp/
└── mcp-servers/          # Existing MCP servers
```

## 1. AI Agents (82 Specialized Agents)

### Location: `~/.claude/agents/`

The agents are automatically available to Claude Code. They provide domain-specific expertise across:

#### Architecture & System Design
- `backend-architect` - RESTful API design, microservices
- `frontend-developer` - React components, responsive layouts
- `cloud-architect` - AWS/Azure/GCP infrastructure design
- `kubernetes-architect` - Cloud-native infrastructure

#### Programming Languages
- `javascript-pro`, `typescript-pro` - Modern web development
- `python-pro`, `java-pro`, `csharp-pro` - Enterprise development
- `rust-pro`, `golang-pro` - Systems programming
- `mobile-developer`, `ios-developer` - Mobile development

#### Quality & Security
- `code-reviewer` - Security-focused code review
- `security-auditor` - Vulnerability assessment
- `test-automator` - Comprehensive test suites
- `performance-engineer` - Application optimization

#### Data & AI
- `ai-engineer` - LLM applications, RAG systems
- `ml-engineer` - ML pipelines, model serving
- `data-scientist` - Data analysis, SQL queries

### Usage Examples

```bash
# Automatic delegation (recommended)
"Implement user authentication" → Claude selects appropriate agents

# Explicit invocation
"Use code-reviewer to analyze the recent changes"
"Have security-auditor scan for vulnerabilities"
"Get performance-engineer to optimize this bottleneck"
```

## 2. Claude Code Workflows

### Location: `~/.claude/workflows/`

#### Code Review Workflow
- Automated code review system with dual-loop architecture
- GitHub Actions integration for PR reviews
- Syntax, completeness, style guide adherence

#### Security Review Workflow
- Proactive vulnerability identification
- OWASP Top 10 compliance checking
- Severity-classified findings with remediation

#### Design Review Workflow
- Front-end code change feedback
- UI/UX consistency validation
- Accessibility compliance checking

### Setup GitHub Actions

Copy workflow files to your repository's `.github/workflows/` directory:

```bash
cp ~/.claude/workflows/code-review/.github/workflows/* your-repo/.github/workflows/
cp ~/.claude/workflows/security-review/.github/workflows/* your-repo/.github/workflows/
```

## 3. Pocket Server

### Location: `~/claude-dev-tools/pocket-server/`

Pocket Server provides mobile OS capabilities for AI agents:

- **Agent runtime**: Approve or auto-run coding agents
- **Native mobile terminal**: Touch-optimized, multi-tab sessions
- **File system + editor**: Browse, view, edit files from phone
- **Background agents**: Launch autonomous coding jobs on VMs
- **Security**: Local-only PIN pairing, short-lived tokens

### Quick Start

```bash
# Start Pocket Server
cd ~/claude-dev-tools/pocket-server
npm start

# Or use the installed CLI (if available)
pocket-server start
```

### Mobile App Setup

1. Install Pocket mobile app:
   - iOS (TestFlight): https://testflight.apple.com/join/ZHNpHgwd
   - Website: https://www.pocket-agent.xyz

2. Pair your device:
   ```bash
   pocket-server pair  # Shows 6-digit PIN
   ```

3. Connect from mobile app using the PIN

## 4. Microsoft Playwright MCP

### Location: `~/claude-dev-tools/playwright-mcp/`

Browser automation capabilities using Playwright:

- **Fast and lightweight**: Uses accessibility tree, not screenshots
- **LLM-friendly**: No vision models needed
- **Deterministic**: Avoids ambiguity of screenshot-based approaches

### Configuration

Already configured in:
- **Claude Code**: `claude mcp add playwright-microsoft`
- **Codex CLI**: Added to `~/.codex/config.toml`

### Usage

The Playwright MCP server provides tools for:
- Page navigation and interaction
- Form filling and element clicking
- Screenshot capture
- JavaScript evaluation
- Network request monitoring

## 5. Codex CLI

### Location: `~/.codex/`

OpenAI's command-line interface with MCP support:

- **Model**: `gpt-5-codex`
- **Trusted projects**: All your development directories
- **MCP servers**: Playwright integration configured

### Usage

```bash
# Start Codex CLI
codex

# Use with MCP servers
codex --mcp-playwright "Take a screenshot of google.com"
```

## 6. Claude Code Guide

### Location: `~/.claude/guides/`

Best practices and patterns for Claude Code development.

## Integration Scripts

### Quick Setup Script

```bash
#!/bin/bash
# ~/claude-dev-tools/setup-all.sh

echo "🚀 Setting up Claude Development Tools..."

# Start Pocket Server
echo "📱 Starting Pocket Server..."
cd ~/claude-dev-tools/pocket-server
npm start &

# List available agents
echo "🤖 Available AI Agents:"
ls ~/.claude/agents/ | head -10
echo "... and $(ls ~/.claude/agents/ | wc -l) total agents"

# Show MCP servers
echo "🔌 Configured MCP Servers:"
claude mcp list

echo "✅ Setup complete! All tools are ready to use."
```

### Agent Quick Reference

```bash
#!/bin/bash
# ~/claude-dev-tools/agent-reference.sh

echo "🤖 Claude AI Agents Quick Reference"
echo "=================================="

echo "Architecture & Design:"
echo "  backend-architect, frontend-developer, cloud-architect"
echo "  kubernetes-architect, graphql-architect"

echo "Programming Languages:"
echo "  javascript-pro, typescript-pro, python-pro, java-pro"
echo "  rust-pro, golang-pro, csharp-pro"

echo "Quality & Security:"
echo "  code-reviewer, security-auditor, test-automator"
echo "  performance-engineer, debugger"

echo "Data & AI:"
echo "  ai-engineer, ml-engineer, data-scientist"
echo "  prompt-engineer"

echo "Business & Operations:"
echo "  business-analyst, content-marketer, customer-support"
echo "  legal-advisor, hr-pro"

echo ""
echo "Usage: 'Use [agent-name] to [task description]'"
```

## Environment Variables

Set these for optimal performance:

```bash
# Pocket Server
export OPENAI_API_KEY="your-openai-key"
export ANTHROPIC_API_KEY="your-anthropic-key"

# Playwright MCP
export PLAYWRIGHT_BROWSERS_PATH="/home/azureuser/.cache/ms-playwright"
```

## Troubleshooting

### Agents Not Activating
- Ensure request clearly indicates the domain
- Be specific about task type and requirements
- Use explicit invocation: "Use [agent-name] to..."

### MCP Server Issues
```bash
# Check MCP server status
claude mcp list

# Test Playwright MCP
cd ~/claude-dev-tools/playwright-mcp
npx playwright-mcp
```

### Pocket Server Connection Issues
- Ensure both devices are on the same Wi-Fi/LAN
- Check firewall allows inbound connections (port 3000)
- Try different port: `pocket-server start --port 3010`

## Best Practices

1. **Automatic Delegation**: Let Claude Code analyze context and select optimal agents
2. **Clear Requirements**: Specify constraints, tech stack, and quality standards
3. **Multi-Agent Workflows**: Use high-level requests for complex multi-step tasks
4. **Security**: Keep API keys secure and use local-only pairing for Pocket Server

## Resources

- [Claude Code Documentation](https://docs.anthropic.com/en/docs/claude-code)
- [Playwright MCP GitHub](https://github.com/microsoft/playwright-mcp)
- [Pocket Server Documentation](https://www.pocket-agent.xyz)
- [Codex CLI Documentation](https://github.com/openai/codex)

---

**Setup completed successfully!** 🎉

All tools are now configured and ready for efficient development with Claude Code and Codex CLI.