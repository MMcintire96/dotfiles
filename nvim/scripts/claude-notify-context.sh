#!/bin/bash
# Get Claude session context for notifications

CACHE_FILE="${XDG_CACHE_HOME:-$HOME/.cache}/claude-nvim/session.json"

# Read working directory from cache
if [ -f "$CACHE_FILE" ] && command -v jq >/dev/null 2>&1; then
  cwd=$(jq -r '.workspace.current_dir // .cwd // ""' "$CACHE_FILE" 2>/dev/null)
  cwd_name=$(basename "$cwd" 2>/dev/null || echo "")

  # Get tmux pane info if in tmux
  if [ -n "$TMUX" ]; then
    pane=$(tmux display-message -p '#S:#I.#P' 2>/dev/null || echo "")
    context="📂 $cwd_name | 🖥️  $pane"
  else
    context="📂 $cwd_name"
  fi

  echo "$context"
else
  # Fallback: just show current directory
  if [ -n "$TMUX" ]; then
    pane=$(tmux display-message -p '#S:#I.#P' 2>/dev/null || echo "")
    echo "🖥️  $pane"
  else
    echo ""
  fi
fi
