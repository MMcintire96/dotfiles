-- Voice conversation and speech-to-text for Claude Code
-- 1. Triggers Claude Code's voice conversation mode (voicemode MCP)
-- 2. Captures speech, transcribes to text, and sends to Claude

local M = {}

-- Configuration
M.config = {
  whisper_endpoint = os.getenv("WHISPER_ENDPOINT") or "http://localhost:2022/v1/audio/transcriptions",
  record_duration = 10, -- max seconds to record
}

-- Find Claude Code terminal buffer
function M.find_claude_terminal()
  for _, bufnr in ipairs(vim.api.nvim_list_bufs()) do
    if vim.bo[bufnr].buftype == "terminal" then
      local bufname = vim.api.nvim_buf_get_name(bufnr)
      -- Check if it's a Claude Code terminal
      if bufname:match("claude") or bufname:match("sidekick") then
        return bufnr
      end
    end
  end
  return nil
end

-- Send command to Claude Code terminal
function M.send_to_terminal(bufnr, text)
  if not bufnr or not vim.api.nvim_buf_is_valid(bufnr) then
    return false
  end

  local channel = vim.bo[bufnr].channel
  if not channel then
    return false
  end

  vim.api.nvim_chan_send(channel, text .. "\n")
  return true
end

-- Start voice conversation mode in Claude Code
function M.start_voice_conversation()
  -- Try to use Sidekick CLI if available
  local ok, cli = pcall(require, "sidekick.cli")
  if ok and cli then
    -- Check if there's an active session
    local session_ok, session = pcall(function() return cli.get() end)
    if session_ok and session then
      -- Get the terminal buffer from the session
      local bufnr = session.bufnr or M.find_claude_terminal()
      if bufnr then
        vim.notify("🎤 Starting voice conversation with Claude...", vim.log.levels.INFO)
        -- Send the /voicemode:converse command
        if M.send_to_terminal(bufnr, "/voicemode:converse") then
          vim.notify("✓ Voice mode activated", vim.log.levels.INFO)
          return
        end
      end
    else
      -- No active session, try to start one
      vim.notify("🚀 Starting Claude Code session...", vim.log.levels.INFO)
      cli.toggle({ name = "claude", focus = true })

      -- Wait for terminal to initialize, then send voice command
      vim.defer_fn(function()
        local bufnr = M.find_claude_terminal()
        if bufnr then
          vim.notify("🎤 Starting voice conversation...", vim.log.levels.INFO)
          M.send_to_terminal(bufnr, "/voicemode:converse")
          vim.notify("✓ Voice mode activated", vim.log.levels.INFO)
        else
          vim.notify("❌ Failed to find Claude terminal", vim.log.levels.ERROR)
        end
      end, 500)
      return
    end
  end

  -- Fallback: try to find a terminal buffer directly
  local term_bufnr = M.find_claude_terminal()
  if term_bufnr then
    vim.notify("🎤 Starting voice conversation with Claude...", vim.log.levels.INFO)
    if M.send_to_terminal(term_bufnr, "/voicemode:converse") then
      vim.notify("✓ Voice mode activated", vim.log.levels.INFO)
      return
    end
  end

  -- If no terminal found, notify user
  vim.notify("❌ No Claude Code session found. Please start Claude Code first (Ctrl-.)", vim.log.levels.WARN)
end

-- Send text message to Claude Code terminal
function M.send_text_to_claude(text)
  if not text or text == "" then
    vim.notify("❌ No text to send", vim.log.levels.WARN)
    return
  end

  -- Try to use Sidekick CLI if available
  local ok, cli = pcall(require, "sidekick.cli")
  if ok and cli then
    -- Check if there's an active session
    local session_ok, session = pcall(function() return cli.get() end)
    if session_ok and session then
      -- Send to existing session
      cli.send({ msg = text })
      vim.notify("✓ Sent: " .. text:sub(1, 60) .. (text:len() > 60 and "..." or ""), vim.log.levels.INFO)
      return
    end
  end

  -- Fallback: try to find a terminal buffer
  local term_bufnr = M.find_claude_terminal()
  if term_bufnr then
    vim.notify("✓ Sent: " .. text:sub(1, 60) .. (text:len() > 60 and "..." or ""), vim.log.levels.INFO)
    M.send_to_terminal(term_bufnr, text)
    return
  end

  -- If no terminal found, notify user
  vim.notify("❌ No Claude Code session found. Please start Claude Code first (Ctrl-.)", vim.log.levels.WARN)
end

-- Capture voice, transcribe to text, and send to Claude (async)
function M.voice_to_text_prompt()
  vim.notify("🎤 Recording... (speak your prompt)", vim.log.levels.INFO)

  local audio_file = "/tmp/nvim-voice-prompt-" .. os.time() .. ".wav"

  -- Start recording
  local record_job = vim.fn.jobstart(
    {"arecord", "-f", "S16_LE", "-r", "16000", "-c", "1", "-d", tostring(M.config.record_duration), audio_file},
    {
      on_exit = function(_, exit_code)
        if exit_code ~= 0 then
          vim.notify("❌ Recording failed. Is arecord installed?", vim.log.levels.ERROR)
          vim.fn.delete(audio_file)
          return
        end

        vim.notify("🔄 Transcribing...", vim.log.levels.INFO)

        -- Send to Whisper
        local curl_cmd = {
          "curl", "-s", "-X", "POST", M.config.whisper_endpoint,
          "-H", "Content-Type: multipart/form-data",
          "-F", "file=@" .. audio_file,
          "-F", "model=whisper-1"
        }

        local output = {}
        local transcribe_job = vim.fn.jobstart(curl_cmd, {
          stdout_buffered = true,
          on_stdout = function(_, data)
            if data then
              for _, line in ipairs(data) do
                if line ~= "" then
                  table.insert(output, line)
                end
              end
            end
          end,
          on_exit = function(_, curl_exit_code)
            -- Clean up audio file
            vim.fn.delete(audio_file)

            if curl_exit_code ~= 0 then
              vim.notify("❌ Transcription failed. Is Whisper endpoint running at " .. M.config.whisper_endpoint .. "?", vim.log.levels.ERROR)
              return
            end

            -- Parse JSON response
            local response_text = table.concat(output, "\n")
            local ok, json = pcall(vim.fn.json_decode, response_text)

            if ok and json and json.text then
              local text = json.text:gsub("^%s*(.-)%s*$", "%1")
              if text ~= "" then
                vim.schedule(function()
                  M.send_text_to_claude(text)
                end)
              else
                vim.notify("❌ No speech detected", vim.log.levels.WARN)
              end
            else
              vim.notify("❌ Failed to parse transcription response", vim.log.levels.ERROR)
            end
          end
        })
      end
    }
  )
end

return M
