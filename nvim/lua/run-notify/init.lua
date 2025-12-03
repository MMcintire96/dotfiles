local M = {}

vim.notify = require("notify")

-- Configuration options
M.config = {
  enabled = true,
  notifications = {
    question = { enabled = true, icon = "🤔", urgency = "normal" },
    completion = { enabled = true, icon = "✅", urgency = "low" },
    tool_approval = { enabled = true, icon = "⚠️", urgency = "critical" },
    error = { enabled = false, icon = "❌", urgency = "critical" },
  },
}

-- Track last known state to avoid duplicate notifications
local last_state = {
  bufnr = nil,
  last_notified_state = nil, -- Track the last state we notified about
  last_notified_content = "", -- Track the content that triggered the notification
  last_notification = 0, -- timestamp of last notification
  notification_cooldown = 2000, -- ms between notifications
}

-- Debounce timer to prevent multiple rapid notifications
local debounce_timer = nil

-- Pattern matching for Claude states
local patterns = {
  question = {
    "?%s*$", -- Ends with question mark
    "Do you want",
    "Would you like",
    "Should I",
    "Can I",
    "May I",
    "Approve?",
    "Continue?",
  },
  tool_approval = {
    "Approve?",
    "Continue?",
    "permission to",
    "Allow me to",
    "proceed with",
  },
  error = {
    "Error:",
    "Failed:",
    "Exception:",
    "cannot",
    "EROR",
    "fatal:",
  },
  completion = {
    "Done",
    "Completed",
    "Finished",
    "✓",
    "✔",
  },
}

-- Check if a line matches any pattern in a category
local function matches_pattern(line, category)
  if not patterns[category] then
    return false
  end

  for _, pattern in ipairs(patterns[category]) do
    if line:match(pattern) then
      return true
    end
  end
  return false
end

-- Get tmux session information
local function get_tmux_info()
  if vim.env.TMUX then
    local session = vim.fn.system("tmux display-message -p '#S'"):gsub("\n", "")
    local window = vim.fn.system("tmux display-message -p '#W'"):gsub("\n", "")
    return string.format("[%s:%s]", session, window)
  end
  return ""
end

-- Send system notification using notify-send
local function send_system_notification(title, message, urgency, icon)
  -- Check if notify-send is available
  if vim.fn.executable("notify-send") == 0 then
    return
  end

  -- Add tmux session info to title if available
  local tmux_info = get_tmux_info()
  if tmux_info ~= "" then
    title = title .. " " .. tmux_info
  end

  local cmd = string.format(
    "notify-send -u %s -i dialog-information '%s' '%s'",
    urgency or "normal",
    icon and (icon .. " " .. title) or title,
    message:gsub("'", "'\\''") -- Escape single quotes
  )

  vim.fn.jobstart(cmd, { detach = true })
end

-- Check if user is viewing the current pane
-- Returns: "same_pane" | "different_pane" | "different_window"
local function get_focus_state()
  if not vim.env.TMUX then
    -- Not in tmux, use xdotool to check window focus
    local result = vim.fn.system("xdotool getactivewindow getwindowname 2>/dev/null")
    if result and (result:match("nvim") or result:match("NVIM")) then
      return "same_pane"
    else
      return "different_window"
    end
  end

  -- In tmux - check if user is in the same pane
  local current_pane = vim.fn.system("tmux display-message -p '#{pane_id}'"):gsub("\n", "")

  -- Get the active (focused) pane
  local active_pane = vim.fn.system("tmux display-message -p -t '{marked}' '#{pane_id}' 2>/dev/null || tmux list-panes -F '#{?pane_active,#{pane_id},}' | grep -v '^$'"):gsub("\n", "")

  if current_pane == active_pane then
    return "same_pane"
  else
    return "different_pane"
  end
end

-- Detect Claude state from buffer content
local function detect_claude_state(bufnr)
  -- Get the last few lines of the buffer
  local line_count = vim.api.nvim_buf_line_count(bufnr)
  local start_line = math.max(0, line_count - 20) -- Check last 20 lines
  local lines = vim.api.nvim_buf_get_lines(bufnr, start_line, -1, false)

  -- Join lines to analyze
  local content = table.concat(lines, "\n")

  -- Check for different states (order matters - more specific first)
  if matches_pattern(content, "tool_approval") then
    return "tool_approval", "Claude needs approval to proceed"
  elseif matches_pattern(content, "error") then
    return "error", "Claude encountered an error"
  elseif matches_pattern(content, "question") then
    return "question", "Claude is asking a question"
  elseif matches_pattern(content, "completion") then
    return "completion", "Claude finished the task"
  end

  return nil, nil
