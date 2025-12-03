# Claude Code Statusline Integration

This integration shows Claude Code session information in your Neovim lualine statusbar.

## What Gets Displayed

When a Claude Code session is active, you'll see:
- 🧠 **Model**: Current Claude model (e.g., "son-4-5" for Sonnet 4.5)
- 💰 **Cost**: Session cost (e.g., "$0.123")
- 📊 **Token Usage**: Context usage percentage (only shown if > 50%)

All components:
- Appear automatically when Claude is active
- Disappear when no session is running
- Update every 1 second
- Use color coding (red for high token usage, yellow/blue otherwise)

## Setup Instructions

### 1. Configure Claude Code

Add this to your `~/.claude/settings.json`:

```json
{
  "statusLine": {
    "type": "command",
    "command": "/home/michael/.config/nvim/scripts/claude-statusline-bridge.sh"
  }
}
```

If you already have a `statusLine` configuration, replace it with the above.

### 2. Reload Neovim

Close and reopen Neovim, or run:
```vim
:source %
```

### 3. Test It

1. Start a Claude Code session in your terminal:
   ```bash
   claude
   ```

2. Send a message to Claude

3. Switch to your Neovim window - you should see Claude session info in the statusline!

## How It Works

```
┌─────────────────────────────────────────────────────────────┐
│ Claude Code CLI                                             │
│ ├─ Sends session JSON to statusline script every update    │
│ └─ Gets formatted statusline back                           │
└─────────────────────────────────────────────────────────────┘
                           │
                           ▼
┌─────────────────────────────────────────────────────────────┐
│ Bridge Script (claude-statusline-bridge.sh)                 │
│ ├─ Writes JSON to: ~/.cache/claude-nvim/session.json       │
│ ├─ Updates timestamp: ~/.cache/claude-nvim/last_update     │
│ └─ Returns formatted statusline to Claude                   │
└─────────────────────────────────────────────────────────────┘
                           │
                           ▼
┌─────────────────────────────────────────────────────────────┐
│ Neovim (lua/claude-statusline.lua)                          │
│ ├─ Reads cached JSON every 1 second                         │
│ ├─ Checks if session is active (< 5 seconds old)           │
│ └─ Updates lualine components                               │
└─────────────────────────────────────────────────────────────┘
```

## Customization

### Show Different Information

Edit `lua/plugin-config.lua` around line 120. You can:

**Add the indicator** (just shows 🤖 when Claude is active):
```lua
lualine_x = {
  require('claude-statusline').lualine_indicator(),  -- Simple emoji
  -- ... rest
}
```

**Show only cost**:
```lua
lualine_x = {
  require('claude-statusline').lualine_cost(),
  -- ... rest
}
```

**Show all info**:
```lua
lualine_x = {
  require('claude-statusline').lualine_model(),
  require('claude-statusline').lualine_cost(),
  require('claude-statusline').lualine_tokens(),
  -- ... rest
}
```

### Change Colors

Edit `lua/claude-statusline.lua`:
- Model: `color = { fg = '#61afef' }` (line ~144)
- Cost: `color = { fg = '#e5c07b' }` (line ~152)
- Tokens: High usage `fg = '#e06c75'`, moderate `fg = '#e5c07b'` (lines ~166-167)

### Change Update Frequency

Edit `lua/claude-statusline.lua` line 11:
```lua
local check_interval = 1  -- Check every 1 second (change this)
```

### Change Session Timeout

Edit `lua/claude-statusline.lua` line 26:
```lua
return (os.time() - timestamp) < 5  -- Consider active if < 5 seconds old
```

## Troubleshooting

### Statusline not showing?

1. **Check if bridge script is executable**:
   ```bash
   ls -la ~/.config/nvim/scripts/claude-statusline-bridge.sh
   ```
   Should show: `-rwxr-xr-x`

2. **Check if Claude is writing the cache**:
   ```bash
   cat ~/.cache/claude-nvim/session.json
   ```
   Should show JSON with model, cost, etc.

3. **Check timestamp**:
   ```bash
   cat ~/.cache/claude-nvim/last_update
   date +%s
   ```
   The difference should be < 5 seconds when Claude is active

4. **Test the bridge script manually**:
   ```bash
   echo '{"model":"claude-sonnet-4-5","cwd":"/home/user","cost":{"current":{"total":0.05}}}' | \
     ~/.config/nvim/scripts/claude-statusline-bridge.sh
   ```
   Should output a formatted statusline and create the cache file

5. **Check Neovim errors**:
   ```vim
   :messages
   ```

### Bridge script not working?

Install `jq` for better JSON parsing:
```bash
sudo pacman -S jq  # Arch Linux
```

Without `jq`, the script uses basic grep parsing (less features).

## Files Created

- `~/.config/nvim/scripts/claude-statusline-bridge.sh` - Bridge script
- `~/.config/nvim/lua/claude-statusline.lua` - Neovim module
- `~/.cache/claude-nvim/session.json` - Cached session data
- `~/.cache/claude-nvim/last_update` - Timestamp of last update
- `~/.config/nvim/lua/plugin-config.lua` - Updated with lualine components
