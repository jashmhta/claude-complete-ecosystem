#!/bin/bash

echo "🚀 Starting MCP Servers as Background Services..."
echo "================================================="

# Function to start MCP server in background with proper stdio handling
start_mcp_server() {
    local name=$1
    local command=$2
    local log_file="/tmp/mcp-${name}.log"

    echo "Starting $name MCP Server..."

    # Start the server in background with proper stdio handling
    nohup bash -c "$command" > "$log_file" 2>&1 < /dev/null &
    local pid=$!

    # Wait a moment for server to start
    sleep 2

    # Check if process is still running
    if kill -0 $pid 2>/dev/null; then
        echo "✅ $name MCP Server started successfully (PID: $pid)"
        echo "   Log file: $log_file"
    else
        echo "❌ $name MCP Server failed to start"
        echo "   Check log: $log_file"
    fi
}

# Start Byterover MCP Server
start_mcp_server "byterover" "cd /home/azureuser/mcp-analysis/byterover-mcp && ./venv/bin/python mcp_server.py"

# Start Filesystem MCP Server
start_mcp_server "filesystem" "cd /home/azureuser/mcp-servers/mcp-servers-official/src/filesystem && npx mcp-server-filesystem /home/azureuser"

# Start Git MCP Server
start_mcp_server "git" "cd /home/azureuser/mcp-servers/git-mcp-server && ./venv/bin/python -m mcp_server_git"

echo ""
echo "🎯 MCP Servers Started!"
echo "Test with: claude mcp list"
echo "Or use: claude 'Use MCP tools to analyze files'"