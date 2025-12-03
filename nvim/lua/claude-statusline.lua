-- Claude Code Statusline Integration
-- Reads Claude session data and provides it to lualine

local M = {}

-- Cache directory
local cache_dir = (vim.env.XDG_CACHE_HOME or vim.env.HOME .. '/.cache') .. '/claude-nvim'
local session_file = cache_dir .. '/session.json'
local timestamp_file = cache_dir .. '/last_update'

-- Cached data
local cached_data = nil
local last_check = 0
local check_interval = 1 -- Check every 1 second

-- Check if file exists and is recent
local function is_session_active()
  local f = io.open(timestamp_file, 'r')
  if not f then return false end

  local timestamp = tonumber(f:read('*all'))
  f:close()

  if not timestamp then return false end

  -- Consider session active if updated within last 60 seconds
  -- Claude only updates while responding, so we use a longer timeout
  return (os.time() - timestamp) < 60
end

-- Read and parse session JSON
local function read_session_data()
  local now = os.time()

  -- Rate limit checks
  if now - last_check < check_interval then
    return cached_data
  end
  last_check = now

  -- Check if session is active
  if not is_session_active() then
    cached_data = nil
    return nil
  end

  -- Read session file
  local f = io.open(session_file, 'r')
  if not f then
    cached_data = nil
    return nil
  end

  local content = f:read('*all')
  f:close()

  -- Parse JSON (simple parser for our needs)
  local ok, decoded = pcall(vim.json.decode, content)
  if ok and decoded then
    cached_data = decoded
    return decoded
  end

  cached_data = nil
  return nil
end

-- Get model name (shortened)
function M.get_model()
  local data = read_session_data()
  if not data or not data.model then return nil end

  -- Use display_name if available, otherwise parse id
  local model = data.model.display_name or data.model.id or data.model
  -- Shorten model name
  model = model:gsub('anthropic%.', '')
  model = model:gsub('claude%-', '')
  model = model:gsub('[Ss]onnet', 'Son')
  model = model:gsub('[Oo]pus', 'Opus')
  model = model:gsub('[Hh]aiku', 'Hai')

  return '🧠 ' .. model
end

-- Get session cost
function M.get_cost()
  local data = read_session_data()
  if not data or not data.cost then return nil end

  local cost = data.cost.total_cost_usd
  if not cost or cost == 0 then return nil end

  return string.format('💰$%.3f', cost)
end

-- Get token usage percentage
function M.get_token_usage()
  local data = read_session_data()
  if not data then return nil end

  -- Check if exceeds 200k tokens
  if data.exceeds_200k_tokens then
    return '📊>200k'
  end

  -- Claude doesn't provide token count in statusline JSON
  -- So we can't calculate percentage
  return nil
end

-- Get working directory from Claude
function M.get_cwd()
  local data = read_session_data()
  if not data or not data.cwd then return nil end

  local cwd = data.cwd
  -- Get basename
  local basename = vim.fn.fnamemodify(cwd, ':t')

  return '📁 ' .. basename
end

-- Check if Claude session is active
function M.is_active()
  return is_session_active()
end

-- Get session indicator
function M.get_indicator()
  if not is_session_active() then return nil end
  return '🤖'
end

-- Lualine component: Claude model
function M.lualine_model()
  return {
    M.get_model,
    cond = M.is_active,
    color = { fg = '#61afef' }, -- Blue
  }
end

-- Lualine component: Session cost
function M.lualine_cost()
  return {
    M.get_cost,
    cond = function() return M.get_cost() ~= nil end,
    color = { fg = '#e5c07b' }, -- Yellow
  }
end

-- Lualine component: Token usage
function M.lualine_tokens()
  return {
    M.get_token_usage,
    cond = function() return M.get_token_usage() ~= nil end,
    color = function()
      local usage_str = M.get_token_usage()
      if not usage_str then return { fg = '#98c379' } end

      local pct = tonumber(usage_str:match('(%d+)%%'))
      if pct and pct > 80 then
        return { fg = '#e06c75' } -- Red for high usage
      else
        return { fg = '#e5c07b' } -- Yellow for moderate usage
      end
    end,
  }
end

-- Lualine component: Simple indicator
function M.lualine_indicator()
  return {
    M.get_indicator,
    cond = M.is_active,
    color = { fg = '#98c379' }, -- Green
  }
end

-- Debug function to expose internal data
function M.debug()
  local data = read_session_data()
  return {
    active = is_session_active(),
    data = data,
    model = M.get_model(),
    cost = M.get_cost(),
  }
end

return M