end

-- Monitor a specific buffer for changes
local function monitor_buffer(bufnr)
  if not M.config.enabled then
    return
  end

  -- Don't monitor if this isn't a Sidekick/terminal buffer
  local bufname = vim.api.nvim_buf_get_name(bufnr)
  if not (bufname:match("sidekick") or bufname:match("claude") or bufname:match("term://")) then
    return
  end

  -- Detect Claude state
  local state, message = detect_claude_state(bufnr)

  if state and M.config.notifications[state] and M.config.notifications[state].enabled then
    -- Get last few lines to create a content fingerprint
    local line_count = vim.api.nvim_buf_line_count(bufnr)
    local start_line = math.max(0, line_count - 5) -- Last 5 lines
    local lines = vim.api.nvim_buf_get_lines(bufnr, start_line, -1, false)
    local content_fingerprint = table.concat(lines, "\n")

    -- Check if this is a duplicate notification
    -- Don't notify if we've already notified about this exact state and similar content
    if last_state.last_notified_state == state and
       last_state.last_notified_content == content_fingerprint then
      return
    end

    -- Check cooldown for different states
    local now = vim.loop.now()
    if now - last_state.last_notification < last_state.notification_cooldown then
      return
    end

    -- Update tracking FIRST to prevent race conditions
    last_state.last_notification = now
    last_state.last_notified_state = state
    last_state.last_notified_content = content_fingerprint

    local notif_config = M.config.notifications[state]

    -- Always send system notification regardless of focus state
    send_system_notification("Claude Code", message, notif_config.urgency, notif_config.icon)
  end
end

-- Debounced monitor function that cancels previous pending calls
local function monitor_buffer_debounced(bufnr, delay)
  -- Cancel any existing timer
  if debounce_timer then
    debounce_timer:stop()
    debounce_timer:close()
    debounce_timer = nil
  end

  -- Create new timer
  debounce_timer = vim.loop.new_timer()
  debounce_timer:start(delay or 500, 0, vim.schedule_wrap(function()
    if vim.api.nvim_buf_is_valid(bufnr) then
      monitor_buffer(bufnr)
    end
    if debounce_timer then
      debounce_timer:close()
      debounce_timer = nil
    end
  end))
end

-- Setup function to initialize monitoring
M.setup = function(options)
  -- Merge user options with defaults
  M.config = vim.tbl_deep_extend("force", M.config, options or {})

  -- Set up autocmds to monitor Sidekick buffers
  vim.api.nvim_create_augroup("ClaudeNotifications", { clear = true })

  -- Monitor terminal buffer changes
  vim.api.nvim_create_autocmd({ "TermOpen", "TermEnter" }, {
    group = "ClaudeNotifications",
    callback = function(args)
      local bufnr = args.buf

      -- Set up buffer monitoring with a timer
      local timer = vim.loop.new_timer()
      timer:start(
        1000, -- Start after 1 second
        2000, -- Check every 2 seconds
        vim.schedule_wrap(function()
          if vim.api.nvim_buf_is_valid(bufnr) then
            monitor_buffer(bufnr)
          else
            timer:stop()
            timer:close()
          end
        end)
      )
    end,
  })

  -- Also monitor on buffer text changes (for faster detection)
  vim.api.nvim_create_autocmd({ "TextChanged", "TextChangedI" }, {
    group = "ClaudeNotifications",
    pattern = "term://*",
    callback = function(args)
      -- Use debounced monitor to prevent duplicate notifications
      monitor_buffer_debounced(args.buf, 500)
    end,
  })
end

-- Manual trigger for testing
M.test = function()
  -- Force send a test notification bypassing all checks
  send_system_notification(
    "Claude Code",
    "Test notification - system is working!",
    "normal",
    "🧪"
  )
end

-- Enable/disable notifications
M.enable = function()
  M.config.enabled = true
  vim.notify("Claude notifications enabled", vim.log.levels.INFO)
end

M.disable = function()
  M.config.enabled = false
  vim.notify("Claude notifications disabled", vim.log.levels.INFO)
end

-- Toggle specific notification types
M.toggle = function(notification_type)
  if M.config.notifications[notification_type] then
    M.config.notifications[notification_type].enabled = not M.config.notifications[notification_type].enabled
    local status = M.config.notifications[notification_type].enabled and "enabled" or "disabled"
    vim.notify(string.format("Claude %s notifications %s", notification_type, status), vim.log.levels.INFO)
  end
end

return M
