#!/bin/bash

# MCP Services Startup Script
# Starts all working MCP servers as persistent background services

echo "🚀 Starting MCP Services..."

# Function to start a service in background
start_service() {
    local name=$1
    local command=$2
    local log_file="/tmp/mcp-${name}.log"

    echo "Starting $name..."
    nohup bash -c "$command" > "$log_file" 2>&1 &
    echo "$name started (PID: $!, Log: $log_file)"
}

# Start Byterover MCP Server
start_service "byterover" "cd /home/azureuser/mcp-analysis/byterover-mcp && ./venv/bin/python mcp_server.py"

# Start Git MCP Server
start_service "git" "cd /home/azureuser/mcp-servers/git-mcp-server && ./venv/bin/python -m mcp_server_git"

# Start Filesystem MCP Server
start_service "filesystem" "cd /home/azureuser/mcp-servers/mcp-servers-official/src/filesystem && npx mcp-server-filesystem /home/azureuser"

# Start Apify MCP Server (if available)
if [ -d "/home/azureuser/mcp-analysis/apify-mcp-server" ]; then
    cd /home/azureuser/mcp-analysis/apify-mcp-server
    if npm list > /dev/null 2>&1; then
        start_service "apify" "cd /home/azureuser/mcp-analysis/apify-mcp-server && npm run start:dev"
    fi
fi

echo ""
echo "✅ MCP Services Started!"
echo "Check logs in /tmp/ for any issues"
echo "Use 'claude mcp list' to verify connections"