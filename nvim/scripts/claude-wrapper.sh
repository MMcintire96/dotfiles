#!/bin/bash
# Claude CLI wrapper script for proper terminal resize handling
# This ensures Claude CLI properly responds to terminal size changes in tmux/Neovim

# Get the actual claude command path
CLAUDE_BIN=$(which claude)

if [ -z "$CLAUDE_BIN" ]; then
    echo "Error: claude command not found in PATH"
    exit 1
fi

# Ensure we have proper terminal dimensions before starting
if [ -n "$TMUX" ]; then
    eval "$(tmux display-message -p 'COLUMNS=#{pane_width};LINES=#{pane_height}')"
    export COLUMNS LINES

    # Force terminal to recognize size changes
    stty columns "$COLUMNS" rows "$LINES" 2>/dev/null || true
fi

# Exec directly into Claude, replacing this wrapper process
# This ensures Claude has full foreground terminal access
exec "$CLAUDE_BIN" "$@"
