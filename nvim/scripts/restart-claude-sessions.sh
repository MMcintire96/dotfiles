#!/bin/bash
# Script to restart existing Claude tmux sessions with the wrapper script
# and attempt to resume Claude CLI sessions

WRAPPER_SCRIPT="$HOME/.config/nvim/scripts/claude-wrapper.sh"

echo "🔍 Looking for tmux sessions running Claude..."

# Find all tmux sessions/panes running claude
tmux list-panes -a -F "#{session_name}:#{window_index}.#{pane_index} #{pane_current_command} #{pane_current_path} #{pane_pid}" | while read -r line; do
    pane_id=$(echo "$line" | awk '{print $1}')
    command=$(echo "$line" | awk '{print $2}')
    pane_path=$(echo "$line" | awk '{print $3}')
    pane_pid=$(echo "$line" | awk '{print $4}')

    # Check if this pane is running claude
    if [[ "$command" == "claude" ]] || ps -p "$pane_pid" -o command= 2>/dev/null | grep -q "claude"; then
        echo ""
        echo "📍 Found Claude session in pane: $pane_id"
        echo "   Working directory: $pane_path"
        echo "   PID: $pane_pid"

        # Ask for confirmation
        read -p "   Restart this session with wrapper? (y/N): " -n 1 -r
        echo

        if [[ $REPLY =~ ^[Yy]$ ]]; then
            echo "   🔄 Restarting session..."

            # Send Ctrl-C to stop the current Claude process
            tmux send-keys -t "$pane_id" C-c
            sleep 0.5

            # Clear the pane
            tmux send-keys -t "$pane_id" "clear" C-m
            sleep 0.3

            # Change to the original working directory
            tmux send-keys -t "$pane_id" "cd '$pane_path'" C-m
            sleep 0.2

            # Start Claude with the wrapper script and --resume flag
            echo "   ▶️  Starting: $WRAPPER_SCRIPT --resume"
            tmux send-keys -t "$pane_id" "$WRAPPER_SCRIPT --resume" C-m

            echo "   ✅ Session restarted!"
        else
            echo "   ⏭️  Skipped."
        fi
    fi
done

echo ""
echo "✨ Done checking Claude sessions!"
echo ""
echo "💡 Tip: Future Claude sessions opened via Neovim (<C-.> or <leader>ai)"
echo "   will automatically use the wrapper script."
