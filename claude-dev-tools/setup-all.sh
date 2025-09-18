#!/bin/bash
# Claude Development Tools Setup Script

echo "🚀 Setting up Claude Development Tools..."
echo "========================================"

# Check if we're in the right directory
if [ ! -d "/home/azureuser/claude-dev-tools" ]; then
    echo "❌ Please run this script from /home/azureuser/claude-dev-tools"
    exit 1
fi

# Start Pocket Server in background
echo "📱 Starting Pocket Server..."
cd /home/azureuser/claude-dev-tools/pocket-server
if [ -f "package.json" ]; then
    echo "   Starting Pocket Server (background process)..."
    npm start > /dev/null 2>&1 &
    POCKET_PID=$!
    echo "   Pocket Server started with PID: $POCKET_PID"
else
    echo "   ⚠️  Pocket Server package.json not found"
fi

# List available agents
echo ""
echo "🤖 Available AI Agents:"
echo "======================"
AGENT_COUNT=$(ls /home/azureuser/.claude/agents/ | wc -l)
echo "Total agents installed: $AGENT_COUNT"
echo ""
echo "Sample agents:"
ls /home/azureuser/.claude/agents/ | head -10 | sed 's/^/  /'
if [ $AGENT_COUNT -gt 10 ]; then
    echo "  ... and $((AGENT_COUNT - 10)) more agents"
fi

# Show MCP servers
echo ""
echo "🔌 Configured MCP Servers:"
echo "========================="
if command -v claude >/dev/null 2>&1; then
    claude mcp list
else
    echo "  Claude CLI not found in PATH"
fi

# Show Codex configuration
echo ""
echo "⚙️  Codex CLI Configuration:"
echo "============================"
if [ -f "/home/azureuser/.codex/config.toml" ]; then
    echo "  Config file: /home/azureuser/.codex/config.toml"
    echo "  Model: $(grep 'model =' /home/azureuser/.codex/config.toml | cut -d'"' -f2)"
    echo "  MCP Servers configured: $(grep -c '\[mcp_servers' /home/azureuser/.codex/config.toml)"
else
    echo "  Codex config not found"
fi

# Show workflows
echo ""
echo "🔄 Available Workflows:"
echo "======================="
if [ -d "/home/azureuser/.claude/workflows" ]; then
    ls /home/azureuser/.claude/workflows/ | sed 's/^/  /'
else
    echo "  No workflows found"
fi

echo ""
echo "✅ Setup complete! All tools are ready to use."
echo ""
echo "📖 Next steps:"
echo "  1. Read the full documentation: cat ~/CLAUDE_DEV_TOOLS_SETUP.md"
echo "  2. Try an agent: 'Use code-reviewer to analyze my code'"
echo "  3. Start Pocket Server: cd ~/claude-dev-tools/pocket-server && npm start"
echo "  4. Use Codex CLI: codex"
echo ""
echo "🎉 Happy coding with Claude!"