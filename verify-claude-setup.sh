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
claude mcp list 2>/dev/null || echo "Could not list MCP servers"

# Check directories
echo "📁 Directory Structure:"
ls -la /home/'$CURRENT_USER' | grep -E "(mcp|claude|CLAUDE)" || echo "No Claude directories found"

# Check key files
echo "📄 Key Files:"
ls -la /home/'$CURRENT_USER'/CLAUDE.md /home/'$CURRENT_USER'/COMPREHENSIVE_CLAUDE_CODE_GUIDE.md /home/'$CURRENT_USER'/start-claude.sh 2>/dev/null || echo "Some key files missing"

echo "🎉 Verification complete!"
