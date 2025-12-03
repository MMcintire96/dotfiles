#!/bin/bash
# Claude Code Statusline Bridge
# This script receives Claude's JSON session data via stdin and:
# 1. Writes it to a cache file for Neovim to read
# 2. Outputs nothing to Claude (info displayed in Neovim statusline instead)

# Cache directory
CACHE_DIR="${XDG_CACHE_HOME:-$HOME/.cache}/claude-nvim"
CACHE_FILE="$CACHE_DIR/session.json"

# Ensure cache directory exists
mkdir -p "$CACHE_DIR"

# Read JSON from stdin
json=$(cat)

# Write to cache file for Neovim to read
echo "$json" > "$CACHE_FILE"
# Update timestamp
date +%s > "$CACHE_DIR/last_update"

# Don't output anything to Claude's statusline
# (The info is displayed in Neovim's lualine instead)
