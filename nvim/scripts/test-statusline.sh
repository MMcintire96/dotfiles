#!/bin/bash
# Test script to simulate Claude updating the statusline

echo "Simulating Claude session..."
echo '{"model":"claude-sonnet-4-5-20250929","cwd":"'"$(pwd)"'","cost":{"current":{"total":0.0523,"inputTokens":12450,"outputTokens":3890}}}' | \
  /home/michael/.config/nvim/scripts/claude-statusline-bridge.sh

echo -e "\n✅ Cache updated. Now check your Neovim statusline!"
echo "The cache will be considered 'active' for 5 seconds."
echo ""
echo "Cache location: ~/.cache/claude-nvim/"
ls -lh ~/.cache/claude-nvim/
