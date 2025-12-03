-- Test script to run inside Neovim
-- Run with: :luafile %

print("=== Claude Statusline Debug ===")

-- Reload the module
package.loaded['claude-statusline'] = nil
local claude = require('claude-statusline')

-- Get debug info
local debug = claude.debug()

print("\nActive:", debug.active)
print("Model:", debug.model or "nil")
print("Cost:", debug.cost or "nil")

if debug.data then
  print("\nRaw Data:")
  print(vim.inspect(debug.data))
else
  print("\nNo data found")
end

-- Check cache files
local cache_dir = (vim.env.XDG_CACHE_HOME or vim.env.HOME .. '/.cache') .. '/claude-nvim'
print("\nCache directory:", cache_dir)

local ts_file = cache_dir .. '/last_update'
local f = io.open(ts_file, 'r')
if f then
  local ts = tonumber(f:read('*all'))
  f:close()
  local now = os.time()
  print("Timestamp:", ts)
  print("Current time:", now)
  print("Age:", now - ts, "seconds")
  print("Should be active:", (now - ts) < 5)
else
  print("Timestamp file not found!")
end

print("\n=== End Debug ===")
