# MCP Servers Configuration for Claude Code

This document explains how to configure and use the three best MCP servers for Playwright testing, coding assistance, and development tools integration with Claude Code.

## 1. Playwright MCP Server

The Playwright MCP server provides browser automation capabilities for testing and web interaction.

### Installation
```bash
cd ~/mcp-servers
git clone https://github.com/executeautomation/mcp-playwright.git
cd mcp-playwright
npm install
npx playwright install-deps
npx playwright install
```

### Usage with Claude Code
```bash
claude mcp add playwright-server "cd /home/azureuser/mcp-servers/mcp-playwright && npx playwright-mcp-server"
```

## 2. Filesystem MCP Server

The Filesystem MCP server provides access to files and directories for reading, writing, and searching.

### Installation
```bash
cd ~/mcp-servers/mcp-servers-official/src/filesystem
npm install
npm run build
```

### Usage with Claude Code
```bash
claude mcp add filesystem-server "cd /home/azureuser/mcp-servers/mcp-servers-official/src/filesystem && npx mcp-server-filesystem /home/azureuser"
```

## 3. Git MCP Server

The Git MCP server provides Git repository operations like status, diff, commit, etc.

### Installation
```bash
cd ~/mcp-servers
mkdir git-mcp-server
cd git-mcp-server
python3 -m venv venv
source venv/bin/activate
pip install gitpython mcp pydantic click
cp -r ~/mcp-servers/mcp-servers-official/src/git .
pip install -e ./git
```

### Usage with Claude Code
```bash
claude mcp add git-server "cd /home/azureuser/mcp-servers/git-mcp-server && source venv/bin/activate && python -m mcp_server_git"
```

## Managing MCP Servers

### List all configured servers
```bash
claude mcp list
```

### Remove a server
```bash
claude mcp remove server-name
```

### Get details about a server
```bash
claude mcp get server-name
```

## Testing the Servers

To test if the servers are working correctly, you can run them directly:

### Playwright Server
```bash
cd ~/mcp-servers/mcp-playwright
npx playwright-mcp-server
```

### Filesystem Server
```bash
cd ~/mcp-servers/mcp-servers-official/src/filesystem
npx mcp-server-filesystem /home/azureuser
```

### Git Server
```bash
cd ~/mcp-servers/git-mcp-server
source venv/bin/activate
python -m mcp_server_git
```